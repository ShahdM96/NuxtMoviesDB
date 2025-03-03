import axios from 'axios'

const apiBaseUrl = 'http://localhost:8080'  // Update with your Java service URL

export const translateText = async (text, targetLanguage) => {
  try {
    console.log(`Sending request to translate: ${text} → ${targetLanguage}`);  // Log the request being sent
    const response = await axios.post(`${apiBaseUrl}/api/translate`, {
      text: text,
      targetLanguage: targetLanguage,
    })

    console.log(`Received translation: ${response.data}`);  // Log the response from the backend
    return response.data;  // Return the translated text
  } catch (error) {
    console.error('Error translating text:', error);
    return text; // Return the original text if translation fails
  }
}
