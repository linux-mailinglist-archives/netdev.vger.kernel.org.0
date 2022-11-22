Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CECFB634A25
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 23:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbiKVWgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 17:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234134AbiKVWgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 17:36:31 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E93C76B5
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 14:36:30 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id f9so11047871pgf.7
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 14:36:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MC/pazp4td7QZ5IYbmgF4DgI2fIt0HyV4RiNQLCeY7s=;
        b=UKSCbjR0oqobS4xAjII29IroCX7QlGlce177pexntrRc7NExkJNEaz/jHwG9R+DEJa
         gOpV2ajJdj40P08VQQWix+rbikOLdIW1hCASFSlWIShfGTbZ83J2VO/9jF9wITTW6Pvk
         kLqchwBGKSMhVaWu6ZsHCtl8ru6Iy1K0II4Vzh0PQCJgtXNkCw0p5XhhkPeTDOLmBPTF
         gYWC87QC2DI80clU4zo+/NQDh3+NruZGujaWUVKw9IpMGqmiihL0F0OWIzIwaK3zW8X5
         b90Z9hxB3i1Zyu0gWtRm1AiGGnycQ87eF1gaVaFIBI+sYOH1F9WEySsBJT+kJUc/Dc8n
         8lRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MC/pazp4td7QZ5IYbmgF4DgI2fIt0HyV4RiNQLCeY7s=;
        b=nZN8sVX8pMDLossotuR7lrarPsn6QpOHYOqvlmUpYuGFVnm+PkkGYgw95YkbzzIHP7
         VC4wBq+haNN3xTub8kHK9hkVixM0ny7oF0AP3QQxe3E9mZDFvTtBF1Hg3lnhHKn2Iw7D
         k7nlYAB8LaMwmyosfODbQMC9HEEuOhZwV3oyiqHscRqYqIVIdebw6sqx52pEIbQxziaH
         FKdoKLZ7Z39ezngfn73CcKOPIMTwZZRKYWRjXh52t7xQgc0gLCCamuNirPri9wNOY7N3
         b1teeU8L9wJy4/00NN2BGO1kbrbL0f3rvdqTyCFy0+M5Dy25d+bJZSlCwHAQNa+0zv/6
         Vf2w==
X-Gm-Message-State: ANoB5plglj1b+WDq8YSbTW1yBbnKuxOpob2cHSleZBWfuiNYQX0bQpGO
        Hz2HwIZYaVIGvhRxdDKByS0=
X-Google-Smtp-Source: AA0mqf4GGsas7tGfw/sWaU0boBgzH0DY2wxIxc5JDFj2mKML+pDIIF8Pa1mhWTv5b0544mRTTfXYwg==
X-Received: by 2002:a65:458a:0:b0:477:9a46:d058 with SMTP id o10-20020a65458a000000b004779a46d058mr5195131pgq.280.1669156590313;
        Tue, 22 Nov 2022 14:36:30 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id v10-20020aa799ca000000b0056286c552ecsm11108193pfi.184.2022.11.22.14.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 14:36:29 -0800 (PST)
Date:   Tue, 22 Nov 2022 14:36:27 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Karol Kolacinski <karol.kolacinski@intel.com>,
        netdev@vger.kernel.org, Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net-next v2 2/7] ice: Remove gettime HW semaphore
Message-ID: <Y31O6zWRjaqttANO@hoboy.vegasvil.org>
References: <20221122221047.3095231-1-anthony.l.nguyen@intel.com>
 <20221122221047.3095231-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122221047.3095231-3-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 02:10:42PM -0800, Tony Nguyen wrote:
> From: Karol Kolacinski <karol.kolacinski@intel.com>
> 
> Reading the time should not block other accesses to the PTP hardware.
> There isn't a significant risk of reading bad values while another
> thread is modifying the clock. Removing the hardware lock around the
> gettime allows multiple application threads to read the clock time with
> less contention.

NAK

Correctness comes before performance.

Thanks,
Richard


> 
> Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
> Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_ptp.c | 31 +++---------------------
>  1 file changed, 3 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
> index 5cf198a33e26..d1bab1876249 100644
> --- a/drivers/net/ethernet/intel/ice/ice_ptp.c
> +++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
> @@ -979,26 +979,6 @@ static void ice_ptp_reset_cached_phctime(struct ice_pf *pf)
>  	ice_ptp_flush_tx_tracker(pf, &pf->ptp.port.tx);
>  }
>  
> -/**
> - * ice_ptp_read_time - Read the time from the device
> - * @pf: Board private structure
> - * @ts: timespec structure to hold the current time value
> - * @sts: Optional parameter for holding a pair of system timestamps from
> - *       the system clock. Will be ignored if NULL is given.
> - *
> - * This function reads the source clock registers and stores them in a timespec.
> - * However, since the registers are 64 bits of nanoseconds, we must convert the
> - * result to a timespec before we can return.
> - */
> -static void
> -ice_ptp_read_time(struct ice_pf *pf, struct timespec64 *ts,
> -		  struct ptp_system_timestamp *sts)
> -{
> -	u64 time_ns = ice_ptp_read_src_clk_reg(pf, sts);
> -
> -	*ts = ns_to_timespec64(time_ns);
> -}
> -
>  /**
>   * ice_ptp_write_init - Set PHC time to provided value
>   * @pf: Board private structure
> @@ -1789,15 +1769,10 @@ ice_ptp_gettimex64(struct ptp_clock_info *info, struct timespec64 *ts,
>  		   struct ptp_system_timestamp *sts)
>  {
>  	struct ice_pf *pf = ptp_info_to_pf(info);
> -	struct ice_hw *hw = &pf->hw;
> +	u64 time_ns;
>  
> -	if (!ice_ptp_lock(hw)) {
> -		dev_err(ice_pf_to_dev(pf), "PTP failed to get time\n");
> -		return -EBUSY;
> -	}
> -
> -	ice_ptp_read_time(pf, ts, sts);
> -	ice_ptp_unlock(hw);
> +	time_ns = ice_ptp_read_src_clk_reg(pf, sts);
> +	*ts = ns_to_timespec64(time_ns);
>  
>  	return 0;
>  }
> -- 
> 2.35.1
> 
