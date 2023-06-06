Return-Path: <netdev+bounces-8495-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF90D7244E4
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:51:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EF37280FE4
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF36A2A9FB;
	Tue,  6 Jun 2023 13:51:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C560A37B71
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:51:18 +0000 (UTC)
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1951DE7E;
	Tue,  6 Jun 2023 06:51:17 -0700 (PDT)
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 356DMaGw001364;
	Tue, 6 Jun 2023 13:51:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=3WO5+MvW1JC+1kcdXtf6mjIMsvUcRKC4UFB7wiOTRE0=;
 b=npSNIV3CzJ99gtyYCM62C8APPa2Tg7f8QlD5ZUwP4WfrNV6K9fjsASC02k3GbkJZisz5
 /ZIdw6POv7bdfVRM5+Eda56DRvty+O/HYINrOVSl3E9Qy5HtHWdbD7YmhK6lwDqiWOrR
 N6OEMFvCHWLjyERjVsfbIvmdLkQogKoGMbgbcVGFf67JGBc+1jraXq6a/WVjttL0aHUg
 1lBCUeIgQhIBqLrGE+8QoDFR8An2l6OjnDKDL7rzYrQhjevtiRbC//LKDQoDral2QbyT
 j6btNUBKNKOGfc05fGstUXpcoUzW5IKtkf3PE1swS7BwhdppxekF0m/Qw/5XXF/cUkd/ zA== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3r1uvv18sj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Jun 2023 13:51:00 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 356Doxi1015101
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 6 Jun 2023 13:50:59 GMT
Received: from [10.226.59.182] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Tue, 6 Jun 2023
 06:50:24 -0700
Message-ID: <b8a25a70-8781-8b82-96d8-bc1ecf2d5468@quicinc.com>
Date: Tue, 6 Jun 2023 07:50:23 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 3/3] net: mhi: Increase the default MTU from 16K to 32K
Content-Language: en-US
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC: <mhi@lists.linux.dev>, <linux-arm-msm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <loic.poulain@linaro.org>
References: <20230606123119.57499-1-manivannan.sadhasivam@linaro.org>
 <20230606123119.57499-4-manivannan.sadhasivam@linaro.org>
From: Jeffrey Hugo <quic_jhugo@quicinc.com>
In-Reply-To: <20230606123119.57499-4-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: -0PRjNpp-hdFXFsGbdgX9cW_9MySjR6f
X-Proofpoint-GUID: -0PRjNpp-hdFXFsGbdgX9cW_9MySjR6f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_10,2023-06-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 clxscore=1011 mlxscore=0 mlxlogscore=655
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306060115
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/6/2023 6:31 AM, Manivannan Sadhasivam wrote:
> Most of the Qualcomm endpoint devices are supporting 32K MTU for the
> UL (Uplink) and DL (Downlink) channels. So let's use the same value
> in the MHI NET driver also. This gives almost 2x increase in the throughput
> for the UL channel.
> 
> Below is the comparision:
> 
> iperf on the UL channel with 16K MTU:
> 
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0-10.0 sec   353 MBytes   296 Mbits/sec
> 
> iperf on the UL channel with 32K MTU:
> 
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0-10.0 sec   695 MBytes   583 Mbits/sec
> 
> Cc: Loic Poulain <loic.poulain@linaro.org>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>   drivers/net/mhi_net.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
> index 3d322ac4f6a5..eddc2c701da4 100644
> --- a/drivers/net/mhi_net.c
> +++ b/drivers/net/mhi_net.c
> @@ -14,7 +14,7 @@
>   
>   #define MHI_NET_MIN_MTU		ETH_MIN_MTU
>   #define MHI_NET_MAX_MTU		0xffff
> -#define MHI_NET_DEFAULT_MTU	0x4000
> +#define MHI_NET_DEFAULT_MTU	0x8000

Why not SZ_32K?

