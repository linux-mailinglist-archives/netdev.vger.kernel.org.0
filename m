Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD416F02D2
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 10:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243188AbjD0Ixe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 04:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242755AbjD0Ixc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 04:53:32 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6756A4EC1;
        Thu, 27 Apr 2023 01:53:29 -0700 (PDT)
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33R7Fnrm021851;
        Thu, 27 Apr 2023 08:53:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=Ie5ALX/3VJVLEugjsOClj9TQHZGvD+KFdEuky2kHy2M=;
 b=NtFu0m5IudiQqvR+zxR5wXku2m0kAe6elEPNKVyEleveLlCgveGS0l4VJ1qPLZDIMgMc
 fGZhn2b/w49oM/OdGKSotR9Q+wf0kRmS4uHe2rbVW+fXTexNSRO5tv7sQMPCWz6GYpMS
 vGEjb+XMUoeULSrcEeN5NWUN5qgaeroDS+tAyjBoZskbDnsNB/SbAeE3X+gLDhnZMz6m
 18oOF89y4zEUmBXezS0pGfJfEndHYajgtXfEO8voZbH6tVUi9Dc9ceKKjPkAWc/Mpp6f
 cRbQZUqPMN/v2pEwmLxhLDO3DhycnxJCN28k8CF5siZ4lNpnJ2ShFOnuZLgDncJ46p7e Gw== 
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3q7j4erg2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 08:53:25 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 33R8rNQt028483
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 08:53:23 GMT
Received: from [10.214.66.58] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Thu, 27 Apr
 2023 01:53:19 -0700
Message-ID: <1ed28be7-7bb5-acc5-c955-f4cf238ffc49@quicinc.com>
Date:   Thu, 27 Apr 2023 14:23:16 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v4 2/2] pinctrl: qcom: Add SDX75 pincontrol driver
Content-Language: en-US
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
CC:     <agross@kernel.org>, <andersson@kernel.org>,
        <konrad.dybcio@linaro.org>, <linus.walleij@linaro.org>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <richardcochran@gmail.com>, <manivannan.sadhasivam@linaro.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <1682327030-25535-1-git-send-email-quic_rohiagar@quicinc.com>
 <1682327030-25535-3-git-send-email-quic_rohiagar@quicinc.com>
 <ZEk9lySMZcrRZYwX@surfacebook>
 <66158251-6934-a07f-4b82-4deaa76fa482@quicinc.com>
 <CAHp75VcCAOD3utLjjXeQ97nGcUTm7pic5F52+e7cJDxpDXwttA@mail.gmail.com>
From:   Rohit Agarwal <quic_rohiagar@quicinc.com>
In-Reply-To: <CAHp75VcCAOD3utLjjXeQ97nGcUTm7pic5F52+e7cJDxpDXwttA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: WuaDZGdObsBJ0i8pV1cu3eJbPywxErRL
X-Proofpoint-GUID: WuaDZGdObsBJ0i8pV1cu3eJbPywxErRL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-27_06,2023-04-26_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 spamscore=0 mlxscore=0
 mlxlogscore=442 lowpriorityscore=0 phishscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304270076
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/26/2023 10:12 PM, Andy Shevchenko wrote:
> On Wed, Apr 26, 2023 at 6:18 PM Rohit Agarwal <quic_rohiagar@quicinc.com> wrote:
>> On 4/26/2023 8:34 PM, andy.shevchenko@gmail.com wrote:
>>> Mon, Apr 24, 2023 at 02:33:50PM +0530, Rohit Agarwal kirjoitti:
> ...
>
>>>> +#define FUNCTION(fname)                                                     \
>>>> +    [msm_mux_##fname] = {                                           \
>>>> +            .name = #fname,                                         \
>>>> +            .groups = fname##_groups,                               \
>>>> +    .ngroups = ARRAY_SIZE(fname##_groups),                          \
>>>> +    }
>>> PINCTRL_PINFUNCTION() ?
>> Ok, Will update this. Shall I also update "PINGROUP" to "PINCTRL_PINGROUP"?
> Yes, please.
PINCTRL_PINGROUP cannot be used as it is, since msm_pigroup has multiple 
other fields that needs to be set
for each pingroup defined.
Would rename this to SDX75_PINGROUP, as seen on some other platforms.
Would that be ok?

Thanks,
Rohit.
>
