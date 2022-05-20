Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E37F52F106
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344626AbiETQq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351893AbiETQqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:46:39 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA612F02E
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:46:38 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id b5so782218plx.10
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kJ+UShlBvuewG0eI4K9vA+11tXumL5qkN39P3NCFnwA=;
        b=dQ6DUOylIAZfzjz9gVbUdwr/W+D6oKkdrN/mXqvMBZC87ty9/hKNCOOj3bh7QvhbgX
         diGZ7PFGOBvUoxfB5a9WmZQG0isTXGFCVCgxIsAcsqbgA19wwTk+UtlZALSCBCBdTdiU
         NRiNME1lhO2c+k/r503yZYf+o+polBdrfRFWI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kJ+UShlBvuewG0eI4K9vA+11tXumL5qkN39P3NCFnwA=;
        b=Ku5GAvQLb95wFXtawWreBoa4mlK2td3qTpKQaH+2RUA3ERbhcPEfGGLZmcmFWF/J+y
         OQUj7NcvqFoCel1D8dSPnjzn9tGcSzNioyQ4h9PgUsfT/4oNtnylCcLe+R2Z/35RS6eC
         XCXmup3VGiz6N1278niSSmATUpi6mp+W++cjhLrv694yJ5bFM99EQSw9tIequ+uXvM6C
         Z9MJtJSE2HsU++SjWvD7ktzetcuRC791wroWWK1E3BDxiHCaJInRgUGkh9oGC/+g/t9N
         02q6GMaqYJZnc0DqjV9x4qjFZC/IQFLkhvFaq0sJ3CH7adh7jAwuAkMl2ey8HKgV5gLe
         KKxA==
X-Gm-Message-State: AOAM531PZ0WR8BoPo0KkGJ56eAu7rvviIs2+HGkVr0ZOTQRjy+ziLNwK
        3KB86Q/Ytb7QT1H1qHJitcEUvnM4takB+Q==
X-Google-Smtp-Source: ABdhPJwBfT2lFs+gFRXdcNanOlE7mOBfL+202Ba/vdgIyTzpVky8H7DgKyUmd3askWyHWxvBpB78Fg==
X-Received: by 2002:a17:902:d550:b0:161:fdb8:3d9d with SMTP id z16-20020a170902d55000b00161fdb83d9dmr1400322plf.42.1653065197620;
        Fri, 20 May 2022 09:46:37 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id kx14-20020a17090b228e00b001dedb8bbe66sm2049763pjb.33.2022.05.20.09.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 09:46:36 -0700 (PDT)
Date:   Fri, 20 May 2022 09:46:36 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: Re: GCC 12 warnings
Message-ID: <202205200938.1EE1FD1@keescook>
References: <20220519193618.6539f9d9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519193618.6539f9d9@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 07:36:18PM -0700, Jakub Kicinski wrote:
> I'm sure you're involved in a number of glorious GCC 12 conversations..

Yeah, and I think I've even found a gcc bug. :|

> We have a handful of drivers in networking which get hit by
> -Warray-bounds because they allocate partial structures (I presume 
> to save memory, misguided but more than 15min of work to refactor).

Yeah, this idiom is pretty common I've noticed -- I fixed a few of these
in the initial work for -Warray-bounds on GCC 11 and earlier, but wow
did GCC 12 do something extra internally.

> Since -Warray-bounds is included by default now this is making our
> lives a little hard [1]. Is there a wider effort to address this?
> If not do you have a recommendation on how to deal with it?

Looks like the issue was this?
https://lore.kernel.org/all/20220520145957.1ec50e44@canb.auug.org.au/

Ah, from cf2df74e202d ("net: fix dev_fill_forward_path with pppoe + bridge")

You mean you missed this particular warning because of the other GCC
12 warnings?

> My best idea is to try to isolate the bad files and punt -Warray-bounds
> to W=1 for those, so we can prevent more of them getting in but not
> break WERROR builds on GCC 12. That said, I'm not sure how to achieve
> that.. This for example did not work:
> 
> --- a/drivers/net/ethernet/mediatek/Makefile
> +++ b/drivers/net/ethernet/mediatek/Makefile
> @@ -9,5 +9,9 @@ mtk_eth-$(CONFIG_NET_MEDIATEK_SOC_WED) += mtk_wed.o
>  ifdef CONFIG_DEBUG_FS
>  mtk_eth-$(CONFIG_NET_MEDIATEK_SOC_WED) += mtk_wed_debugfs.o
>  endif
>  obj-$(CONFIG_NET_MEDIATEK_SOC_WED) += mtk_wed_ops.o
>  obj-$(CONFIG_NET_MEDIATEK_STAR_EMAC) += mtk_star_emac.o
> +
> +ifneq ($(findstring 1, $(KBUILD_EXTRA_WARN)),)
> +CFLAGS_mtk_ppe.o += -Wno-array-bounds
> +endif

This worked for me:

diff --git a/drivers/net/can/usb/kvaser_usb/Makefile b/drivers/net/can/usb/kvaser_usb/Makefile
index cf260044f0b9..43eb921f9102 100644
--- a/drivers/net/can/usb/kvaser_usb/Makefile
+++ b/drivers/net/can/usb/kvaser_usb/Makefile
@@ -1,3 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_CAN_KVASER_USB) += kvaser_usb.o
 kvaser_usb-y = kvaser_usb_core.o kvaser_usb_leaf.o kvaser_usb_hydra.o
+
+ifeq ($(KBUILD_EXTRA_WARN),)
+CFLAGS_kvaser_usb_hydra.o += -Wno-array-bounds
+endif

-- 
Kees Cook
