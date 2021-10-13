Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46E142CE0A
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbhJMWcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbhJMWb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:31:58 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2B4C061749
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 15:29:54 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id d11so1375930ilc.8
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 15:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+UaWoPYgh/IlsZkW64UiV2FE6ol+8ckrPgr4czx/dkM=;
        b=fwXIC9krTtMpXGZdy7XfCbJIv3IIaXs1of9MwKKmIa9hBeuWRhmv2hBnRlELSVGEGb
         HSNBKbW0jLG7QCKLBIaIZlElrAH78yyE6M2tdPotXF0lJSUL4WpqSMSO9CJNggZ9cne5
         eF2JYqr73Y9p5/tzmTypXKhfl35LeHnAlCQ0c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+UaWoPYgh/IlsZkW64UiV2FE6ol+8ckrPgr4czx/dkM=;
        b=IwPPe2n6cu6VX5xOdsuxcutbibBYndmV+q+upuUeS/M+EyuMfLuzNYiQazafgN59W8
         NAD+QvHIm78JCjSJqtkoIvQdNGH4xAPr33jr1KbiKNuyCimZGw7OuHI4blW3pLfak/c8
         I/PtyTe4ceZvOcbXEp53HbEwN6Jc2wRPeVIK/Zsxxr7ZO8g+QF0ObaM3rrAokitBaxz9
         33VuVUVLI5Okq5zNUzni0CDele9sO2TCB7ngP/ZL27IpbAN7r1cdalaFdViZFoNOoGTS
         gpGN91rGtr/JiRVZ7hMWoQtgdnHdHxuJd9Brir2stRH2gLNx+xNvVmyZDionFG6dTISg
         pn6A==
X-Gm-Message-State: AOAM5337eT0VocHjK1/Oa0eVd4S5vww/WpejIL+dP+m/XeMVtBKe4K9K
        RNP5JqRV9dzLXwcXSowLgIXrRg==
X-Google-Smtp-Source: ABdhPJxutFU36A25HdXYPVmTo3MPnZVXokb+4+6wqFGk96xtNiqxz/gQ+fhdIZoTPAuF95l29us2Zg==
X-Received: by 2002:a05:6e02:1521:: with SMTP id i1mr1448400ilu.16.1634164194099;
        Wed, 13 Oct 2021 15:29:54 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id r17sm354435ile.40.2021.10.13.15.29.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 15:29:53 -0700 (PDT)
Subject: Re: [RFC PATCH 07/17] net: ipa: Add IPA v2.x register definitions
To:     Sireesh Kodali <sireeshkodali1@gmail.com>,
        phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, elder@kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210920030811.57273-1-sireeshkodali1@gmail.com>
 <20210920030811.57273-8-sireeshkodali1@gmail.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <c7370126-e26e-bd6d-3502-0e35bdb4dd63@ieee.org>
Date:   Wed, 13 Oct 2021 17:29:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210920030811.57273-8-sireeshkodali1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/19/21 10:08 PM, Sireesh Kodali wrote:
> IPA v2.x is an older version the IPA hardware, and is 32 bit.
> 
> Most of the registers were just shifted in newer IPA versions, but
> the register fields have remained the same across IPA versions. This
> means that only the register addresses needed to be added to the driver.
> 
> To handle the different IPA register addresses, static inline functions
> have been defined that return the correct register address.

Thank you for following the existing convention in implementing these.
Even if it isn't perfect, it's good to remain consistent.

You use:
	if (version <= IPA_VERSION_2_6L)
but then also define and use
	if (IPA_VERSION_RANGE(version, 2_0, 2_6L))
And the only new IPA versions are 2_0, 2_5, and 2_6L.

I would stick with the former and don't define IPA_VERSION_RANGE().
Nothing less than IPA v2.0 (or 3.0 currently) is supported, so
"there is no version less than that."

Oh, and I noticed some local variables defined without the
"reverse Christmas tree order" which, like it or not, is the
convention used consistently throughout this driver.

I might quibble with a few other minor things in these definitions
but overall this looks fine.

					-Alex

> Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
> ---
>   drivers/net/ipa/ipa_cmd.c      |   3 +-
>   drivers/net/ipa/ipa_endpoint.c |  33 +++---
>   drivers/net/ipa/ipa_main.c     |   8 +-
>   drivers/net/ipa/ipa_mem.c      |   5 +-
>   drivers/net/ipa/ipa_reg.h      | 184 +++++++++++++++++++++++++++------
>   drivers/net/ipa/ipa_version.h  |  12 +++
>   6 files changed, 195 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
> index 0bdbc331fa78..7a104540dc26 100644
> --- a/drivers/net/ipa/ipa_cmd.c
> +++ b/drivers/net/ipa/ipa_cmd.c
> @@ -326,7 +326,8 @@ static bool ipa_cmd_register_write_valid(struct ipa *ipa)
>   	 * worst case (highest endpoint number) offset of that endpoint
>   	 * fits in the register write command field(s) that must hold it.
>   	 */
> -	offset = IPA_REG_ENDP_STATUS_N_OFFSET(IPA_ENDPOINT_COUNT - 1);
> +	offset = ipa_reg_endp_status_n_offset(ipa->version,
> +			IPA_ENDPOINT_COUNT - 1);
>   	name = "maximal endpoint status";
>   	if (!ipa_cmd_register_write_offset_valid(ipa, name, offset))
>   		return false;
> diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
> index dbef549c4537..7d3ab61cd890 100644
> --- a/drivers/net/ipa/ipa_endpoint.c
> +++ b/drivers/net/ipa/ipa_endpoint.c
> @@ -242,8 +242,8 @@ static struct ipa_trans *ipa_endpoint_trans_alloc(struct ipa_endpoint *endpoint,
>   static bool
>   ipa_endpoint_init_ctrl(struct ipa_endpoint *endpoint, bool suspend_delay)
>   {
> -	u32 offset = IPA_REG_ENDP_INIT_CTRL_N_OFFSET(endpoint->endpoint_id);
>   	struct ipa *ipa = endpoint->ipa;
> +	u32 offset = ipa_reg_endp_init_ctrl_n_offset(ipa->version, endpoint->endpoint_id);
>   	bool state;
>   	u32 mask;
>   	u32 val;
> @@ -410,7 +410,7 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
>   		if (!(endpoint->ee_id == GSI_EE_MODEM && endpoint->toward_ipa))
>   			continue;
>   
> -		offset = IPA_REG_ENDP_STATUS_N_OFFSET(endpoint_id);
> +		offset = ipa_reg_endp_status_n_offset(ipa->version, endpoint_id);
>   
>   		/* Value written is 0, and all bits are updated.  That
>   		 * means status is disabled on the endpoint, and as a
> @@ -431,7 +431,8 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
>   
>   static void ipa_endpoint_init_cfg(struct ipa_endpoint *endpoint)
>   {
> -	u32 offset = IPA_REG_ENDP_INIT_CFG_N_OFFSET(endpoint->endpoint_id);
> +	struct ipa *ipa = endpoint->ipa;
> +	u32 offset = ipa_reg_endp_init_cfg_n_offset(ipa->version, endpoint->endpoint_id);
>   	enum ipa_cs_offload_en enabled;
>   	u32 val = 0;
>   
> @@ -523,8 +524,8 @@ ipa_qmap_header_size(enum ipa_version version, struct ipa_endpoint *endpoint)
>    */
>   static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
>   {
> -	u32 offset = IPA_REG_ENDP_INIT_HDR_N_OFFSET(endpoint->endpoint_id);
>   	struct ipa *ipa = endpoint->ipa;
> +	u32 offset = ipa_reg_endp_init_hdr_n_offset(ipa->version, endpoint->endpoint_id);
>   	u32 val = 0;
>   
>   	if (endpoint->data->qmap) {
> @@ -565,9 +566,9 @@ static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
>   
>   static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
>   {
> -	u32 offset = IPA_REG_ENDP_INIT_HDR_EXT_N_OFFSET(endpoint->endpoint_id);
> -	u32 pad_align = endpoint->data->rx.pad_align;
>   	struct ipa *ipa = endpoint->ipa;
> +	u32 offset = ipa_reg_endp_init_hdr_ext_n_offset(ipa->version, endpoint->endpoint_id);
> +	u32 pad_align = endpoint->data->rx.pad_align;
>   	u32 val = 0;
>   
>   	val |= HDR_ENDIANNESS_FMASK;		/* big endian */
> @@ -609,6 +610,7 @@ static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
>   
>   static void ipa_endpoint_init_hdr_metadata_mask(struct ipa_endpoint *endpoint)
>   {
> +	enum ipa_version version = endpoint->ipa->version;
>   	u32 endpoint_id = endpoint->endpoint_id;
>   	u32 val = 0;
>   	u32 offset;
> @@ -616,7 +618,7 @@ static void ipa_endpoint_init_hdr_metadata_mask(struct ipa_endpoint *endpoint)
>   	if (endpoint->toward_ipa)
>   		return;		/* Register not valid for TX endpoints */
>   
> -	offset = IPA_REG_ENDP_INIT_HDR_METADATA_MASK_N_OFFSET(endpoint_id);
> +	offset = ipa_reg_endp_init_hdr_metadata_mask_n_offset(version, endpoint_id);
>   
>   	/* Note that HDR_ENDIANNESS indicates big endian header fields */
>   	if (endpoint->data->qmap)
> @@ -627,7 +629,8 @@ static void ipa_endpoint_init_hdr_metadata_mask(struct ipa_endpoint *endpoint)
>   
>   static void ipa_endpoint_init_mode(struct ipa_endpoint *endpoint)
>   {
> -	u32 offset = IPA_REG_ENDP_INIT_MODE_N_OFFSET(endpoint->endpoint_id);
> +	enum ipa_version version = endpoint->ipa->version;
> +	u32 offset = ipa_reg_endp_init_mode_n_offset(version, endpoint->endpoint_id);
>   	u32 val;
>   
>   	if (!endpoint->toward_ipa)
> @@ -716,8 +719,8 @@ static u32 aggr_sw_eof_active_encoded(enum ipa_version version, bool enabled)
>   
>   static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
>   {
> -	u32 offset = IPA_REG_ENDP_INIT_AGGR_N_OFFSET(endpoint->endpoint_id);
>   	enum ipa_version version = endpoint->ipa->version;
> +	u32 offset = ipa_reg_endp_init_aggr_n_offset(version, endpoint->endpoint_id);
>   	u32 val = 0;
>   
>   	if (endpoint->data->aggregation) {
> @@ -853,7 +856,7 @@ static void ipa_endpoint_init_hol_block_timer(struct ipa_endpoint *endpoint,
>   	u32 offset;
>   	u32 val;
>   
> -	offset = IPA_REG_ENDP_INIT_HOL_BLOCK_TIMER_N_OFFSET(endpoint_id);
> +	offset = ipa_reg_endp_init_hol_block_timer_n_offset(ipa->version, endpoint_id);
>   	val = hol_block_timer_val(ipa, microseconds);
>   	iowrite32(val, ipa->reg_virt + offset);
>   }
> @@ -861,12 +864,13 @@ static void ipa_endpoint_init_hol_block_timer(struct ipa_endpoint *endpoint,
>   static void
>   ipa_endpoint_init_hol_block_enable(struct ipa_endpoint *endpoint, bool enable)
>   {
> +	enum ipa_version version = endpoint->ipa->version;
>   	u32 endpoint_id = endpoint->endpoint_id;
>   	u32 offset;
>   	u32 val;
>   
>   	val = enable ? HOL_BLOCK_EN_FMASK : 0;
> -	offset = IPA_REG_ENDP_INIT_HOL_BLOCK_EN_N_OFFSET(endpoint_id);
> +	offset = ipa_reg_endp_init_hol_block_en_n_offset(version, endpoint_id);
>   	iowrite32(val, endpoint->ipa->reg_virt + offset);
>   }
>   
> @@ -887,7 +891,8 @@ void ipa_endpoint_modem_hol_block_clear_all(struct ipa *ipa)
>   
>   static void ipa_endpoint_init_deaggr(struct ipa_endpoint *endpoint)
>   {
> -	u32 offset = IPA_REG_ENDP_INIT_DEAGGR_N_OFFSET(endpoint->endpoint_id);
> +	enum ipa_version version = endpoint->ipa->version;
> +	u32 offset = ipa_reg_endp_init_deaggr_n_offset(version, endpoint->endpoint_id);
>   	u32 val = 0;
>   
>   	if (!endpoint->toward_ipa)
> @@ -979,7 +984,7 @@ static void ipa_endpoint_status(struct ipa_endpoint *endpoint)
>   	u32 val = 0;
>   	u32 offset;
>   
> -	offset = IPA_REG_ENDP_STATUS_N_OFFSET(endpoint_id);
> +	offset = ipa_reg_endp_status_n_offset(ipa->version, endpoint_id);
>   
>   	if (endpoint->data->status_enable) {
>   		val |= STATUS_EN_FMASK;
> @@ -1384,7 +1389,7 @@ void ipa_endpoint_default_route_set(struct ipa *ipa, u32 endpoint_id)
>   	val |= u32_encode_bits(endpoint_id, ROUTE_FRAG_DEF_PIPE_FMASK);
>   	val |= ROUTE_DEF_RETAIN_HDR_FMASK;
>   
> -	iowrite32(val, ipa->reg_virt + IPA_REG_ROUTE_OFFSET);
> +	iowrite32(val, ipa->reg_virt + ipa_reg_route_offset(ipa->version));
>   }
>   
>   void ipa_endpoint_default_route_clear(struct ipa *ipa)
> diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
> index 6ab691ff1faf..ba06e3ad554c 100644
> --- a/drivers/net/ipa/ipa_main.c
> +++ b/drivers/net/ipa/ipa_main.c
> @@ -191,7 +191,7 @@ static void ipa_hardware_config_comp(struct ipa *ipa)
>   	if (ipa->version < IPA_VERSION_4_0)
>   		return;
>   
> -	val = ioread32(ipa->reg_virt + IPA_REG_COMP_CFG_OFFSET);
> +	val = ioread32(ipa->reg_virt + ipa_reg_comp_cfg_offset(ipa->version));
>   
>   	if (ipa->version == IPA_VERSION_4_0) {
>   		val &= ~IPA_QMB_SELECT_CONS_EN_FMASK;
> @@ -206,7 +206,7 @@ static void ipa_hardware_config_comp(struct ipa *ipa)
>   	val |= GSI_MULTI_INORDER_RD_DIS_FMASK;
>   	val |= GSI_MULTI_INORDER_WR_DIS_FMASK;
>   
> -	iowrite32(val, ipa->reg_virt + IPA_REG_COMP_CFG_OFFSET);
> +	iowrite32(val, ipa->reg_virt + ipa_reg_comp_cfg_offset(ipa->version));
>   }
>   
>   /* Configure DDR and (possibly) PCIe max read/write QSB values */
> @@ -355,7 +355,7 @@ static void ipa_hardware_config(struct ipa *ipa, const struct ipa_data *data)
>   	/* IPA v4.5+ has no backward compatibility register */
>   	if (version < IPA_VERSION_4_5) {
>   		val = data->backward_compat;
> -		iowrite32(val, ipa->reg_virt + IPA_REG_BCR_OFFSET);
> +		iowrite32(val, ipa->reg_virt + ipa_reg_bcr_offset(ipa->version));
>   	}
>   
>   	/* Implement some hardware workarounds */
> @@ -384,7 +384,7 @@ static void ipa_hardware_config(struct ipa *ipa, const struct ipa_data *data)
>   		/* Configure aggregation timer granularity */
>   		granularity = ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY);
>   		val = u32_encode_bits(granularity, AGGR_GRANULARITY_FMASK);
> -		iowrite32(val, ipa->reg_virt + IPA_REG_COUNTER_CFG_OFFSET);
> +		iowrite32(val, ipa->reg_virt + ipa_reg_counter_cfg_offset(ipa->version));
>   	} else {
>   		ipa_qtime_config(ipa);
>   	}
> diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
> index 16e5fdd5bd73..8acc88070a6f 100644
> --- a/drivers/net/ipa/ipa_mem.c
> +++ b/drivers/net/ipa/ipa_mem.c
> @@ -113,7 +113,8 @@ int ipa_mem_setup(struct ipa *ipa)
>   	mem = ipa_mem_find(ipa, IPA_MEM_MODEM_PROC_CTX);
>   	offset = ipa->mem_offset + mem->offset;
>   	val = proc_cntxt_base_addr_encoded(ipa->version, offset);
> -	iowrite32(val, ipa->reg_virt + IPA_REG_LOCAL_PKT_PROC_CNTXT_OFFSET);
> +	iowrite32(val, ipa->reg_virt +
> +		  ipa_reg_local_pkt_proc_cntxt_base_offset(ipa->version));
>   
>   	return 0;
>   }
> @@ -316,7 +317,7 @@ int ipa_mem_config(struct ipa *ipa)
>   	u32 i;
>   
>   	/* Check the advertised location and size of the shared memory area */
> -	val = ioread32(ipa->reg_virt + IPA_REG_SHARED_MEM_SIZE_OFFSET);
> +	val = ioread32(ipa->reg_virt + ipa_reg_shared_mem_size_offset(ipa->version));
>   
>   	/* The fields in the register are in 8 byte units */
>   	ipa->mem_offset = 8 * u32_get_bits(val, SHARED_MEM_BADDR_FMASK);
> diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
> index a5b355384d4a..fcae0296cfa4 100644
> --- a/drivers/net/ipa/ipa_reg.h
> +++ b/drivers/net/ipa/ipa_reg.h
> @@ -65,7 +65,17 @@ struct ipa;
>    * of valid bits for the register.
>    */
>   
> -#define IPA_REG_COMP_CFG_OFFSET				0x0000003c
> +#define IPA_REG_COMP_SW_RESET_OFFSET		0x0000003c
> +
> +#define IPA_REG_V2_ENABLED_PIPES_OFFSET		0x000005dc
> +
> +static inline u32 ipa_reg_comp_cfg_offset(enum ipa_version version)
> +{
> +	if (version <= IPA_VERSION_2_6L)
> +		return 0x38;
> +
> +	return 0x3c;
> +}
>   /* The next field is not supported for IPA v4.0+, not present for IPA v4.5+ */
>   #define ENABLE_FMASK				GENMASK(0, 0)
>   /* The next field is present for IPA v4.7+ */
> @@ -124,6 +134,7 @@ static inline u32 full_flush_rsc_closure_en_encoded(enum ipa_version version,
>   	return u32_encode_bits(val, GENMASK(17, 17));
>   }
>   
> +/* This register is only present on IPA v3.0 and above */
>   #define IPA_REG_CLKON_CFG_OFFSET			0x00000044
>   #define RX_FMASK				GENMASK(0, 0)
>   #define PROC_FMASK				GENMASK(1, 1)
> @@ -164,7 +175,14 @@ static inline u32 full_flush_rsc_closure_en_encoded(enum ipa_version version,
>   /* The next field is present for IPA v4.7+ */
>   #define DRBIP_FMASK				GENMASK(31, 31)
>   
> -#define IPA_REG_ROUTE_OFFSET				0x00000048
> +static inline u32 ipa_reg_route_offset(enum ipa_version version)
> +{
> +	if (version <= IPA_VERSION_2_6L)
> +		return 0x44;
> +
> +	return 0x48;
> +}
> +
>   #define ROUTE_DIS_FMASK				GENMASK(0, 0)
>   #define ROUTE_DEF_PIPE_FMASK			GENMASK(5, 1)
>   #define ROUTE_DEF_HDR_TABLE_FMASK		GENMASK(6, 6)
> @@ -172,7 +190,14 @@ static inline u32 full_flush_rsc_closure_en_encoded(enum ipa_version version,
>   #define ROUTE_FRAG_DEF_PIPE_FMASK		GENMASK(21, 17)
>   #define ROUTE_DEF_RETAIN_HDR_FMASK		GENMASK(24, 24)
>   
> -#define IPA_REG_SHARED_MEM_SIZE_OFFSET			0x00000054
> +static inline u32 ipa_reg_shared_mem_size_offset(enum ipa_version version)
> +{
> +	if (version <= IPA_VERSION_2_6L)
> +		return 0x50;
> +
> +	return 0x54;
> +}
> +
>   #define SHARED_MEM_SIZE_FMASK			GENMASK(15, 0)
>   #define SHARED_MEM_BADDR_FMASK			GENMASK(31, 16)
>   
> @@ -219,7 +244,13 @@ static inline u32 ipa_reg_state_aggr_active_offset(enum ipa_version version)
>   }
>   
>   /* The next register is not present for IPA v4.5+ */
> -#define IPA_REG_BCR_OFFSET				0x000001d0
> +static inline u32 ipa_reg_bcr_offset(enum ipa_version version)
> +{
> +	if (IPA_VERSION_RANGE(version, 2_5, 2_6L))
> +		return 0x5b0;
> +
> +	return 0x1d0;
> +}
>   /* The next two fields are not present for IPA v4.2+ */
>   #define BCR_CMDQ_L_LACK_ONE_ENTRY_FMASK		GENMASK(0, 0)
>   #define BCR_TX_NOT_USING_BRESP_FMASK		GENMASK(1, 1)
> @@ -236,7 +267,14 @@ static inline u32 ipa_reg_state_aggr_active_offset(enum ipa_version version)
>   #define BCR_ROUTER_PREFETCH_EN_FMASK		GENMASK(9, 9)
>   
>   /* The value of the next register must be a multiple of 8 (bottom 3 bits 0) */
> -#define IPA_REG_LOCAL_PKT_PROC_CNTXT_OFFSET		0x000001e8
> +static inline u32 ipa_reg_local_pkt_proc_cntxt_base_offset(enum ipa_version version)
> +{
> +	if (version <= IPA_VERSION_2_6L)
> +		return 0x5e0;
> +
> +	return 0x1e8;
> +}
> +
>   
>   /* Encoded value for LOCAL_PKT_PROC_CNTXT register BASE_ADDR field */
>   static inline u32 proc_cntxt_base_addr_encoded(enum ipa_version version,
> @@ -252,7 +290,14 @@ static inline u32 proc_cntxt_base_addr_encoded(enum ipa_version version,
>   #define IPA_REG_AGGR_FORCE_CLOSE_OFFSET			0x000001ec
>   
>   /* The next register is not present for IPA v4.5+ */
> -#define IPA_REG_COUNTER_CFG_OFFSET			0x000001f0
> +static inline u32 ipa_reg_counter_cfg_offset(enum ipa_version version)
> +{
> +	if (IPA_VERSION_RANGE(version, 2_5, 2_6L))
> +		return 0x5e8;
> +
> +	return 0x1f0;
> +}
> +
>   /* The next field is not present for IPA v3.5+ */
>   #define EOT_COAL_GRANULARITY			GENMASK(3, 0)
>   #define AGGR_GRANULARITY_FMASK			GENMASK(8, 4)
> @@ -349,15 +394,27 @@ enum ipa_pulse_gran {
>   #define Y_MIN_LIM_FMASK				GENMASK(21, 16)
>   #define Y_MAX_LIM_FMASK				GENMASK(29, 24)
>   
> -#define IPA_REG_ENDP_INIT_CTRL_N_OFFSET(ep) \
> -					(0x00000800 + 0x0070 * (ep))
> +static inline u32 ipa_reg_endp_init_ctrl_n_offset(enum ipa_version version, u16 ep)
> +{
> +	if (version <= IPA_VERSION_2_6L)
> +		return 0x70 + 0x4 * ep;
> +
> +	return 0x800 + 0x70 * ep;
> +}
> +
>   /* Valid only for RX (IPA producer) endpoints (do not use for IPA v4.0+) */
>   #define ENDP_SUSPEND_FMASK			GENMASK(0, 0)
>   /* Valid only for TX (IPA consumer) endpoints */
>   #define ENDP_DELAY_FMASK			GENMASK(1, 1)
>   
> -#define IPA_REG_ENDP_INIT_CFG_N_OFFSET(ep) \
> -					(0x00000808 + 0x0070 * (ep))
> +static inline u32 ipa_reg_endp_init_cfg_n_offset(enum ipa_version version, u16 ep)
> +{
> +	if (version <= IPA_VERSION_2_6L)
> +		return 0xc0 + 0x4 * ep;
> +
> +	return 0x808 + 0x70 * ep;
> +}
> +
>   #define FRAG_OFFLOAD_EN_FMASK			GENMASK(0, 0)
>   #define CS_OFFLOAD_EN_FMASK			GENMASK(2, 1)
>   #define CS_METADATA_HDR_OFFSET_FMASK		GENMASK(6, 3)
> @@ -383,8 +440,14 @@ enum ipa_nat_en {
>   	IPA_NAT_DST			= 0x2,
>   };
>   
> -#define IPA_REG_ENDP_INIT_HDR_N_OFFSET(ep) \
> -					(0x00000810 + 0x0070 * (ep))
> +static inline u32 ipa_reg_endp_init_hdr_n_offset(enum ipa_version version, u16 ep)
> +{
> +	if (IPA_VERSION_RANGE(version, 2_0, 2_6L))
> +		return 0x170 + 0x4 * ep;
> +
> +	return 0x810 + 0x70 * ep;
> +}
> +
>   #define HDR_LEN_FMASK				GENMASK(5, 0)
>   #define HDR_OFST_METADATA_VALID_FMASK		GENMASK(6, 6)
>   #define HDR_OFST_METADATA_FMASK			GENMASK(12, 7)
> @@ -440,8 +503,14 @@ static inline u32 ipa_metadata_offset_encoded(enum ipa_version version,
>   	return val;
>   }
>   
> -#define IPA_REG_ENDP_INIT_HDR_EXT_N_OFFSET(ep) \
> -					(0x00000814 + 0x0070 * (ep))
> +static inline u32 ipa_reg_endp_init_hdr_ext_n_offset(enum ipa_version version, u16 ep)
> +{
> +	if (IPA_VERSION_RANGE(version, 2_0, 2_6L))
> +		return 0x1c0 + 0x4 * ep;
> +
> +	return 0x814 + 0x70 * ep;
> +}
> +
>   #define HDR_ENDIANNESS_FMASK			GENMASK(0, 0)
>   #define HDR_TOTAL_LEN_OR_PAD_VALID_FMASK	GENMASK(1, 1)
>   #define HDR_TOTAL_LEN_OR_PAD_FMASK		GENMASK(2, 2)
> @@ -454,12 +523,23 @@ static inline u32 ipa_metadata_offset_encoded(enum ipa_version version,
>   #define HDR_ADDITIONAL_CONST_LEN_MSB_FMASK	GENMASK(21, 20)
>   
>   /* Valid only for RX (IPA producer) endpoints */
> -#define IPA_REG_ENDP_INIT_HDR_METADATA_MASK_N_OFFSET(rxep) \
> -					(0x00000818 + 0x0070 * (rxep))
> +static inline u32 ipa_reg_endp_init_hdr_metadata_mask_n_offset(enum ipa_version version, u16 rxep)
> +{
> +	if (version <= IPA_VERSION_2_6L)
> +		return 0x220 + 0x4 * rxep;
> +
> +	return 0x818 + 0x70 * rxep;
> +}
>   
>   /* Valid only for TX (IPA consumer) endpoints */
> -#define IPA_REG_ENDP_INIT_MODE_N_OFFSET(txep) \
> -					(0x00000820 + 0x0070 * (txep))
> +static inline u32 ipa_reg_endp_init_mode_n_offset(enum ipa_version version, u16 txep)
> +{
> +	if (IPA_VERSION_RANGE(version, 2_0, 2_6L))
> +		return 0x2c0 + 0x4 * txep;
> +
> +	return 0x820 + 0x70 * txep;
> +}
> +
>   #define MODE_FMASK				GENMASK(2, 0)
>   /* The next field is present for IPA v4.5+ */
>   #define DCPH_ENABLE_FMASK			GENMASK(3, 3)
> @@ -480,8 +560,14 @@ enum ipa_mode {
>   	IPA_DMA				= 0x3,
>   };
>   
> -#define IPA_REG_ENDP_INIT_AGGR_N_OFFSET(ep) \
> -					(0x00000824 +  0x0070 * (ep))
> +static inline u32 ipa_reg_endp_init_aggr_n_offset(enum ipa_version version,
> +						  u16 ep)
> +{
> +	if (IPA_VERSION_RANGE(version, 2_0, 2_6L))
> +		return 0x320 + 0x4 * ep;
> +	return 0x824 + 0x70 * ep;
> +}
> +
>   #define AGGR_EN_FMASK				GENMASK(1, 0)
>   #define AGGR_TYPE_FMASK				GENMASK(4, 2)
>   
> @@ -543,14 +629,27 @@ enum ipa_aggr_type {
>   };
>   
>   /* Valid only for RX (IPA producer) endpoints */
> -#define IPA_REG_ENDP_INIT_HOL_BLOCK_EN_N_OFFSET(rxep) \
> -					(0x0000082c +  0x0070 * (rxep))
> +static inline u32 ipa_reg_endp_init_hol_block_en_n_offset(enum ipa_version version,
> +							  u16 rxep)
> +{
> +	if (IPA_VERSION_RANGE(version, 2_0, 2_6L))
> +		return 0x3c0 + 0x4 * rxep;
> +
> +	return 0x82c + 0x70 * rxep;
> +}
> +
>   #define HOL_BLOCK_EN_FMASK			GENMASK(0, 0)
>   
>   /* Valid only for RX (IPA producer) endpoints */
> -#define IPA_REG_ENDP_INIT_HOL_BLOCK_TIMER_N_OFFSET(rxep) \
> -					(0x00000830 +  0x0070 * (rxep))
> -/* The next two fields are present for IPA v4.2 only */
> +static inline u32 ipa_reg_endp_init_hol_block_timer_n_offset(enum ipa_version version, u16 rxep)
> +{
> +	if (IPA_VERSION_RANGE(version, 2_0, 2_6L))
> +		return 0x420 + 0x4 * rxep;
> +
> +	return 0x830 + 0x70 * rxep;
> +}
> +
> +/* The next fields are present for IPA v4.2 only */
>   #define BASE_VALUE_FMASK			GENMASK(4, 0)
>   #define SCALE_FMASK				GENMASK(12, 8)
>   /* The next two fields are present for IPA v4.5 */
> @@ -558,8 +657,14 @@ enum ipa_aggr_type {
>   #define GRAN_SEL_FMASK				GENMASK(8, 8)
>   
>   /* Valid only for TX (IPA consumer) endpoints */
> -#define IPA_REG_ENDP_INIT_DEAGGR_N_OFFSET(txep) \
> -					(0x00000834 + 0x0070 * (txep))
> +static inline u32 ipa_reg_endp_init_deaggr_n_offset(enum ipa_version version, u16 txep)
> +{
> +	if (IPA_VERSION_RANGE(version, 2_0, 2_6L))
> +		return 0x470 + 0x4 * txep;
> +
> +	return 0x834 + 0x70 * txep;
> +}
> +
>   #define DEAGGR_HDR_LEN_FMASK			GENMASK(5, 0)
>   #define SYSPIPE_ERR_DETECTION_FMASK		GENMASK(6, 6)
>   #define PACKET_OFFSET_VALID_FMASK		GENMASK(7, 7)
> @@ -629,8 +734,14 @@ enum ipa_seq_rep_type {
>   	IPA_SEQ_REP_DMA_PARSER			= 0x08,
>   };
>   
> -#define IPA_REG_ENDP_STATUS_N_OFFSET(ep) \
> -					(0x00000840 + 0x0070 * (ep))
> +static inline u32 ipa_reg_endp_status_n_offset(enum ipa_version version, u16 ep)
> +{
> +	if (version <= IPA_VERSION_2_6L)
> +		return 0x4c0 + 0x4 * ep;
> +
> +	return 0x840 + 0x70 * ep;
> +}
> +
>   #define STATUS_EN_FMASK				GENMASK(0, 0)
>   #define STATUS_ENDP_FMASK			GENMASK(5, 1)
>   /* The next field is not present for IPA v4.5+ */
> @@ -662,6 +773,9 @@ enum ipa_seq_rep_type {
>   static inline u32 ipa_reg_irq_stts_ee_n_offset(enum ipa_version version,
>   					       u32 ee)
>   {
> +	if (version <= IPA_VERSION_2_6L)
> +		return 0x00001008 + 0x1000 * ee;
> +
>   	if (version < IPA_VERSION_4_9)
>   		return 0x00003008 + 0x1000 * ee;
>   
> @@ -675,6 +789,9 @@ static inline u32 ipa_reg_irq_stts_offset(enum ipa_version version)
>   
>   static inline u32 ipa_reg_irq_en_ee_n_offset(enum ipa_version version, u32 ee)
>   {
> +	if (version <= IPA_VERSION_2_6L)
> +		return 0x0000100c + 0x1000 * ee;
> +
>   	if (version < IPA_VERSION_4_9)
>   		return 0x0000300c + 0x1000 * ee;
>   
> @@ -688,6 +805,9 @@ static inline u32 ipa_reg_irq_en_offset(enum ipa_version version)
>   
>   static inline u32 ipa_reg_irq_clr_ee_n_offset(enum ipa_version version, u32 ee)
>   {
> +	if (version <= IPA_VERSION_2_6L)
> +		return 0x00001010 + 0x1000 * ee;
> +
>   	if (version < IPA_VERSION_4_9)
>   		return 0x00003010 + 0x1000 * ee;
>   
> @@ -776,6 +896,9 @@ enum ipa_irq_id {
>   
>   static inline u32 ipa_reg_irq_uc_ee_n_offset(enum ipa_version version, u32 ee)
>   {
> +	if (version <= IPA_VERSION_2_6L)
> +		return 0x101c + 1000 * ee;
> +
>   	if (version < IPA_VERSION_4_9)
>   		return 0x0000301c + 0x1000 * ee;
>   
> @@ -793,6 +916,9 @@ static inline u32 ipa_reg_irq_uc_offset(enum ipa_version version)
>   static inline u32
>   ipa_reg_irq_suspend_info_ee_n_offset(enum ipa_version version, u32 ee)
>   {
> +	if (version <= IPA_VERSION_2_6L)
> +		return 0x00001098 + 0x1000 * ee;
> +
>   	if (version == IPA_VERSION_3_0)
>   		return 0x00003098 + 0x1000 * ee;
>   
> diff --git a/drivers/net/ipa/ipa_version.h b/drivers/net/ipa/ipa_version.h
> index 6c16c895d842..0d816de586ba 100644
> --- a/drivers/net/ipa/ipa_version.h
> +++ b/drivers/net/ipa/ipa_version.h
> @@ -8,6 +8,9 @@
>   
>   /**
>    * enum ipa_version
> + * @IPA_VERSION_2_0:	IPA version 2.0
> + * @IPA_VERSION_2_5:	IPA version 2.5/2.6
> + * @IPA_VERSION_2_6:	IPA version 2.6L
>    * @IPA_VERSION_3_0:	IPA version 3.0/GSI version 1.0
>    * @IPA_VERSION_3_1:	IPA version 3.1/GSI version 1.1
>    * @IPA_VERSION_3_5:	IPA version 3.5/GSI version 1.2
> @@ -25,6 +28,9 @@
>    * new version is added.
>    */
>   enum ipa_version {
> +	IPA_VERSION_2_0,
> +	IPA_VERSION_2_5,
> +	IPA_VERSION_2_6L,
>   	IPA_VERSION_3_0,
>   	IPA_VERSION_3_1,
>   	IPA_VERSION_3_5,
> @@ -38,4 +44,10 @@ enum ipa_version {
>   	IPA_VERSION_4_11,
>   };
>   
> +#define IPA_HAS_GSI(version) ((version) > IPA_VERSION_2_6L)
> +#define IPA_IS_64BIT(version) ((version) > IPA_VERSION_2_6L)
> +#define IPA_VERSION_RANGE(_version, _from, _to) \
> +	((_version) >= (IPA_VERSION_##_from) &&  \
> +	 (_version) <= (IPA_VERSION_##_to))
> +
>   #endif /* _IPA_VERSION_H_ */
> 

