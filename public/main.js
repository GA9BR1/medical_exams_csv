const app = Vue.createApp({
  data() {
    return {
      tests: [],
      file: null,
      selected: false,
      waiting_response: false,
      response_message: null,
      searchText: '',
      loading_results: true,
      itemsPerPage: 4,
      currentPage: 1,
      changePage: 1,
      any_concluded_import: false,
      concluded_imports: []
    }
  },

  watch: {
    searchText() {
      this.currentPage = 1;
    },
    changePage(event) {
      let value = event.target;
      if (this.changePage < 1 && this.totalPages != 0) {
        this.currentPage = 1;
        this.changePage = 1;
        return
      } else if (this.changePage == 0 && this.totalPages == 0) {
        this.changePage = 0;
        return
      } else if(this.changePage > this.totalPages) {
        this.currentPage = this.totalPages;
        this.changePage = this.totalPages;
        return
      }
      this.currentPage = this.changePage;
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
    },
    totalPages() {
      return Math.ceil(this.listResult.length / this.itemsPerPage);
    },
    paginatedData() {
      const startIndex = (this.currentPage - 1) * this.itemsPerPage;
      const endIndex = startIndex + this.itemsPerPage;
      let result = this.listResult.slice(startIndex, endIndex);
      if (result.length == 0 && this.totalPages == 0) {
        this.changePage = 0;
        return result; 
      }
      this.changePage = this.currentPage;
      return result;
    }
  },

  async mounted(){
    await this.getData();
    this.loading_results = false;
    setInterval(async () => {
      await this.askForJobStatus();
    }, 5000);
  },


  methods: {
    async getData(){
      let response = await fetch('http://localhost:3000/tests')
      data = await response.json();
      this.tests = data
    },

    prevPage() {
      if (this.currentPage > 1) {
        this.currentPage--;
        this.changePage--;
      }
    },
    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++;
        this.changePage++;
      }
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
        let response = await fetch('http://localhost:3000/import', {
          method: 'POST',
          body: formData
        });
        
        this.waiting_response = false;
        if (response.ok) {
          job_id = await response.text()
          this.response_message = "Arquivo recebido pelo servidor";
          let items = { ...localStorage };
          let max_id = 0;
          if (Object.keys(items).length > 0) {
            max_id = this.storeJobIds(items, max_id)
          }
          localStorage.setItem(`job-id-${parseInt(max_id) + 1}`, job_id )
          await this.getData();
        }else{
          this.response_message = "Houve um erro na importação";
        }
      } catch (error) {
        console.error(error)
      }
    },

    async askForJobStatus(){
      let items = { ...localStorage }
      let jobIds = []
      if (Object.keys(items).length > 0) {
        for (let i = 0; i < Object.keys(items).length; i++) {
          jobIds.push(Object.values(items)[i])
        }
        try {
          let response = await fetch('http://localhost:3000/status', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify(jobIds)
          });
  
          if (response.ok) {
            items = {...localStorage}
            body = await response.json();
            const parsedBody = body.map(item => JSON.parse(item));
            for (let i = 0; i < body.length; i++) {
              if (Object.keys(items).length > 0) {
                for (let j = 0; j < Object.keys(items).length; j++) {
                  chave = Object.keys(items)[j]
                  value = localStorage.getItem(chave)
                  if (value == parsedBody[i][2]) {
                    if (parsedBody[i][0] === 'Completed'){
                      this.concluded_imports.push(parsedBody[i])
                      localStorage.removeItem(chave)
                      await this.getData()
                    }
                  }
                }
              }
            }
            
            if (this.concluded_imports.length > 0) {
              this.any_concluded_import = true;
            }
          }
        } catch (e) {
          console.error(e)
        }
      } 
    },

    storeJobIds(items, max_id){
      for (let i = 0; i < Object.keys(items).length; i++) {
        let last_item_splited = Object.keys(items)[i].split('-')
        let last_job_index = last_item_splited[last_item_splited.length - 1]
        if (last_job_index > max_id) {
          max_id = last_job_index
        } 
      }
      return max_id
    },

    showTestDetails(event){
      id_array = event.target.id.split('-');
      id_call = id_array[id_array.length - 1];
      simple_card_element = document.getElementById(`test-card-${id_call}`);
      details_element = document.getElementById(`details-div-${id_call}`);
      test_card = document.getElementById(`test-card-general-${id_call}`);
      show_details_element = event.target;
      if (simple_card_element.classList[0] === "test-card-simple-closed"){
        simple_card_element.classList.remove('test-card-simple-closed');
        simple_card_element.classList.add('test-card-simple-opened');
        details_element.classList.remove('hidden');
        show_details_element.innerHTML = 'Recolher detalhes';
        test_card.scrollIntoView({ behavior: 'smooth', block: 'center' });
      } else {
        simple_card_element.classList.remove('test-card-simple-opened');
        simple_card_element.classList.add('test-card-simple-closed');
        details_element.classList.add('hidden');
        show_details_element.innerHTML = 'Mais detalhes';
        opened_simple_test_cards = document.getElementsByClassName('test-card-simple-opened')
        opened_test_cards = []
        for (let i = 0; i < opened_simple_test_cards.length; i++){
          let element = opened_simple_test_cards[i];
          testcard_parent_element_id_split = element.parentElement.id.split('-');
          opened_test_cards.push({[testcard_parent_element_id_split[testcard_parent_element_id_split.length - 1]]: element.parentElement});
        }
        nearest_index = this.getNearestOpenedDetails(opened_test_cards, id_call);
        if(opened_test_cards.length != 0){
          Object.values(opened_test_cards[nearest_index])[0].scrollIntoView({ behavior: 'smooth', block: 'center' });
        } 
      }
    },

    getNearestOpenedDetails(opened_test_cards, id_call) {
      let nearest_index = 0;
      let diff = 0;
    
      opened_test_cards.forEach(function(object, index){
        const current_diff = Math.abs(id_call - Object.keys(object)[0]);
        
        if (current_diff < diff || index == 0) {
          nearest_index = index;
          diff = current_diff;
        }
      });
      return nearest_index;
    },

    showAlert(tt){
      let limits = tt.limits.split('-');
      let upper_limit = limits[1];
      let bottom_limit = limits[0];
      let result = tt.result;
      let upper_difference = upper_limit - result;
      let bottom_difference = result - bottom_limit;

      return (upper_difference <= 5) || (bottom_difference <= 5)
    },

    getAlertIcon(tt){
      let limits = tt.limits.split('-');
      let upper_limit = limits[1];
      let bottom_limit = limits[0];
      let result = tt.result;
      let upper_difference = upper_limit - result;
      let bottom_difference = result - bottom_limit;

      if ((upper_difference >= 0 && upper_difference <= 5) || (bottom_difference >= 0 && bottom_difference <= 5)) {
        return 'aviso.png';
      } else if (upper_difference < 0 || bottom_difference < 0) {
        return 'warning.png';
      }
    }
  }
})


app.mount('#app');