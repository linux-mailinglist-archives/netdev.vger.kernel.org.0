Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4B14F92BE
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 12:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234407AbiDHKTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 06:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234311AbiDHKTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 06:19:45 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE8CC748F;
        Fri,  8 Apr 2022 03:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649413058; x=1680949058;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=ZN2WT+aHWp12igTiJOcFcOuGrpSymXLSvwLhWlCo5CA=;
  b=nCQW6y+0U1FyujEKxJLqRYg7Cpt10pqNOpzWDbY1SvMls0IhBHjWYLK+
   3+UZjceY27qkk5X9wSQzC8uAbGBxLfrhWmGRZWNmPF7V5jremElRQSZYi
   wplAnCKjer4o/6/N+FiwpdQh+5PIXtUmV+eU1XochQixbqfifhHcejU0T
   fk4nogI/mATK0syYSP1raiIxdufxfdL3YBUnEyd7Irqn/gXUFQKxtSnLf
   rW/CnzjBGHH4ziORtRwpxncuLqNRuC8IE6Xj6w0jj/0L3QQyiwhLS9Jrx
   c52Mp8kN0lY4xV2VxEZTV4DiVvyIqah6qMWLCc/tAUt2XViKxt4qDx+If
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="242155536"
X-IronPort-AV: E=Sophos;i="5.90,244,1643702400"; 
   d="scan'208";a="242155536"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 03:17:38 -0700
X-IronPort-AV: E=Sophos;i="5.90,244,1643702400"; 
   d="scan'208";a="571439569"
Received: from dmunisam-mobl.ger.corp.intel.com (HELO localhost) ([10.249.141.69])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 03:17:31 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     cgel.zte@gmail.com, alexander.deucher@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie
Cc:     daniel@ffwll.ch, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, tvrtko.ursulin@linux.intel.com,
        lv.ruyi@zte.com.cn, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-scsi@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] drivers: Fix spelling mistake "writting" -> "writing"
In-Reply-To: <20220408095531.2495168-1-lv.ruyi@zte.com.cn>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20220408095531.2495168-1-lv.ruyi@zte.com.cn>
Date:   Fri, 08 Apr 2022 13:17:27 +0300
Message-ID: <87sfqnj2vc.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 08 Apr 2022, cgel.zte@gmail.com wrote:
> From: Lv Ruyi <lv.ruyi@zte.com.cn>
>
> There are some spelling mistakes in the comments. Fix it.

Please prefer splitting by driver. This isn't even split by subsystem. I
presume there are very few maintainers willing to pick this up as it is.

BR,
Jani.

>
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
> ---
>  drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c              | 2 +-
>  drivers/gpu/drm/i915/i915_request.c                 | 2 +-
>  drivers/net/ethernet/sfc/mcdi_pcol.h                | 4 ++--
>  drivers/net/ethernet/toshiba/tc35815.c              | 2 +-
>  drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c | 4 ++--
>  drivers/platform/x86/hp_accel.c                     | 2 +-
>  drivers/rtc/rtc-sa1100.c                            | 2 +-
>  drivers/scsi/pmcraid.c                              | 4 ++--
>  8 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> index 9426e252d8aa..ce361fce7155 100644
> --- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> @@ -7304,7 +7304,7 @@ static void gfx_v10_0_setup_grbm_cam_remapping(struct amdgpu_device *adev)
>  		return;
>  
>  	/* initialize cam_index to 0
> -	 * index will auto-inc after each data writting */
> +	 * index will auto-inc after each data writing */
>  	WREG32_SOC15(GC, 0, mmGRBM_CAM_INDEX, 0);
>  
>  	switch (adev->ip_versions[GC_HWIP][0]) {
> diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
> index 582770360ad1..cf79a25cd98a 100644
> --- a/drivers/gpu/drm/i915/i915_request.c
> +++ b/drivers/gpu/drm/i915/i915_request.c
> @@ -451,7 +451,7 @@ static bool __request_in_flight(const struct i915_request *signal)
>  	 * to avoid tearing.]
>  	 *
>  	 * Note that the read of *execlists->active may race with the promotion
> -	 * of execlists->pending[] to execlists->inflight[], overwritting
> +	 * of execlists->pending[] to execlists->inflight[], overwriting
>  	 * the value at *execlists->active. This is fine. The promotion implies
>  	 * that we received an ACK from the HW, and so the context is not
>  	 * stuck -- if we do not see ourselves in *active, the inflight status
> diff --git a/drivers/net/ethernet/sfc/mcdi_pcol.h b/drivers/net/ethernet/sfc/mcdi_pcol.h
> index d3fcbf930dba..ff617b1b38d3 100644
> --- a/drivers/net/ethernet/sfc/mcdi_pcol.h
> +++ b/drivers/net/ethernet/sfc/mcdi_pcol.h
> @@ -73,8 +73,8 @@
>   *               \------------------------------ Resync (always set)
>   *
>   * The client writes it's request into MC shared memory, and rings the
> - * doorbell. Each request is completed by either by the MC writting
> - * back into shared memory, or by writting out an event.
> + * doorbell. Each request is completed by either by the MC writing
> + * back into shared memory, or by writing out an event.
>   *
>   * All MCDI commands support completion by shared memory response. Each
>   * request may also contain additional data (accounted for by HEADER.LEN),
> diff --git a/drivers/net/ethernet/toshiba/tc35815.c b/drivers/net/ethernet/toshiba/tc35815.c
> index ce38f7515225..1b4c207afb66 100644
> --- a/drivers/net/ethernet/toshiba/tc35815.c
> +++ b/drivers/net/ethernet/toshiba/tc35815.c
> @@ -157,7 +157,7 @@ struct tc35815_regs {
>  #define PROM_Read	       0x00004000 /*10:Read operation		     */
>  #define PROM_Write	       0x00002000 /*01:Write operation		     */
>  #define PROM_Erase	       0x00006000 /*11:Erase operation		     */
> -					  /*00:Enable or Disable Writting,   */
> +					  /*00:Enable or Disable Writing,    */
>  					  /*	  as specified in PROM_Addr. */
>  #define PROM_Addr_Ena	       0x00000030 /*11xxxx:PROM Write enable	     */
>  					  /*00xxxx:	      disable	     */
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
> index eaba66113328..fbb4941d0da8 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
> @@ -520,7 +520,7 @@ static void _rtl92cu_init_queue_reserved_page(struct ieee80211_hw *hw,
>  		 * 2 out-ep. Remainder pages have assigned to High queue */
>  		if (outepnum > 1 && txqremaininpage)
>  			numhq += txqremaininpage;
> -		/* NOTE: This step done before writting REG_RQPN. */
> +		/* NOTE: This step done before writing REG_RQPN. */
>  		if (ischipn) {
>  			if (queue_sel & TX_SELE_NQ)
>  				numnq = txqpageunit;
> @@ -539,7 +539,7 @@ static void _rtl92cu_init_queue_reserved_page(struct ieee80211_hw *hw,
>  			numlq = ischipn ? WMM_CHIP_B_PAGE_NUM_LPQ :
>  				WMM_CHIP_A_PAGE_NUM_LPQ;
>  		}
> -		/* NOTE: This step done before writting REG_RQPN. */
> +		/* NOTE: This step done before writing REG_RQPN. */
>  		if (ischipn) {
>  			if (queue_sel & TX_SELE_NQ)
>  				numnq = WMM_CHIP_B_PAGE_NUM_NPQ;
> diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
> index e9f852f7c27f..b59b852a666f 100644
> --- a/drivers/platform/x86/hp_accel.c
> +++ b/drivers/platform/x86/hp_accel.c
> @@ -122,7 +122,7 @@ static int lis3lv02d_acpi_read(struct lis3lv02d *lis3, int reg, u8 *ret)
>  static int lis3lv02d_acpi_write(struct lis3lv02d *lis3, int reg, u8 val)
>  {
>  	struct acpi_device *dev = lis3->bus_priv;
> -	unsigned long long ret; /* Not used when writting */
> +	unsigned long long ret; /* Not used when writing */
>  	union acpi_object in_obj[2];
>  	struct acpi_object_list args = { 2, in_obj };
>  
> diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
> index 1250887e4382..a52a333de8e8 100644
> --- a/drivers/rtc/rtc-sa1100.c
> +++ b/drivers/rtc/rtc-sa1100.c
> @@ -231,7 +231,7 @@ int sa1100_rtc_init(struct platform_device *pdev, struct sa1100_rtc *info)
>  	 * initialization is unknown and could in principle happen during
>  	 * normal processing.
>  	 *
> -	 * Notice that clearing bit 1 and 0 is accomplished by writting ONES to
> +	 * Notice that clearing bit 1 and 0 is accomplished by writing ONES to
>  	 * the corresponding bits in RTSR. */
>  	writel_relaxed(RTSR_AL | RTSR_HZ, info->rtsr);
>  
> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index fd674ed1febe..d7f4680f6106 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -857,7 +857,7 @@ static void _pmcraid_fire_command(struct pmcraid_cmd *cmd)
>  	unsigned long lock_flags;
>  
>  	/* Add this command block to pending cmd pool. We do this prior to
> -	 * writting IOARCB to ioarrin because IOA might complete the command
> +	 * writing IOARCB to ioarrin because IOA might complete the command
>  	 * by the time we are about to add it to the list. Response handler
>  	 * (isr/tasklet) looks for cmd block in the pending pending list.
>  	 */
> @@ -2450,7 +2450,7 @@ static void pmcraid_request_sense(struct pmcraid_cmd *cmd)
>  
>  	/* request sense might be called as part of error response processing
>  	 * which runs in tasklets context. It is possible that mid-layer might
> -	 * schedule queuecommand during this time, hence, writting to IOARRIN
> +	 * schedule queuecommand during this time, hence, writing to IOARRIN
>  	 * must be protect by host_lock
>  	 */
>  	pmcraid_send_cmd(cmd, pmcraid_erp_done,

-- 
Jani Nikula, Intel Open Source Graphics Center
