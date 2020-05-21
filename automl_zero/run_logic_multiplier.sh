# Copyright 2020 The Google Research Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#!/bin/bash

DATA_DIR=$(pwd)/binary_logic_data/

# Evaluating (only evolving the setup) a hand designed Neural Network on
# projected binary tasks. Utility script to check whether the tasks are
# ready.
bazel run -c opt \
  --copt=-DMAX_SCALAR_ADDRESSES=5 \
  --copt=-DMAX_VECTOR_ADDRESSES=9 \
  --copt=-DMAX_MATRIX_ADDRESSES=2 \
  :run_search_experiment -- \
  --search_experiment_spec=" \
    search_tasks { \
      tasks { \
        projected_binary_classification_task { \
          dataset_name: 'logic_multiply' \
          path: '${DATA_DIR}' \
          held_out_pairs {positive_class: 0 negative_class: 1} \
          max_supported_data_seed: 1 \
        } \
        features_size: 2 \
        num_train_examples: 160 \
        num_valid_examples: 17 \
        num_train_epochs: 1 \
        num_tasks: 10 \
        eval_type: ACCURACY \
      } \
    } \
    setup_ops: [SCALAR_SUM_OP, SCALAR_PRODUCT_OP, SCALAR_HEAVYSIDE_OP] \
    predict_ops: [SCALAR_SUM_OP, SCALAR_PRODUCT_OP, SCALAR_HEAVYSIDE_OP] \
    learn_ops: [SCALAR_SUM_OP, SCALAR_PRODUCT_OP, SCALAR_HEAVYSIDE_OP] \
    setup_size_init: 1 \
    mutate_setup_size_min: 1 \
    mutate_setup_size_max: 21 \
    predict_size_init: 1 \
    mutate_predict_size_min: 1 \
    mutate_predict_size_max: 34 \
    learn_size_init: 1 \
    mutate_learn_size_min: 1 \
    mutate_learn_size_max: 55 \
    train_budget {train_budget_baseline: NEURAL_NET_ALGORITHM} \
    fitness_combination_mode: MEAN_FITNESS_COMBINATION \
    population_size: 100 \
    tournament_size: 10 \
    initial_population: NO_OP_ALGORITHM \
    max_train_steps: 100000000000 \
    allowed_mutation_types {
      mutation_types: [ALTER_PARAM_MUTATION_TYPE, RANDOMIZE_COMPONENT_FUNCTION_MUTATION_TYPE, INSERT_INSTRUCTION_MUTATION_TYPE, REMOVE_INSTRUCTION_MUTATION_TYPE] \
    } \
    mutate_prob: 0.9 \
    progress_every: 10000 \
    " \
  --final_tasks="
    tasks { \
      projected_binary_classification_task { \
        dataset_name: 'logic_multiply' \
        path: '${DATA_DIR}' \
        held_out_pairs {positive_class: 0 negative_class: 1} \
        max_supported_data_seed: 1 \
      } \
      features_size: 2 \
      num_train_examples: 160 \
      num_valid_examples: 17 \
      num_train_epochs: 1 \
      num_tasks: 100 \
      eval_type: ACCURACY \
    } \
    " \
  --random_seed=0 \
  --select_tasks="
    tasks { \
      projected_binary_classification_task { \
        dataset_name: 'logic_multiply' \
        path: '${DATA_DIR}' \
        held_out_pairs {positive_class: 0 negative_class: 1} \
        max_supported_data_seed: 1 \
      } \
      features_size: 2 \
      num_train_examples: 160 \
      num_valid_examples: 17 \
      num_train_epochs: 1 \
      num_tasks: 10 \
      eval_type: ACCURACY \
    } \
    "