Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992CD284660
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgJFG4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgJFG4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:56:21 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC52C0613D1
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 23:56:21 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id d81so1749433wmc.1
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 23:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=uefgcZJEjxyEQ9EMRE9mQWtY5FP1/cOBvuhrVucWaL4=;
        b=mXkwBwV3uHgEOxFz+BrpkbePSh2uIiVsOL4Q8BYDAJDypvyxJYM0atdBu9izyBiklN
         JUT7Rs3FZZcA7EGJwKM5eeigcUBVvcDfeZm83LFbXnscy1H1lahoLDUs2XAHwSXWered
         DoiTT0h2TqAf+eoQCa+OKq1yKWTMadlruJk2Jaq03oF84s+8Isc4+roffFBG83sO+pPJ
         QpcK3Ic1k3+Ao2UnCTjcI5+Xsv99zs8kNZPGGF7AhC+2etryShDW/guLwkZ7bHE/VSa4
         bxTXQmucpLNCD3efMbFkW6dDT90QxhHowDxNVj2MVVRdHZvtBaYzDalinrAp5ynsnWs1
         U3kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=uefgcZJEjxyEQ9EMRE9mQWtY5FP1/cOBvuhrVucWaL4=;
        b=KiOwL5XxTYbgIwyhKbTvtR5V3P6rxQH4nTt4EYObV/sTI3POdqJ3k4P2kVOK5dpwr4
         oGG4hKyXazJeyd8e11xTG2c/wbHJYSZsn6eD2iUNTr253HTz8JzkRBvE9JG3cxQNmbUF
         du4dS+zA8zjgtNd+Uabbh71kQ/BaaoNBIMYC7BKkwKLCB75JWVBJVTWqFeaSqO0Fknor
         cGyHGigQ9Ll1A3mY0ZxQ91AmaUhEZCV9zGiqZpCUoWWdwJR/WPZdj2KDHMiC42kD9Zsq
         Y1tu9BqS9EkIToNCOCJILIVHcWU7hoQnLe7DsCx2J+B77quOxWsce8E4tje6RHhtm+3l
         O8BA==
X-Gm-Message-State: AOAM530DVX3HPZFRb+JnCes2TMWAZzwgmL3AbNxEkCzcCyhcMIo8nox/
        FWocuFgXjhDo4r5tVpmnv85FAV730O0apg==
X-Google-Smtp-Source: ABdhPJwXGqcOK5nEDYkkUxOnDx8BbUTICgzVOqRZG+MR8mEOAOKX5hhn6oiAkfCBUvZAL7QZuAzfFQ==
X-Received: by 2002:a7b:cb04:: with SMTP id u4mr3091764wmj.130.1601967379940;
        Mon, 05 Oct 2020 23:56:19 -0700 (PDT)
Received: from dell ([91.110.221.236])
        by smtp.gmail.com with ESMTPSA id b8sm2545643wmb.4.2020.10.05.23.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 23:56:19 -0700 (PDT)
Date:   Tue, 6 Oct 2020 07:56:17 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Luciano Coelho <luca@coelho.fi>
Subject: Re: [PATCH v2 00/29] [Set 1,2,3] Rid W=1 warnings in Wireless
Message-ID: <20201006065617.GX6148@dell>
References: <20200910065431.657636-1-lee.jones@linaro.org>
 <20201002090353.GS6148@dell>
 <87362rdhv2.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87362rdhv2.fsf@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 06 Oct 2020, Kalle Valo wrote:

> Lee Jones <lee.jones@linaro.org> writes:
> 
> > On Thu, 10 Sep 2020, Lee Jones wrote:
> >
> >> This is a rebased/re-worked set of patches which have been
> >> previously posted to the mailing list(s).
> >> 
> >> This set is part of a larger effort attempting to clean-up W=1
> >> kernel builds, which are currently overwhelmingly riddled with
> >> niggly little warnings.
> >> 
> >> There are quite a few W=1 warnings in the Wireless.  My plan
> >> is to work through all of them over the next few weeks.
> >> Hopefully it won't be too long before drivers/net/wireless
> >> builds clean with W=1 enabled.
> >> 
> >> Lee Jones (29):
> >>   iwlwifi: dvm: Demote non-compliant kernel-doc headers
> >>   iwlwifi: rs: Demote non-compliant kernel-doc headers
> >>   iwlwifi: dvm: tx: Demote non-compliant kernel-doc headers
> >>   iwlwifi: dvm: lib: Demote non-compliant kernel-doc headers
> >>   iwlwifi: calib: Demote seemingly unintentional kerneldoc header
> >>   wil6210: Fix a couple of formatting issues in 'wil6210_debugfs_init'
> >>   iwlwifi: dvm: sta: Demote a bunch of nonconformant kernel-doc headers
> >>   iwlwifi: mvm: ops: Remove unused static struct 'iwl_mvm_debug_names'
> >>   iwlwifi: dvm: Demote a couple of nonconformant kernel-doc headers
> >>   iwlwifi: mvm: utils: Fix some doc-rot
> >>   iwlwifi: dvm: scan: Demote a few nonconformant kernel-doc headers
> >>   iwlwifi: dvm: rxon: Demote non-conformant kernel-doc headers
> >>   iwlwifi: mvm: tx: Demote misuse of kernel-doc headers
> >>   iwlwifi: dvm: devices: Fix function documentation formatting issues
> >>   iwlwifi: iwl-drv: Provide descriptions debugfs dentries
> >>   wil6210: wmi: Fix formatting and demote non-conforming function
> >>     headers
> >>   wil6210: interrupt: Demote comment header which is clearly not
> >>     kernel-doc
> >>   wil6210: txrx: Demote obvious abuse of kernel-doc
> >>   wil6210: txrx_edma: Demote comments which are clearly not kernel-doc
> >>   wil6210: pmc: Demote a few nonconformant kernel-doc function headers
> >>   wil6210: wil_platform: Demote kernel-doc header to standard comment
> >>     block
> >>   wil6210: wmi: Correct misnamed function parameter 'ptr_'
> >>   ath6kl: wmi: Remove unused variable 'rate'
> >>   ath9k: ar9002_initvals: Remove unused array
> >>     'ar9280PciePhy_clkreq_off_L1_9280'
> >>   ath9k: ar9001_initvals: Remove unused array 'ar5416Bank6_9100'
> >>   ath9k: ar5008_initvals: Remove unused table entirely
> >>   ath9k: ar5008_initvals: Move ar5416Bank{0,1,2,3,7} to where they are
> >>     used
> >>   brcmsmac: phytbl_lcn: Remove unused array 'dot11lcn_gain_tbl_rev1'
> >>   brcmsmac: phy_lcn: Remove unused variable
> >>     'lcnphy_rx_iqcomp_table_rev0'
> >
> > What's happening with all of these iwlwifi patches?
> >
> > Looks like they are still not applied.
> 
> Luca (CCed) takes iwlwifi patches to his iwlwifi tree.

Thanks Kalle.

Luca,

  Do you know why these patches have not been applied yet?  Do you
plan on applying them this week?  -rc1 is not due for release for
nearly 3 weeks now that Linus tagged an -rc8.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
