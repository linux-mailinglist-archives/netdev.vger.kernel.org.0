Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE816261452
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 18:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731250AbgIHQOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 12:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731601AbgIHQNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:13:44 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A4CC0617BC
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 05:17:19 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id k18so1805896wmj.5
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 05:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Xc7i9lFK8Z9R/MbK0MEH717j2fSmQT53OR6EzTp19b0=;
        b=lYC28hVZNplpFlJguFTo17ufEt4v1awGCLlyg53LDahG1qLKkk2iSqo4q5/BXpF1tP
         mYYZh6zrtoYhycnLgwHULltqyyIyWY6Yo5mxnHZMOBx3b3nPR3Oc/IhnvmR0JqAkoVew
         JHhfPTj/embJyrxkmS1f5C9vrO1r0N2xl5Athz/e5qwnJuYUmjzaCZeYqCsMHUsljg96
         eRbZrszeSGw76h3YoKo9+GB/gnsos1P2uVf4FurbAeWGkBuGDP5Tw/Hzw9xq5vdUCMzb
         OY5dq7iH6YNBm0tXXp4cJ71ksPLYvIx1E8P+FIOn+xFjqmLEVPnO3GdXjtY0FUpJA5Jz
         x4OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Xc7i9lFK8Z9R/MbK0MEH717j2fSmQT53OR6EzTp19b0=;
        b=ZbNXaec56LnlGtokyRTRyaBUNYlC9LJ6N/+EkpHANVvdJfHQE+9B0BrNBVOQo6wCD3
         xmsf/0wbhXRGuxFocmVTkZKengjEW4IfdTS+z7dOfn7JnubumIs3SGqgbmGs4C8tPcPs
         XIKQ5xDP5ZuIEHzPu+pi7sbZlJnA2sO5WlfPZqROxFln0Z798f9AHRYgDDE9dHCxpYXg
         ABpJmu4OyaGc3P+FurhqyhqV6dwj8bc9JOYXFYWenAfO96jg70R+JAIcXcqUYFSPgvh0
         rdCPN5RaJ10hGePjrjmdiNSr+c1ylHY1EbWeVh9vrk5Bifh3wIXnvLhwDjhGZXpbBIQ4
         Fz+Q==
X-Gm-Message-State: AOAM5334VscGJRg7E0iWfCqwjUWipwh3nkdG84nCKqlVs6Jz6PPrTAIv
        d6blXueK8M3Ln7WG0mvsR1/WYA==
X-Google-Smtp-Source: ABdhPJxyI6Xo3tu8zWV1QA/p9cNs1Pi+FbS/Si2RJHDJ9AAZhjuqTxhTHzOs3t4qITlTvFu8PwIiCA==
X-Received: by 2002:a05:600c:c5:: with SMTP id u5mr4044015wmm.14.1599567438139;
        Tue, 08 Sep 2020 05:17:18 -0700 (PDT)
Received: from dell ([91.110.221.179])
        by smtp.gmail.com with ESMTPSA id g186sm13774918wmg.25.2020.09.08.05.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 05:17:17 -0700 (PDT)
Date:   Tue, 8 Sep 2020 13:17:15 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
Subject: Re: [PATCH 16/28] wireless: marvell: mwifiex: init: Move
 'tos_to_tid_inv' to where it's used
Message-ID: <20200908121715.GS4400@dell>
References: <20200819072402.3085022-17-lee.jones@linaro.org>
 <20200831155151.0DCB5C4339C@smtp.codeaurora.org>
 <20200908084953.GJ4400@dell>
 <010101746d98d278-67bb0cbd-fe22-4344-8c2a-9c65e04ff501-000000@us-west-2.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <010101746d98d278-67bb0cbd-fe22-4344-8c2a-9c65e04ff501-000000@us-west-2.amazonses.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 08 Sep 2020, Kalle Valo wrote:

> Lee Jones <lee.jones@linaro.org> writes:
> 
> > On Mon, 31 Aug 2020, Kalle Valo wrote:
> >
> >> Lee Jones <lee.jones@linaro.org> wrote:
> >> 
> >> > 'tos_to_tid_inv' is only used in 2 of 17 files it's current being
> >> > included into.
> >> > 
> >> > Fixes the following W=1 kernel build warning(s):
> >> > 
> >> >  In file included from drivers/net/wireless/marvell/mwifiex/main.c:23:
> >> >  In file included from drivers/net/wireless/marvell/mwifiex/cmdevt.c:26:
> >> >  In file included from drivers/net/wireless/marvell/mwifiex/util.c:25:
> >> >  In file included from drivers/net/wireless/marvell/mwifiex/txrx.c:25:
> >> >  In file included from drivers/net/wireless/marvell/mwifiex/11n.c:25:
> >> >  In file included from drivers/net/wireless/marvell/mwifiex/wmm.c:25:
> >> >  In file included from drivers/net/wireless/marvell/mwifiex/11n_aggr.c:25:
> >> >  In file included from drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c:25:
> >> >  In file included from drivers/net/wireless/marvell/mwifiex/join.c:25:
> >> >  In file included from drivers/net/wireless/marvell/mwifiex/sta_cmd.c:25:
> >> >  In file included from drivers/net/wireless/marvell/mwifiex/sta_ioctl.c:25:
> >> >  In file included from drivers/net/wireless/marvell/mwifiex/sta_event.c:25:
> >> >  In file included from drivers/net/wireless/marvell/mwifiex/uap_txrx.c:23:
> >> >  In file included from drivers/net/wireless/marvell/mwifiex/sdio.c:27:
> >> >  In file included from drivers/net/wireless/marvell/mwifiex/sta_tx.c:25:
> >> >  drivers/net/wireless/marvell/mwifiex/wmm.h:41:17: warning:
> >> > ‘tos_to_tid_inv’ defined but not used [-Wunused-const-variable=]
> >> >  41 | static const u8 tos_to_tid_inv[] = {
> >> > 
> >> >  NB: Snipped for brevity
> >> > 
> >> > Cc: Amitkumar Karwar <amitkarwar@gmail.com>
> >> > Cc: Ganapathi Bhat <ganapathi.bhat@nxp.com>
> >> > Cc: Xinming Hu <huxinming820@gmail.com>
> >> > Cc: Kalle Valo <kvalo@codeaurora.org>
> >> > Cc: "David S. Miller" <davem@davemloft.net>
> >> > Cc: Jakub Kicinski <kuba@kernel.org>
> >> > Cc: linux-wireless@vger.kernel.org
> >> > Cc: netdev@vger.kernel.org
> >> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >> 
> >> The patch creates two duplicate arrays, this makes it worse than it was
> >> before.
> >
> > We have a choice (and you don't like either of them). :)
> >
> > Either add the variable into the file(s) they are used or tell the
> > compiler that it's okay for other files to declare but not used them
> > (mark as __maybe_unused).
> >
> > What is your preferred solution?
> 
> Yue already sent a patch for this (at least I think so, not 100% sure if
> this is the same case):
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=d56ee19a148edaa9972ca12f817e395ba436078b
> 
> But that's the solution I like :) There's only one array and it's shared
> by all the users.

Any idea if this results in anything different from making use of
__maybe_unused once compiled?

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
