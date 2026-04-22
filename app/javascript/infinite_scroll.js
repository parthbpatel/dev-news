const instances = []

class InfiniteScroll {
  constructor(root) {
    this.root = root
    this.pages = root.querySelector('[data-infinite-scroll-target="pages"]')
    this.loading = false
    this.observer = new IntersectionObserver(this.handleIntersect.bind(this), {
      rootMargin: '320px 0px 480px 0px'
    })

    this.observeNextSentinel()
  }

  disconnect() {
    this.observer.disconnect()
  }

  handleIntersect(entries) {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        this.loadNextPage(entry.target)
      }
    })
  }

  observeNextSentinel() {
    const sentinels = this.pages.querySelectorAll('[data-infinite-scroll-target="sentinel"]')
    const nextSentinel = sentinels[sentinels.length - 1]

    if (!nextSentinel) {
      return
    }

    this.observer.observe(nextSentinel)
  }

  async loadNextPage(sentinel) {
    if (this.loading) {
      return
    }

    const nextUrl = sentinel.dataset.nextUrl

    if (!nextUrl) {
      this.observer.unobserve(sentinel)
      return
    }

    this.loading = true
    this.observer.unobserve(sentinel)
    sentinel.classList.add('is-loading')

    try {
      const response = await fetch(nextUrl, {
        headers: {
          'Accept': 'text/html',
          'X-Requested-With': 'XMLHttpRequest'
        },
        credentials: 'same-origin'
      })

      if (!response.ok) {
        throw new Error(`Infinite scroll request failed with status ${response.status}`)
      }

      const html = await response.text()
      const template = document.createElement('template')
      template.innerHTML = html.trim()

      sentinel.remove()
      this.pages.appendChild(template.content)
      this.observeNextSentinel()
    } catch (_error) {
      sentinel.classList.remove('is-loading')
      sentinel.classList.add('has-error')
    } finally {
      this.loading = false
    }
  }
}

const initializeInfiniteScroll = () => {
  document.querySelectorAll('[data-infinite-scroll]').forEach((element) => {
    instances.push(new InfiniteScroll(element))
  })
}

const cleanupInfiniteScroll = () => {
  while (instances.length > 0) {
    instances.pop().disconnect()
  }
}

document.addEventListener('turbolinks:load', initializeInfiniteScroll)
document.addEventListener('turbolinks:before-cache', cleanupInfiniteScroll)
