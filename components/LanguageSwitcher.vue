<script setup>
import { ref, computed, onMounted } from 'vue'
import { useI18n } from 'vue-i18n'
import { translateText } from '@/services/translate' // Import the translation service

const { locale, locales, setLocale, t } = useI18n() // Use i18n for translation management

// Static languages that already have translations (from en.json, es.json, etc.)
const staticLocales = computed(() => {
  return locales.value.filter((loc) => loc.file)  // Keep only the languages with static files
})

// List of dynamic languages that we want to add to the dropdown (i.e., languages not in staticLocales)
const dynamicLocales = ref([
  { code: 'fr-FR', name: 'Français' },
  { code: 'it', name: 'Italiano' },
  { code: 'ja', name: '日本語' },
  { code: 'zh-CN', name: '简体中文' },
  { code: 'pt-BR', name: 'Português do Brasil' },
  { code: 'pt-PT', name: 'Português' },
  { code: 'ru-RU', name: 'Русский' },
  { code: 'de-DE', name: 'Deutsch' },
  { code: 'es-ES', name: 'Español' },
  { code: 'uk-UA', name: 'Українська' },
  { code: 'ar', name: 'العربية' },
  { code: 'ko', name: '한국어' },
  { code: 'tr', name: 'Türkçe' },
  { code: 'nl', name: 'Nederlands' },
  { code: 'sv', name: 'Svenska' },
  { code: 'pl', name: 'Polski' },
  { code: 'da', name: 'Dansk' },
  { code: 'fi', name: 'Suomi' },
  { code: 'no', name: 'Norsk' },
  { code: 'cs', name: 'Čeština' },
  { code: 'hi', name: 'हिन्दी' },
  { code: 'th', name: 'ไทย' },
  { code: 'id', name: 'Bahasa Indonesia' },
  { code: 'ms', name: 'Melayu' },
  { code: 'he', name: 'עברית' },
])

// Combine both static and dynamic locales for the dropdown
const availableLocales = computed(() => {
  return [...staticLocales.value, ...dynamicLocales.value]
})

// Function to update language
function updateLocale(event) {
  const newLocale = event.target.value
  setLocale(newLocale)

  // If the language is dynamic (not in staticLocales), fetch translations from the backend
  if (!staticLocales.value.find((loc) => loc.code === newLocale)) {
    // If language doesn't exist in static list, fetch dynamically
    fetchTranslations(newLocale)
  } else {
    // Reload page for static translations (they're already loaded)
    window.location.reload()
  }
}

// Fetch translations dynamically from Java backend
async function fetchTranslations(newLocale) {
  try {
    // Get the keys of translations dynamically and fetch them from the backend
    const translationKeys = Object.keys(t(''))  // Using the `t` method from `useI18n()` to get all keys

    // Fetch dynamic translations for each key
    for (const key of translationKeys) {
      const originalText = t(key)  // Get the original text for each key
      console.log(`Sending text to translate: ${originalText} → ${newLocale}`);  // Log the original text being sent

      const translatedText = await translateText(originalText, newLocale)  // Translate dynamically using Java service
      console.log(`Received translated text: ${translatedText}`);  // Log translated text to check

      // Apply the translation to the current locale
      await setLocale(newLocale)  // Set the locale before updating translations
      await t(key, translatedText) // Update the translation for the specific key
    }
  } catch (error) {
    console.error(`Error translating to ${newLocale}:`, error)
  }
}

// Initialize language dropdown on page load
onMounted(() => {
  const langSwitcher = document.querySelector('#langSwitcher')
  langSwitcher.value = locale.value
})
</script>

<template>
  <div flex gap2 items-center mt-5>
    Language:
    <select id="langSwitcher" rounded-md text-sm p-1 @change="updateLocale">
      <option v-for="loc in availableLocales" :key="loc.code" :value="loc.code" p-1>
        {{ loc.name }}
      </option>
    </select>
  </div>
</template>
