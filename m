Return-Path: <netdev+bounces-1497-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB7546FE04A
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:31:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A15DD28152F
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:31:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3643111B9;
	Wed, 10 May 2023 14:31:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80DF14AAD
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:31:09 +0000 (UTC)
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF6F3C3A;
	Wed, 10 May 2023 07:31:07 -0700 (PDT)
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34AEDOC5025734;
	Wed, 10 May 2023 14:31:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=qvkap/Y4TOHNL07iP0yA+DU+o2en3bsNw5khWwqRep4=;
 b=JuT76hqv1dTTTGM76rlFed3VtXYMk2irmt6VJdHtnvsN5wZcF8hR+OwIPFhyALcA2Ieo
 Ybp0EgABwL+5A9PBhmmsXjvxIqdLZIJ5mLSIleJfUF4CekpqsCazCt9EaHGwrYA9R1EH
 cxKaJXE9g13Q6ho50ktGu4kPm4w8+F9M2OcZUCzN8xJ/TfyNm6y8kebxcQhldOPjycdL
 NEHvTGzO1ngIYaBQ7lZdToIDdvPtgzPk3i4gjSXRN1RUktpb5pnowZMBXq+0Vfm5xjin
 UgjhVwYnoVwnsX6OUa+4rHUqaG6h6m1g8Kx4NVOg3dFObLiNY9iUkmQbIymobUmmCp+t zQ== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qg6u0gs6r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 May 2023 14:31:00 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 34AEV0nH016864
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 May 2023 14:31:00 GMT
Received: from [10.216.41.111] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Wed, 10 May
 2023 07:30:54 -0700
Message-ID: <1ffc9474-0a05-44d8-0cc0-24a065443b18@quicinc.com>
Date: Wed, 10 May 2023 20:00:50 +0530
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
To: <andy.shevchenko@gmail.com>
CC: <agross@kernel.org>, <andersson@kernel.org>, <konrad.dybcio@linaro.org>,
        <linus.walleij@linaro.org>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <richardcochran@gmail.com>,
        <manivannan.sadhasivam@linaro.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-gpio@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <1683718725-14869-1-git-send-email-quic_rohiagar@quicinc.com>
 <1683718725-14869-5-git-send-email-quic_rohiagar@quicinc.com>
 <ZFun8m5y-r0yUHhq@surfacebook>
From: Rohit Agarwal <quic_rohiagar@quicinc.com>
In-Reply-To: <ZFun8m5y-r0yUHhq@surfacebook>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: J_TKjw0X-VTOUwa6NEhUNkLYpk-zGXbJ
X-Proofpoint-ORIG-GUID: J_TKjw0X-VTOUwa6NEhUNkLYpk-zGXbJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=844 clxscore=1015 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305100117
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 5/10/2023 7:49 PM, andy.shevchenko@gmail.com wrote:
> Wed, May 10, 2023 at 05:08:45PM +0530, Rohit Agarwal kirjoitti:
>> Add initial Qualcomm SDX75 pinctrl driver to support pin configuration
>> with pinctrl framework for SDX75 SoC.
>> While at it, reordering the SDX65 entry.
> ...
>
>> +#define FUNCTION(n)							\
>> +	[msm_mux_##n] = {						\
>> +			.func = PINCTRL_PINFUNCTION(#n,			\
>> +					n##_groups,			\
>> +					ARRAY_SIZE(n##_groups))		\
>> +			}
> But don't you now have MSM_PIN_FUNCTION() macro?

So Sorry, a mistake from my end. Will immediately update.

Thanks for reviewing.
Rohit.


>

