# Flower Species Classfication App

- Apple Core ML
- Apple ARKit

## Classfication Model Architecture

[FlowerSnapModel](https://github.com/luyiming/FlowerSnapModel)

Current results:
```
Flower12 dataset
-----------------------------------------------------
Rank-1: 100.00%
Rank-5: 100.00%

              precision    recall  f1-score   support

 bluebell          1.00      1.00      1.00         4
 buttercup         1.00      1.00      1.00         9
 coltsfoot         1.00      1.00      1.00         8
   cowslip         1.00      1.00      1.00         6
    crocus         1.00      1.00      1.00        10
  daffodil         1.00      1.00      1.00         8
      daisy        1.00      1.00      1.00        12
 dandelion         1.00      1.00      1.00         6
 fritillary        1.00      1.00      1.00         6
      iris         1.00      1.00      1.00        10
lilyvalley         1.00      1.00      1.00        10
     pansy         1.00      1.00      1.00         8
  snowdrop         1.00      1.00      1.00         8
 sunflower         1.00      1.00      1.00        10
tigerlily          1.00      1.00      1.00         9
     tulip         1.00      1.00      1.00         7
windflower         1.00      1.00      1.00         5

 micro avg         1.00      1.00      1.00       136
 macro avg         1.00      1.00      1.00       136
weighted avg       1.00      1.00      1.00       136
```

```
Flower102 dataset
------------------------------------------------------------------
Rank-1: 95.97%
Rank-5: 99.27%

                           precision    recall  f1-score   support

         alpine sea holly       1.00      1.00      1.00         6
                anthurium       1.00      1.00      1.00        11
                artichoke       1.00      1.00      1.00         7
                   azalea       1.00      0.70      0.82        10
                ball moss       0.83      1.00      0.91         5
           balloon flower       1.00      0.71      0.83         7
           barbeton daisy       1.00      1.00      1.00         6
             bearded iris       1.00      1.00      1.00         5
                 bee balm       1.00      1.00      1.00         9
         bird of paradise       1.00      1.00      1.00         9
       bishop of llandaff       1.00      1.00      1.00        11
         black-eyed susan       1.00      1.00      1.00         4
          blackberry lily       1.00      1.00      1.00         3
           blanket flower       1.00      1.00      1.00         3
         bolero deep blue       1.00      1.00      1.00         3
            bougainvillea       0.73      0.89      0.80         9
                 bromelia       1.00      1.00      1.00         9
                buttercup       1.00      1.00      1.00         3
        californian poppy       1.00      1.00      1.00         8
                 camellia       1.00      0.86      0.92         7
               canna lily       0.67      0.75      0.71         8
         canterbury bells       0.67      0.80      0.73         5
              cape flower       1.00      1.00      1.00        11
                carnation       1.00      0.80      0.89         5
         cautleya spicata       1.00      1.00      1.00        10
                 clematis       0.92      0.92      0.92        12
              colt's foot       1.00      1.00      1.00        13
                columbine       0.90      0.90      0.90        10
         common dandelion       1.00      1.00      1.00         8
               corn poppy       1.00      0.83      0.91         6
                cyclamen        0.95      1.00      0.97        18
                 daffodil       1.00      1.00      1.00         7
              desert-rose       0.80      1.00      0.89         4
         english marigold       1.00      1.00      1.00         5
                fire lily       1.00      1.00      1.00         2
                 foxglove       1.00      0.91      0.95        22
               frangipani       1.00      1.00      1.00        18
               fritillary       1.00      1.00      1.00         9
             garden phlox       0.86      0.86      0.86         7
                    gaura       1.00      1.00      1.00         7
                  gazania       1.00      1.00      1.00         5
                 geranium       1.00      1.00      1.00         6
    giant white arum lily       1.00      1.00      1.00         7
            globe thistle       1.00      1.00      1.00         3
             globe-flower       1.00      1.00      1.00         3
           grape hyacinth       1.00      1.00      1.00         3
         great masterwort       1.00      1.00      1.00         7
hard-leaved pocket orchid       1.00      1.00      1.00         8
                 hibiscus       1.00      1.00      1.00        14
             hippeastrum        1.00      1.00      1.00         5
         japanese anemone       0.86      1.00      0.92         6
              king protea       1.00      1.00      1.00         7
              lenten rose       0.89      1.00      0.94         8
                    lotus       1.00      0.94      0.97        16
         love in the mist       1.00      1.00      1.00         4
                 magnolia       1.00      0.90      0.95        10
                   mallow       0.86      0.86      0.86         7
                 marigold       1.00      1.00      1.00         4
            mexican aster       1.00      1.00      1.00         3
          mexican petunia       1.00      0.90      0.95        10
                monkshood       1.00      1.00      1.00         2
              moon orchid       1.00      0.88      0.93         8
            morning glory       1.00      1.00      1.00        12
            orange dahlia       1.00      1.00      1.00         8
             osteospermum       1.00      1.00      1.00         5
              oxeye daisy       1.00      1.00      1.00         6
           passion flower       1.00      1.00      1.00        16
              pelargonium       1.00      1.00      1.00         6
            peruvian lily       0.86      1.00      0.92        12
                  petunia       0.81      1.00      0.90        26
        pincushion flower       1.00      1.00      1.00         5
            pink primrose       1.00      1.00      1.00         1
      pink-yellow dahlia?       1.00      1.00      1.00         7
               poinsettia       1.00      0.80      0.89         5
                  primula       1.00      0.86      0.92         7
 prince of wales feathers       1.00      1.00      1.00         5
        purple coneflower       1.00      1.00      1.00        11
               red ginger       1.00      1.00      1.00         2
                     rose       1.00      1.00      1.00        15
     ruby-lipped cattleya       1.00      0.86      0.92         7
               siam tulip       1.00      0.50      0.67         2
               silverbush       1.00      1.00      1.00         4
               snapdragon       0.89      0.89      0.89         9
            spear thistle       1.00      1.00      1.00         3
            spring crocus       1.00      1.00      1.00         7
         stemless gentian       1.00      1.00      1.00         8
                sunflower       1.00      1.00      1.00        10
                sweet pea       0.71      1.00      0.83         5
            sweet william       0.86      0.86      0.86         7
               sword lily       0.83      0.91      0.87        11
              thorn apple       1.00      0.94      0.97        16
               tiger lily       1.00      1.00      1.00         6
                toad lily       1.00      1.00      1.00         3
              tree mallow       1.00      1.00      1.00         5
               tree poppy       1.00      1.00      1.00         4
          trumpet creeper       1.00      0.78      0.88         9
               wallflower       1.00      1.00      1.00        24
               water lily       1.00      1.00      1.00        19
               watercress       0.93      0.96      0.95        27
               wild pansy       1.00      1.00      1.00         8
               windflower       1.00      1.00      1.00         6
              yellow iris       1.00      1.00      1.00         2

                micro avg       0.96      0.96      0.96       819
                macro avg       0.97      0.96      0.96       819
             weighted avg       0.96      0.96      0.96       819
```