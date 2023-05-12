Return-Path: <netdev+bounces-2071-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E594C700311
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:57:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1E49281A38
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:57:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 920CF947C;
	Fri, 12 May 2023 08:57:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8710B321D
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 08:57:02 +0000 (UTC)
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42C31FFF;
	Fri, 12 May 2023 01:56:54 -0700 (PDT)
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34C8o5SO016557;
	Fri, 12 May 2023 08:56:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=HQCOda9I+zTBzSitzRgWfMehR9PpJE0Iy5PO36eCLfA=;
 b=R/V9Ciy7FAeEyAGC2z4WhTxtmR52wRx3dIw7+GLPlE7T7g9StJruArFCzK72gx+1x3Pp
 IMhN1tOAYSOgbU1Fo66Sh5NtkvdLneCTlaGUJGKvoIDrYqO/CHbWR50mBi91e+WSOJFT
 3lZugCRYCtK3L9n3yHzf4Y1/121ul1MWJtPcCvcgDZ7DzD3LE1WOsg1+TLIQ9eTtr/6d
 STRbgD0ciLCw0M1KuO2mMfU9IJ2vFIFi0hXotPZKCPkX5Qra6dLpk2nTwz6WxXapS5rH
 68uPc+LWsyHNGutaB/eSksZJJzJRl3t2yWaytzr3JpJ1Vi1BfLypcUBbnW9AgLn5ZftL Og== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qhj9s00c2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 May 2023 08:56:42 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 34C8ufrB015832
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 May 2023 08:56:41 GMT
Received: from [10.214.66.58] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Fri, 12 May
 2023 01:56:36 -0700
Message-ID: <1e8073d1-d1f0-de1a-2331-913cbedafc29@quicinc.com>
Date: Fri, 12 May 2023 14:26:33 +0530
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v7 2/4] pinctrl: qcom: Remove the msm_function struct
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
 <1683730825-15668-3-git-send-email-quic_rohiagar@quicinc.com>
 <20230511163352.kfjpvagh2rysyelo@ripper>
From: Rohit Agarwal <quic_rohiagar@quicinc.com>
In-Reply-To: <20230511163352.kfjpvagh2rysyelo@ripper>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: zwvRm9rtOh3UCWoB1CPEqbtJY9d5xRsG
X-Proofpoint-GUID: zwvRm9rtOh3UCWoB1CPEqbtJY9d5xRsG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-12_05,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=735 mlxscore=0
 adultscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305120074
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 5/11/2023 10:03 PM, Bjorn Andersson wrote:
> On Wed, May 10, 2023 at 08:30:23PM +0530, Rohit Agarwal wrote:
>> Remove the msm_function struct to reuse the generic pinfunction
>> struct. Also, define a generic PINFUNCTION macro that can be used across
>> qcom target specific pinctrl files to avoid code repetition.
>>
> Looks nice! No need to carry our own structs for things that has made it
> into the framework.
>
> Reviewed-by: Bjorn Andersson <andersson@kernel.org>
>
> But, ipq9574.c has made it into linux-next now, so this breaks the build
> of that driver. So please update this patch. And please send the two
> refactoring patches on their own, followed by the SDX75 based on that,
> so we can get those merged quickly, before any other impediments are
> introduced.
Sure, Will the refactoring patches independently rebased on linux-next.

Thanks,
Rohit.
>
> Regards,
> Bjorn

