<template>
  <div class="record-manager">
    <h2>Коментарии</h2>
    <div class="add-record">
      <input type="text" v-model="newRecord" placeholder="Введите новый коментарий" @keyup.enter="addRecord" />
      <button @click="addRecord">Добавить</button>
    </div>
    <div style="margin-bottom: 10px;"></div>
    <p v-if="error" class="error">{{ error }}</p>
    <div v-for="record in records" :key="record.id" class="record-block">
      <div class="record-text">{{ record.text }}</div>
      <div class="record-actions">
        <button @click="editRecord(record)">Изменить</button>
        <button @click="deleteRecord(record.id)">Удалить</button>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';

export default {
  name: 'RecordManager',
  setup() {
    const API_URL = `${window.location.protocol}//localhost:8090`;
    const records = ref([]);
    const newRecord = ref('');
    const error = ref('');

    const fetchRecords = async () => {
      error.value = '';
      try {
        const res = await fetch(API_URL + "/get");
        if (!res.ok) throw new Error(`Ошибка загрузки: ${res.status}`);
        const data = await res.json();
        if (Array.isArray(data)) records.value = data;
      } catch (err) {
        error.value = err.message;
      }
    };

    const addRecord = async () => {
      const text = newRecord.value.trim();
      if (!text) return;

      try {
        const res = await fetch(API_URL + "/post", {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ text }),
        });
        if (!res.ok) throw new Error(`Ошибка создания: ${res.status}`);
        const created = await res.json();
        records.value.push(created);
        newRecord.value = '';
      } catch (err) {
        error.value = err.message;
      }
    };

    const deleteRecord = async (id) => {
      try {
        const res = await fetch(`${API_URL}/delete?id=${id}`, { method: 'DELETE' });
        if (!res.ok) throw new Error(`Ошибка удаления: ${res.status}`);
        records.value = records.value.filter(r => r.id !== id);
      } catch (err) {
        error.value = err.message;
      }
    };

    const editRecord = async (record) => {
      const newText = prompt('Введите новый текст', record.text);
      if (!newText) return;

      try {
        const res = await fetch(API_URL + "/patch", {
          method: 'PATCH',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ id: record.id, text: newText }),
        });
        if (!res.ok) throw new Error(`Ошибка обновления: ${res.status}`);
        const updated = await res.json();
        const index = records.value.findIndex(r => r.id === updated.id);
        if (index !== -1) records.value[index] = updated;
      } catch (err) {
        error.value = err.message;
      }
    };

    onMounted(fetchRecords);

    return {
      records,
      newRecord,
      error,
      addRecord,
      deleteRecord,
      editRecord,
    };
  },
};
</script>

<style scoped>
.record-block {
  border: 1px solid #ccc;
  padding: 10px;
  margin-bottom: 10px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.record-actions button {
  margin-left: 5px;
}

.add-record {
  margin-top: 15px;
}

.error {
  color: red;
  margin-top: 10px;
}
</style>
