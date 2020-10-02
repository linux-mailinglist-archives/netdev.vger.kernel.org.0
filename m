Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D7E280F6D
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 11:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387550AbgJBJD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 05:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgJBJD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 05:03:58 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB91C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 02:03:57 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id t17so896640wmi.4
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 02:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=GMl7/j88Iz46F6Y+1lgqEhwx+ihDL4dLgjSpHmIIUds=;
        b=jzmQ0yzEa0SE3WP4cm6xCn0WqgA8A1gFiJvg8siOK/8IWedstvxznXYW3EVrrk7lV+
         tzAmBI7SUmo/Q990g6cvSwfpV6+iN/4SukyDDZj1i0AVj2Q06LgDdbQT3ePzYWeR8NrU
         bux5rT8OH2tP7kNkforH0GzYte4gL5xI4gfMhz34NAtcidGTjA0AeXUZKiM50VRYHjdZ
         rX2TlOTcW+ZyX50+xFu5lvgjawrCbEFlKQeaUO6ULozadmhBKj2uEhJz8u0AGr/GvPPt
         /aWc+je5PIT5hh5ceTMmyGWef+nlBUztHFylE03CJ2qaj1sshRvFwuOVB8xkWfrRHXgu
         ZrlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=GMl7/j88Iz46F6Y+1lgqEhwx+ihDL4dLgjSpHmIIUds=;
        b=Htca4BiKyz5ohmKKWSGZ0mtTrJvsgwHLM/l6/VejrF4Hj5+sWZ0b6OHVk+H6FJCLvi
         Ibr1Ysn0MK4+icZOIFbk3HwLEtmlZjm2JZRwff2K5ZjCKU/KlCMaU2tq7j7x3ntSfp07
         4dqGHwtwes7Ux+4JLq2IdIzQ9hw5PHrHN14QtT8pVriytE8xGfOJyEYcIsqVXwTDvpMn
         CdhL2eflg73+rx5GDqhVSFzYStC/HzpJm0p+xVI3+51nLtPsicqiBj98QYMmaQdM91w0
         TyhcPcPjYk6VhQmniSNEKJ8+zdZnMJXFW/1AVc2qnBzY0yEuqoMmi4SaTj8UkPLIBthJ
         RROA==
X-Gm-Message-State: AOAM531ypv70q8gvvlQPdBoU/LVcNJKe/s6XQt68Y0TdsGxGOnMFWHD0
        1/eb+VBkt6j9gXHQo/wSIpwbOQAZEYDSCg==
X-Google-Smtp-Source: ABdhPJw70LY1kPIFBdESXYlJH3qP4DzeHZ24QPyztH1Z1PJV2Quya6u6e4iMNs8CAmj2Hb0gu07YNw==
X-Received: by 2002:a1c:b7d7:: with SMTP id h206mr1773289wmf.159.1601629436439;
        Fri, 02 Oct 2020 02:03:56 -0700 (PDT)
Received: from dell ([91.110.221.236])
        by smtp.gmail.com with ESMTPSA id f12sm955863wmf.26.2020.10.02.02.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 02:03:55 -0700 (PDT)
Date:   Fri, 2 Oct 2020 10:03:53 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 00/29] [Set 1,2,3] Rid W=1 warnings in Wireless
Message-ID: <20201002090353.GS6148@dell>
References: <20200910065431.657636-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200910065431.657636-1-lee.jones@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020, Lee Jones wrote:

> This is a rebased/re-worked set of patches which have been
> previously posted to the mailing list(s).
> 
> This set is part of a larger effort attempting to clean-up W=1
> kernel builds, which are currently overwhelmingly riddled with
> niggly little warnings.
> 
> There are quite a few W=1 warnings in the Wireless.  My plan
> is to work through all of them over the next few weeks.
> Hopefully it won't be too long before drivers/net/wireless
> builds clean with W=1 enabled.
> 
> Lee Jones (29):
>   iwlwifi: dvm: Demote non-compliant kernel-doc headers
>   iwlwifi: rs: Demote non-compliant kernel-doc headers
>   iwlwifi: dvm: tx: Demote non-compliant kernel-doc headers
>   iwlwifi: dvm: lib: Demote non-compliant kernel-doc headers
>   iwlwifi: calib: Demote seemingly unintentional kerneldoc header
>   wil6210: Fix a couple of formatting issues in 'wil6210_debugfs_init'
>   iwlwifi: dvm: sta: Demote a bunch of nonconformant kernel-doc headers
>   iwlwifi: mvm: ops: Remove unused static struct 'iwl_mvm_debug_names'
>   iwlwifi: dvm: Demote a couple of nonconformant kernel-doc headers
>   iwlwifi: mvm: utils: Fix some doc-rot
>   iwlwifi: dvm: scan: Demote a few nonconformant kernel-doc headers
>   iwlwifi: dvm: rxon: Demote non-conformant kernel-doc headers
>   iwlwifi: mvm: tx: Demote misuse of kernel-doc headers
>   iwlwifi: dvm: devices: Fix function documentation formatting issues
>   iwlwifi: iwl-drv: Provide descriptions debugfs dentries
>   wil6210: wmi: Fix formatting and demote non-conforming function
>     headers
>   wil6210: interrupt: Demote comment header which is clearly not
>     kernel-doc
>   wil6210: txrx: Demote obvious abuse of kernel-doc
>   wil6210: txrx_edma: Demote comments which are clearly not kernel-doc
>   wil6210: pmc: Demote a few nonconformant kernel-doc function headers
>   wil6210: wil_platform: Demote kernel-doc header to standard comment
>     block
>   wil6210: wmi: Correct misnamed function parameter 'ptr_'
>   ath6kl: wmi: Remove unused variable 'rate'
>   ath9k: ar9002_initvals: Remove unused array
>     'ar9280PciePhy_clkreq_off_L1_9280'
>   ath9k: ar9001_initvals: Remove unused array 'ar5416Bank6_9100'
>   ath9k: ar5008_initvals: Remove unused table entirely
>   ath9k: ar5008_initvals: Move ar5416Bank{0,1,2,3,7} to where they are
>     used
>   brcmsmac: phytbl_lcn: Remove unused array 'dot11lcn_gain_tbl_rev1'
>   brcmsmac: phy_lcn: Remove unused variable
>     'lcnphy_rx_iqcomp_table_rev0'

What's happening with all of these iwlwifi patches?

Looks like they are still not applied.

BTW, there should be another week of development left, as indicated by
Linus during -rc6.  Looks like there will be an -rc8 after all.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
