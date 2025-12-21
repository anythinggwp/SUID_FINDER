<template>
  <div class="record-manager">
    <h2>Записи</h2>

    <ul>
      <li v-for="record in records" :key="record.id">
        {{ record.text }}
      </li>
    </ul>

    <div class="add-record">
      <input
        type="text"
        v-model="newRecord"
        placeholder="Введите текст новой записи"
        @keyup.enter="addRecord"
      />
      <button @click="addRecord">Добавить</button>
    </div>

    <p v-if="error" class="error">{{ error }}</p>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';

export default {
  name: 'RecordManager',
  setup() {
    const API_URL = 'https://example.com/api/records'; // <- Замени на твой сервер
    const records = ref([]);
    const newRecord = ref('');
    const error = ref('');

    const fetchRecords = async () => {
      try {
        const res = await fetch(API_URL);
        if (!res.ok) throw new Error(`Ошибка загрузки: ${res.status}`);
        records.value = await res.json();
      } catch (err) {
        error.value = err.message;
      }
    };

    const addRecord = async () => {
      if (!newRecord.value.trim()) return;

      try {
        const res = await fetch(API_URL, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ text: newRecord.value.trim() }),
        });

        if (!res.ok) throw new Error(`Ошибка создания: ${res.status}`);
        const created = await res.json();
        records.value.push(created);
        newRecord.value = '';
      } catch (err) {
        error.value = err.message;
      }
    };

    onMounted(() => {
      fetchRecords();
    });

    return {
      records,
      newRecord,
      error,
      addRecord,
    };
  },
};
</script>

<style scoped>
.record-manager {
  max-width: 400px;
  margin: 1rem auto;
  font-family: sans-serif;
}

.add-record {
  margin-top: 1rem;
  display: flex;
  gap: 0.5rem;
}

input {
  flex: 1;
  padding: 0.5rem;
}

button {
  padding: 0.5rem 1rem;
}

.error {
  color: red;
  margin-top: 0.5rem;
}
</style>

