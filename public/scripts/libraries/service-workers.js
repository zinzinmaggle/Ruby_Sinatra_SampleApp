$(function(){
    if ('serviceWorker' in navigator) {
        navigator.serviceWorker
                 .register('/scripts/libraries/serviceworker.js')
                 .then(function() { console.log('Service Worker Registered'); });
    }
    
})