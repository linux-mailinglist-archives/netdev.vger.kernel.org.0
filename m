Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4AB267890
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 09:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725814AbgILHf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 03:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgILHfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 03:35:52 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4B4C061573;
        Sat, 12 Sep 2020 00:35:52 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id o8so16470295ejb.10;
        Sat, 12 Sep 2020 00:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vVstsRYbims6zfnRcAlwpo0Z6QMKaiNdgin+5Ie4n4k=;
        b=dY3dSzOzACsDcZDNlpPWbl+liJT10/1tPgPURqSyCcS0D3LNyIFcxHz9TXshlBDGO0
         kJd/PR+XqIWK990HOt8BMlkCowzUQgY6d7zZeXaK5ilL+9h2bvuiLrpMOqLqO4YXBcli
         Q0hOhEsPqFJO0rrz56ahFaiPWe72FE1qW+TzUD38NHrxaV6v/bDuSsDout2TEUiSTwxG
         3s3YS0T7QhVDfj/LL9IFbqHoZjjejGJ/LgvC2PH5T/+VwnPAt3vkM86KdqmSk+qD0K/w
         mFtA12/42uDF8K7IpkHwnB6UmpOFTgSSqu2iLvqgdc2eEsgFbYl6NiGFCcTKV4D+QVwL
         Dirg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vVstsRYbims6zfnRcAlwpo0Z6QMKaiNdgin+5Ie4n4k=;
        b=cWB8ys4xsmdM4+7OtZtLtED4dDwC4TBqDJ7tG2UiuW0BJQo+LRfF4msUTZM3aQn3zF
         Lf/zeDj0KxNbNm53su0j4XUZWpdKd/Z8LAM21rtaJw+cnEoiKu3o9XVHvYxf5zGZBuwZ
         kXPZyt2p9VJqRiCfmhww/ExSB2GVF1aoKPwzsXyYX8y/dhVU18gAjWoMgbN1BmotG3FF
         V4obLflGLfv1LelJfcImakoSWhCz+wmS9a/cswbW9/symqtWPUd+5MY1aK1E3L+TRsZm
         usXu/ynK+WHbfw+xgtmDhJyqLIT7UdiNrg2FW3K/gdL04r7iWk7NTIPOudW/J12cL7q5
         7Tgg==
X-Gm-Message-State: AOAM5304hTnQADdplgWsXcjx63FNOTH48q6BE3lEMXsfE3pEt7savWUF
        hFS3kS0kkQiyLTrMHjXWLXM=
X-Google-Smtp-Source: ABdhPJzUpWOhLQaKid2nvpj0/oWczKJxvIQpFfMcNdx/R2LzwSv29sfxYtfYFzCWna2DF+w0/fC5Ew==
X-Received: by 2002:a17:906:9443:: with SMTP id z3mr5458008ejx.156.1599896150640;
        Sat, 12 Sep 2020 00:35:50 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id bf25sm3901096edb.95.2020.09.12.00.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 00:35:50 -0700 (PDT)
Date:   Sat, 12 Sep 2020 10:35:48 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 2/2] ptp_qoriq: support FIPER3
Message-ID: <20200912073548.c3yb7fe7mhi6cews@skbuf>
References: <20200912033006.20771-1-yangbo.lu@nxp.com>
 <20200912033006.20771-3-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200912033006.20771-3-yangbo.lu@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yangbo,

On Sat, Sep 12, 2020 at 11:30:06AM +0800, Yangbo Lu wrote:
> The FIPER3 (fixed interval period pulse generator) is supported on
> DPAA2 and ENETC network controller hardware. This patch is to support
> it in ptp_qoriq driver.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---
>  drivers/ptp/ptp_qoriq.c       | 23 ++++++++++++++++++++++-
>  include/linux/fsl/ptp_qoriq.h |  3 +++
>  2 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
> index c09c16be..68beb1b 100644
> --- a/drivers/ptp/ptp_qoriq.c
> +++ b/drivers/ptp/ptp_qoriq.c
> @@ -72,6 +72,10 @@ static void set_fipers(struct ptp_qoriq *ptp_qoriq)
>  	set_alarm(ptp_qoriq);
>  	ptp_qoriq->write(&regs->fiper_regs->tmr_fiper1, ptp_qoriq->tmr_fiper1);
>  	ptp_qoriq->write(&regs->fiper_regs->tmr_fiper2, ptp_qoriq->tmr_fiper2);
> +
> +	if (ptp_qoriq->fiper3_support)
> +		ptp_qoriq->write(&regs->fiper_regs->tmr_fiper3,
> +				 ptp_qoriq->tmr_fiper3);
>  }
>  
>  int extts_clean_up(struct ptp_qoriq *ptp_qoriq, int index, bool update_event)
> @@ -366,6 +370,7 @@ static u32 ptp_qoriq_nominal_freq(u32 clk_src)
>   *   "fsl,tmr-add"
>   *   "fsl,tmr-fiper1"
>   *   "fsl,tmr-fiper2"
> + *   "fsl,tmr-fiper3" (required only for DPAA2 and ENETC hardware)
>   *   "fsl,max-adj"
>   *
>   * Return 0 if success
> @@ -412,6 +417,7 @@ static int ptp_qoriq_auto_config(struct ptp_qoriq *ptp_qoriq,
>  	ptp_qoriq->tmr_add = freq_comp;
>  	ptp_qoriq->tmr_fiper1 = DEFAULT_FIPER1_PERIOD - ptp_qoriq->tclk_period;
>  	ptp_qoriq->tmr_fiper2 = DEFAULT_FIPER2_PERIOD - ptp_qoriq->tclk_period;
> +	ptp_qoriq->tmr_fiper3 = DEFAULT_FIPER3_PERIOD - ptp_qoriq->tclk_period;
>  
>  	/* max_adj = 1000000000 * (freq_ratio - 1.0) - 1
>  	 * freq_ratio = reference_clock_freq / nominal_freq
> @@ -446,6 +452,13 @@ int ptp_qoriq_init(struct ptp_qoriq *ptp_qoriq, void __iomem *base,
>  	else
>  		ptp_qoriq->extts_fifo_support = false;
>  
> +	if (of_device_is_compatible(node, "fsl,dpaa2-ptp") ||
> +	    of_device_is_compatible(node, "fsl,enetc-ptp")) {
> +		ptp_qoriq->fiper3_support = true;
> +	} else {
> +		ptp_qoriq->fiper3_support = false;
> +	}

Since struct ptp_qoriq is kzalloc()-ed, maybe you can skip the "else"
branch?

> +
>  	if (of_property_read_u32(node,
>  				 "fsl,tclk-period", &ptp_qoriq->tclk_period) ||
>  	    of_property_read_u32(node,
> @@ -457,7 +470,10 @@ int ptp_qoriq_init(struct ptp_qoriq *ptp_qoriq, void __iomem *base,
>  	    of_property_read_u32(node,
>  				 "fsl,tmr-fiper2", &ptp_qoriq->tmr_fiper2) ||
>  	    of_property_read_u32(node,
> -				 "fsl,max-adj", &ptp_qoriq->caps.max_adj)) {
> +				 "fsl,max-adj", &ptp_qoriq->caps.max_adj) ||
> +	    (of_property_read_u32(node,
> +				 "fsl,tmr-fiper3", &ptp_qoriq->tmr_fiper3) &&
> +	     ptp_qoriq->fiper3_support)) {

Could you check for the "ptp_qoriq->fiper3_support" boolean first, so
that a useless device tree property lookup is not performed?

>  		pr_warn("device tree node missing required elements, try automatic configuration\n");
>  
>  		if (ptp_qoriq_auto_config(ptp_qoriq, node))
> @@ -502,6 +518,11 @@ int ptp_qoriq_init(struct ptp_qoriq *ptp_qoriq, void __iomem *base,
>  	ptp_qoriq->write(&regs->ctrl_regs->tmr_prsc, ptp_qoriq->tmr_prsc);
>  	ptp_qoriq->write(&regs->fiper_regs->tmr_fiper1, ptp_qoriq->tmr_fiper1);
>  	ptp_qoriq->write(&regs->fiper_regs->tmr_fiper2, ptp_qoriq->tmr_fiper2);
> +
> +	if (ptp_qoriq->fiper3_support)
> +		ptp_qoriq->write(&regs->fiper_regs->tmr_fiper3,
> +				 ptp_qoriq->tmr_fiper3);
> +
>  	set_alarm(ptp_qoriq);
>  	ptp_qoriq->write(&regs->ctrl_regs->tmr_ctrl,
>  			 tmr_ctrl|FIPERST|RTPE|TE|FRD);
> diff --git a/include/linux/fsl/ptp_qoriq.h b/include/linux/fsl/ptp_qoriq.h
> index 884b8f8..01acebe 100644
> --- a/include/linux/fsl/ptp_qoriq.h
> +++ b/include/linux/fsl/ptp_qoriq.h
> @@ -136,6 +136,7 @@ struct ptp_qoriq_registers {
>  #define DEFAULT_TMR_PRSC	2
>  #define DEFAULT_FIPER1_PERIOD	1000000000
>  #define DEFAULT_FIPER2_PERIOD	1000000000
> +#define DEFAULT_FIPER3_PERIOD	1000000000
>  
>  struct ptp_qoriq {
>  	void __iomem *base;
> @@ -147,6 +148,7 @@ struct ptp_qoriq {
>  	struct dentry *debugfs_root;
>  	struct device *dev;
>  	bool extts_fifo_support;
> +	bool fiper3_support;
>  	int irq;
>  	int phc_index;
>  	u32 tclk_period;  /* nanoseconds */
> @@ -155,6 +157,7 @@ struct ptp_qoriq {
>  	u32 cksel;
>  	u32 tmr_fiper1;
>  	u32 tmr_fiper2;
> +	u32 tmr_fiper3;
>  	u32 (*read)(unsigned __iomem *addr);
>  	void (*write)(unsigned __iomem *addr, u32 val);
>  };
> -- 
> 2.7.4
> 

With that,

Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Thanks for doing this!
-Vladimir
