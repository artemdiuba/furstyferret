function TTLtrain = read_pulse_train(binName, path, dw, dLineList)

% binName = 'P3_conf2_g0_tcat.obx0.obx.bin';
% path = 'C:\NeuralData\Data\Linguine_data_sample\supercat\P3_conf2\P3_conf2_g0';

[meta] = SGLX_readMeta.ReadMeta(binName, path);

dataArray = SGLX_readMeta.ReadBin(0, Inf, meta, binName, path);

%%
% dw = 1;
% dLineList = 10;

TTLtrain = SGLX_readMeta.ExtractDigital(dataArray, meta, dw, dLineList);

