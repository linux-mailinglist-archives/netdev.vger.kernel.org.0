Return-Path: <netdev+bounces-2072-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3FAF70031B
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:58:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D59A281A68
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:58:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3AB9A924;
	Fri, 12 May 2023 08:58:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2739EDA
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 08:58:19 +0000 (UTC)
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED80FE43;
	Fri, 12 May 2023 01:58:17 -0700 (PDT)
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34C7cc5V030388;
	Fri, 12 May 2023 08:57:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=IxvYox8iISCxq2a0JNGYr4eSPlCMv5SdB3EEdXVzUtk=;
 b=oa1kucphpcGWROYxkXLPoKc8x7QYJjxii9EaIMqhglWRu1fJV+iMqjgoNrFEW9kB23KE
 0yoRs5oR997weq7VmxP4sl174OWjSuUligkghv3QPsIAJnL5aRNtcfhs0VBeEg7xochc
 JHE3m6zvIawHr4+melmU7uT4jgBE8crmcByO5V2ZHtObuAWI/dQuzV3oqb14fG1pi5vm
 ZoFnjjVB00ktiYSm2DNffv6mTbOHBVujllE0EHdfFwobCLDpP3TH2Bsm2jKH07Kw4BhP
 v7x2yiQ1OayxcnXzUBlh0sQlDXn5N6WqkpX5vfsUomZXxcpxfPlOxOMcFEFwzxzX4wFL Gg== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qh5g99gqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 May 2023 08:57:36 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 34C8vZYx016776
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 May 2023 08:57:35 GMT
Received: from [10.214.66.58] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Fri, 12 May
 2023 01:57:30 -0700
Message-ID: <a66293bf-3231-dc23-aed4-22cbb91c3a5e@quicinc.com>
Date: Fri, 12 May 2023 14:27:28 +0530
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v7 4/4] pinctrl: qcom: Add SDX75 pincontrol driver
Content-Language: en-US
To: Bjorn Andersson <andersson@kernel.org>
CC: <agross@kernel.org>, <konrad.dybcio@linaro.org>,
        <linus.walleij@linaro.org>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <richardcochran@gmail.com>,
        <manivannan.sadhasivam@linaro.org>, <andy.shevchenko@gmail.com>,
        <linux-arm-msm@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <1683730825-15668-1-git-send-email-quic_rohiagar@quicinc.com>
 <1683730825-15668-5-git-send-email-quic_rohiagar@quicinc.com>
 <20230511164623.iaziwwwfyroextce@ripper>
From: Rohit Agarwal <quic_rohiagar@quicinc.com>
In-Reply-To: <20230511164623.iaziwwwfyroextce@ripper>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: PUj2yMS-fM6EAHgsFWIa7Hg3kpfcu60o
X-Proofpoint-ORIG-GUID: PUj2yMS-fM6EAHgsFWIa7Hg3kpfcu60o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-12_05,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 impostorscore=0 malwarescore=0
 suspectscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305120074
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 5/11/2023 10:16 PM, Bjorn Andersson wrote:
> On Wed, May 10, 2023 at 08:30:25PM +0530, Rohit Agarwal wrote:
>> Add initial Qualcomm SDX75 pinctrl driver to support pin configuration
>> with pinctrl framework for SDX75 SoC.
>> While at it, reordering the SDX65 entry.
>>
> Nice, some comment below.
>
>> Signed-off-by: Rohit Agarwal <quic_rohiagar@quicinc.com>
>> ---
> [..]
>> diff --git a/drivers/pinctrl/qcom/pinctrl-sdx75.c b/drivers/pinctrl/qcom/pinctrl-sdx75.c
>> new file mode 100644
>> index 0000000..6f95c0a
>> --- /dev/null
>> +++ b/drivers/pinctrl/qcom/pinctrl-sdx75.c
>> @@ -0,0 +1,1595 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (c) 2023 Qualcomm Innovation Center, Inc. All rights reserved.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_device.h>
>> +#include <linux/platform_device.h>
>> +#include "pinctrl-msm.h"
>> +
>> +#define REG_BASE 0x100000
> We typically reference the inner TLMM block and omit this offset... But
> I don't have a strong opinion.
>
> [..]
>
>> +enum sdx75_functions {
>> +	msm_mux_gpio,
> Please sort these alphabetically.
>
>> +	msm_mux_eth0_mdc,
> [..]
>> +	msm_mux__,
>> +};
>> +
> [..]
>> +static const struct pinfunction sdx75_functions[] = {
>> +	MSM_PIN_FUNCTION(gpio),
>> +	MSM_PIN_FUNCTION(eth0_mdc),
> Please sort these alphabetically, and please squash individual pins into
> their functional group.
>
> [..]
>> +	MSM_PIN_FUNCTION(qup_se0_l0),
>> +	MSM_PIN_FUNCTION(qup_se0_l1),
>> +	MSM_PIN_FUNCTION(qup_se0_l2),
>> +	MSM_PIN_FUNCTION(qup_se0_l3),
> E.g. this forces the DT writer to write individual -pins for each
> signal. Better keep it "qup_se0" and the author is free to group the
> pins in their states as they need (and as you know you don't need to
> specify all pins for a given function).
>
> [..]
>> +};
>> +
>> +/* Every pin is maintained as a single group, and missing or non-existing pin
>> + * would be maintained as dummy group to synchronize pin group index with
>> + * pin descriptor registered with pinctrl core.
>> + * Clients would not be able to request these dummy pin groups.
>> + */
> Please omit this comment.
>
>> +static const struct msm_pingroup sdx75_groups[] = {
> [..]
>> +	[16] = PINGROUP(16, pri_mi2s_ws, qup_se2_l2, qup_se1_l2_mirb, qdss_cti,
>> +			qdss_cti, _, _, _, _, _),
> Please break the rules and leave these lines unwrapped.
>
>> +	[17] = PINGROUP(17, pri_mi2s_data0, qup_se2_l3, qup_se1_l3_mirb,
>> +			qdss_cti, qdss_cti, _, _, _, _, _),
> [..]
>> +	[131] = PINGROUP(131, _, _, _, _, _, _, _, _, _, _),
>> +	[132] =	PINGROUP(132, _, _, _, _, _, _, _, _, _, _),
>> +	[133] = SDC_QDSD_PINGROUP(sdc1_rclk, 0x19A000, 16, 0),
> Lowercase hex digits please.
>
>> +	[134] = SDC_QDSD_PINGROUP(sdc1_clk, 0x19A000, 14, 6),
>> +	[135] = SDC_QDSD_PINGROUP(sdc1_cmd, 0x19A000, 11, 3),
>> +	[136] = SDC_QDSD_PINGROUP(sdc1_data, 0x19A000, 9, 0),
>> +	[137] = SDC_QDSD_PINGROUP(sdc2_clk, 0x19B000, 14, 6),
>> +	[138] = SDC_QDSD_PINGROUP(sdc2_cmd, 0x19B000, 11, 3),
>> +	[139] = SDC_QDSD_PINGROUP(sdc2_data, 0x19B000, 9, 0),
>> +};
> [..]
>> +static const struct of_device_id sdx75_pinctrl_of_match[] = {
>> +	{ .compatible = "qcom,sdx75-tlmm", .data = &sdx75_pinctrl },
>> +	{ }
>> +};
>> +
> [..]
>> +
>> +MODULE_DESCRIPTION("QTI sdx75 pinctrl driver");
>> +MODULE_LICENSE("GPL");
>> +MODULE_DEVICE_TABLE(of, sdx75_pinctrl_of_match);
> Keep the MODULE_DEVICE_TABLE() just below the sdx75_pinctrl_of_match
> please, so future readers doesn't need to search for it.
Will update all the comments in the next patch version.

Thanks for reviewing,
Rohit
> Regards,
> Bjorn

