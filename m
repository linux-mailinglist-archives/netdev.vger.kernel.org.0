Return-Path: <netdev+bounces-1468-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A3906FDD84
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:16:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7109281356
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 12:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4F2312B73;
	Wed, 10 May 2023 12:16:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5562105
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 12:16:11 +0000 (UTC)
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37DF7D85;
	Wed, 10 May 2023 05:16:08 -0700 (PDT)
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34ABWnju020035;
	Wed, 10 May 2023 12:16:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=G3T57yHsK+Ldw+osZ3of3JF0Uc5zm+fdQ05Fc4Z+g+Q=;
 b=ElzJiAnfCnESM/Wh8jz91+bjp+dn0QOYkAaEcNcF+0F/GG01Xv/mzdzjvqgAnn36//HO
 4NoNeNloX+65F7Rccd+P3n89alH5cKRy/u8L13vZ5TlAo/w+tWeKvMbi4DaY5kaFr8p0
 ReJXrvBVLb03jt29Gl79I6OYblhLL20BeEsGcf0UYh+/v3xRIE12tUr0JIRZtTvPyMVz
 jf6CqlAhcKwrqlwu3sGUrjpI4eexuq4Ig/E/kO3tenv8CsSCRGHhvTiJpqxEH3bIDgye
 Vi21Dny7jxSUv1X66H+M6JsHYOHIGLLeQOefgt5S/KU4gc3zh81L68t9xl4OxWN5XgjU JQ== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qfruta2w2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 May 2023 12:16:03 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 34ACG24b018967
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 May 2023 12:16:02 GMT
Received: from [10.214.66.58] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Wed, 10 May
 2023 05:15:57 -0700
Message-ID: <c0c3db1d-e83c-3610-ed61-db84cd88b569@quicinc.com>
Date: Wed, 10 May 2023 17:45:54 +0530
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v6 0/4] Add pinctrl support for SDX75
Content-Language: en-US
To: <andy.shevchenko@gmail.com>, <agross@kernel.org>, <andersson@kernel.org>,
        <konrad.dybcio@linaro.org>, <linus.walleij@linaro.org>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <richardcochran@gmail.com>, <manivannan.sadhasivam@linaro.org>,
        Mukesh Ojha <quic_mojha@quicinc.com>
CC: <linux-arm-msm@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <1683718725-14869-1-git-send-email-quic_rohiagar@quicinc.com>
From: Rohit Agarwal <quic_rohiagar@quicinc.com>
In-Reply-To: <1683718725-14869-1-git-send-email-quic_rohiagar@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: QiqRx-tcUuWKf8IOEz2yko6MXCbzTtmy
X-Proofpoint-ORIG-GUID: QiqRx-tcUuWKf8IOEz2yko6MXCbzTtmy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 phishscore=0 bulkscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=966
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305100096
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 5/10/2023 5:08 PM, Rohit Agarwal wrote:
> Hi,
>
> Changes in v6:
>   - Refactoring as per suggestions from Andy to remove msm_function and
>     reusing the pinfunction and pingroup struct with macros as well.

Patch 2/4 didnt go through in the mailing list linux-arm-msm because of 
char length.
BOUNCE linux-arm-msm@vger.kernel.org: Message too long (>100000 chars)

Here is the link for it. 
https://lore.kernel.org/all/1683718725-14869-3-git-send-email-quic_rohiagar@quicinc.com/
Please suggest if this patch needs to be broken down.

Thanks,
Rohit.
> Changes in v5:
>   - Refactor the pinctrl target files based on the new macro and
>     structure defined as suggested by Andy.
>
> Changes in v4:
>   - Fixed the bindings check and rebased on linux-next.
>
> Changes in v3:
>   - Rebased the bindings on linux-next as suggested by Krzysztof.
>
> Changes in v2:
>   - Updated the bindings to clear the bindings check.
>
> This patch series adds pinctrl bindings and tlmm support for SDX75.
>
> Thanks,
> Rohit.
>
> Rohit Agarwal (4):
>    dt-bindings: pinctrl: qcom: Add SDX75 pinctrl devicetree compatible
>    pinctrl: qcom: Remove the msm_function struct
>    pinctrl: qcom: Refactor generic qcom pinctrl driver
>    pinctrl: qcom: Add SDX75 pincontrol driver
>
>   .../bindings/pinctrl/qcom,sdx75-tlmm.yaml          |  169 +++
>   drivers/pinctrl/qcom/Kconfig                       |   30 +-
>   drivers/pinctrl/qcom/Makefile                      |    3 +-
>   drivers/pinctrl/qcom/pinctrl-apq8064.c             |  104 +-
>   drivers/pinctrl/qcom/pinctrl-apq8084.c             |  264 ++--
>   drivers/pinctrl/qcom/pinctrl-ipq4019.c             |  104 +-
>   drivers/pinctrl/qcom/pinctrl-ipq5332.c             |  206 ++-
>   drivers/pinctrl/qcom/pinctrl-ipq6018.c             |  260 ++--
>   drivers/pinctrl/qcom/pinctrl-ipq8064.c             |  114 +-
>   drivers/pinctrl/qcom/pinctrl-ipq8074.c             |  240 ++-
>   drivers/pinctrl/qcom/pinctrl-mdm9607.c             |  276 ++--
>   drivers/pinctrl/qcom/pinctrl-mdm9615.c             |   90 +-
>   drivers/pinctrl/qcom/pinctrl-msm.c                 |   13 +-
>   drivers/pinctrl/qcom/pinctrl-msm.h                 |   42 +-
>   drivers/pinctrl/qcom/pinctrl-msm8226.c             |  156 +-
>   drivers/pinctrl/qcom/pinctrl-msm8660.c             |  252 ++-
>   drivers/pinctrl/qcom/pinctrl-msm8909.c             |  268 ++--
>   drivers/pinctrl/qcom/pinctrl-msm8916.c             |  556 ++++---
>   drivers/pinctrl/qcom/pinctrl-msm8953.c             |  424 +++---
>   drivers/pinctrl/qcom/pinctrl-msm8960.c             |  464 +++---
>   drivers/pinctrl/qcom/pinctrl-msm8976.c             |  212 ++-
>   drivers/pinctrl/qcom/pinctrl-msm8994.c             |  564 ++++---
>   drivers/pinctrl/qcom/pinctrl-msm8996.c             |  508 +++----
>   drivers/pinctrl/qcom/pinctrl-msm8998.c             |  380 +++--
>   drivers/pinctrl/qcom/pinctrl-msm8x74.c             |  474 +++---
>   drivers/pinctrl/qcom/pinctrl-qcm2290.c             |  230 ++-
>   drivers/pinctrl/qcom/pinctrl-qcs404.c              |  388 +++--
>   drivers/pinctrl/qcom/pinctrl-qdf2xxx.c             |    6 +-
>   drivers/pinctrl/qcom/pinctrl-qdu1000.c             |  249 ++-
>   drivers/pinctrl/qcom/pinctrl-sa8775p.c             |  308 ++--
>   drivers/pinctrl/qcom/pinctrl-sc7180.c              |  254 ++--
>   drivers/pinctrl/qcom/pinctrl-sc7280.c              |  322 ++--
>   drivers/pinctrl/qcom/pinctrl-sc8180x.c             |  286 ++--
>   drivers/pinctrl/qcom/pinctrl-sc8280xp.c            |  358 +++--
>   drivers/pinctrl/qcom/pinctrl-sdm660.c              |  387 +++--
>   drivers/pinctrl/qcom/pinctrl-sdm670.c              |  284 ++--
>   drivers/pinctrl/qcom/pinctrl-sdm845.c              |  286 ++--
>   drivers/pinctrl/qcom/pinctrl-sdx55.c               |  190 ++-
>   drivers/pinctrl/qcom/pinctrl-sdx65.c               |  194 ++-
>   drivers/pinctrl/qcom/pinctrl-sdx75.c               | 1601 ++++++++++++++++++++
>   drivers/pinctrl/qcom/pinctrl-sm6115.c              |  162 +-
>   drivers/pinctrl/qcom/pinctrl-sm6125.c              |  282 ++--
>   drivers/pinctrl/qcom/pinctrl-sm6350.c              |  296 ++--
>   drivers/pinctrl/qcom/pinctrl-sm6375.c              |  358 +++--
>   drivers/pinctrl/qcom/pinctrl-sm8150.c              |  286 ++--
>   drivers/pinctrl/qcom/pinctrl-sm8250.c              |  258 ++--
>   drivers/pinctrl/qcom/pinctrl-sm8350.c              |  298 ++--
>   drivers/pinctrl/qcom/pinctrl-sm8450.c              |  300 ++--
>   drivers/pinctrl/qcom/pinctrl-sm8550.c              |  320 ++--
>   49 files changed, 7763 insertions(+), 6313 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml
>   create mode 100644 drivers/pinctrl/qcom/pinctrl-sdx75.c
>

