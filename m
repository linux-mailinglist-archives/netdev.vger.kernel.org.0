Return-Path: <netdev+bounces-1093-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99DDE6FC266
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:09:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71DE5280C6B
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:09:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A55F85673;
	Tue,  9 May 2023 09:09:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FE617C2
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 09:09:52 +0000 (UTC)
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F19D2;
	Tue,  9 May 2023 02:09:50 -0700 (PDT)
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3497wi1W024934;
	Tue, 9 May 2023 09:09:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=2jjYTW2QY7LaQiGHgOA8YEiVll5kvVeAt8E4zatt5z0=;
 b=eymY5OterDkErlO6yOonDwRtpsW6GEqkTWrrZQRaoVOzTed0rdR7xeYOqzjHv19jh5Pb
 ELu+bD9qMd+GtyxMobkGG/mUry0u20Q4v+hNkc9YH35AJHo8ylCEzG2DG4TSuNGVYvg/
 s/zJX60Gv8tQ9YZmcoyWJO1hJO1/8LJsZ66YBFT6w7qPGRmkcrUbCvEpoj0CifPdliWP
 sNZVXV8r6zOGRaJwos1xMDv6rBlyYD/8h5pvRrqlgg7qYGkDukOzgrZWtKEiuTtU3ZbW
 iY7JfrgnWmBvLucSdVgwsiC+zITt+LFfPUq0vIcZKRE8bIGNvVDcpQpSo2VcobqhDBFV 2g== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qf78ps80b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 May 2023 09:09:45 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 34999ihb014166
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 9 May 2023 09:09:44 GMT
Received: from [10.216.33.39] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Tue, 9 May 2023
 02:09:39 -0700
Message-ID: <2d60886f-a731-ee29-dd2e-1a1438bd7d03@quicinc.com>
Date: Tue, 9 May 2023 14:39:36 +0530
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH 2/4] dt-bindings: clock: Add GCC bindings support for
 SDX75
Content-Language: en-US
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
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
 <20230419133013.2563-3-quic_tdas@quicinc.com>
 <3b7394e1-1be7-ec38-61bd-708a624070ac@linaro.org>
From: Taniya Das <quic_tdas@quicinc.com>
In-Reply-To: <3b7394e1-1be7-ec38-61bd-708a624070ac@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: nzuZDC-rN7_ZBwO-wxLot06H_egbKl9p
X-Proofpoint-GUID: nzuZDC-rN7_ZBwO-wxLot06H_egbKl9p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-09_05,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 clxscore=1015 suspectscore=0
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2305090070
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thanks for the review.

On 4/19/2023 11:41 PM, Krzysztof Kozlowski wrote:
> On 19/04/2023 15:30, Taniya Das wrote:
>> From: Imran Shaik <quic_imrashai@quicinc.com>
>>
> 
> Thank you for your patch. There is something to discuss/improve.
> 
>> Add support for GCC bindings and update documentation for
>> clock rpmh driver for SDX75.
> 
> Subject: drop second/last, redundant "bindings support for". The
> "dt-bindings" prefix is already stating that these are bindings.
> But missing vendor name (Qualcomm). Both in subject and commit msg.
> 
> 

All the below comments will be taken care in the next patchset.

> 
>>
>> Signed-off-by: Imran Shaik <quic_imrashai@quicinc.com>
>> Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
>> ---
>>   .../bindings/clock/qcom,gcc-sdx75.yaml        |  69 +++++++
>>   .../bindings/clock/qcom,rpmhcc.yaml           |   1 +
>>   include/dt-bindings/clock/qcom,gcc-sdx75.h    | 193 ++++++++++++++++++
>>   3 files changed, 263 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/clock/qcom,gcc-sdx75.yaml
>>   create mode 100644 include/dt-bindings/clock/qcom,gcc-sdx75.h
>>
>> diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sdx75.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-sdx75.yaml
>> new file mode 100644
>> index 000000000000..6489d857d5c4
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sdx75.yaml
> 
> All new devices come as SoC-IP, so qcom,sdx75-gcc
> 
>> @@ -0,0 +1,69 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/clock/qcom,gcc-sdx75.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: Qualcomm Global Clock & Reset Controller on SDX75
>> +
>> +maintainers:
>> +  - Imran Shaik <quic_imrashai@quicinc.com>
>> +  - Taniya Das <quic_tdas@quicinc.com>
>> +
>> +description: |
>> +  Qualcomm global clock control module provides the clocks, resets and power
>> +  domains on SDX75
>> +
>> +  See also:: include/dt-bindings/clock/qcom,gcc-sdx75.h
> 
> Also hee
> 
>> +
>> +properties:
>> +  compatible:
>> +    const: qcom,gcc-sdx75
> 
> Also here
> 
>> +
>> +  clocks:
>> +    items:
>> +      - description: Board XO source
>> +      - description: PCIE20 phy aux clock source
>> +      - description: PCIE_1 Pipe clock source
>> +      - description: PCIE_2 Pipe clock source
>> +      - description: PCIE Pipe clock source
>> +      - description: Sleep clock source
>> +      - description: USB3 phy wrapper pipe clock source
>> +
>> +  clock-names:
>> +    items:
>> +      - const: bi_tcxo
>> +      - const: pcie20_phy_aux_clk
>> +      - const: pcie_1_pipe_clk
>> +      - const: pcie_2_pipe_clk
>> +      - const: pcie_pipe_clk
>> +      - const: sleep_clk
>> +      - const: usb3_phy_wrapper_gcc_usb30_pipe_clk
> 
> Drop clock names entirely.
> 
>> +
>> +required:
>> +  - compatible
>> +  - clocks
>> +  - clock-names
>> +
>> +allOf:
>> +  - $ref: qcom,gcc.yaml#
>> +
>> +unevaluatedProperties: false
>> +
>> +examples:
>> +  - |
>> +    #include <dt-bindings/clock/qcom,rpmh.h>
>> +    clock-controller@80000 {
>> +      compatible = "qcom,gcc-sdx75";
>> +      reg = <0x80000 0x1f7400>;
>> +      clocks = <&rpmhcc RPMH_CXO_CLK>, <&pcie20_phy_aux_clk>, <&pcie_1_pipe_clk>,
>> +               <&pcie_2_pipe_clk>, <&pcie_pipe_clk>, <&sleep_clk>,
>> +               <&usb3_phy_wrapper_gcc_usb30_pipe_clk>;
>> +      clock-names = "bi_tcxo", "pcie20_phy_aux_clk", "pcie_1_pipe_clk",
>> +                    "pcie_2_pipe_clk", "pcie_pipe_clk", "sleep_clk",
>> +                    "usb3_phy_wrapper_gcc_usb30_pipe_clk";
>> +      #clock-cells = <1>;
>> +      #reset-cells = <1>;
>> +      #power-domain-cells = <1>;
>> +    };
>> +...
>> diff --git a/Documentation/devicetree/bindings/clock/qcom,rpmhcc.yaml b/Documentation/devicetree/bindings/clock/qcom,rpmhcc.yaml
>> index d5a250b7c2af..267cf8c26823 100644
>> --- a/Documentation/devicetree/bindings/clock/qcom,rpmhcc.yaml
>> +++ b/Documentation/devicetree/bindings/clock/qcom,rpmhcc.yaml
>> @@ -27,6 +27,7 @@ properties:
>>         - qcom,sdm845-rpmh-clk
>>         - qcom,sdx55-rpmh-clk
>>         - qcom,sdx65-rpmh-clk
>> +      - qcom,sdx75-rpmh-clk
> 
> Separate patch.
> 
> 
>>         - qcom,sm6350-rpmh-clk
>>         - qcom,sm8150-rpmh-clk
>>         - qcom,sm8250-rpmh-clk
>> diff --git a/include/dt-bindings/clock/qcom,gcc-sdx75.h b/include/dt-bindings/clock/qcom,gcc-sdx75.h
>> new file mode 100644
>> index 000000000000..a470e8c4fd41
>> --- /dev/null
>> +++ b/include/dt-bindings/clock/qcom,gcc-sdx75.h
> 
> qcom,sdx75-gcc
> 
>> @@ -0,0 +1,193 @@
>> +/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */
>> +/*
>> + * Copyright (c) 2022-2023, Qualcomm Innovation Center, Inc. All rights reserved.
>> + */
>> +
>> +#ifndef _DT_BINDINGS_CLK_QCOM_GCC_SDX75_H
>> +#define _DT_BINDINGS_CLK_QCOM_GCC_SDX75_H
>> +
>> +/* GCC clocks */
> 
> 
> Best regards,
> Krzysztof
> 

-- 
Thanks & Regards,
Taniya Das.

