const app = Vue.createApp({
  data() {
    return {
      tests: [],
      file: null,
      selected: false,
      waiting_response: false,
      response_message: null,
      searchText: '',
      loading_results: true
    }
  },

  computed: {
    listResult(){
      if(this.searchText){
        return this.tests.filter(test => {
          return test['result_token'].toLowerCase().includes(this.searchText.toLowerCase()) ||
                 test['cpf'].toLowerCase().includes(this.searchText.toLowerCase()) ||
                 test['result_date'].split('-').reverse().join('/').includes(this.searchText)
        });
      }else{
        return this.tests;
      }
    }
  },

  async mounted(){
    await this.getData();
    this.loading_results = false;
  },

  methods: {
    async getData(){
      let response = await fetch('http://localhost:3000/tests')
      data = await response.json();
      this.tests = data
    },

    handleFileUpload(event){
      const file = event.target.files[0];
      if (!file) return;
      this.file = file;
      this.selected = true;
      this.response_message = null;
    },

    async sendFile(){
      const formData = new FormData();
      formData.append('csvFile', this.file)

      try {
        this.waiting_response = true;
        console.log(this.waiting_response)
        let response = await fetch('http://localhost:3000/import', {
          method: 'POST',
          body: formData,
        });
        
        this.waiting_response = false;
        if (response.ok) {
          this.response_message = "Dados importados com sucesso";
        }else{
          this.response_message = "Houve um erro na importação";
        }
      } catch (error) {
        console.error(error)
      }
    },

    testDetails(event){
      id_array = event.target.id.split('-')
      id_call = id_array[id_array.length - 1]
      simple_card_element = document.getElementById(`test-card-${id_call}`)
      details_element = document.getElementById(`details-div-${id_call}`)
      show_details_element = event.target
      if (simple_card_element.classList[0] === "test-card-simple-closed"){
        simple_card_element.classList.remove('test-card-simple-closed');
        simple_card_element.classList.add('test-card-simple-opened');
        details_element.classList.remove('hidden');
        show_details_element.innerHTML = 'Recolher detalhes'
      } else {
        simple_card_element.classList.remove('test-card-simple-opened')
        simple_card_element.classList.add('test-card-simple-closed')
        details_element.classList.add('hidden');
        show_details_element.innerHTML = 'Mais detalhes'
      }
      console.log(simple_card_element)
    }
  }
})


app.mount('#app');