'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"version.json": "ce14ed81a97b6d3dada946b4a3b84483",
"index.html": "af514158e98f140c1e284de843d53158",
"/": "af514158e98f140c1e284de843d53158",
"main.dart.js": "85a8da50c1df271160bad31e316f0834",
"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "1a0075946bf7e0759ad6474ed45365f9",
"assets/AssetManifest.json": "7c670c80716788ae379ed6e40adadfc6",
"assets/NOTICES": "4f6e0735ea131c8ed9db64da5d0f86ea",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "57d849d738900cfd590e9adc7e208250",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/AssetManifest.bin": "9d8bc5de8cc5390206f47ac75036358c",
"assets/fonts/MaterialIcons-Regular.otf": "2919ded75bf661d1d9c4d5e3c5dcce6c",
"assets/assets/images/background/01.jpg": "726f3388585d822504cfc8e53762a0d4",
"assets/assets/images/background/09-10.jpg": "369f43d608f05ef7ff7a3f603e8e7aa9",
"assets/assets/images/background/13.jpg": "68239fbea8ea4a94b0965ed2bb1c389d",
"assets/assets/images/background/11.jpg": "c88a8e50e969c1d8f291e9da889d9c46",
"assets/assets/images/background/04.jpg": "9a1a3bcc97315afd940cb1b367dc2899",
"assets/assets/images/background/02-03.jpg": "f2c334f3c1ede8f6fb2548722a228100",
"assets/assets/images/background/50.jpg": "988a9c69f8485673ff3b61872de70a29",
"assets/assets/images/detail/wind-speed.png": "fab67e8ca42c9e5c17fa5540be230983",
"assets/assets/images/detail/pressure.png": "d25448170f0df21c2730ed6884a396a9",
"assets/assets/images/detail/map.png": "80fd18a8760f157d51dba1f675560e08",
"assets/assets/images/detail/visibility.png": "da594bbb81f4ce3f39365173cf9e4607",
"assets/assets/images/detail/sunrise.png": "c85c58de8991aed7c78b71c8c06641b9",
"assets/assets/images/detail/sea-level.png": "f924bf9d393cc28c8393f9795ec29d84",
"assets/assets/images/detail/max-min.png": "0ff2e8d8e6a11173f00d4f9107fced45",
"assets/assets/images/detail/humidity.png": "a6d07951bf55f303128e590ce2fc3e24",
"assets/assets/images/detail/sunset.png": "31ff8175c50c64cf084cb6117b428410",
"assets/assets/images/detail/welcome.png": "d315491ca52c1f3f477de3a548653334",
"assets/assets/images/icon/03n.png": "17cc1a8a95028b89ba6988ee47eeab29",
"assets/assets/images/icon/01d.png": "575900edccbc7def167f7874c02aeb0b",
"assets/assets/images/icon/10d.png": "4417bf88c7bbcd8e24fb78ee6479b362",
"assets/assets/images/icon/50d.png": "d35bb25d12281cd9ee5ce78a98cd2aa7",
"assets/assets/images/icon/11d.png": "efffb1e26f6de5bf5c8adbd872a2933a",
"assets/assets/images/icon/10n.png": "d4b6596291c114305b64056bd92ccee3",
"assets/assets/images/icon/04d.png": "66117fab0f288a2867b340fa2fcde31b",
"assets/assets/images/icon/13d.png": "e95fb90fc5a4aac111be78770921beb1",
"assets/assets/images/icon/09d.png": "451d37e6cea3af4a568110863a1adcf7",
"assets/assets/images/icon/01n.png": "1200cde3569cf69bd80e1ddabc0f15cd",
"assets/assets/images/icon/03d.png": "67aaf9dbe30989c25cbde6c6ec099213",
"canvaskit/skwasm.js": "1df4d741f441fa1a4d10530ced463ef8",
"canvaskit/skwasm.wasm": "6711032e17bf49924b2b001cef0d3ea3",
"canvaskit/chromium/canvaskit.js": "8c8392ce4a4364cbb240aa09b5652e05",
"canvaskit/chromium/canvaskit.wasm": "fc18c3010856029414b70cae1afc5cd9",
"canvaskit/canvaskit.js": "76f7d822f42397160c5dfc69cbc9b2de",
"canvaskit/canvaskit.wasm": "f48eaf57cada79163ec6dec7929486ea",
"canvaskit/skwasm.worker.js": "19659053a277272607529ef87acf9d8a"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
