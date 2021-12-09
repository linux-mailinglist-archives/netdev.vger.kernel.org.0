Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A31346E3C2
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 09:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbhLIIMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 03:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhLIIMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 03:12:15 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD61C061746;
        Thu,  9 Dec 2021 00:08:42 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id o14so3305063plg.5;
        Thu, 09 Dec 2021 00:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bQ//qzxcaCvVb6ot0qD8IPCeFbIym26Gbhvyc0Rn+OY=;
        b=hMWlQr8v/xD3QGTqZBSkAsOp9MrAg+v2pjWL0ypH9IHls8Pbj4J+K8boBgmHWXDSKt
         mCXj0k9qI4EvdxarD9lN532zNPcwGRuBiJIcP5nSgaJ6LgeIIPMXI3Kyx45STzSU0/Mt
         AhblodxPvBYEbvyZwtTUwU90PDSkEdtrtcWtrVjt/3tN6rQEIem3FL4TfFukHMJcpKtc
         qW2SC3RNTfV0xsKeI81ENQSqOgwoQYR+dBLSvPM3guGD7hPQshTQnjHyXLpe0+nv+iUH
         JbthCa/5msaR7H1f84NgApvbjpjISW7H5sgeKVQL2/AKivOQ7TApWqdJpaD6PEjj1qCP
         arzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bQ//qzxcaCvVb6ot0qD8IPCeFbIym26Gbhvyc0Rn+OY=;
        b=Te4SVWitudsxZOT1WkYdGF05lr88znPbzgBIiDl2TmSuzjSA+L0TUcUoJWmgg4L0AP
         JRVBj55CbnUCZozBf8yQ1u++wl7auINTN8cGHnjVs2pOF/Lj6v4IGZuGo+MgdcZ2veJm
         LSuO3/A+/pXr1jdsjHG1vlA00Q+xlPes3DKSGRpVyWUj78/Avli0dPVNv2DHQM8xRgCk
         e/eduzfCEnrkUlOTRKMaMkOlCpEShlVYV5yJ2Mefx3y1ccfxsXZnYBgyCws6ikPIXmrm
         fd5qv+f7Ppy0EoP+oAf8YWP934UeM4/EfRVj/c9ODvmh7sMet9Aiv0lFJ916TBiMV2k8
         fPqg==
X-Gm-Message-State: AOAM531owiS214CzVJFhfoFkJX3Hi3f9JtgV90KT4j8NoIq+jzWH9FE5
        ++hcrGb9MPC4+0Ej2NvB+kk=
X-Google-Smtp-Source: ABdhPJziqpUtQYWo22b4cdx2YvrY55qz0/w1JcSw7qyUAPPS6GrD0f/Q0+FqadkrDHcHSDvX6TFi5A==
X-Received: by 2002:a17:902:d4c2:b0:142:2039:e8e5 with SMTP id o2-20020a170902d4c200b001422039e8e5mr66050036plg.18.1639037321785;
        Thu, 09 Dec 2021 00:08:41 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::50b? ([2404:f801:9000:1a:efea::50b])
        by smtp.gmail.com with ESMTPSA id na15sm9117400pjb.31.2021.12.09.00.08.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 00:08:41 -0800 (PST)
Message-ID: <44a2bae4-22aa-326b-8ff8-476dd535254e@gmail.com>
Date:   Thu, 9 Dec 2021 16:08:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH V6 5/5] net: netvsc: Add Isolation VM support for netvsc
 driver
Content-Language: en-US
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "hch@infradead.org" <hch@infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "hch@lst.de" <hch@lst.de>, "joro@8bytes.org" <joro@8bytes.org>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
References: <20211207075602.2452-1-ltykernel@gmail.com>
 <20211207075602.2452-6-ltykernel@gmail.com>
 <BN8PR21MB128401EEDE6B8C8553CC8009CA6F9@BN8PR21MB1284.namprd21.prod.outlook.com>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <BN8PR21MB128401EEDE6B8C8553CC8009CA6F9@BN8PR21MB1284.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/9/2021 4:14 AM, Haiyang Zhang wrote:
>> From: Tianyu Lan <ltykernel@gmail.com>
>> Sent: Tuesday, December 7, 2021 2:56 AM
>> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>; Stephen
>> Hemminger <sthemmin@microsoft.com>; wei.liu@kernel.org; Dexuan Cui <decui@microsoft.com>;
>> tglx@linutronix.de; mingo@redhat.com; bp@alien8.de; dave.hansen@linux.intel.com;
>> x86@kernel.org; hpa@zytor.com; davem@davemloft.net; kuba@kernel.org; jejb@linux.ibm.com;
>> martin.petersen@oracle.com; arnd@arndb.de; hch@infradead.org; m.szyprowski@samsung.com;
>> robin.murphy@arm.com; Tianyu Lan <Tianyu.Lan@microsoft.com>; thomas.lendacky@amd.com;
>> Michael Kelley (LINUX) <mikelley@microsoft.com>
>> Cc: iommu@lists.linux-foundation.org; linux-arch@vger.kernel.org; linux-
>> hyperv@vger.kernel.org; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org;
>> netdev@vger.kernel.org; vkuznets <vkuznets@redhat.com>; brijesh.singh@amd.com;
>> konrad.wilk@oracle.com; hch@lst.de; joro@8bytes.org; parri.andrea@gmail.com;
>> dave.hansen@intel.com
>> Subject: [PATCH V6 5/5] net: netvsc: Add Isolation VM support for netvsc driver
>>
>> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>
>> In Isolation VM, all shared memory with host needs to mark visible
>> to host via hvcall. vmbus_establish_gpadl() has already done it for
>> netvsc rx/tx ring buffer. The page buffer used by vmbus_sendpacket_
>> pagebuffer() stills need to be handled. Use DMA API to map/umap
>> these memory during sending/receiving packet and Hyper-V swiotlb
>> bounce buffer dma address will be returned. The swiotlb bounce buffer
>> has been masked to be visible to host during boot up.
>>
>> rx/tx ring buffer is allocated via vzalloc() and they need to be
>> mapped into unencrypted address space(above vTOM) before sharing
>> with host and accessing. Add hv_map/unmap_memory() to map/umap rx
>> /tx ring buffer.
>>
>> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
>> ---
>> Change since v3:
>>         * Replace HV_HYP_PAGE_SIZE with PAGE_SIZE and virt_to_hvpfn()
>>           with vmalloc_to_pfn() in the hv_map_memory()
>>
>> Change since v2:
>>         * Add hv_map/unmap_memory() to map/umap rx/tx ring buffer.
>> ---
>>   arch/x86/hyperv/ivm.c             |  28 ++++++
>>   drivers/hv/hv_common.c            |  11 +++
>>   drivers/net/hyperv/hyperv_net.h   |   5 ++
>>   drivers/net/hyperv/netvsc.c       | 136 +++++++++++++++++++++++++++++-
>>   drivers/net/hyperv/netvsc_drv.c   |   1 +
>>   drivers/net/hyperv/rndis_filter.c |   2 +
>>   include/asm-generic/mshyperv.h    |   2 +
>>   include/linux/hyperv.h            |   5 ++
>>   8 files changed, 187 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
>> index 69c7a57f3307..2b994117581e 100644
>> --- a/arch/x86/hyperv/ivm.c
>> +++ b/arch/x86/hyperv/ivm.c
>> @@ -287,3 +287,31 @@ int hv_set_mem_host_visibility(unsigned long kbuffer, int pagecount,
>> bool visibl
>>   	kfree(pfn_array);
>>   	return ret;
>>   }
>> +
>> +/*
>> + * hv_map_memory - map memory to extra space in the AMD SEV-SNP Isolation VM.
>> + */
>> +void *hv_map_memory(void *addr, unsigned long size)
>> +{
>> +	unsigned long *pfns = kcalloc(size / PAGE_SIZE,
>> +				      sizeof(unsigned long), GFP_KERNEL);
>> +	void *vaddr;
>> +	int i;
>> +
>> +	if (!pfns)
>> +		return NULL;
>> +
>> +	for (i = 0; i < size / PAGE_SIZE; i++)
>> +		pfns[i] = vmalloc_to_pfn(addr + i * PAGE_SIZE) +
>> +			(ms_hyperv.shared_gpa_boundary >> PAGE_SHIFT);
>> +
>> +	vaddr = vmap_pfn(pfns, size / PAGE_SIZE, PAGE_KERNEL_IO);
>> +	kfree(pfns);
>> +
>> +	return vaddr;
>> +}
>> +
>> +void hv_unmap_memory(void *addr)
>> +{
>> +	vunmap(addr);
>> +}
>> diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
>> index 7be173a99f27..3c5cb1f70319 100644
>> --- a/drivers/hv/hv_common.c
>> +++ b/drivers/hv/hv_common.c
>> @@ -295,3 +295,14 @@ u64 __weak hv_ghcb_hypercall(u64 control, void *input, void *output,
>> u32 input_s
>>   	return HV_STATUS_INVALID_PARAMETER;
>>   }
>>   EXPORT_SYMBOL_GPL(hv_ghcb_hypercall);
>> +
>> +void __weak *hv_map_memory(void *addr, unsigned long size)
>> +{
>> +	return NULL;
>> +}
>> +EXPORT_SYMBOL_GPL(hv_map_memory);
>> +
>> +void __weak hv_unmap_memory(void *addr)
>> +{
>> +}
>> +EXPORT_SYMBOL_GPL(hv_unmap_memory);
>> diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
>> index 315278a7cf88..cf69da0e296c 100644
>> --- a/drivers/net/hyperv/hyperv_net.h
>> +++ b/drivers/net/hyperv/hyperv_net.h
>> @@ -164,6 +164,7 @@ struct hv_netvsc_packet {
>>   	u32 total_bytes;
>>   	u32 send_buf_index;
>>   	u32 total_data_buflen;
>> +	struct hv_dma_range *dma_range;
>>   };
>>
>>   #define NETVSC_HASH_KEYLEN 40
>> @@ -1074,6 +1075,7 @@ struct netvsc_device {
>>
>>   	/* Receive buffer allocated by us but manages by NetVSP */
>>   	void *recv_buf;
>> +	void *recv_original_buf;
>>   	u32 recv_buf_size; /* allocated bytes */
>>   	struct vmbus_gpadl recv_buf_gpadl_handle;
>>   	u32 recv_section_cnt;
>> @@ -1082,6 +1084,7 @@ struct netvsc_device {
>>
>>   	/* Send buffer allocated by us */
>>   	void *send_buf;
>> +	void *send_original_buf;
>>   	u32 send_buf_size;
>>   	struct vmbus_gpadl send_buf_gpadl_handle;
>>   	u32 send_section_cnt;
>> @@ -1731,4 +1734,6 @@ struct rndis_message {
>>   #define RETRY_US_HI	10000
>>   #define RETRY_MAX	2000	/* >10 sec */
>>
>> +void netvsc_dma_unmap(struct hv_device *hv_dev,
>> +		      struct hv_netvsc_packet *packet);
>>   #endif /* _HYPERV_NET_H */
>> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
>> index 396bc1c204e6..b7ade735a806 100644
>> --- a/drivers/net/hyperv/netvsc.c
>> +++ b/drivers/net/hyperv/netvsc.c
>> @@ -153,8 +153,21 @@ static void free_netvsc_device(struct rcu_head *head)
>>   	int i;
>>
>>   	kfree(nvdev->extension);
>> -	vfree(nvdev->recv_buf);
>> -	vfree(nvdev->send_buf);
>> +
>> +	if (nvdev->recv_original_buf) {
>> +		hv_unmap_memory(nvdev->recv_buf);
>> +		vfree(nvdev->recv_original_buf);
>> +	} else {
>> +		vfree(nvdev->recv_buf);
>> +	}
>> +
>> +	if (nvdev->send_original_buf) {
>> +		hv_unmap_memory(nvdev->send_buf);
>> +		vfree(nvdev->send_original_buf);
>> +	} else {
>> +		vfree(nvdev->send_buf);
>> +	}
>> +
>>   	kfree(nvdev->send_section_map);
>>
>>   	for (i = 0; i < VRSS_CHANNEL_MAX; i++) {
>> @@ -338,6 +351,7 @@ static int netvsc_init_buf(struct hv_device *device,
>>   	unsigned int buf_size;
>>   	size_t map_words;
>>   	int i, ret = 0;
>> +	void *vaddr;
>>
>>   	/* Get receive buffer area. */
>>   	buf_size = device_info->recv_sections * device_info->recv_section_size;
>> @@ -373,6 +387,17 @@ static int netvsc_init_buf(struct hv_device *device,
>>   		goto cleanup;
>>   	}
>>
>> +	if (hv_isolation_type_snp()) {
>> +		vaddr = hv_map_memory(net_device->recv_buf, buf_size);
>> +		if (!vaddr) {
>> +			ret = -ENOMEM;
>> +			goto cleanup;
>> +		}
>> +
>> +		net_device->recv_original_buf = net_device->recv_buf;
>> +		net_device->recv_buf = vaddr;
>> +	}
>> +
>>   	/* Notify the NetVsp of the gpadl handle */
>>   	init_packet = &net_device->channel_init_pkt;
>>   	memset(init_packet, 0, sizeof(struct nvsp_message));
>> @@ -476,6 +501,17 @@ static int netvsc_init_buf(struct hv_device *device,
>>   		goto cleanup;
>>   	}
>>
>> +	if (hv_isolation_type_snp()) {
>> +		vaddr = hv_map_memory(net_device->send_buf, buf_size);
>> +		if (!vaddr) {
>> +			ret = -ENOMEM;
>> +			goto cleanup;
>> +		}
>> +
>> +		net_device->send_original_buf = net_device->send_buf;
>> +		net_device->send_buf = vaddr;
>> +	}
>> +
>>   	/* Notify the NetVsp of the gpadl handle */
>>   	init_packet = &net_device->channel_init_pkt;
>>   	memset(init_packet, 0, sizeof(struct nvsp_message));
>> @@ -766,7 +802,7 @@ static void netvsc_send_tx_complete(struct net_device *ndev,
>>
>>   	/* Notify the layer above us */
>>   	if (likely(skb)) {
>> -		const struct hv_netvsc_packet *packet
>> +		struct hv_netvsc_packet *packet
>>   			= (struct hv_netvsc_packet *)skb->cb;
>>   		u32 send_index = packet->send_buf_index;
>>   		struct netvsc_stats *tx_stats;
>> @@ -782,6 +818,7 @@ static void netvsc_send_tx_complete(struct net_device *ndev,
>>   		tx_stats->bytes += packet->total_bytes;
>>   		u64_stats_update_end(&tx_stats->syncp);
>>
>> +		netvsc_dma_unmap(ndev_ctx->device_ctx, packet);
>>   		napi_consume_skb(skb, budget);
>>   	}
>>
>> @@ -946,6 +983,88 @@ static void netvsc_copy_to_send_buf(struct netvsc_device *net_device,
>>   		memset(dest, 0, padding);
>>   }
>>
>> +void netvsc_dma_unmap(struct hv_device *hv_dev,
>> +		      struct hv_netvsc_packet *packet)
>> +{
>> +	u32 page_count = packet->cp_partial ?
>> +		packet->page_buf_cnt - packet->rmsg_pgcnt :
>> +		packet->page_buf_cnt;
>> +	int i;
>> +
>> +	if (!hv_is_isolation_supported())
>> +		return;
>> +
>> +	if (!packet->dma_range)
>> +		return;
>> +
>> +	for (i = 0; i < page_count; i++)
>> +		dma_unmap_single(&hv_dev->device, packet->dma_range[i].dma,
>> +				 packet->dma_range[i].mapping_size,
>> +				 DMA_TO_DEVICE);
>> +
>> +	kfree(packet->dma_range);
>> +}
>> +
>> +/* netvsc_dma_map - Map swiotlb bounce buffer with data page of
>> + * packet sent by vmbus_sendpacket_pagebuffer() in the Isolation
>> + * VM.
>> + *
>> + * In isolation VM, netvsc send buffer has been marked visible to
>> + * host and so the data copied to send buffer doesn't need to use
>> + * bounce buffer. The data pages handled by vmbus_sendpacket_pagebuffer()
>> + * may not be copied to send buffer and so these pages need to be
>> + * mapped with swiotlb bounce buffer. netvsc_dma_map() is to do
>> + * that. The pfns in the struct hv_page_buffer need to be converted
>> + * to bounce buffer's pfn. The loop here is necessary because the
>> + * entries in the page buffer array are not necessarily full
>> + * pages of data.  Each entry in the array has a separate offset and
>> + * len that may be non-zero, even for entries in the middle of the
>> + * array.  And the entries are not physically contiguous.  So each
>> + * entry must be individually mapped rather than as a contiguous unit.
>> + * So not use dma_map_sg() here.
>> + */
>> +int netvsc_dma_map(struct hv_device *hv_dev,
>> +		   struct hv_netvsc_packet *packet,
>> +		   struct hv_page_buffer *pb)
>> +{
>> +	u32 page_count =  packet->cp_partial ?
>> +		packet->page_buf_cnt - packet->rmsg_pgcnt :
>> +		packet->page_buf_cnt;
>> +	dma_addr_t dma;
>> +	int i;
>> +
>> +	if (!hv_is_isolation_supported())
>> +		return 0;
>> +
>> +	packet->dma_range = kcalloc(page_count,
>> +				    sizeof(*packet->dma_range),
>> +				    GFP_KERNEL);
>> +	if (!packet->dma_range)
>> +		return -ENOMEM;
>> +
>> +	for (i = 0; i < page_count; i++) {
>> +		char *src = phys_to_virt((pb[i].pfn << HV_HYP_PAGE_SHIFT)
>> +					 + pb[i].offset);
>> +		u32 len = pb[i].len;
>> +
>> +		dma = dma_map_single(&hv_dev->device, src, len,
>> +				     DMA_TO_DEVICE);
>> +		if (dma_mapping_error(&hv_dev->device, dma)) {
>> +			kfree(packet->dma_range);
>> +			return -ENOMEM;
>> +		}
>> +
>> +		/* pb[].offset and pb[].len are not changed during dma mapping
>> +		 * and so not reassign.
>> +		 */
>> +		packet->dma_range[i].dma = dma;
>> +		packet->dma_range[i].mapping_size = len;
>> +		pb[i].pfn = dma >> HV_HYP_PAGE_SHIFT;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   static inline int netvsc_send_pkt(
>>   	struct hv_device *device,
>>   	struct hv_netvsc_packet *packet,
>> @@ -986,14 +1105,24 @@ static inline int netvsc_send_pkt(
>>
>>   	trace_nvsp_send_pkt(ndev, out_channel, rpkt);
>>
>> +	packet->dma_range = NULL;
>>   	if (packet->page_buf_cnt) {
>>   		if (packet->cp_partial)
>>   			pb += packet->rmsg_pgcnt;
>>
>> +		ret = netvsc_dma_map(ndev_ctx->device_ctx, packet, pb);
>> +		if (ret) {
>> +			ret = -EAGAIN;
>> +			goto exit;
>> +		}
> 
> Returning EAGAIN will let the upper network layer busy retry,
> which may make things worse.
> I suggest to return ENOSPC here like another place in this
> function, which will just drop the packet, and let the network
> protocol/app layer decide how to recover.
> 

Yes, agree. Will update in the next version. Thanks.

