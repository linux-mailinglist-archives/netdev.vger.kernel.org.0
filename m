Return-Path: <netdev+bounces-1095-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 973C76FC272
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:14:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DAC22810EC
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 274798BE8;
	Tue,  9 May 2023 09:14:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B143FFE
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 09:14:53 +0000 (UTC)
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19983DC59;
	Tue,  9 May 2023 02:14:52 -0700 (PDT)
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3496sNLM016601;
	Tue, 9 May 2023 09:14:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=32NsFka5NxTjUhZwkz5YfWn1fveMy+8Ql3+i5UypZIo=;
 b=Nkq6bqvyeYcevv+EXoTxYa9Y5wAhi6OS9L+Wyz5fgQf3cZG5lyB6386J6UqKYaUo3RH/
 7Djpgw7ZraqF+tUff9W3aB8YSrHEShVmJvJxuW+IlK06SORk9NZ+DMW9ov2ZbQwOl1/f
 SBtr6+rsgYw2l0f0zfnXjFBaMcpY8iVmBcQBNbQF4WYkUblNdpL6A1LdYepNEnPNOJiy
 G7CcYPzAw7QP+ekDWIYL9cvKYhCTYecpdsqgA14yPdPalsqAosIPCbvmZMhrI6jdbg3I
 VflaG5fJuuLdipleH/dHVI6nEjrdmwXNy7OiSuv1Pq9bEjirSRq2g/6mb+Ua0PSvrVVS RA== 
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qf77j191v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 May 2023 09:14:46 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3499EkHT005374
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 9 May 2023 09:14:46 GMT
Received: from [10.216.33.39] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Tue, 9 May 2023
 02:14:40 -0700
Message-ID: <f9a64c13-a8e4-c84d-cf6d-86f4ddf6d288@quicinc.com>
Date: Tue, 9 May 2023 14:44:37 +0530
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH 4/4] clk: qcom: Add GCC driver support for SDX75
Content-Language: en-US
To: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Stephen Boyd
	<sboyd@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Bjorn Andersson
	<andersson@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Krzysztof Kozlowski
	<krzysztof.kozlowski+dt@linaro.org>,
        Richard Cochran
	<richardcochran@gmail.com>,
        Michael Turquette <mturquette@baylibre.com>
CC: <quic_skakitap@quicinc.com>, Imran Shaik <quic_imrashai@quicinc.com>,
        <linux-arm-msm@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <quic_rohiagar@quicinc.com>, <netdev@vger.kernel.org>
References: <20230419133013.2563-1-quic_tdas@quicinc.com>
 <20230419133013.2563-5-quic_tdas@quicinc.com>
 <af5435c3-b3a4-af46-444e-023d6ee2304a@linaro.org>
From: Taniya Das <quic_tdas@quicinc.com>
In-Reply-To: <af5435c3-b3a4-af46-444e-023d6ee2304a@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: BFzArWZcS3o1RPEdyiyrPO-qLa3W5INw
X-Proofpoint-GUID: BFzArWZcS3o1RPEdyiyrPO-qLa3W5INw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-09_05,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=887 adultscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2305090072
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thanks Dmitry for the review.

On 4/20/2023 3:40 PM, Dmitry Baryshkov wrote:
>> +static const struct clk_parent_data gcc_parent_data_5[] = {
>> +    { .fw_name = "emac0_sgmiiphy_rclk" },
> 
> So, this looks like a mixture of fw_name and index clocks. Please 
> migrate all of fw_names to the .index usage.
> 

I will take care of it to move to index, but does it not bind us to use 
the right index always from DT.

The current approach I was thinking to bind the XO clock to 0th index, 
but we cannot gurantee these external clocks would be placed at the 
right index.

>> +    { .index = DT_BI_TCXO },
>> +};
>> +
>> +static const struct parent_map gcc_parent_map_6[] = {
>> +    { P_EMAC0_SGMIIPHY_TCLK, 0 },
>> +    { P_BI_TCXO, 2 },
>> +};
>> +
>> +static const struct clk_parent_data gcc_parent_data_6[] = {
>> +    { .fw_name = "emac0_sgmiiphy_tclk" },
>> +    { .index = DT_BI_TCXO },
>> +};
>> +
>> +static const struct parent_map gcc_parent_map_7[] = {
>> +    { P_EMAC0_SGMIIPHY_MAC_RCLK, 0 },
>> +    { P_BI_TCXO, 2 },
>> +};
>> +
>> +static const struct clk_parent_data gcc_parent_data_7[] = {
>> +    { .fw_name = "emac0_sgmiiphy_mac_rclk" },
>> +    { .index = DT_BI_TCXO },
>> +};
>> +
>> +static const struct parent_map gcc_parent_map_8[] = {
>> +    { P_EMAC0_SGMIIPHY_MAC_TCLK, 0 },
>> +    { P_BI_TCXO, 2 },
>> +};
>> +
>> +static const struct clk_parent_data gcc_parent_data_8[] = {
>> +    { .fw_name = "emac0_sgmiiphy_mac_tclk" },
>> +    { .index = DT_BI_TCXO },
>> +};
>> +
>> +static const struct parent_map gcc_parent_map_9[] = {
>> +    { P_EMAC1_SGMIIPHY_RCLK, 0 },
>> +    { P_BI_TCXO, 2 },
>> +};
>> +
>> +static const struct clk_parent_data gcc_parent_data_9[] = {
>> +    { .fw_name = "emac1_sgmiiphy_rclk" },
>> +    { .index = DT_BI_TCXO },
>> +};
>> +
>> +static const struct parent_map gcc_parent_map_10[] = {
>> +    { P_EMAC1_SGMIIPHY_TCLK, 0 },
>> +    { P_BI_TCXO, 2 },
>> +};
>> +
>> +static const struct clk_parent_data gcc_parent_data_10[] = {
>> +    { .fw_name = "emac1_sgmiiphy_tclk" },
>> +    { .index = DT_BI_TCXO },
>> +};
>> +
>> +static const struct parent_map gcc_parent_map_11[] = {
>> +    { P_EMAC1_SGMIIPHY_MAC_RCLK, 0 },
>> +    { P_BI_TCXO, 2 },
>> +};
>> +
>> +static const struct clk_parent_data gcc_parent_data_11[] = {
>> +    { .fw_name = "emac1_sgmiiphy_mac_rclk" },
>> +    { .index = DT_BI_TCXO },
>> +};
>> +
>> +static const struct parent_map gcc_parent_map_12[] = {
>> +    { P_EMAC1_SGMIIPHY_MAC_TCLK, 0 },
>> +    { P_BI_TCXO, 2 },
>> +};
>> +
>> +static const struct clk_parent_data gcc_parent_data_12[] = {
>> +    { .fw_name = "emac1_sgmiiphy_mac_tclk" },
>> +    { .index = DT_BI_TCXO },
>> +};
>> +
>> +static const struct parent_map gcc_parent_map_13[] = {
>> +    { P_PCIE_1_PIPE_CLK, 0 },
>> +    { P_BI_TCXO, 2 },
>> +};
>> +
>> +static const struct clk_parent_data gcc_parent_data_13[] = {
>> +    { .fw_name = "pcie_1_pipe_clk" },
>> +    { .index = DT_BI_TCXO },
>> +};
>> +
>> +static const struct parent_map gcc_parent_map_14[] = {
>> +    { P_PCIE_2_PIPE_CLK, 0 },
>> +    { P_BI_TCXO, 2 },
>> +};
>> +
>> +static const struct clk_parent_data gcc_parent_data_14[] = {
>> +    { .fw_name = "pcie_2_pipe_clk" },
>> +    { .index = DT_BI_TCXO },
>> +};
>> +
>> +static const struct parent_map gcc_parent_map_15[] = {
>> +    { P_PCIE20_PHY_AUX_CLK, 0 },
>> +    { P_BI_TCXO, 2 },
>> +};
>> +
>> +static const struct clk_parent_data gcc_parent_data_15[] = {
>> +    { .fw_name = "pcie20_phy_aux_clk" },
>> +    { .index = DT_BI_TCXO },
>> +};
>> +
>> +static const struct parent_map gcc_parent_map_16[] = {
>> +    { P_PCIE_PIPE_CLK, 0 },
>> +    { P_BI_TCXO, 2 },
>> +};
>> +
>> +static const struct clk_parent_data gcc_parent_data_16[] = {
>> +    { .fw_name = "pcie_pipe_clk" },
>> +    { .index = DT_BI_TCXO },
>> +};
>> +
>> +static const struct parent_map gcc_parent_map_17[] = {
>> +    { P_BI_TCXO, 0 },
>> +    { P_GPLL0_OUT_MAIN, 1 },
>> +    { P_GPLL6_OUT_MAIN, 2 },
>> +    { P_GPLL0_OUT_EVEN, 6 },
>> +};
>> +
>> +static const struct clk_parent_data gcc_parent_data_17[] = {
>> +    { .index = DT_BI_TCXO },
>> +    { .hw = &gpll0.clkr.hw },
>> +    { .hw = &gpll6.clkr.hw },
>> +    { .hw = &gpll0_out_even.clkr.hw },
>> +};
>> +
>> +static const struct parent_map gcc_parent_map_18[] = {
>> +    { P_BI_TCXO, 0 },
>> +    { P_GPLL0_OUT_MAIN, 1 },
>> +    { P_GPLL8_OUT_MAIN, 2 },
>> +    { P_GPLL0_OUT_EVEN, 6 },
>> +};
>> +
>> +static const struct clk_parent_data gcc_parent_data_18[] = {
>> +    { .index = DT_BI_TCXO },
>> +    { .hw = &gpll0.clkr.hw },
>> +    { .hw = &gpll8.clkr.hw },
>> +    { .hw = &gpll0_out_even.clkr.hw },
>> +};
>> +
>> +static const struct parent_map gcc_parent_map_19[] = {
>> +    { P_USB3_PHY_WRAPPER_GCC_USB30_PIPE_CLK, 0 },
>> +    { P_BI_TCXO, 2 },
>> +};
>> +
>> +static const struct clk_parent_data gcc_parent_data_19[] = {
>> +    { .fw_name = "usb3_phy_wrapper_gcc_usb30_pipe_clk" },
>> +    { .index = DT_BI_TCXO },
>> +};
>> +
>> +static struct clk_regmap_mux gcc_emac0_cc_sgmiiphy_rx_clk_src = {
>> +    .reg = 0x71060,
>> +    .shift = 0,
>> +    .width = 2,
>> +    .parent_map = gcc_parent_map_5,
>> +    .clkr = {
>> +        .hw.init = &(const struct clk_init_data) {
>> +            .name = "gcc_emac0_cc_sgmiiphy_rx_clk_src",
>> +            .parent_data = gcc_parent_data_5,
>> +            .num_parents = ARRAY_SIZE(gcc_parent_data_5),
>> +            .ops = &clk_regmap_mux_closest_ops,
>> +        },
>> +    },
>> +};
>> +
>> +static struct clk_regmap_mux gcc_emac0_cc_sgmiiphy_tx_clk_src = {
>> +    .reg = 0x71058,
>> +    .shift = 0,
>> +    .width = 2,
>> +    .parent_map = gcc_parent_map_6,
>> +    .clkr = {
>> +        .hw.init = &(const struct clk_init_data) {
>> +            .name = "gcc_emac0_cc_sgmiiphy_tx_clk_src",
>> +            .parent_data = gcc_parent_data_6,
>> +            .num_parents = ARRAY_SIZE(gcc_parent_data_6),
>> +            .ops = &clk_regmap_mux_closest_ops,
>> +        },
>> +    },
>> +};
>> +
>> +static struct clk_regmap_mux gcc_emac0_sgmiiphy_mac_rclk_src = {
>> +    .reg = 0x71098,
>> +    .shift = 0,
>> +    .width = 2,
>> +    .parent_map = gcc_parent_map_7,
>> +    .clkr = {
>> +        .hw.init = &(const struct clk_init_data) {
>> +            .name = "gcc_emac0_sgmiiphy_mac_rclk_src",
>> +            .parent_data = gcc_parent_data_7,
>> +            .num_parents = ARRAY_SIZE(gcc_parent_data_7),
>> +            .ops = &clk_regmap_mux_closest_ops,
>> +        },
>> +    },
>> +};
>> +
>> +static struct clk_regmap_mux gcc_emac0_sgmiiphy_mac_tclk_src = {
>> +    .reg = 0x71094,
>> +    .shift = 0,
>> +    .width = 2,
>> +    .parent_map = gcc_parent_map_8,
>> +    .clkr = {
>> +        .hw.init = &(const struct clk_init_data) {
>> +            .name = "gcc_emac0_sgmiiphy_mac_tclk_src",
>> +            .parent_data = gcc_parent_data_8,
>> +            .num_parents = ARRAY_SIZE(gcc_parent_data_8),
>> +            .ops = &clk_regmap_mux_closest_ops,
>> +        },
>> +    },
>> +};
>> +
>> +static struct clk_regmap_mux gcc_emac1_cc_sgmiiphy_rx_clk_src = {
>> +    .reg = 0x72060,
>> +    .shift = 0,
>> +    .width = 2,
>> +    .parent_map = gcc_parent_map_9,
>> +    .clkr = {
>> +        .hw.init = &(const struct clk_init_data) {
>> +            .name = "gcc_emac1_cc_sgmiiphy_rx_clk_src",
>> +            .parent_data = gcc_parent_data_9,
>> +            .num_parents = ARRAY_SIZE(gcc_parent_data_9),
>> +            .ops = &clk_regmap_mux_closest_ops,
>> +        },
>> +    },
>> +};
>> +
>> +static struct clk_regmap_mux gcc_emac1_cc_sgmiiphy_tx_clk_src = {
>> +    .reg = 0x72058,
>> +    .shift = 0,
>> +    .width = 2,
>> +    .parent_map = gcc_parent_map_10,
>> +    .clkr = {
>> +        .hw.init = &(const struct clk_init_data) {
>> +            .name = "gcc_emac1_cc_sgmiiphy_tx_clk_src",
>> +            .parent_data = gcc_parent_data_10,
>> +            .num_parents = ARRAY_SIZE(gcc_parent_data_10),
>> +            .ops = &clk_regmap_mux_closest_ops,
>> +        },
>> +    },
>> +};
>> +
>> +static struct clk_regmap_mux gcc_emac1_sgmiiphy_mac_rclk_src = {
>> +    .reg = 0x72098,
>> +    .shift = 0,
>> +    .width = 2,
>> +    .parent_map = gcc_parent_map_11,
>> +    .clkr = {
>> +        .hw.init = &(const struct clk_init_data) {
>> +            .name = "gcc_emac1_sgmiiphy_mac_rclk_src",
>> +            .parent_data = gcc_parent_data_11,
>> +            .num_parents = ARRAY_SIZE(gcc_parent_data_11),
>> +            .ops = &clk_regmap_mux_closest_ops,
>> +        },
>> +    },
>> +};
>> +
>> +static struct clk_regmap_mux gcc_emac1_sgmiiphy_mac_tclk_src = {
>> +    .reg = 0x72094,
>> +    .shift = 0,
>> +    .width = 2,
>> +    .parent_map = gcc_parent_map_12,
>> +    .clkr = {
>> +        .hw.init = &(const struct clk_init_data) {
>> +            .name = "gcc_emac1_sgmiiphy_mac_tclk_src",
>> +            .parent_data = gcc_parent_data_12,
>> +            .num_parents = ARRAY_SIZE(gcc_parent_data_12),
>> +            .ops = &clk_regmap_mux_closest_ops,
>> +        },
>> +    },
>> +};
>> +
>> +static struct clk_regmap_mux gcc_pcie_1_pipe_clk_src = {
>> +    .reg = 0x67084,
>> +    .shift = 0,
>> +    .width = 2,
>> +    .parent_map = gcc_parent_map_13,
>> +    .clkr = {
>> +        .hw.init = &(const struct clk_init_data) {
>> +            .name = "gcc_pcie_1_pipe_clk_src",
>> +            .parent_data = gcc_parent_data_13,
>> +            .num_parents = ARRAY_SIZE(gcc_parent_data_13),
>> +            .ops = &clk_regmap_mux_closest_ops,
> 
> Are these clocks a clk_regmap_mux_closest_ops in reality 
> clk_regmap_phy_mux_ops?

clk_regmap_phy_mux_ops cannot be used here, as multi parent mux requires 
the .get_parent ops to be supported.

> 
>> +        },
>> +    },



-- 
Thanks & Regards,
Taniya Das.

