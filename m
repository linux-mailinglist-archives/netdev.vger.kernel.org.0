Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948C46EA48B
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 09:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbjDUHSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 03:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbjDUHSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 03:18:45 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C5E93DD;
        Fri, 21 Apr 2023 00:18:17 -0700 (PDT)
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33L4ri4O030244;
        Fri, 21 Apr 2023 07:18:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=MMbu8AVje94TL2LrIbbYFPGR0xdwPu3iS/k7ci3jtTg=;
 b=M1XheFtdZf7G1xNpwgCSNxsSORD15RbhmpnSNxnWxV8e/61/vmPSNmmTBPUByai6Q8ry
 /hFLMqLX7lNW7c/4430XcRT6l66kEMpazCBgzQurzYt6ZTH0qO0EhkajM/nPGxptHqvm
 llbz8+iD8wrT9Vs/TXsF385+dJPHjONFbC3qOMQeFkw+v6qnUXlg61IDMuXJkGDxeUEV
 AtxLGS3UryEP5vKUo3oYgRTykYz4WsviXmA1eLVAHLQbesDFOPAm/BQ7VWvUMPtL6bVV
 kr88QZqAFvnO6BQRA8C+OPXKAzNqs4V13OACVJKffaSpC+bkG6QHwiNnlmvieR9na3UH 4A== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3q3ewh0rwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 07:18:13 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 33L7IBcK021378
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 07:18:11 GMT
Received: from [10.216.54.119] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Fri, 21 Apr
 2023 00:18:03 -0700
Message-ID: <bbf3c3fa-1ab6-e438-860b-bbf19349eb86@quicinc.com>
Date:   Fri, 21 Apr 2023 12:47:41 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 1/2] dt-bindings: pinctrl: qcom: Add SDX75 pinctrl
 devicetree compatible
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        <agross@kernel.org>, <andersson@kernel.org>,
        <konrad.dybcio@linaro.org>, <linus.walleij@linaro.org>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <richardcochran@gmail.com>, <manivannan.sadhasivam@linaro.org>
CC:     <linux-arm-msm@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <1681966915-15720-1-git-send-email-quic_rohiagar@quicinc.com>
 <1681966915-15720-2-git-send-email-quic_rohiagar@quicinc.com>
 <73644f38-8165-f041-f9d7-a2f2bdd69f17@linaro.org>
From:   Rohit Agarwal <quic_rohiagar@quicinc.com>
In-Reply-To: <73644f38-8165-f041-f9d7-a2f2bdd69f17@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: Mez6ong0_FSLr-OyUMBc24L1N0RERvwZ
X-Proofpoint-GUID: Mez6ong0_FSLr-OyUMBc24L1N0RERvwZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-21_01,2023-04-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 clxscore=1011
 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304210062
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/20/2023 6:16 PM, Krzysztof Kozlowski wrote:
> On 20/04/2023 07:01, Rohit Agarwal wrote:
>> Add device tree binding Documentation details for Qualcomm SDX75
>> pinctrl driver.
>>
>> Signed-off-by: Rohit Agarwal <quic_rohiagar@quicinc.com>
>> ---
>>   .../bindings/pinctrl/qcom,sdx75-tlmm.yaml          | 195 +++++++++++++++++++++
>>   1 file changed, 195 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml b/Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml
>> new file mode 100644
>> index 0000000..1d03f13
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml
>> @@ -0,0 +1,195 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/bindings/pinctrl/qcom,sdx75-tlmm.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: Qualcomm Technologies, Inc. SDX75 TLMM block
>> +
>> +maintainers:
>> +  - Rohit Agarwal <quic_rohiagar@quicinc.com>
>> +
>> +description: |
>> +  This binding describes the Top Level Mode Multiplexer block and found in
>> +  SDX75 platform.
> Please start from some existing bindings to avoid all the issues we
> fixed. This binding does not look like current ones.
Sure Krzysztof, Will update this as per the new format of bindings.
Thanks,
Rohit.
>
> Best regards,
> Krzysztof
>
