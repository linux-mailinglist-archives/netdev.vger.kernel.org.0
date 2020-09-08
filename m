Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D489260D9F
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 10:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730023AbgIHIeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 04:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729234AbgIHIer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 04:34:47 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5F6C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 01:34:44 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z1so18200642wrt.3
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 01:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=CW7SWlQziB+XLEfwDIarCUWn2egUFfp8nzobe9Kqg9c=;
        b=oQsLgdniIzJlP1V7VOZOZZwmmHc8QXyz1sX64QYO80LQrCxwzh22dSDrIe4RIMbDb5
         XwuYiesWLUOPUg/MDzU2WD4ef2pe93qwmqHBChFQh8NsHDRfhzNfSz54GKs/uz+TVuJo
         3AgRf5yeK4/WLMWkT7UhON/1u7Ztp1NvMPAtyyjyuDFISbiqgWrA8u0MoH4AD155T+Q0
         oHpo5ilILtn+2t+Nw44k5UW13tmZ1WCX5MV9nkjvBE6uCE0yMJH543vdHxaPQceAhrBn
         rEHe0NRpXugJAwHttO0JyJ0eRxpmpyDxT8U4aY2J69RnCohHzzz7RkbiVC2Dv8FAKT1M
         8+Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=CW7SWlQziB+XLEfwDIarCUWn2egUFfp8nzobe9Kqg9c=;
        b=LXO3ZH7ZBpY8ZE3cG7UDf09QeQXBvZigEDaTlGKu7YzsIGx0yI86a3Mx3MunMDMeP3
         M25PK3XnfYBi1eRswLAZ305j+YfLPSPBMDxg/t+o1Ku4olDfrp100O+/PmD9zKdUUdn3
         yheh8R1QQ9kggWTlftu45PzGitVqjKuBK3afQlVgNNlC20rBRBQW9pNvhW4bE0jU4xW8
         GjNf2TU20dgpvNuO9FDk6sbm0MHkBs1oTs6BjHFcASH2i0sDGGt+mtJJE0kQq+YhtO20
         E1piaaZh/8j52AwoRwl1AdNBJPQQkymJg3xw+zFQ60wNgBarEUy+ZyFVIiUsmAeBBUTN
         97+Q==
X-Gm-Message-State: AOAM531yiPMj2CmJJnnalFEftzzewrSoucKUJSZ3Zs2rYwhA6byxjQQF
        iG3riQ94W6HJssB2dx3CLWY3+w==
X-Google-Smtp-Source: ABdhPJzXOYfeEE1jBZn1K2gwr7k//NMMDGlmorqjNcf0DmIixHtICN0767+4NHgOHegYHiL6t9fAEw==
X-Received: by 2002:a5d:4c90:: with SMTP id z16mr27189113wrs.170.1599554083077;
        Tue, 08 Sep 2020 01:34:43 -0700 (PDT)
Received: from dell ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id n4sm32853292wrp.61.2020.09.08.01.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 01:34:42 -0700 (PDT)
Date:   Tue, 8 Sep 2020 09:34:39 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
Subject: Re: [24/30] mwifiex: wmm: Mark 'mwifiex_1d_to_wmm_queue' as
 __maybe_unused
Message-ID: <20200908083439.GG4400@dell>
References: <20200826093401.1458456-25-lee.jones@linaro.org>
 <20200901131601.C3840C433C6@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200901131601.C3840C433C6@smtp.codeaurora.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 01 Sep 2020, Kalle Valo wrote:

> Lee Jones <lee.jones@linaro.org> wrote:
> 
> > 'mwifiex_1d_to_wmm_queue' is used in'; main.c, txrx.c and uap_txrx.c
> > 
> > ... but not used in 14 other source files which include 'wmm.h'.
> > 
> > Fixes the following W=1 kernel build warning(s):
> > 
> >  In file included from drivers/net/wireless/marvell/mwifiex/init.c:25:
> >  drivers/net/wireless/marvell/mwifiex/wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
> >  34 | static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
> >  | ^~~~~~~~~~~~~~~~~~~~~~~
> >  In file included from drivers/net/wireless/marvell/mwifiex/cmdevt.c:26:
> >  drivers/net/wireless/marvell/mwifiex/wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
> >  34 | static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
> >  | ^~~~~~~~~~~~~~~~~~~~~~~
> >  In file included from drivers/net/wireless/marvell/mwifiex/util.c:25:
> >  drivers/net/wireless/marvell/mwifiex/wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
> >  34 | static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
> >  | ^~~~~~~~~~~~~~~~~~~~~~~
> >  In file included from drivers/net/wireless/marvell/mwifiex/wmm.c:25:
> >  drivers/net/wireless/marvell/mwifiex/wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
> >  34 | static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
> >  | ^~~~~~~~~~~~~~~~~~~~~~~
> >  In file included from drivers/net/wireless/marvell/mwifiex/11n.c:25:
> >  drivers/net/wireless/marvell/mwifiex/wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
> >  34 | static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
> >  | ^~~~~~~~~~~~~~~~~~~~~~~
> >  In file included from drivers/net/wireless/marvell/mwifiex/11n_aggr.c:25:
> >  drivers/net/wireless/marvell/mwifiex/wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
> >  34 | static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
> >  | ^~~~~~~~~~~~~~~~~~~~~~~
> >  In file included from drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c:25:
> >  drivers/net/wireless/marvell/mwifiex/wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
> >  34 | static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
> >  | ^~~~~~~~~~~~~~~~~~~~~~~
> >  In file included from drivers/net/wireless/marvell/mwifiex/11n.h:25,
> >  from drivers/net/wireless/marvell/mwifiex/scan.c:25:
> >  drivers/net/wireless/marvell/mwifiex/wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
> >  34 | static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
> >  | ^~~~~~~~~~~~~~~~~~~~~~~
> > 
> >  NB: Many entries - snipped for brevity.
> > 
> > Cc: Amitkumar Karwar <amitkarwar@gmail.com>
> > Cc: Ganapathi Bhat <ganapathi.bhat@nxp.com>
> > Cc: Xinming Hu <huxinming820@gmail.com>
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: linux-wireless@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Failed to apply:
> 
> fatal: sha1 information is lacking or useless (drivers/net/wireless/marvell/mwifiex/wmm.h).
> error: could not build fake ancestor
> Applying: mwifiex: wmm: Mark 'mwifiex_1d_to_wmm_queue' as __maybe_unused
> Patch failed at 0001 mwifiex: wmm: Mark 'mwifiex_1d_to_wmm_queue' as __maybe_unused
> The copy of the patch that failed is found in: .git/rebase-apply/patch
> 
> Patch set to Changes Requested.

I'll rebase everything I have onto -next and see about re-submitting.

Thanks.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
