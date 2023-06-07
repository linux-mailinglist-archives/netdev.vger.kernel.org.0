Return-Path: <netdev+bounces-8958-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB8A472667C
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:53:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81E6D281314
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:53:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E05233CA0;
	Wed,  7 Jun 2023 16:53:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5841ACD4
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:53:09 +0000 (UTC)
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE811FC2;
	Wed,  7 Jun 2023 09:53:07 -0700 (PDT)
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357EqEvj015863;
	Wed, 7 Jun 2023 16:52:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=ccILPXJMNW+fazdoPQ/ZhN5RvSTJkO1d+AFoitKRVio=;
 b=lH9xrwGfpYqUrfdowM0r/PWLceeR4whKcFPVtucAFoe+VnzyhapF6eputI+o6SmHnnXi
 N8OlCbuIReCehaejqvpuxBbEnJTT8pUJmAODAxlSwNhB0jddjDnqQwsumvHvCteFWqLb
 Svduhq2LaMyCkFeoTi17eOhWK76c3uLFnVKc3ER3tG3Q5sOAVd1FBK6Sh0rHQPSBeniX
 Cq6y2whKcM2w/cBWsSyr15vycOR1JqM0d6nq7Qc4AnDiS1+/ZdVQif8Yazs1wvall3Zc
 Xaua9rSYIqZ5loDI4xqqH4/eTCxbvsvfwCvgbLwjqhwNd60q1xIDp/ucsscuEVQ29C1e jg== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3r2a6yte6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Jun 2023 16:52:56 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 357Gqu8V011234
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 7 Jun 2023 16:52:56 GMT
Received: from [10.226.59.182] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Wed, 7 Jun 2023
 09:52:55 -0700
Message-ID: <b5cfa726-b61e-90eb-7d4b-d81844189cf6@quicinc.com>
Date: Wed, 7 Jun 2023 10:52:54 -0600
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
From: Jeffrey Hugo <quic_jhugo@quicinc.com>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC: <mhi@lists.linux.dev>, <linux-arm-msm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <loic.poulain@linaro.org>
References: <20230607152427.108607-1-manivannan.sadhasivam@linaro.org>
 <20230607152427.108607-2-manivannan.sadhasivam@linaro.org>
 <26a85bae-1a33-dd1f-5e73-0ab6da100abf@quicinc.com>
In-Reply-To: <26a85bae-1a33-dd1f-5e73-0ab6da100abf@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: XKIXGsCiUwRK55YVguS5wyCe6EWDdv6i
X-Proofpoint-GUID: XKIXGsCiUwRK55YVguS5wyCe6EWDdv6i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_09,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 mlxlogscore=964 adultscore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306070144
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/7/2023 10:27 AM, Jeffrey Hugo wrote:
> On 6/7/2023 9:24 AM, Manivannan Sadhasivam wrote:
>> Add a network driver for the Modem Host Interface (MHI) endpoint devices
>> that provides network interfaces to the PCIe based Qualcomm endpoint
>> devices supporting MHI bus. This driver allows the MHI endpoint 
>> devices to
>> establish IP communication with the host machines (x86, ARM64) over MHI
>> bus.
>>
>> The driver currently supports only IP_SW0 MHI channel that can be used
>> to route IP traffic from the endpoint CPU to host machine.
>>
>> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>> ---
>>   drivers/net/Kconfig      |   9 ++
>>   drivers/net/Makefile     |   1 +
>>   drivers/net/mhi_ep_net.c | 331 +++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 341 insertions(+)
>>   create mode 100644 drivers/net/mhi_ep_net.c
>>
>> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
>> index 368c6f5b327e..36b628e2e49f 100644
>> --- a/drivers/net/Kconfig
>> +++ b/drivers/net/Kconfig
>> @@ -452,6 +452,15 @@ config MHI_NET
>>         QCOM based WWAN modems for IP or QMAP/rmnet protocol (like 
>> SDX55).
>>         Say Y or M.
>> +config MHI_EP_NET
>> +    tristate "MHI Endpoint network driver"
>> +    depends on MHI_BUS_EP
>> +    help
>> +      This is the network driver for MHI bus implementation in endpoint
>> +      devices. It is used provide the network interface for QCOM 
>> endpoint
>> +      devices such as SDX55 modems.
>> +      Say Y or M.
> 
> What will the module be called if "m" is selected?
> 
>> +
>>   endif # NET_CORE
>>   config SUNGEM_PHY
>> diff --git a/drivers/net/Makefile b/drivers/net/Makefile
>> index e26f98f897c5..b8e706a4150e 100644
>> --- a/drivers/net/Makefile
>> +++ b/drivers/net/Makefile
>> @@ -40,6 +40,7 @@ obj-$(CONFIG_NLMON) += nlmon.o
>>   obj-$(CONFIG_NET_VRF) += vrf.o
>>   obj-$(CONFIG_VSOCKMON) += vsockmon.o
>>   obj-$(CONFIG_MHI_NET) += mhi_net.o
>> +obj-$(CONFIG_MHI_EP_NET) += mhi_ep_net.o
>>   #
>>   # Networking Drivers
>> diff --git a/drivers/net/mhi_ep_net.c b/drivers/net/mhi_ep_net.c
>> new file mode 100644
>> index 000000000000..0d7939caefc7
>> --- /dev/null
>> +++ b/drivers/net/mhi_ep_net.c
>> @@ -0,0 +1,331 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +/*
>> + * MHI Endpoint Network driver
>> + *
>> + * Based on drivers/net/mhi_net.c
>> + *
>> + * Copyright (c) 2023, Linaro Ltd.
>> + * Author: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>> + */
>> +
>> +#include <linux/if_arp.h>
>> +#include <linux/mhi_ep.h>
>> +#include <linux/mod_devicetable.h>
>> +#include <linux/module.h>
>> +#include <linux/netdevice.h>
>> +#include <linux/skbuff.h>
>> +#include <linux/u64_stats_sync.h>
>> +
>> +#define MHI_NET_MIN_MTU        ETH_MIN_MTU
>> +#define MHI_NET_MAX_MTU        0xffff

ETH_MAX_MTU ?

Personal preference thing.  If you think 0xffff is really the superior 
option, so be it.  Personally, it takes me a second to figure out that 
is 64k - 1 and then relate it to the MHI packet size limit.  Also seems 
really odd with this line of code right next to, and related to, 
ETH_MIN_MTU.  Feels like a non-magic number here will make things more 
maintainable.

Alternatively move MHI_MAX_MTU out of host/internal.h into something 
that is convenient for this driver to include and use?  It is a 
fundamental constant for the MHI protocol, we just haven't yet had a 
need for it to be used outside of the MHI bus implementation code.

>> +
>> +struct mhi_ep_net_stats {
>> +    u64_stats_t rx_packets;
>> +    u64_stats_t rx_bytes;
>> +    u64_stats_t rx_errors;
>> +    u64_stats_t tx_packets;
>> +    u64_stats_t tx_bytes;
>> +    u64_stats_t tx_errors;
>> +    u64_stats_t tx_dropped;
>> +    struct u64_stats_sync tx_syncp;
>> +    struct u64_stats_sync rx_syncp;
>> +};
>> +
>> +struct mhi_ep_net_dev {
>> +    struct mhi_ep_device *mdev;
>> +    struct net_device *ndev;
>> +    struct mhi_ep_net_stats stats;
>> +    struct workqueue_struct *xmit_wq;
>> +    struct work_struct xmit_work;
>> +    struct sk_buff_head tx_buffers;
>> +    spinlock_t tx_lock; /* Lock for protecting tx_buffers */
>> +    u32 mru;
>> +};
>> +
>> +static void mhi_ep_net_dev_process_queue_packets(struct work_struct 
>> *work)
>> +{
>> +    struct mhi_ep_net_dev *mhi_ep_netdev = container_of(work,
>> +            struct mhi_ep_net_dev, xmit_work);
> 
> Looks like this can fit all on one line to me.
> 
> 


