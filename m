Return-Path: <netdev+bounces-8941-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA2507265E9
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:29:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44E091C20E06
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D283C37337;
	Wed,  7 Jun 2023 16:29:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE8E370F8
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:29:23 +0000 (UTC)
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737F42113;
	Wed,  7 Jun 2023 09:28:49 -0700 (PDT)
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357G7s9M008575;
	Wed, 7 Jun 2023 16:27:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=27+/o+iLEAjAkmX6+2IU2QtYLVlt1oHU4+OW/n9wBSs=;
 b=kLpP4cetmb1ZBZ6Whxokr0muLzPOGCzUvKbq1QTs8BkCKjCKaQUdbxzgyl9pohyrrHyW
 yYGlHe61UXFgLmQoAwn8KbNQxB+GXodSdMwQs5Wsm6jVVVzFPd3beMhiQzd2c0BltzsR
 FN7CbwkxspE7tO4mttU0+5FoHn3KIRuYInlMPjALGIZngMsFQu2eI5QHRpd9k+FPNsLk
 hUYY4e2EGK/coHcSJpJNZDQXWQSohE9Yd7ajoFZ4mttq2OB3ThpWB/oftHhALLJiNang
 2O1bV6sR8J33Rno0rMLRTkkjY8YDoOQvG+qW2pdfYpzhJ1cE4QWTSAPc1KbavhvMO5Nt 9A== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3r2w5501gs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Jun 2023 16:27:50 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 357GRn7j029180
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 7 Jun 2023 16:27:49 GMT
Received: from [10.226.59.182] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Wed, 7 Jun 2023
 09:27:48 -0700
Message-ID: <26a85bae-1a33-dd1f-5e73-0ab6da100abf@quicinc.com>
Date: Wed, 7 Jun 2023 10:27:47 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v2 1/2] net: Add MHI Endpoint network driver
Content-Language: en-US
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC: <mhi@lists.linux.dev>, <linux-arm-msm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <loic.poulain@linaro.org>
References: <20230607152427.108607-1-manivannan.sadhasivam@linaro.org>
 <20230607152427.108607-2-manivannan.sadhasivam@linaro.org>
From: Jeffrey Hugo <quic_jhugo@quicinc.com>
In-Reply-To: <20230607152427.108607-2-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: iIXVLqb25q__aAaVUbTnMdPmk_XgCepD
X-Proofpoint-ORIG-GUID: iIXVLqb25q__aAaVUbTnMdPmk_XgCepD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_07,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 mlxlogscore=912 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306070140
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/7/2023 9:24 AM, Manivannan Sadhasivam wrote:
> Add a network driver for the Modem Host Interface (MHI) endpoint devices
> that provides network interfaces to the PCIe based Qualcomm endpoint
> devices supporting MHI bus. This driver allows the MHI endpoint devices to
> establish IP communication with the host machines (x86, ARM64) over MHI
> bus.
> 
> The driver currently supports only IP_SW0 MHI channel that can be used
> to route IP traffic from the endpoint CPU to host machine.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>   drivers/net/Kconfig      |   9 ++
>   drivers/net/Makefile     |   1 +
>   drivers/net/mhi_ep_net.c | 331 +++++++++++++++++++++++++++++++++++++++
>   3 files changed, 341 insertions(+)
>   create mode 100644 drivers/net/mhi_ep_net.c
> 
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 368c6f5b327e..36b628e2e49f 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -452,6 +452,15 @@ config MHI_NET
>   	  QCOM based WWAN modems for IP or QMAP/rmnet protocol (like SDX55).
>   	  Say Y or M.
>   
> +config MHI_EP_NET
> +	tristate "MHI Endpoint network driver"
> +	depends on MHI_BUS_EP
> +	help
> +	  This is the network driver for MHI bus implementation in endpoint
> +	  devices. It is used provide the network interface for QCOM endpoint
> +	  devices such as SDX55 modems.
> +	  Say Y or M.

What will the module be called if "m" is selected?

> +
>   endif # NET_CORE
>   
>   config SUNGEM_PHY
> diff --git a/drivers/net/Makefile b/drivers/net/Makefile
> index e26f98f897c5..b8e706a4150e 100644
> --- a/drivers/net/Makefile
> +++ b/drivers/net/Makefile
> @@ -40,6 +40,7 @@ obj-$(CONFIG_NLMON) += nlmon.o
>   obj-$(CONFIG_NET_VRF) += vrf.o
>   obj-$(CONFIG_VSOCKMON) += vsockmon.o
>   obj-$(CONFIG_MHI_NET) += mhi_net.o
> +obj-$(CONFIG_MHI_EP_NET) += mhi_ep_net.o
>   
>   #
>   # Networking Drivers
> diff --git a/drivers/net/mhi_ep_net.c b/drivers/net/mhi_ep_net.c
> new file mode 100644
> index 000000000000..0d7939caefc7
> --- /dev/null
> +++ b/drivers/net/mhi_ep_net.c
> @@ -0,0 +1,331 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * MHI Endpoint Network driver
> + *
> + * Based on drivers/net/mhi_net.c
> + *
> + * Copyright (c) 2023, Linaro Ltd.
> + * Author: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> + */
> +
> +#include <linux/if_arp.h>
> +#include <linux/mhi_ep.h>
> +#include <linux/mod_devicetable.h>
> +#include <linux/module.h>
> +#include <linux/netdevice.h>
> +#include <linux/skbuff.h>
> +#include <linux/u64_stats_sync.h>
> +
> +#define MHI_NET_MIN_MTU		ETH_MIN_MTU
> +#define MHI_NET_MAX_MTU		0xffff
> +
> +struct mhi_ep_net_stats {
> +	u64_stats_t rx_packets;
> +	u64_stats_t rx_bytes;
> +	u64_stats_t rx_errors;
> +	u64_stats_t tx_packets;
> +	u64_stats_t tx_bytes;
> +	u64_stats_t tx_errors;
> +	u64_stats_t tx_dropped;
> +	struct u64_stats_sync tx_syncp;
> +	struct u64_stats_sync rx_syncp;
> +};
> +
> +struct mhi_ep_net_dev {
> +	struct mhi_ep_device *mdev;
> +	struct net_device *ndev;
> +	struct mhi_ep_net_stats stats;
> +	struct workqueue_struct *xmit_wq;
> +	struct work_struct xmit_work;
> +	struct sk_buff_head tx_buffers;
> +	spinlock_t tx_lock; /* Lock for protecting tx_buffers */
> +	u32 mru;
> +};
> +
> +static void mhi_ep_net_dev_process_queue_packets(struct work_struct *work)
> +{
> +	struct mhi_ep_net_dev *mhi_ep_netdev = container_of(work,
> +			struct mhi_ep_net_dev, xmit_work);

Looks like this can fit all on one line to me.


