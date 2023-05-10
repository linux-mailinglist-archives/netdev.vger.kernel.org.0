Return-Path: <netdev+bounces-1502-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB9F56FE078
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:36:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80C3F28159A
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:36:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D238F14AA6;
	Wed, 10 May 2023 14:36:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D3014A93
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:36:02 +0000 (UTC)
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2839E7AA8;
	Wed, 10 May 2023 07:36:01 -0700 (PDT)
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34AEEkDP021015;
	Wed, 10 May 2023 14:35:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=emN30TBHHqWYt8kSsxV70C/rXs0PtRmNhisx1C/akdk=;
 b=NIAjKeZrXdkVo4WZxw2hIvnp1A64nRn841NOyTo7UnnrSNF+Gj1a45Prt7tFynQInn8u
 0ntDV95Fyd5fJORPwcx5SJt0ekFlFgwg0fBOPUO5yTrfasA6yMMfuDVMDtWUSZ0zLwSK
 3xGgPfS1K7KzLnWtdtBde4vxx/Bm7p15GkupDiSIAzWx46K/B2GsXISTpFpJIVzaYlu6
 VrQnZc+1JP6l0uPgZTF2fWe4epLBJmB1tt2wQ78QBIJVrIGggUquTVXg+PJ4zlMbhgax
 jI4gyrVfFQLNubgUuun1qr5wDEOBbPO+iAOz9c+RbBouXWwirp0KXfS4e2uR6imrsgJ6 eg== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qg1g11aj4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 May 2023 14:35:56 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 34AEZuvS023692
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 May 2023 14:35:56 GMT
Received: from [10.216.41.111] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Wed, 10 May
 2023 07:35:50 -0700
Message-ID: <332c114f-51dd-dcfb-687b-439b4bdd6a59@quicinc.com>
Date: Wed, 10 May 2023 20:05:47 +0530
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v6 4/4] pinctrl: qcom: Add SDX75 pincontrol driver
Content-Language: en-US
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: <agross@kernel.org>, <andersson@kernel.org>, <konrad.dybcio@linaro.org>,
        <linus.walleij@linaro.org>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <richardcochran@gmail.com>,
        <manivannan.sadhasivam@linaro.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-gpio@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <1683718725-14869-1-git-send-email-quic_rohiagar@quicinc.com>
 <1683718725-14869-5-git-send-email-quic_rohiagar@quicinc.com>
 <ZFun8m5y-r0yUHhq@surfacebook>
 <1ffc9474-0a05-44d8-0cc0-24a065443b18@quicinc.com>
 <CAHp75VcCYo2uF2VY6x3jFb3v-whXrCW_U_bKnnWAfzg+dAe1zQ@mail.gmail.com>
From: Rohit Agarwal <quic_rohiagar@quicinc.com>
In-Reply-To: <CAHp75VcCYo2uF2VY6x3jFb3v-whXrCW_U_bKnnWAfzg+dAe1zQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: a0WVVcxuQMiDkchGhXCTI9QXDLQMzWGl
X-Proofpoint-ORIG-GUID: a0WVVcxuQMiDkchGhXCTI9QXDLQMzWGl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=788 clxscore=1015 spamscore=0 bulkscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305100117
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 5/10/2023 8:04 PM, Andy Shevchenko wrote:
> On Wed, May 10, 2023 at 5:31 PM Rohit Agarwal <quic_rohiagar@quicinc.com> wrote:
>> On 5/10/2023 7:49 PM, andy.shevchenko@gmail.com wrote:
>>> Wed, May 10, 2023 at 05:08:45PM +0530, Rohit Agarwal kirjoitti:
> ...
>
>>>> +#define FUNCTION(n)                                                 \
>>>> +    [msm_mux_##n] = {                                               \
>>>> +                    .func = PINCTRL_PINFUNCTION(#n,                 \
>>>> +                                    n##_groups,                     \
>>>> +                                    ARRAY_SIZE(n##_groups))         \
>>>> +                    }
>>> But don't you now have MSM_PIN_FUNCTION() macro?
>> So Sorry, a mistake from my end. Will immediately update.
> Don't forget to collect my tags for the other patches.
Yes Sure.

Thanks,
Rohit

>

