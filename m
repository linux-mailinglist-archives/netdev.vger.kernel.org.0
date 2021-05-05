Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC21374B6E
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 00:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234508AbhEEWoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 18:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234464AbhEEWn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 18:43:57 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE23C061574
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 15:43:00 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id p15so3141085iln.3
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 15:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6xDXGimjiKX0oAjNr0YWi5H91r48UKSz6Lf5a8CMJBY=;
        b=QdE2bXq250/FjzQdeGOr/Q8IUfpsRbQDY+ZZOhrbEvSAfSvGoVOC+rDYYwCIGRpU9J
         0L+tZcu51nwyULAetpzdn1p6nVf6otjwdYN5t344dFTobr5wVN7j3UaXDt/eztcwuZF8
         XpTHDP8zAfLjdJAaZE71dF9TvHB7buW8HWhZw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6xDXGimjiKX0oAjNr0YWi5H91r48UKSz6Lf5a8CMJBY=;
        b=G+l66Z3wIf3l4BGf5pDYWFk1Jb4VvNK5ehWV35T62+NTtCdoi/Iwf/TYkK7Fvhc+zJ
         LcNFOy60lcnr36sS+tA8OzhAHJ/2ujdXad38z9RinHjSsjHjlufcZNCCcBvBKVWvKK1l
         fR7B1bA7RNtWe91UdYCUEr6cXXGXGzMGOlQFIA/i/m4CVXax/9ARQvNOXopEMz3pc1bK
         IcKooE8klbVlHSm/ppYZH8FQT6PYt8Oq8/cqOzrGoYQfmRhhLNBbQVhhC5VZYsclRxpy
         X6et70gZlTAgpmPhRiq80SIIvvHjcN7jluuE6WEeDwhIMxbhj+r1GIGYbwVkNf3DJ0yx
         iViA==
X-Gm-Message-State: AOAM5331ORBANBT78iVjG2etXXP4l8yqUJ2cUXwClU4FQRMAmM9jMqPV
        Rz/zKjppGnz9fv0Ecbir3MOquA==
X-Google-Smtp-Source: ABdhPJyAB+gBgKVo8ka6Y+karjKl7jzlAZpPwqHg0pCuhj7zfxU9rl9HYEEiyuP9MpexTuq+ACkXfA==
X-Received: by 2002:a92:1304:: with SMTP id 4mr1171491ilt.126.1620254580121;
        Wed, 05 May 2021 15:43:00 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id i5sm360215ilv.34.2021.05.05.15.42.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 15:42:59 -0700 (PDT)
Subject: Re: [PATCH v1 5/7] net: ipa: Add support for IPA on MSM8998
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>, elder@kernel.org
Cc:     bjorn.andersson@linaro.org, agross@kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, konrad.dybcio@somainline.org,
        marijn.suijten@somainline.org, phone-devel@vger.kernel.org
References: <20210211175015.200772-1-angelogioacchino.delregno@somainline.org>
 <20210211175015.200772-6-angelogioacchino.delregno@somainline.org>
From:   Alex Elder <elder@ieee.org>
Message-ID: <4d7e99de-ae60-8227-8193-32eb200b5384@ieee.org>
Date:   Wed, 5 May 2021 17:42:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210211175015.200772-6-angelogioacchino.delregno@somainline.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/21 11:50 AM, AngeloGioacchino Del Regno wrote:
> MSM8998 features IPA v3.1 (GSI v1.0): add the required configuration
> data for it.
> 
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>

This looks great, but since you first posted this code, we
name these data files based on the IPA version, and there
are some new things defined within them.

Two things I found that you got wrong was the assignment of
the endpoint resource group, and you were missing the assignment
of limits from some resource groups.  I think everything else
you provided looks correct, or it's pretty close.

I will define a real pseudo memory region to mark the end of
memory (rather than using UC_EVENT_RING).

I will be verifying all information you provided here, and
will update the file to be named "ipa_data-v3.1.c", and
will add or revise the information to match the current
way these files are defined.

I'll credit you and will include a link to your original
post.

					-Alex

> ---
>   drivers/net/ipa/Makefile           |   3 +-
>   drivers/net/ipa/ipa_data-msm8998.c | 407 +++++++++++++++++++++++++++++
>   drivers/net/ipa/ipa_data.h         |   5 +
>   drivers/net/ipa/ipa_main.c         |   4 +
>   4 files changed, 418 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/net/ipa/ipa_data-msm8998.c
> 
> diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
> index afe5df1e6eee..4a6f4053dce2 100644
> --- a/drivers/net/ipa/Makefile
> +++ b/drivers/net/ipa/Makefile
> @@ -9,4 +9,5 @@ ipa-y			:=	ipa_main.o ipa_clock.o ipa_reg.o ipa_mem.o \
>   				ipa_endpoint.o ipa_cmd.o ipa_modem.o \
>   				ipa_qmi.o ipa_qmi_msg.o
>   
> -ipa-y			+=	ipa_data-sdm845.o ipa_data-sc7180.o
> +ipa-y			+=	ipa_data-msm8998.o ipa_data-sdm845.o \
> +				ipa_data-sc7180.o
> diff --git a/drivers/net/ipa/ipa_data-msm8998.c b/drivers/net/ipa/ipa_data-msm8998.c
> new file mode 100644
> index 000000000000..90e724468e40
> --- /dev/null
> +++ b/drivers/net/ipa/ipa_data-msm8998.c
> @@ -0,0 +1,407 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
> + * Copyright (C) 2019-2020 Linaro Ltd.
> + * Coypright (C) 2021, AngeloGioacchino Del Regno
> + *                     <angelogioacchino.delregno@somainline.org>
> + */
> +
> +#include <linux/log2.h>
> +
> +#include "gsi.h"
> +#include "ipa_data.h"
> +#include "ipa_endpoint.h"
> +#include "ipa_mem.h"
> +
> +/* Endpoint configuration for the MSM8998 SoC. */
> +static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
> +	[IPA_ENDPOINT_AP_COMMAND_TX] = {
> +		.ee_id		= GSI_EE_AP,
> +		.channel_id	= 6,
> +		.endpoint_id	= 22,
> +		.toward_ipa	= true,
> +		.channel = {
> +			.tre_count	= 256,
> +			.event_count	= 256,
> +			.tlv_count	= 18,
> +		},
> +		.endpoint = {
> +			.seq_type	= IPA_SEQ_DMA_ONLY,
> +			.config = {
> +				.resource_group	= 1,
> +				.dma_mode	= true,
> +				.dma_endpoint	= IPA_ENDPOINT_AP_LAN_RX,
> +			},
> +		},
> +	},
> +	[IPA_ENDPOINT_AP_LAN_RX] = {
> +		.ee_id		= GSI_EE_AP,
> +		.channel_id	= 7,
> +		.endpoint_id	= 15,
> +		.toward_ipa	= false,
> +		.channel = {
> +			.tre_count	= 256,
> +			.event_count	= 256,
> +			.tlv_count	= 8,
> +		},
> +		.endpoint = {
> +			.seq_type	= IPA_SEQ_INVALID,
> +			.config = {
> +				.resource_group	= 1,
> +				.aggregation	= true,
> +				.status_enable	= true,
> +				.rx = {
> +					.pad_align	= ilog2(sizeof(u32)),
> +				},
> +			},
> +		},
> +	},
> +	[IPA_ENDPOINT_AP_MODEM_TX] = {
> +		.ee_id		= GSI_EE_AP,
> +		.channel_id	= 5,
> +		.endpoint_id	= 3,
> +		.toward_ipa	= true,
> +		.channel = {
> +			.tre_count	= 512,
> +			.event_count	= 512,
> +			.tlv_count	= 16,
> +		},
> +		.endpoint = {
> +			.filter_support	= true,
> +			.seq_type	=
> +				IPA_SEQ_2ND_PKT_PROCESS_PASS_NO_DEC_UCP,
> +			.config = {
> +				.resource_group	= 1,
> +				.checksum	= true,
> +				.qmap		= true,
> +				.status_enable	= true,
> +				.tx = {
> +					.status_endpoint =
> +						IPA_ENDPOINT_MODEM_AP_RX,
> +				},
> +			},
> +		},
> +	},
> +	[IPA_ENDPOINT_AP_MODEM_RX] = {
> +		.ee_id		= GSI_EE_AP,
> +		.channel_id	= 8,
> +		.endpoint_id	= 16,
> +		.toward_ipa	= false,
> +		.channel = {
> +			.tre_count	= 256,
> +			.event_count	= 256,
> +			.tlv_count	= 8,
> +		},
> +		.endpoint = {
> +			.seq_type	= IPA_SEQ_INVALID,
> +			.config = {
> +				.resource_group	= 1,
> +				.checksum	= true,
> +				.qmap		= true,
> +				.aggregation	= true,
> +				.rx = {
> +					.aggr_close_eof	= true,
> +				},
> +			},
> +		},
> +	},
> +	[IPA_ENDPOINT_MODEM_COMMAND_TX] = {
> +		.ee_id		= GSI_EE_MODEM,
> +		.channel_id	= 1,
> +		.endpoint_id	= 6,
> +		.toward_ipa	= true,
> +	},
> +	[IPA_ENDPOINT_MODEM_LAN_TX] = {
> +		.ee_id		= GSI_EE_MODEM,
> +		.channel_id	= 4,
> +		.endpoint_id	= 9,
> +		.toward_ipa	= true,
> +		.endpoint = {
> +			.filter_support	= true,
> +		},
> +	},
> +	[IPA_ENDPOINT_MODEM_LAN_RX] = {
> +		.ee_id		= GSI_EE_MODEM,
> +		.channel_id	= 6,
> +		.endpoint_id	= 19,
> +		.toward_ipa	= false,
> +	},
> +	[IPA_ENDPOINT_MODEM_AP_TX] = {
> +		.ee_id		= GSI_EE_MODEM,
> +		.channel_id	= 0,
> +		.endpoint_id	= 5,
> +		.toward_ipa	= true,
> +		.endpoint = {
> +			.filter_support	= true,
> +		},
> +	},
> +	[IPA_ENDPOINT_MODEM_AP_RX] = {
> +		.ee_id		= GSI_EE_MODEM,
> +		.channel_id	= 5,
> +		.endpoint_id	= 18,
> +		.toward_ipa	= false,
> +	},
> +};
> +
> +/* For the MSM8998, resource groups are allocated this way:
> + *              SRC     DST
> + *   group 0:	UL      UL
> + *   group 1:	DL      DL/DPL
> + */
> +static const struct ipa_resource_src ipa_resource_src[] = {
> +	{
> +		.type = IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS,
> +		.limits[0] = {
> +			.min = 3,
> +			.max = 255,
> +		},
> +		.limits[1] = {
> +			.min = 3,
> +			.max = 255,
> +		},
> +	},
> +	{
> +		.type = IPA_RESOURCE_TYPE_SRC_HDR_SECTORS,
> +		.limits[0] = {
> +			.min = 0,
> +			.max = 255,
> +		},
> +		.limits[1] = {
> +			.min = 0,
> +			.max = 255,
> +		},
> +	},
> +	{
> +		.type = IPA_RESOURCE_TYPE_SRC_HDRI1_BUFFER,
> +		.limits[0] = {
> +			.min = 0,
> +			.max = 255,
> +		},
> +		.limits[1] = {
> +			.min = 0,
> +			.max = 255,
> +		},
> +	},
> +	{
> +		.type = IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_LISTS,
> +		.limits[0] = {
> +			.min = 14,
> +			.max = 14,
> +		},
> +		.limits[1] = {
> +			.min = 16,
> +			.max = 16,
> +		},
> +	},
> +	{
> +		.type = IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_BUFF,
> +		.limits[0] = {
> +			.min = 19,
> +			.max = 19,
> +		},
> +		.limits[1] = {
> +			.min = 26,
> +			.max = 26,
> +		},
> +	},
> +	{
> +		.type = IPA_RESOURCE_TYPE_SRC_HDRI2_BUFFERS,
> +		.limits[0] = {
> +			.min = 0,
> +			.max = 255,
> +		},
> +		.limits[1] = {
> +			.min = 0,
> +			.max = 255,
> +		},
> +	},
> +	{
> +		.type = IPA_RESOURCE_TYPE_SRC_HPS_DMARS,
> +		.limits[0] = {
> +			.min = 0,
> +			.max = 255,
> +		},
> +		.limits[1] = {
> +			.min = 0,
> +			.max = 255,
> +		},
> +	},
> +	{
> +		.type = IPA_RESOURCE_TYPE_SRC_ACK_ENTRIES,
> +		.limits[0] = {
> +			.min = 14,
> +			.max = 14,
> +		},
> +		.limits[1] = {
> +			.min = 16,
> +			.max = 16,
> +		},
> +	},
> +};
> +
> +static const struct ipa_resource_dst ipa_resource_dst[] = {
> +	{
> +		.type = IPA_RESOURCE_TYPE_DST_DATA_SECTORS,
> +		.limits[0] = {
> +			.min = 2,
> +			.max = 2,
> +		},
> +		.limits[1] = {
> +			.min = 3,
> +			.max = 3,
> +		},
> +	},
> +	{
> +		.type = IPA_RESOURCE_TYPE_DST_DATA_SECTOR_LISTS,
> +		.limits[0] = {
> +			.min = 0,
> +			.max = 255,
> +		},
> +		.limits[1] = {
> +			.min = 0,
> +			.max = 255,
> +		},
> +	},
> +	{
> +		.type = IPA_RESOURCE_TYPE_DST_DPS_DMARS,
> +		.limits[0] = {
> +			.min = 2,
> +			.max = 63,
> +		},
> +		.limits[1] = {
> +			.min = 1,
> +			.max = 63,
> +		},
> +	},
> +};
> +
> +/* Resource configuration for the MSM8998 SoC. */
> +static const struct ipa_resource_data ipa_resource_data = {
> +	.resource_src_count	= ARRAY_SIZE(ipa_resource_src),
> +	.resource_src		= ipa_resource_src,
> +	.resource_dst_count	= ARRAY_SIZE(ipa_resource_dst),
> +	.resource_dst		= ipa_resource_dst,
> +};
> +
> +/* IPA-resident memory region configuration for the MSM8998 SoC. */
> +static const struct ipa_mem ipa_mem_local_data[] = {
> +	[IPA_MEM_UC_SHARED] = {
> +		.offset		= 0x0000,
> +		.size		= 0x0080,
> +		.canary_count	= 0,
> +	},
> +	[IPA_MEM_UC_INFO] = {
> +		.offset		= 0x0080,
> +		.size		= 0x0200,
> +		.canary_count	= 0,
> +	},
> +	[IPA_MEM_V4_FILTER_HASHED] = {
> +		.offset		= 0x0288,
> +		.size		= 0x0078,
> +		.canary_count	= 2,
> +	},
> +	[IPA_MEM_V4_FILTER] = {
> +		.offset		= 0x0308,
> +		.size		= 0x0078,
> +		.canary_count	= 2,
> +	},
> +	[IPA_MEM_V6_FILTER_HASHED] = {
> +		.offset		= 0x0388,
> +		.size		= 0x0078,
> +		.canary_count	= 2,
> +	},
> +	[IPA_MEM_V6_FILTER] = {
> +		.offset		= 0x0408,
> +		.size		= 0x0078,
> +		.canary_count	= 2,
> +	},
> +	[IPA_MEM_V4_ROUTE_HASHED] = {
> +		.offset		= 0x0488,
> +		.size		= 0x0078,
> +		.canary_count	= 2,
> +	},
> +	[IPA_MEM_V4_ROUTE] = {
> +		.offset		= 0x0508,
> +		.size		= 0x0078,
> +		.canary_count	= 2,
> +	},
> +	[IPA_MEM_V6_ROUTE_HASHED] = {
> +		.offset		= 0x0588,
> +		.size		= 0x0078,
> +		.canary_count	= 2,
> +	},
> +	[IPA_MEM_V6_ROUTE] = {
> +		.offset		= 0x0608,
> +		.size		= 0x0078,
> +		.canary_count	= 2,
> +	},
> +	[IPA_MEM_MODEM_HEADER] = {
> +		.offset		= 0x0688,
> +		.size		= 0x0140,
> +		.canary_count	= 2,
> +	},
> +	[IPA_MEM_AP_HEADER] = {
> +		.offset		= 0x07c8,
> +		.size		= 0x0000,
> +		.canary_count	= 0,
> +	},
> +	[IPA_MEM_MODEM_PROC_CTX] = {
> +		.offset		= 0x07d0,
> +		.size		= 0x0200,
> +		.canary_count	= 2,
> +	},
> +	[IPA_MEM_AP_PROC_CTX] = {
> +		.offset		= 0x09d0,
> +		.size		= 0x0200,
> +		.canary_count	= 0,
> +	},
> +	[IPA_MEM_MODEM] = {
> +		.offset		= 0x0bd8,
> +		.size		= 0x1424,
> +		.canary_count	= 0,
> +	},
> +	[IPA_MEM_UC_EVENT_RING] = { /* end_ofst */
> +		.offset		= 0x2000,
> +		.size		= 0,
> +		.canary_count	= 1,
> +	},
> +};
> +
> +static struct ipa_mem_data ipa_mem_data = {
> +	.local_count	= ARRAY_SIZE(ipa_mem_local_data),
> +	.local		= ipa_mem_local_data,
> +	.imem_addr	= 0x146bd000,
> +	.imem_size	= 0x00002000,
> +	.smem_id	= 497,
> +	.smem_size	= 0x00002000,
> +};
> +
> +static struct ipa_clock_data ipa_clock_data = {
> +	.core_clock_rate	= 75 * 1000 * 1000,	/* Hz */
> +	/* Interconnect rates are in 1000 byte/second units */
> +	.interconnect = {
> +		[IPA_INTERCONNECT_MEMORY] = {
> +			.peak_rate	= 640000,	/* 640 MBps */
> +			.average_rate	= 80000,	/* 80 MBps */
> +		},
> +		/* Average rate is unused for the next two interconnects */
> +		[IPA_INTERCONNECT_IMEM] = {
> +			.peak_rate	= 640000,	/* 350 MBps */
> +			.average_rate	= 0,		/* unused */
> +		},
> +		[IPA_INTERCONNECT_CONFIG] = {
> +			.peak_rate	= 80000,	/* 40 MBps */
> +			.average_rate	= 0,		/* unused */
> +		},
> +	},
> +};
> +
> +/* Configuration data for the MSM8998 SoC. */
> +const struct ipa_data ipa_data_msm8998 = {
> +	.version	= IPA_VERSION_3_1,
> +	.endpoint_count	= ARRAY_SIZE(ipa_gsi_endpoint_data),
> +	.endpoint_data	= ipa_gsi_endpoint_data,
> +	.resource_data	= &ipa_resource_data,
> +	.mem_data	= &ipa_mem_data,
> +	.clock_data	= &ipa_clock_data,
> +};
> diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
> index 0ed5ffe2b8da..da2141f6888f 100644
> --- a/drivers/net/ipa/ipa_data.h
> +++ b/drivers/net/ipa/ipa_data.h
> @@ -179,8 +179,11 @@ struct ipa_gsi_endpoint_data {
>   /** enum ipa_resource_type_src - source resource types */
>   enum ipa_resource_type_src {
>   	IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS,
> +	IPA_RESOURCE_TYPE_SRC_HDR_SECTORS,
> +	IPA_RESOURCE_TYPE_SRC_HDRI1_BUFFER,
>   	IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_LISTS,
>   	IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_BUFF,
> +	IPA_RESOURCE_TYPE_SRC_HDRI2_BUFFERS,
>   	IPA_RESOURCE_TYPE_SRC_HPS_DMARS,
>   	IPA_RESOURCE_TYPE_SRC_ACK_ENTRIES,
>   };
> @@ -188,6 +191,7 @@ enum ipa_resource_type_src {
>   /** enum ipa_resource_type_dst - destination resource types */
>   enum ipa_resource_type_dst {
>   	IPA_RESOURCE_TYPE_DST_DATA_SECTORS,
> +	IPA_RESOURCE_TYPE_DST_DATA_SECTOR_LISTS,
>   	IPA_RESOURCE_TYPE_DST_DPS_DMARS,
>   };
>   
> @@ -304,6 +308,7 @@ struct ipa_data {
>   	const struct ipa_clock_data *clock_data;
>   };
>   
> +extern const struct ipa_data ipa_data_msm8998;
>   extern const struct ipa_data ipa_data_sdm845;
>   extern const struct ipa_data ipa_data_sc7180;
>   
> diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
> index be191993fbec..33a7d483c5e0 100644
> --- a/drivers/net/ipa/ipa_main.c
> +++ b/drivers/net/ipa/ipa_main.c
> @@ -721,6 +721,10 @@ static int ipa_firmware_load(struct device *dev)
>   }
>   
>   static const struct of_device_id ipa_match[] = {
> +	{
> +		.compatible	= "qcom,msm8998-ipa",
> +		.data		= &ipa_data_msm8998,
> +	},
>   	{
>   		.compatible	= "qcom,sdm845-ipa",
>   		.data		= &ipa_data_sdm845,
> 

