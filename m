Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFE762FB65
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 18:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241930AbiKRRQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 12:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242363AbiKRRQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 12:16:00 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3ABC70A1E
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 09:15:56 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id jn7so3258260plb.13
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 09:15:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e0dcZ9j1KNb8WBvFR9rtRV/vMdYaXhRyA3Yua2cPdC8=;
        b=mA7OgJSJHze1AQD0JuMgDf8YzERR8ER1Jfqc2eBy2JG76DRGSCRWasgI/TSqU5N7L2
         13PSDURTweLClZl98/qNMZCrWa1c1LpMlfIzR9QQj+U3g3zTadG3j/lfHxwcSJuoFmgy
         S/S9SwNjmRsKnR4NLNppABCXE5fBG2ImvqxTU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e0dcZ9j1KNb8WBvFR9rtRV/vMdYaXhRyA3Yua2cPdC8=;
        b=LshzdSyMc1PZsIGubTGUk6L7h3DVyni1w3bf4pcr3Jqo0KRKCbAS1fbUYKCXLSwn08
         iZQOPBPVJcM8rQWNu/XtCqVJNU0bj4k9uJV08L/xCRJW0sqy32WKgIoDy6AgOpsJ/ZSd
         gHafeF76ipfTDy7K2p1N5C7+TB1dHFFXJWoZ8lILqXn9F1R28sIEvAX+AVC4fk6O6n72
         k1rqx+GcU7VRXjGeL79hTBUbuH45D31xFmnixjXuauRGWrDg57oklhvq/h/DzwzLG0er
         xso7FyECr672VsYmDjOZdzYfXdtngKKOgY+CSJZK5BL3Cn3VJnCD+GwVvW8hFa2NGhXd
         H7ag==
X-Gm-Message-State: ANoB5pl9LL+ornLtbc5380/yZSBCpYDT6SBqcW7iMePz/YLPr7UCzOUq
        tjbMbVI69egrh8Ct97LDrXsjxw==
X-Google-Smtp-Source: AA0mqf444BCmM02vRgNsNJ9jeekglWnrlS3civ1y17C9r9VP2nk9tsUzwD6SfYIHtI+REmszIyeRKQ==
X-Received: by 2002:a17:903:40cb:b0:178:b4b7:d74d with SMTP id t11-20020a17090340cb00b00178b4b7d74dmr443795pld.83.1668791755288;
        Fri, 18 Nov 2022 09:15:55 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i10-20020a170902c94a00b0016d72804664sm3953109pla.205.2022.11.18.09.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 09:15:54 -0800 (PST)
Date:   Fri, 18 Nov 2022 09:15:53 -0800
From:   Kees Cook <keescook@chromium.org>
To:     kernel test robot <lkp@intel.com>, Li Yang <leoyang.li@nxp.com>
Cc:     oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: drivers/net/ethernet/freescale/ucc_geth.c:1838:50: sparse:
 sparse: incorrect type in argument 1 (different address spaces)
Message-ID: <202211180913.C8F97040C8@keescook>
References: <202211141853.MBd0aSID-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202211141853.MBd0aSID-lkp@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 06:55:25PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   094226ad94f471a9f19e8f8e7140a09c2625abaa
> commit: 72d67229f522e3331d1eabd9f58d36ae080eb228 slab: clean up function prototypes
> date:   1 year ago

This warning isn't from the above commit. There seems to be a standing
issue with this freescale driver and not correctly using the iomem
memcpy helpers. For example of how this can be fixed, see:

7dc69c7d073e ("firmware: meson_sm: Fix memcpy vs iomem type warnings")

-Kees

> config: powerpc-randconfig-s032-20221114
> compiler: powerpc-linux-gcc (GCC) 12.1.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # apt-get install sparse
>         # sparse version: v0.6.4-39-gce1a6720-dirty
>         # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=72d67229f522e3331d1eabd9f58d36ae080eb228
>         git remote add linus https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>         git fetch --no-tags linus master
>         git checkout 72d67229f522e3331d1eabd9f58d36ae080eb228
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=powerpc SHELL=/bin/bash drivers/net/ethernet/freescale/
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> 
> sparse warnings: (new ones prefixed by >>)
>    drivers/net/ethernet/freescale/ucc_geth.c:243:21: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:243:21: sparse:     expected unsigned int volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:243:21: sparse:     got restricted __be32 [noderef] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:404:22: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned short volatile [noderef] [usertype] __iomem *addr @@     got restricted __be16 [noderef] [usertype] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:404:22: sparse:     expected unsigned short volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:404:22: sparse:     got restricted __be16 [noderef] [usertype] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:405:22: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned short volatile [noderef] [usertype] __iomem *addr @@     got restricted __be16 [noderef] [usertype] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:405:22: sparse:     expected unsigned short volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:405:22: sparse:     got restricted __be16 [noderef] [usertype] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:406:22: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned short volatile [noderef] [usertype] __iomem *addr @@     got restricted __be16 [noderef] [usertype] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:406:22: sparse:     expected unsigned short volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:406:22: sparse:     got restricted __be16 [noderef] [usertype] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:448:23: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected restricted __be16 [noderef] [usertype] __iomem *reg @@     got unsigned short [noderef] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:448:23: sparse:     expected restricted __be16 [noderef] [usertype] __iomem *reg
>    drivers/net/ethernet/freescale/ucc_geth.c:448:23: sparse:     got unsigned short [noderef] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:1316:26: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int const volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:1316:26: sparse:     expected unsigned int const volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:1316:26: sparse:     got restricted __be32 [noderef] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:1343:19: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:1343:19: sparse:     expected unsigned int volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:1343:19: sparse:     got restricted __be32 [noderef] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:1389:9: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] [usertype] __iomem *p_uccm @@
>    drivers/net/ethernet/freescale/ucc_geth.c:1389:9: sparse:     expected unsigned int volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:1389:9: sparse:     got restricted __be32 [noderef] [usertype] __iomem *p_uccm
>    drivers/net/ethernet/freescale/ucc_geth.c:1389:9: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int const volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] [usertype] __iomem *p_uccm @@
>    drivers/net/ethernet/freescale/ucc_geth.c:1389:9: sparse:     expected unsigned int const volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:1389:9: sparse:     got restricted __be32 [noderef] [usertype] __iomem *p_uccm
>    drivers/net/ethernet/freescale/ucc_geth.c:1390:22: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] [usertype] __iomem *p_ucce @@
>    drivers/net/ethernet/freescale/ucc_geth.c:1390:22: sparse:     expected unsigned int volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:1390:22: sparse:     got restricted __be32 [noderef] [usertype] __iomem *p_ucce
>    drivers/net/ethernet/freescale/ucc_geth.c:1401:36: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int const volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] [usertype] __iomem *p_ucce @@
>    drivers/net/ethernet/freescale/ucc_geth.c:1401:36: sparse:     expected unsigned int const volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:1401:36: sparse:     got restricted __be32 [noderef] [usertype] __iomem *p_ucce
>    drivers/net/ethernet/freescale/ucc_geth.c:1570:38: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int const volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:1570:38: sparse:     expected unsigned int const volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:1570:38: sparse:     got restricted __be32 [noderef] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:1635:35: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:1635:35: sparse:     expected unsigned int volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:1635:35: sparse:     got restricted __be32 [noderef] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:1823:41: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int const volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:1823:41: sparse:     expected unsigned int const volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:1823:41: sparse:     got restricted __be32 [noderef] __iomem *
> >> drivers/net/ethernet/freescale/ucc_geth.c:1838:50: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const *objp @@     got unsigned char [noderef] [usertype] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:1838:50: sparse:     expected void const *objp
>    drivers/net/ethernet/freescale/ucc_geth.c:1838:50: sparse:     got unsigned char [noderef] [usertype] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:1863:33: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int const volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:1863:33: sparse:     expected unsigned int const volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:1863:33: sparse:     got restricted __be32 [noderef] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:1875:42: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const *objp @@     got unsigned char [noderef] [usertype] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:1875:42: sparse:     expected void const *objp
>    drivers/net/ethernet/freescale/ucc_geth.c:1875:42: sparse:     got unsigned char [noderef] [usertype] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:1964:17: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:1964:17: sparse:     expected unsigned int volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:1964:17: sparse:     got restricted __be32 [noderef] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:1964:17: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int const volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:1964:17: sparse:     expected unsigned int const volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:1964:17: sparse:     got restricted __be32 [noderef] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:1966:17: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:1966:17: sparse:     expected unsigned int volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:1966:17: sparse:     got restricted __be32 [noderef] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:1966:17: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int const volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:1966:17: sparse:     expected unsigned int const volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:1966:17: sparse:     got restricted __be32 [noderef] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:2012:29: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] [usertype] __iomem *p_uccm @@
>    drivers/net/ethernet/freescale/ucc_geth.c:2012:29: sparse:     expected unsigned int volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:2012:29: sparse:     got restricted __be32 [noderef] [usertype] __iomem *p_uccm
>    drivers/net/ethernet/freescale/ucc_geth.c:2015:29: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] [usertype] __iomem *p_ucce @@
>    drivers/net/ethernet/freescale/ucc_geth.c:2015:29: sparse:     expected unsigned int volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:2015:29: sparse:     got restricted __be32 [noderef] [usertype] __iomem *p_ucce
>    drivers/net/ethernet/freescale/ucc_geth.c:2159:40: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected unsigned char [noderef] [usertype] __iomem * @@     got void * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:2159:40: sparse:     expected unsigned char [noderef] [usertype] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:2159:40: sparse:     got void *
>    drivers/net/ethernet/freescale/ucc_geth.c:2167:47: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void * @@     got unsigned char [noderef] [usertype] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:2167:47: sparse:     expected void *
>    drivers/net/ethernet/freescale/ucc_geth.c:2167:47: sparse:     got unsigned char [noderef] [usertype] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:2187:37: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:2187:37: sparse:     expected unsigned int volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:2187:37: sparse:     got restricted __be32 [noderef] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:2220:40: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected unsigned char [noderef] [usertype] __iomem * @@     got void * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:2220:40: sparse:     expected unsigned char [noderef] [usertype] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:2220:40: sparse:     got void *
>    drivers/net/ethernet/freescale/ucc_geth.c:2247:37: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:2247:37: sparse:     expected unsigned int volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:2247:37: sparse:     got restricted __be32 [noderef] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:2309:32: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [noderef] [usertype] __iomem *upsmr_register @@     got restricted __be32 [noderef] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:2309:32: sparse:     expected unsigned int [noderef] [usertype] __iomem *upsmr_register
>    drivers/net/ethernet/freescale/ucc_geth.c:2309:32: sparse:     got restricted __be32 [noderef] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:2315:57: sparse: sparse: incorrect type in argument 4 (different base types) @@     expected unsigned int [noderef] [usertype] __iomem *upsmr_register @@     got restricted __be32 [noderef] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:2315:57: sparse:     expected unsigned int [noderef] [usertype] __iomem *upsmr_register
>    drivers/net/ethernet/freescale/ucc_geth.c:2315:57: sparse:     got restricted __be32 [noderef] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:2327:35: sparse: sparse: incorrect type in argument 6 (different base types) @@     expected unsigned int [noderef] [usertype] __iomem *upsmr_register @@     got restricted __be32 [noderef] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:2327:35: sparse:     expected unsigned int [noderef] [usertype] __iomem *upsmr_register
>    drivers/net/ethernet/freescale/ucc_geth.c:2327:35: sparse:     got restricted __be32 [noderef] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:2375:37: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected unsigned int [noderef] [usertype] __iomem *upsmr_register @@     got restricted __be32 [noderef] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:2375:37: sparse:     expected unsigned int [noderef] [usertype] __iomem *upsmr_register
>    drivers/net/ethernet/freescale/ucc_geth.c:2375:37: sparse:     got restricted __be32 [noderef] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:2453:64: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void volatile *address @@     got unsigned char [noderef] [usertype] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:2453:64: sparse:     expected void volatile *address
>    drivers/net/ethernet/freescale/ucc_geth.c:2453:64: sparse:     got unsigned char [noderef] [usertype] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:2456:45: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void volatile *address @@     got unsigned char [noderef] [usertype] __iomem *[assigned] endOfRing @@
>    drivers/net/ethernet/freescale/ucc_geth.c:2456:45: sparse:     expected void volatile *address
>    drivers/net/ethernet/freescale/ucc_geth.c:2456:45: sparse:     got unsigned char [noderef] [usertype] __iomem *[assigned] endOfRing
>    drivers/net/ethernet/freescale/ucc_geth.c:2676:64: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void volatile *address @@     got unsigned char [noderef] [usertype] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:2676:64: sparse:     expected void volatile *address
>    drivers/net/ethernet/freescale/ucc_geth.c:2676:64: sparse:     got unsigned char [noderef] [usertype] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:2943:21: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:2943:21: sparse:     expected unsigned int volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:2943:21: sparse:     got restricted __be32 [noderef] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:3009:46: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int const volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] __iomem * @@
>    drivers/net/ethernet/freescale/ucc_geth.c:3009:46: sparse:     expected unsigned int const volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:3009:46: sparse:     got restricted __be32 [noderef] __iomem *
>    drivers/net/ethernet/freescale/ucc_geth.c:3137:17: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] [usertype] __iomem *p_uccm @@
>    drivers/net/ethernet/freescale/ucc_geth.c:3137:17: sparse:     expected unsigned int volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:3137:17: sparse:     got restricted __be32 [noderef] [usertype] __iomem *p_uccm
>    drivers/net/ethernet/freescale/ucc_geth.c:3137:17: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int const volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] [usertype] __iomem *p_uccm @@
>    drivers/net/ethernet/freescale/ucc_geth.c:3137:17: sparse:     expected unsigned int const volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:3137:17: sparse:     got restricted __be32 [noderef] [usertype] __iomem *p_uccm
>    drivers/net/ethernet/freescale/ucc_geth.c:3158:34: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int const volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] [usertype] __iomem *p_ucce @@
>    drivers/net/ethernet/freescale/ucc_geth.c:3158:34: sparse:     expected unsigned int const volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:3158:34: sparse:     got restricted __be32 [noderef] [usertype] __iomem *p_ucce
>    drivers/net/ethernet/freescale/ucc_geth.c:3159:34: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int const volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] [usertype] __iomem *p_uccm @@
>    drivers/net/ethernet/freescale/ucc_geth.c:3159:34: sparse:     expected unsigned int const volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:3159:34: sparse:     got restricted __be32 [noderef] [usertype] __iomem *p_uccm
>    drivers/net/ethernet/freescale/ucc_geth.c:3161:22: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] [usertype] __iomem *p_ucce @@
>    drivers/net/ethernet/freescale/ucc_geth.c:3161:22: sparse:     expected unsigned int volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:3161:22: sparse:     got restricted __be32 [noderef] [usertype] __iomem *p_ucce
>    drivers/net/ethernet/freescale/ucc_geth.c:3167:38: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] [usertype] __iomem *p_uccm @@
>    drivers/net/ethernet/freescale/ucc_geth.c:3167:38: sparse:     expected unsigned int volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:3167:38: sparse:     got restricted __be32 [noderef] [usertype] __iomem *p_uccm
>    drivers/net/ethernet/freescale/ucc_geth.c:3413:17: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] [usertype] __iomem *p_uccm @@
>    drivers/net/ethernet/freescale/ucc_geth.c:3413:17: sparse:     expected unsigned int volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:3413:17: sparse:     got restricted __be32 [noderef] [usertype] __iomem *p_uccm
>    drivers/net/ethernet/freescale/ucc_geth.c:3413:17: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int const volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] [usertype] __iomem *p_uccm @@
>    drivers/net/ethernet/freescale/ucc_geth.c:3413:17: sparse:     expected unsigned int const volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:3413:17: sparse:     got restricted __be32 [noderef] [usertype] __iomem *p_uccm
>    drivers/net/ethernet/freescale/ucc_geth.c:3436:25: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] [usertype] __iomem *p_uccm @@
>    drivers/net/ethernet/freescale/ucc_geth.c:3436:25: sparse:     expected unsigned int volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:3436:25: sparse:     got restricted __be32 [noderef] [usertype] __iomem *p_uccm
>    drivers/net/ethernet/freescale/ucc_geth.c:3436:25: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int const volatile [noderef] [usertype] __iomem *addr @@     got restricted __be32 [noderef] [usertype] __iomem *p_uccm @@
>    drivers/net/ethernet/freescale/ucc_geth.c:3436:25: sparse:     expected unsigned int const volatile [noderef] [usertype] __iomem *addr
>    drivers/net/ethernet/freescale/ucc_geth.c:3436:25: sparse:     got restricted __be32 [noderef] [usertype] __iomem *p_uccm
> 
> vim +1838 drivers/net/ethernet/freescale/ucc_geth.c
> 
> ce973b141dfac4 drivers/net/ucc_geth.c                    Li Yang          2006-08-14  1805  
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1806  static void ucc_geth_free_rx(struct ucc_geth_private *ugeth)
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1807  {
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1808  	struct ucc_geth_info *ug_info;
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1809  	struct ucc_fast_info *uf_info;
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1810  	u16 i, j;
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1811  	u8 __iomem *bd;
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1812  
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1813  
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1814  	ug_info = ugeth->ug_info;
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1815  	uf_info = &ug_info->uf_info;
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1816  
> 53f49d86ea2108 drivers/net/ethernet/freescale/ucc_geth.c Rasmus Villemoes 2021-01-19  1817  	for (i = 0; i < ucc_geth_rx_queues(ugeth->ug_info); i++) {
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1818  		if (ugeth->p_rx_bd_ring[i]) {
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1819  			/* Return existing data buffers in ring */
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1820  			bd = ugeth->p_rx_bd_ring[i];
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1821  			for (j = 0; j < ugeth->ug_info->bdRingLenRx[i]; j++) {
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1822  				if (ugeth->rx_skbuff[i][j]) {
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1823  					dma_unmap_single(ugeth->dev,
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1824  						in_be32(&((struct qe_bd __iomem *)bd)->buf),
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1825  						ugeth->ug_info->
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1826  						uf_info.max_rx_buf_length +
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1827  						UCC_GETH_RX_DATA_BUF_ALIGNMENT,
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1828  						DMA_FROM_DEVICE);
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1829  					dev_kfree_skb_any(
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1830  						ugeth->rx_skbuff[i][j]);
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1831  					ugeth->rx_skbuff[i][j] = NULL;
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1832  				}
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1833  				bd += sizeof(struct qe_bd);
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1834  			}
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1835  
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1836  			kfree(ugeth->rx_skbuff[i]);
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1837  
> 9b0dfef4755301 drivers/net/ethernet/freescale/ucc_geth.c Rasmus Villemoes 2021-01-19 @1838  			kfree(ugeth->p_rx_bd_ring[i]);
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1839  			ugeth->p_rx_bd_ring[i] = NULL;
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1840  		}
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1841  	}
> e19a82c18f0e63 drivers/net/ethernet/freescale/ucc_geth.c Paul Gortmaker   2012-02-27  1842  
> 
> :::::: The code at line 1838 was first introduced by commit
> :::::: 9b0dfef4755301d9f7fcef63e2f64d23649bebb4 ethernet: ucc_geth: simplify rx/tx allocations
> 
> :::::: TO: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> :::::: CC: Jakub Kicinski <kuba@kernel.org>
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://01.org/lkp

> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/powerpc 5.15.0 Kernel Configuration
> #
> CONFIG_CC_VERSION_TEXT="powerpc-linux-gcc (GCC) 12.1.0"
> CONFIG_CC_IS_GCC=y
> CONFIG_GCC_VERSION=120100
> CONFIG_CLANG_VERSION=0
> CONFIG_AS_IS_GNU=y
> CONFIG_AS_VERSION=23800
> CONFIG_LD_IS_BFD=y
> CONFIG_LD_VERSION=23800
> CONFIG_LLD_VERSION=0
> CONFIG_CC_HAS_ASM_GOTO=y
> CONFIG_CC_HAS_ASM_GOTO_OUTPUT=y
> CONFIG_CC_HAS_ASM_INLINE=y
> CONFIG_CC_HAS_NO_PROFILE_FN_ATTR=y
> CONFIG_IRQ_WORK=y
> CONFIG_BUILDTIME_TABLE_SORT=y
> CONFIG_THREAD_INFO_IN_TASK=y
> 
> #
> # General setup
> #
> CONFIG_BROKEN_ON_SMP=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_COMPILE_TEST=y
> # CONFIG_WERROR is not set
> CONFIG_LOCALVERSION=""
> CONFIG_BUILD_SALT=""
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_KERNEL_GZIP=y
> CONFIG_DEFAULT_INIT=""
> CONFIG_DEFAULT_HOSTNAME="(none)"
> # CONFIG_SWAP is not set
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_POSIX_MQUEUE=y
> CONFIG_POSIX_MQUEUE_SYSCTL=y
> CONFIG_WATCH_QUEUE=y
> # CONFIG_CROSS_MEMORY_ATTACH is not set
> CONFIG_USELIB=y
> CONFIG_AUDIT=y
> CONFIG_HAVE_ARCH_AUDITSYSCALL=y
> CONFIG_AUDITSYSCALL=y
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_GENERIC_IRQ_SHOW_LEVEL=y
> CONFIG_GENERIC_IRQ_CHIP=y
> CONFIG_IRQ_DOMAIN=y
> CONFIG_IRQ_SIM=y
> CONFIG_IRQ_DOMAIN_HIERARCHY=y
> CONFIG_IRQ_FORCED_THREADING=y
> CONFIG_SPARSE_IRQ=y
> # CONFIG_GENERIC_IRQ_DEBUGFS is not set
> # end of IRQ subsystem
> 
> CONFIG_GENERIC_TIME_VSYSCALL=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> CONFIG_TIME_KUNIT_TEST=y
> 
> #
> # Timers subsystem
> #
> CONFIG_HZ_PERIODIC=y
> # CONFIG_NO_HZ_IDLE is not set
> # CONFIG_NO_HZ is not set
> # CONFIG_HIGH_RES_TIMERS is not set
> # end of Timers subsystem
> 
> CONFIG_BPF=y
> CONFIG_HAVE_EBPF_JIT=y
> 
> #
> # BPF subsystem
> #
> CONFIG_BPF_SYSCALL=y
> # CONFIG_BPF_UNPRIV_DEFAULT_OFF is not set
> # end of BPF subsystem
> 
> # CONFIG_PREEMPT_NONE is not set
> CONFIG_PREEMPT_VOLUNTARY=y
> # CONFIG_PREEMPT is not set
> CONFIG_PREEMPT_COUNT=y
> 
> #
> # CPU/Task time and stats accounting
> #
> CONFIG_TICK_CPU_ACCOUNTING=y
> # CONFIG_VIRT_CPU_ACCOUNTING_NATIVE is not set
> # CONFIG_IRQ_TIME_ACCOUNTING is not set
> CONFIG_PSI=y
> # CONFIG_PSI_DEFAULT_DISABLED is not set
> # end of CPU/Task time and stats accounting
> 
> CONFIG_CPU_ISOLATION=y
> 
> #
> # RCU Subsystem
> #
> CONFIG_TINY_RCU=y
> # CONFIG_RCU_EXPERT is not set
> CONFIG_SRCU=y
> CONFIG_TINY_SRCU=y
> CONFIG_TASKS_RCU_GENERIC=y
> CONFIG_TASKS_RCU=y
> CONFIG_TASKS_RUDE_RCU=y
> CONFIG_TASKS_TRACE_RCU=y
> # end of RCU Subsystem
> 
> CONFIG_IKCONFIG=y
> CONFIG_IKCONFIG_PROC=y
> CONFIG_IKHEADERS=y
> 
> #
> # Scheduler features
> #
> # end of Scheduler features
> 
> # CONFIG_CGROUPS is not set
> CONFIG_CHECKPOINT_RESTORE=y
> # CONFIG_SCHED_AUTOGROUP is not set
> # CONFIG_SYSFS_DEPRECATED is not set
> # CONFIG_RELAY is not set
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> # CONFIG_RD_GZIP is not set
> CONFIG_RD_BZIP2=y
> CONFIG_RD_LZMA=y
> CONFIG_RD_XZ=y
> CONFIG_RD_LZO=y
> # CONFIG_RD_LZ4 is not set
> CONFIG_RD_ZSTD=y
> CONFIG_BOOT_CONFIG=y
> # CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE is not set
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> CONFIG_HAVE_LD_DEAD_CODE_DATA_ELIMINATION=y
> # CONFIG_LD_DEAD_CODE_DATA_ELIMINATION is not set
> CONFIG_LD_ORPHAN_WARN=y
> CONFIG_SYSCTL=y
> CONFIG_SYSCTL_EXCEPTION_TRACE=y
> CONFIG_EXPERT=y
> # CONFIG_MULTIUSER is not set
> CONFIG_SGETMASK_SYSCALL=y
> CONFIG_SYSFS_SYSCALL=y
> CONFIG_FHANDLE=y
> CONFIG_POSIX_TIMERS=y
> # CONFIG_PRINTK is not set
> CONFIG_BUG=y
> # CONFIG_BASE_FULL is not set
> # CONFIG_FUTEX is not set
> # CONFIG_EPOLL is not set
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> # CONFIG_AIO is not set
> CONFIG_IO_URING=y
> CONFIG_ADVISE_SYSCALLS=y
> CONFIG_MEMBARRIER=y
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> CONFIG_KALLSYMS_BASE_RELATIVE=y
> # CONFIG_USERFAULTFD is not set
> CONFIG_ARCH_HAS_MEMBARRIER_CALLBACKS=y
> CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
> CONFIG_KCMP=y
> CONFIG_RSEQ=y
> # CONFIG_DEBUG_RSEQ is not set
> CONFIG_EMBEDDED=y
> CONFIG_HAVE_PERF_EVENTS=y
> CONFIG_PC104=y
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> # end of Kernel Performance Events And Counters
> 
> # CONFIG_VM_EVENT_COUNTERS is not set
> CONFIG_COMPAT_BRK=y
> CONFIG_SLAB=y
> # CONFIG_SLUB is not set
> # CONFIG_SLOB is not set
> CONFIG_SLAB_MERGE_DEFAULT=y
> # CONFIG_SLAB_FREELIST_RANDOM is not set
> CONFIG_SLAB_FREELIST_HARDENED=y
> CONFIG_SHUFFLE_PAGE_ALLOCATOR=y
> # CONFIG_PROFILING is not set
> CONFIG_TRACEPOINTS=y
> # end of General setup
> 
> CONFIG_PPC32=y
> # CONFIG_PPC64 is not set
> 
> #
> # Processor support
> #
> # CONFIG_PPC_BOOK3S_32 is not set
> # CONFIG_PPC_85xx is not set
> CONFIG_PPC_8xx=y
> # CONFIG_40x is not set
> # CONFIG_44x is not set
> CONFIG_860_CPU=y
> CONFIG_TARGET_CPU_BOOL=y
> CONFIG_TARGET_CPU="860"
> CONFIG_PPC_HAVE_KUEP=y
> CONFIG_PPC_KUEP=y
> CONFIG_PPC_HAVE_KUAP=y
> CONFIG_PPC_KUAP=y
> CONFIG_PPC_KUAP_DEBUG=y
> CONFIG_PPC_MMU_NOHASH=y
> CONFIG_PMU_SYSFS=y
> CONFIG_NR_CPUS=1
> CONFIG_NOT_COHERENT_CACHE=y
> # end of Processor support
> 
> CONFIG_VDSO32=y
> CONFIG_CPU_BIG_ENDIAN=y
> CONFIG_32BIT=y
> CONFIG_MMU=y
> CONFIG_ARCH_MMAP_RND_BITS_MAX=17
> CONFIG_ARCH_MMAP_RND_BITS_MIN=11
> CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=17
> CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=11
> CONFIG_NR_IRQS=512
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_PPC=y
> CONFIG_EARLY_PRINTK=y
> CONFIG_PANIC_TIMEOUT=180
> CONFIG_SCHED_OMIT_FRAME_POINTER=y
> CONFIG_AUDIT_ARCH=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUPPORTS_UPROBES=y
> CONFIG_PGTABLE_LEVELS=2
> 
> #
> # Platform support
> #
> CONFIG_SCOM_DEBUGFS=y
> CONFIG_CPM1=y
> # CONFIG_MPC8XXFADS is not set
> CONFIG_MPC86XADS=y
> # CONFIG_MPC885ADS is not set
> # CONFIG_PPC_EP88XC is not set
> # CONFIG_PPC_ADDER875 is not set
> # CONFIG_TQM8XX is not set
> 
> #
> # MPC8xx CPM Options
> #
> 
> #
> # Generic MPC8xx Options
> #
> # CONFIG_8xx_GPIO is not set
> # CONFIG_NO_UCODE_PATCH is not set
> # CONFIG_USB_SOF_UCODE_PATCH is not set
> CONFIG_I2C_SPI_UCODE_PATCH=y
> # CONFIG_I2C_SPI_SMC1_UCODE_PATCH is not set
> # CONFIG_SMC_UCODE_PATCH is not set
> CONFIG_UCODE_PATCH=y
> 
> #
> # 8xx advanced setup
> #
> CONFIG_PIN_TLB=y
> # CONFIG_PIN_TLB_DATA is not set
> CONFIG_PIN_TLB_IMMR=y
> # end of 8xx advanced setup
> # end of MPC8xx CPM Options
> 
> CONFIG_KVM_GUEST=y
> CONFIG_EPAPR_PARAVIRT=y
> 
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_GOV_ATTR_SET=y
> CONFIG_CPU_FREQ_GOV_COMMON=y
> CONFIG_CPU_FREQ_STAT=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> # CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
> CONFIG_CPU_FREQ_GOV_POWERSAVE=y
> CONFIG_CPU_FREQ_GOV_USERSPACE=y
> # CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
> 
> #
> # CPU frequency scaling drivers
> #
> # end of CPU Frequency scaling
> 
> #
> # CPUIdle driver
> #
> 
> #
> # CPU Idle
> #
> CONFIG_CPU_IDLE=y
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_CPU_IDLE_GOV_MENU=y
> # CONFIG_CPU_IDLE_GOV_TEO is not set
> CONFIG_CPU_IDLE_GOV_HALTPOLL=y
> 
> #
> # POWERPC CPU Idle Drivers
> #
> # end of POWERPC CPU Idle Drivers
> # end of CPU Idle
> # end of CPUIdle driver
> 
> # CONFIG_QE_GPIO is not set
> CONFIG_CPM=y
> CONFIG_GEN_RTC=y
> # end of Platform support
> 
> #
> # Kernel options
> #
> # CONFIG_HIGHMEM is not set
> # CONFIG_HZ_100 is not set
> CONFIG_HZ_250=y
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=250
> # CONFIG_MATH_EMULATION is not set
> CONFIG_ARCH_FLATMEM_ENABLE=y
> CONFIG_ILLEGAL_POINTER_VALUE=0
> CONFIG_PPC_4K_PAGES=y
> # CONFIG_PPC_16K_PAGES is not set
> CONFIG_PPC_PAGE_SHIFT=12
> CONFIG_THREAD_SHIFT=13
> CONFIG_DATA_SHIFT=23
> CONFIG_FORCE_MAX_ZONEORDER=11
> CONFIG_CMDLINE=""
> CONFIG_EXTRA_TARGETS=""
> CONFIG_PM=y
> # CONFIG_PM_DEBUG is not set
> CONFIG_PM_GENERIC_DOMAINS=y
> # CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
> CONFIG_PM_GENERIC_DOMAINS_OF=y
> # end of Kernel options
> 
> #
> # Bus options
> #
> CONFIG_FSL_SOC=y
> CONFIG_FSL_LBC=y
> # end of Bus options
> 
> #
> # Advanced setup
> #
> CONFIG_ADVANCED_OPTIONS=y
> # CONFIG_LOWMEM_SIZE_BOOL is not set
> CONFIG_LOWMEM_SIZE=0x30000000
> # CONFIG_PAGE_OFFSET_BOOL is not set
> CONFIG_PAGE_OFFSET=0xc0000000
> CONFIG_KERNEL_START_BOOL=y
> CONFIG_KERNEL_START=0xc0000000
> CONFIG_PHYSICAL_START=0x00000000
> # CONFIG_TASK_SIZE_BOOL is not set
> CONFIG_TASK_SIZE=0x80000000
> # end of Advanced setup
> 
> CONFIG_PPC_LIB_RHEAP=y
> CONFIG_VIRTUALIZATION=y
> 
> #
> # General architecture-dependent options
> #
> # CONFIG_JUMP_LABEL is not set
> CONFIG_UPROBES=y
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_ARCH_USE_BUILTIN_BSWAP=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_OPTPROBES=y
> CONFIG_HAVE_KPROBES_ON_FTRACE=y
> CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
> CONFIG_HAVE_NMI=y
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_GENERIC_SMP_IDLE_THREAD=y
> CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
> CONFIG_ARCH_HAS_SET_MEMORY=y
> CONFIG_ARCH_32BIT_OFF_T=y
> CONFIG_HAVE_ASM_MODVERSIONS=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> CONFIG_HAVE_RSEQ=y
> CONFIG_HAVE_HW_BREAKPOINT=y
> CONFIG_HAVE_PERF_REGS=y
> CONFIG_HAVE_PERF_USER_STACK_DUMP=y
> CONFIG_HAVE_ARCH_JUMP_LABEL=y
> CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
> CONFIG_MMU_GATHER_TABLE_FREE=y
> CONFIG_MMU_GATHER_RCU_TABLE_FREE=y
> CONFIG_MMU_GATHER_PAGE_SIZE=y
> CONFIG_ARCH_WANT_IRQS_OFF_ACTIVATE_MM=y
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
> CONFIG_ARCH_WEAK_RELEASE_ACQUIRE=y
> CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
> CONFIG_HAVE_ARCH_SECCOMP=y
> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
> CONFIG_SECCOMP=y
> CONFIG_SECCOMP_FILTER=y
> CONFIG_SECCOMP_CACHE_DEBUG=y
> CONFIG_HAVE_STACKPROTECTOR=y
> # CONFIG_STACKPROTECTOR is not set
> CONFIG_LTO_NONE=y
> CONFIG_HAVE_VIRT_CPU_ACCOUNTING=y
> CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
> CONFIG_HAVE_ARCH_HUGE_VMAP=y
> CONFIG_HAVE_ARCH_HUGE_VMALLOC=y
> CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
> CONFIG_MODULES_USE_ELF_RELA=y
> CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
> CONFIG_HAVE_SOFTIRQ_ON_OWN_STACK=y
> CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
> CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
> CONFIG_ARCH_MMAP_RND_BITS=11
> CONFIG_HAVE_RELIABLE_STACKTRACE=y
> CONFIG_HAVE_ARCH_NVRAM_OPS=y
> CONFIG_CLONE_BACKWARDS=y
> CONFIG_OLD_SIGSUSPEND=y
> CONFIG_OLD_SIGACTION=y
> CONFIG_COMPAT_32BIT_TIME=y
> CONFIG_HAVE_ARCH_VMAP_STACK=y
> # CONFIG_VMAP_STACK is not set
> CONFIG_ARCH_OPTIONAL_KERNEL_RWX=y
> CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
> CONFIG_STRICT_KERNEL_RWX=y
> CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
> CONFIG_ARCH_HAS_PHYS_TO_DMA=y
> # CONFIG_LOCK_EVENT_COUNTS is not set
> CONFIG_ARCH_WANT_LD_ORPHAN_WARN=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> 
> #
> # GCOV-based kernel profiling
> #
> # CONFIG_GCOV_KERNEL is not set
> CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
> # end of GCOV-based kernel profiling
> 
> CONFIG_HAVE_GCC_PLUGINS=y
> # CONFIG_GCC_PLUGINS is not set
> # end of General architecture-dependent options
> 
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=1
> # CONFIG_MODULES is not set
> CONFIG_MODULES_TREE_LOOKUP=y
> CONFIG_BLOCK=y
> CONFIG_BLK_DEV_BSG_COMMON=y
> CONFIG_BLK_DEV_BSGLIB=y
> CONFIG_BLK_DEV_INTEGRITY=y
> CONFIG_BLK_DEV_INTEGRITY_T10=y
> CONFIG_BLK_DEV_ZONED=y
> # CONFIG_BLK_WBT is not set
> CONFIG_BLK_DEBUG_FS=y
> CONFIG_BLK_DEBUG_FS_ZONED=y
> # CONFIG_BLK_SED_OPAL is not set
> # CONFIG_BLK_INLINE_ENCRYPTION is not set
> 
> #
> # Partition Types
> #
> # CONFIG_PARTITION_ADVANCED is not set
> CONFIG_MSDOS_PARTITION=y
> CONFIG_EFI_PARTITION=y
> # end of Partition Types
> 
> CONFIG_BLK_MQ_VIRTIO=y
> CONFIG_BLK_PM=y
> 
> #
> # IO Schedulers
> #
> CONFIG_MQ_IOSCHED_DEADLINE=y
> CONFIG_MQ_IOSCHED_KYBER=y
> CONFIG_IOSCHED_BFQ=y
> # end of IO Schedulers
> 
> CONFIG_ASN1=y
> CONFIG_UNINLINE_SPIN_UNLOCK=y
> CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
> CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE=y
> 
> #
> # Executable file formats
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_ELFCORE=y
> # CONFIG_BINFMT_SCRIPT is not set
> CONFIG_BINFMT_MISC=y
> # CONFIG_COREDUMP is not set
> # end of Executable file formats
> 
> #
> # Memory Management options
> #
> CONFIG_FLATMEM=y
> CONFIG_HAVE_FAST_GUP=y
> CONFIG_ARCH_KEEP_MEMBLOCK=y
> CONFIG_MEMORY_ISOLATION=y
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> # CONFIG_COMPACTION is not set
> # CONFIG_PAGE_REPORTING is not set
> CONFIG_MIGRATION=y
> CONFIG_CONTIG_ALLOC=y
> CONFIG_VIRT_TO_BUS=y
> # CONFIG_KSM is not set
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> CONFIG_NEED_PER_CPU_KM=y
> # CONFIG_CLEANCACHE is not set
> CONFIG_CMA=y
> # CONFIG_CMA_DEBUG is not set
> # CONFIG_CMA_DEBUGFS is not set
> # CONFIG_CMA_SYSFS is not set
> CONFIG_CMA_AREAS=7
> # CONFIG_ZPOOL is not set
> # CONFIG_ZSMALLOC is not set
> CONFIG_GENERIC_EARLY_IOREMAP=y
> # CONFIG_IDLE_PAGE_TRACKING is not set
> # CONFIG_PERCPU_STATS is not set
> # CONFIG_GUP_TEST is not set
> CONFIG_ARCH_HAS_PTE_SPECIAL=y
> CONFIG_ARCH_HAS_HUGEPD=y
> 
> #
> # Data Access Monitoring
> #
> # CONFIG_DAMON is not set
> # end of Data Access Monitoring
> # end of Memory Management options
> 
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> # CONFIG_PACKET is not set
> CONFIG_UNIX=y
> CONFIG_UNIX_SCM=y
> CONFIG_AF_UNIX_OOB=y
> CONFIG_UNIX_DIAG=y
> # CONFIG_XDP_SOCKETS is not set
> # CONFIG_INET is not set
> CONFIG_NETWORK_SECMARK=y
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> CONFIG_NETFILTER=y
> # CONFIG_NETFILTER_ADVANCED is not set
> CONFIG_ATM=y
> # CONFIG_ATM_LANE is not set
> CONFIG_STP=y
> CONFIG_GARP=y
> # CONFIG_BRIDGE is not set
> CONFIG_VLAN_8021Q=y
> CONFIG_VLAN_8021Q_GVRP=y
> # CONFIG_VLAN_8021Q_MVRP is not set
> # CONFIG_DECNET is not set
> CONFIG_LLC=y
> CONFIG_LLC2=y
> CONFIG_ATALK=y
> # CONFIG_DEV_APPLETALK is not set
> # CONFIG_X25 is not set
> CONFIG_LAPB=y
> CONFIG_PHONET=y
> # CONFIG_IEEE802154 is not set
> CONFIG_NET_SCHED=y
> 
> #
> # Queueing/Scheduling
> #
> CONFIG_NET_SCH_CBQ=y
> # CONFIG_NET_SCH_HTB is not set
> CONFIG_NET_SCH_HFSC=y
> CONFIG_NET_SCH_ATM=y
> CONFIG_NET_SCH_PRIO=y
> CONFIG_NET_SCH_MULTIQ=y
> CONFIG_NET_SCH_RED=y
> # CONFIG_NET_SCH_SFB is not set
> CONFIG_NET_SCH_SFQ=y
> CONFIG_NET_SCH_TEQL=y
> CONFIG_NET_SCH_TBF=y
> # CONFIG_NET_SCH_CBS is not set
> CONFIG_NET_SCH_ETF=y
> CONFIG_NET_SCH_TAPRIO=y
> CONFIG_NET_SCH_GRED=y
> CONFIG_NET_SCH_DSMARK=y
> CONFIG_NET_SCH_NETEM=y
> # CONFIG_NET_SCH_DRR is not set
> CONFIG_NET_SCH_MQPRIO=y
> # CONFIG_NET_SCH_SKBPRIO is not set
> CONFIG_NET_SCH_CHOKE=y
> # CONFIG_NET_SCH_QFQ is not set
> CONFIG_NET_SCH_CODEL=y
> CONFIG_NET_SCH_FQ_CODEL=y
> CONFIG_NET_SCH_CAKE=y
> # CONFIG_NET_SCH_FQ is not set
> CONFIG_NET_SCH_HHF=y
> # CONFIG_NET_SCH_PIE is not set
> CONFIG_NET_SCH_PLUG=y
> CONFIG_NET_SCH_ETS=y
> CONFIG_NET_SCH_DEFAULT=y
> # CONFIG_DEFAULT_CODEL is not set
> # CONFIG_DEFAULT_FQ_CODEL is not set
> # CONFIG_DEFAULT_SFQ is not set
> CONFIG_DEFAULT_PFIFO_FAST=y
> CONFIG_DEFAULT_NET_SCH="pfifo_fast"
> 
> #
> # Classification
> #
> CONFIG_NET_CLS=y
> CONFIG_NET_CLS_BASIC=y
> CONFIG_NET_CLS_TCINDEX=y
> CONFIG_NET_CLS_FW=y
> CONFIG_NET_CLS_U32=y
> # CONFIG_CLS_U32_PERF is not set
> CONFIG_CLS_U32_MARK=y
> # CONFIG_NET_CLS_RSVP is not set
> CONFIG_NET_CLS_RSVP6=y
> CONFIG_NET_CLS_FLOW=y
> # CONFIG_NET_CLS_BPF is not set
> CONFIG_NET_CLS_FLOWER=y
> CONFIG_NET_CLS_MATCHALL=y
> CONFIG_NET_EMATCH=y
> CONFIG_NET_EMATCH_STACK=32
> # CONFIG_NET_EMATCH_CMP is not set
> # CONFIG_NET_EMATCH_NBYTE is not set
> # CONFIG_NET_EMATCH_U32 is not set
> CONFIG_NET_EMATCH_META=y
> # CONFIG_NET_EMATCH_TEXT is not set
> CONFIG_NET_EMATCH_CANID=y
> # CONFIG_NET_CLS_ACT is not set
> CONFIG_NET_SCH_FIFO=y
> # CONFIG_DCB is not set
> # CONFIG_DNS_RESOLVER is not set
> CONFIG_BATMAN_ADV=y
> CONFIG_BATMAN_ADV_BATMAN_V=y
> CONFIG_BATMAN_ADV_NC=y
> # CONFIG_BATMAN_ADV_DEBUG is not set
> # CONFIG_BATMAN_ADV_TRACING is not set
> CONFIG_VSOCKETS=y
> CONFIG_VSOCKETS_DIAG=y
> CONFIG_VSOCKETS_LOOPBACK=y
> CONFIG_VIRTIO_VSOCKETS=y
> CONFIG_VIRTIO_VSOCKETS_COMMON=y
> # CONFIG_NETLINK_DIAG is not set
> # CONFIG_MPLS is not set
> CONFIG_NET_NSH=y
> CONFIG_HSR=y
> CONFIG_QRTR=y
> CONFIG_QRTR_SMD=y
> CONFIG_QRTR_TUN=y
> CONFIG_QRTR_MHI=y
> CONFIG_NET_RX_BUSY_POLL=y
> CONFIG_BQL=y
> 
> #
> # Network testing
> #
> # end of Network testing
> # end of Networking options
> 
> # CONFIG_HAMRADIO is not set
> CONFIG_CAN=y
> # CONFIG_CAN_RAW is not set
> # CONFIG_CAN_BCM is not set
> # CONFIG_CAN_GW is not set
> CONFIG_CAN_J1939=y
> # CONFIG_CAN_ISOTP is not set
> 
> #
> # CAN Device Drivers
> #
> # CONFIG_CAN_VCAN is not set
> # CONFIG_CAN_VXCAN is not set
> # CONFIG_CAN_SLCAN is not set
> # CONFIG_CAN_DEV is not set
> # CONFIG_CAN_DEBUG_DEVICES is not set
> # end of CAN Device Drivers
> 
> CONFIG_BT=y
> # CONFIG_BT_BREDR is not set
> CONFIG_BT_LE=y
> CONFIG_BT_LEDS=y
> # CONFIG_BT_MSFTEXT is not set
> # CONFIG_BT_AOSPEXT is not set
> CONFIG_BT_DEBUGFS=y
> # CONFIG_BT_SELFTEST is not set
> # CONFIG_BT_FEATURE_DEBUG is not set
> 
> #
> # Bluetooth device drivers
> #
> CONFIG_BT_INTEL=y
> # CONFIG_BT_HCIBTUSB is not set
> CONFIG_BT_HCIBTSDIO=y
> CONFIG_BT_HCIUART=y
> CONFIG_BT_HCIUART_H4=y
> CONFIG_BT_HCIUART_BCSP=y
> # CONFIG_BT_HCIUART_ATH3K is not set
> # CONFIG_BT_HCIUART_INTEL is not set
> CONFIG_BT_HCIUART_AG6XX=y
> CONFIG_BT_HCIBCM203X=y
> CONFIG_BT_HCIBPA10X=y
> CONFIG_BT_HCIBFUSB=y
> CONFIG_BT_HCIVHCI=y
> # CONFIG_BT_MRVL is not set
> # CONFIG_BT_MTKSDIO is not set
> # CONFIG_BT_QCOMSMD is not set
> CONFIG_BT_VIRTIO=y
> # end of Bluetooth device drivers
> 
> # CONFIG_MCTP is not set
> CONFIG_WIRELESS=y
> # CONFIG_CFG80211 is not set
> 
> #
> # CFG80211 needs to be enabled for MAC80211
> #
> CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
> CONFIG_RFKILL=y
> CONFIG_RFKILL_LEDS=y
> CONFIG_RFKILL_GPIO=y
> CONFIG_NET_9P=y
> CONFIG_NET_9P_VIRTIO=y
> CONFIG_NET_9P_DEBUG=y
> CONFIG_CAIF=y
> # CONFIG_CAIF_DEBUG is not set
> # CONFIG_CAIF_NETDEV is not set
> # CONFIG_CAIF_USB is not set
> # CONFIG_NFC is not set
> CONFIG_PSAMPLE=y
> CONFIG_NET_IFE=y
> CONFIG_LWTUNNEL=y
> CONFIG_GRO_CELLS=y
> # CONFIG_NET_SELFTESTS is not set
> CONFIG_NET_SOCK_MSG=y
> CONFIG_NET_DEVLINK=y
> CONFIG_FAILOVER=y
> # CONFIG_ETHTOOL_NETLINK is not set
> 
> #
> # Device Drivers
> #
> CONFIG_PCCARD=y
> # CONFIG_PCMCIA is not set
> 
> #
> # PC-card bridges
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_AUXILIARY_BUS=y
> # CONFIG_UEVENT_HELPER is not set
> CONFIG_DEVTMPFS=y
> CONFIG_DEVTMPFS_MOUNT=y
> CONFIG_STANDALONE=y
> # CONFIG_PREVENT_FIRMWARE_BUILD is not set
> 
> #
> # Firmware loader
> #
> CONFIG_FW_LOADER=y
> CONFIG_FW_LOADER_PAGED_BUF=y
> CONFIG_EXTRA_FIRMWARE=""
> CONFIG_FW_LOADER_USER_HELPER=y
> # CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
> # CONFIG_FW_LOADER_COMPRESS is not set
> # end of Firmware loader
> 
> CONFIG_WANT_DEV_COREDUMP=y
> CONFIG_ALLOW_DEV_COREDUMP=y
> CONFIG_DEV_COREDUMP=y
> # CONFIG_DEBUG_DRIVER is not set
> CONFIG_DEBUG_DEVRES=y
> # CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
> CONFIG_PM_QOS_KUNIT_TEST=y
> CONFIG_DRIVER_PE_KUNIT_TEST=y
> CONFIG_GENERIC_CPU_AUTOPROBE=y
> CONFIG_SOC_BUS=y
> CONFIG_REGMAP=y
> CONFIG_REGMAP_I2C=y
> CONFIG_REGMAP_SLIMBUS=y
> CONFIG_REGMAP_SPMI=y
> CONFIG_REGMAP_W1=y
> CONFIG_REGMAP_MMIO=y
> CONFIG_REGMAP_IRQ=y
> CONFIG_REGMAP_SCCB=y
> CONFIG_REGMAP_I3C=y
> CONFIG_DMA_SHARED_BUFFER=y
> CONFIG_DMA_FENCE_TRACE=y
> # end of Generic Driver Options
> 
> #
> # Bus devices
> #
> # CONFIG_ARM_INTEGRATOR_LM is not set
> # CONFIG_BT1_APB is not set
> # CONFIG_BT1_AXI is not set
> # CONFIG_HISILICON_LPC is not set
> # CONFIG_INTEL_IXP4XX_EB is not set
> # CONFIG_QCOM_EBI2 is not set
> # CONFIG_FSL_MC_BUS is not set
> CONFIG_MHI_BUS=y
> # CONFIG_MHI_BUS_DEBUG is not set
> # end of Bus devices
> 
> CONFIG_CONNECTOR=y
> # CONFIG_PROC_EVENTS is not set
> 
> #
> # Firmware Drivers
> #
> 
> #
> # ARM System Control and Management Interface Protocol
> #
> # CONFIG_ARM_SCMI_PROTOCOL is not set
> CONFIG_ARM_SCMI_POWER_DOMAIN=y
> # end of ARM System Control and Management Interface Protocol
> 
> # CONFIG_ARM_SCPI_PROTOCOL is not set
> CONFIG_ARM_SCPI_POWER_DOMAIN=y
> # CONFIG_FIRMWARE_MEMMAP is not set
> # CONFIG_TURRIS_MOX_RWTM is not set
> # CONFIG_BCM47XX_NVRAM is not set
> # CONFIG_GOOGLE_FIRMWARE is not set
> 
> #
> # Tegra firmware driver
> #
> # end of Tegra firmware driver
> # end of Firmware Drivers
> 
> CONFIG_GNSS=y
> CONFIG_MTD=y
> 
> #
> # Partition parsers
> #
> CONFIG_MTD_AR7_PARTS=y
> # CONFIG_MTD_BCM63XX_PARTS is not set
> # CONFIG_MTD_CMDLINE_PARTS is not set
> # CONFIG_MTD_OF_PARTS is not set
> # CONFIG_MTD_PARSER_IMAGETAG is not set
> # CONFIG_MTD_PARSER_TRX is not set
> # CONFIG_MTD_SHARPSL_PARTS is not set
> CONFIG_MTD_REDBOOT_PARTS=y
> CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
> # CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
> # CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
> # end of Partition parsers
> 
> #
> # User Modules And Translation Layers
> #
> CONFIG_MTD_BLKDEVS=y
> CONFIG_MTD_BLOCK=y
> 
> #
> # Note that in some cases UBI block is preferred. See MTD_UBI_BLOCK.
> #
> CONFIG_FTL=y
> CONFIG_NFTL=y
> # CONFIG_NFTL_RW is not set
> CONFIG_INFTL=y
> CONFIG_RFD_FTL=y
> CONFIG_SSFDC=y
> # CONFIG_SM_FTL is not set
> CONFIG_MTD_OOPS=y
> # CONFIG_MTD_PARTITIONED_MASTER is not set
> 
> #
> # RAM/ROM/Flash chip drivers
> #
> CONFIG_MTD_CFI=y
> # CONFIG_MTD_JEDECPROBE is not set
> CONFIG_MTD_GEN_PROBE=y
> # CONFIG_MTD_CFI_ADV_OPTIONS is not set
> CONFIG_MTD_MAP_BANK_WIDTH_1=y
> CONFIG_MTD_MAP_BANK_WIDTH_2=y
> CONFIG_MTD_MAP_BANK_WIDTH_4=y
> CONFIG_MTD_CFI_I1=y
> CONFIG_MTD_CFI_I2=y
> # CONFIG_MTD_CFI_INTELEXT is not set
> CONFIG_MTD_CFI_AMDSTD=y
> CONFIG_MTD_CFI_STAA=y
> CONFIG_MTD_CFI_UTIL=y
> CONFIG_MTD_RAM=y
> CONFIG_MTD_ROM=y
> CONFIG_MTD_ABSENT=y
> # end of RAM/ROM/Flash chip drivers
> 
> #
> # Mapping drivers for chip access
> #
> # CONFIG_MTD_COMPLEX_MAPPINGS is not set
> # CONFIG_MTD_PHYSMAP is not set
> # CONFIG_MTD_SC520CDP is not set
> # CONFIG_MTD_NETSC520 is not set
> # CONFIG_MTD_TS5500 is not set
> CONFIG_MTD_CFI_FLAGADM=y
> # CONFIG_MTD_PLATRAM is not set
> # end of Mapping drivers for chip access
> 
> #
> # Self-contained MTD device drivers
> #
> CONFIG_MTD_SPEAR_SMI=y
> CONFIG_MTD_SLRAM=y
> CONFIG_MTD_PHRAM=y
> # CONFIG_MTD_MTDRAM is not set
> # CONFIG_MTD_BLOCK2MTD is not set
> 
> #
> # Disk-On-Chip Device Drivers
> #
> CONFIG_MTD_DOCG3=y
> CONFIG_BCH_CONST_M=14
> CONFIG_BCH_CONST_T=4
> # end of Self-contained MTD device drivers
> 
> #
> # NAND
> #
> CONFIG_MTD_NAND_CORE=y
> CONFIG_MTD_ONENAND=y
> CONFIG_MTD_ONENAND_VERIFY_WRITE=y
> CONFIG_MTD_ONENAND_GENERIC=y
> # CONFIG_MTD_ONENAND_SAMSUNG is not set
> CONFIG_MTD_ONENAND_OTP=y
> CONFIG_MTD_ONENAND_2X_PROGRAM=y
> CONFIG_MTD_RAW_NAND=y
> 
> #
> # Raw/parallel NAND flash controllers
> #
> CONFIG_MTD_NAND_AMS_DELTA=y
> # CONFIG_MTD_NAND_OMAP2 is not set
> # CONFIG_MTD_NAND_SHARPSL is not set
> # CONFIG_MTD_NAND_ATMEL is not set
> # CONFIG_MTD_NAND_MARVELL is not set
> # CONFIG_MTD_NAND_SLC_LPC32XX is not set
> # CONFIG_MTD_NAND_MLC_LPC32XX is not set
> # CONFIG_MTD_NAND_BRCMNAND is not set
> # CONFIG_MTD_NAND_OXNAS is not set
> CONFIG_MTD_NAND_FSL_ELBC=y
> CONFIG_MTD_NAND_FSL_IFC=y
> # CONFIG_MTD_NAND_VF610_NFC is not set
> # CONFIG_MTD_NAND_MXC is not set
> # CONFIG_MTD_NAND_SH_FLCTL is not set
> # CONFIG_MTD_NAND_DAVINCI is not set
> # CONFIG_MTD_NAND_TXX9NDFMC is not set
> # CONFIG_MTD_NAND_FSMC is not set
> # CONFIG_MTD_NAND_SUNXI is not set
> # CONFIG_MTD_NAND_HISI504 is not set
> # CONFIG_MTD_NAND_QCOM is not set
> # CONFIG_MTD_NAND_MTK is not set
> CONFIG_MTD_NAND_MXIC=y
> # CONFIG_MTD_NAND_TEGRA is not set
> # CONFIG_MTD_NAND_STM32_FMC2 is not set
> # CONFIG_MTD_NAND_MESON is not set
> CONFIG_MTD_NAND_GPIO=y
> CONFIG_MTD_NAND_PLATFORM=y
> CONFIG_MTD_NAND_CADENCE=y
> CONFIG_MTD_NAND_ARASAN=y
> CONFIG_MTD_NAND_INTEL_LGM=y
> 
> #
> # Misc
> #
> # CONFIG_MTD_NAND_NANDSIM is not set
> # CONFIG_MTD_NAND_DISKONCHIP is not set
> 
> #
> # ECC engine support
> #
> CONFIG_MTD_NAND_ECC=y
> CONFIG_MTD_NAND_ECC_SW_HAMMING=y
> CONFIG_MTD_NAND_ECC_SW_HAMMING_SMC=y
> CONFIG_MTD_NAND_ECC_SW_BCH=y
> # end of ECC engine support
> # end of NAND
> 
> #
> # LPDDR & LPDDR2 PCM memory drivers
> #
> CONFIG_MTD_LPDDR=y
> CONFIG_MTD_QINFO_PROBE=y
> # end of LPDDR & LPDDR2 PCM memory drivers
> 
> # CONFIG_MTD_UBI is not set
> # CONFIG_MTD_HYPERBUS is not set
> CONFIG_DTC=y
> CONFIG_OF=y
> # CONFIG_OF_UNITTEST is not set
> # CONFIG_OF_ALL_DTBS is not set
> CONFIG_OF_FLATTREE=y
> CONFIG_OF_EARLY_FLATTREE=y
> CONFIG_OF_KOBJ=y
> CONFIG_OF_DYNAMIC=y
> CONFIG_OF_ADDRESS=y
> CONFIG_OF_IRQ=y
> CONFIG_OF_NET=y
> CONFIG_OF_RESERVED_MEM=y
> # CONFIG_OF_OVERLAY is not set
> CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
> CONFIG_PARPORT=y
> CONFIG_PARPORT_PC=y
> CONFIG_PARPORT_PC_FIFO=y
> CONFIG_PARPORT_PC_SUPERIO=y
> # CONFIG_PARPORT_AX88796 is not set
> CONFIG_PARPORT_1284=y
> CONFIG_BLK_DEV=y
> CONFIG_BLK_DEV_NULL_BLK=y
> # CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION is not set
> CONFIG_CDROM=y
> # CONFIG_PARIDE is not set
> CONFIG_BLK_DEV_LOOP=y
> CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
> # CONFIG_BLK_DEV_CRYPTOLOOP is not set
> 
> #
> # DRBD disabled because PROC_FS or INET not selected
> #
> CONFIG_BLK_DEV_NBD=y
> CONFIG_BLK_DEV_RAM=y
> CONFIG_BLK_DEV_RAM_COUNT=16
> CONFIG_BLK_DEV_RAM_SIZE=4096
> CONFIG_CDROM_PKTCDVD=y
> CONFIG_CDROM_PKTCDVD_BUFFERS=8
> CONFIG_CDROM_PKTCDVD_WCACHE=y
> # CONFIG_ATA_OVER_ETH is not set
> CONFIG_VIRTIO_BLK=y
> 
> #
> # NVME Support
> #
> CONFIG_NVME_CORE=y
> CONFIG_NVME_MULTIPATH=y
> # CONFIG_NVME_HWMON is not set
> CONFIG_NVME_FABRICS=y
> CONFIG_NVME_FC=y
> # CONFIG_NVME_TARGET is not set
> # end of NVME Support
> 
> #
> # Misc devices
> #
> # CONFIG_AD525X_DPOT is not set
> CONFIG_DUMMY_IRQ=y
> CONFIG_ICS932S401=y
> # CONFIG_ATMEL_SSC is not set
> CONFIG_ENCLOSURE_SERVICES=y
> CONFIG_HI6421V600_IRQ=y
> # CONFIG_QCOM_COINCELL is not set
> # CONFIG_QCOM_FASTRPC is not set
> # CONFIG_APDS9802ALS is not set
> CONFIG_ISL29003=y
> CONFIG_ISL29020=y
> # CONFIG_SENSORS_TSL2550 is not set
> CONFIG_SENSORS_BH1770=y
> CONFIG_SENSORS_APDS990X=y
> CONFIG_HMC6352=y
> # CONFIG_DS1682 is not set
> # CONFIG_SRAM is not set
> CONFIG_XILINX_SDFEC=y
> CONFIG_MISC_RTSX=y
> CONFIG_HISI_HIKEY_USB=y
> CONFIG_C2PORT=y
> 
> #
> # EEPROM support
> #
> CONFIG_EEPROM_AT24=y
> CONFIG_EEPROM_LEGACY=y
> CONFIG_EEPROM_MAX6875=y
> CONFIG_EEPROM_93CX6=y
> CONFIG_EEPROM_IDT_89HPESX=y
> CONFIG_EEPROM_EE1004=y
> # end of EEPROM support
> 
> #
> # Texas Instruments shared transport line discipline
> #
> CONFIG_TI_ST=y
> # end of Texas Instruments shared transport line discipline
> 
> CONFIG_ALTERA_STAPL=y
> CONFIG_ECHO=y
> CONFIG_MISC_RTSX_USB=y
> # CONFIG_PVPANIC is not set
> # end of Misc devices
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> CONFIG_RAID_ATTRS=y
> CONFIG_SCSI_COMMON=y
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> CONFIG_SCSI_NETLINK=y
> CONFIG_SCSI_PROC_FS=y
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> CONFIG_CHR_DEV_ST=y
> CONFIG_BLK_DEV_SR=y
> CONFIG_CHR_DEV_SG=y
> # CONFIG_BLK_DEV_BSG is not set
> # CONFIG_CHR_DEV_SCH is not set
> CONFIG_SCSI_ENCLOSURE=y
> # CONFIG_SCSI_CONSTANTS is not set
> CONFIG_SCSI_LOGGING=y
> # CONFIG_SCSI_SCAN_ASYNC is not set
> 
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=y
> CONFIG_SCSI_FC_ATTRS=y
> CONFIG_SCSI_ISCSI_ATTRS=y
> CONFIG_SCSI_SAS_ATTRS=y
> CONFIG_SCSI_SAS_LIBSAS=y
> # CONFIG_SCSI_SAS_ATA is not set
> # CONFIG_SCSI_SAS_HOST_SMP is not set
> CONFIG_SCSI_SRP_ATTRS=y
> # end of SCSI Transports
> 
> CONFIG_SCSI_LOWLEVEL=y
> CONFIG_ISCSI_BOOT_SYSFS=y
> # CONFIG_SCSI_HISI_SAS is not set
> # CONFIG_SCSI_UFSHCD is not set
> # CONFIG_SCSI_UFS_TI_J721E is not set
> CONFIG_LIBFC=y
> CONFIG_LIBFCOE=y
> # CONFIG_SCSI_PPA is not set
> CONFIG_SCSI_IMM=y
> CONFIG_SCSI_IZIP_EPP16=y
> # CONFIG_SCSI_IZIP_SLOW_CTR is not set
> CONFIG_SCSI_DEBUG=y
> CONFIG_SCSI_VIRTIO=y
> # CONFIG_SCSI_DH is not set
> # end of SCSI device support
> 
> CONFIG_ATA=y
> CONFIG_SATA_HOST=y
> # CONFIG_ATA_VERBOSE_ERROR is not set
> CONFIG_ATA_FORCE=y
> # CONFIG_SATA_PMP is not set
> 
> #
> # Controllers with non-SFF native interface
> #
> # CONFIG_SATA_AHCI_PLATFORM is not set
> # CONFIG_AHCI_IMX is not set
> CONFIG_AHCI_CEVA=y
> # CONFIG_AHCI_QORIQ is not set
> # CONFIG_SATA_FSL is not set
> # CONFIG_SATA_GEMINI is not set
> CONFIG_ATA_SFF=y
> 
> #
> # SFF controllers with custom DMA interface
> #
> CONFIG_ATA_BMDMA=y
> 
> #
> # SATA SFF controllers with BMDMA
> #
> # CONFIG_SATA_HIGHBANK is not set
> # CONFIG_SATA_MV is not set
> # CONFIG_SATA_RCAR is not set
> 
> #
> # PATA SFF controllers with BMDMA
> #
> 
> #
> # PIO-only SFF controllers
> #
> # CONFIG_PATA_IXP4XX_CF is not set
> # CONFIG_PATA_PLATFORM is not set
> 
> #
> # Generic fallback / legacy drivers
> #
> # CONFIG_MD is not set
> CONFIG_TARGET_CORE=y
> CONFIG_TCM_IBLOCK=y
> CONFIG_TCM_FILEIO=y
> CONFIG_TCM_PSCSI=y
> CONFIG_LOOPBACK_TARGET=y
> # CONFIG_TCM_FC is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> # CONFIG_FIREWIRE is not set
> # end of IEEE 1394 (FireWire) support
> 
> # CONFIG_MACINTOSH_DRIVERS is not set
> CONFIG_NETDEVICES=y
> CONFIG_MII=y
> # CONFIG_NET_CORE is not set
> # CONFIG_ATM_DRIVERS is not set
> # CONFIG_CAIF_DRIVERS is not set
> CONFIG_ETHERNET=y
> # CONFIG_NET_VENDOR_ACTIONS is not set
> CONFIG_NET_VENDOR_ALACRITECH=y
> CONFIG_ALTERA_TSE=y
> CONFIG_NET_VENDOR_AMAZON=y
> # CONFIG_NET_XGENE is not set
> # CONFIG_NET_XGENE_V2 is not set
> # CONFIG_NET_VENDOR_AQUANTIA is not set
> CONFIG_NET_VENDOR_ARC=y
> # CONFIG_ARC_EMAC is not set
> CONFIG_NET_VENDOR_BROADCOM=y
> CONFIG_B44=y
> # CONFIG_BCM4908_ENET is not set
> CONFIG_BCMGENET=y
> # CONFIG_BGMAC_BCMA is not set
> # CONFIG_BGMAC_PLATFORM is not set
> CONFIG_SYSTEMPORT=y
> # CONFIG_NET_VENDOR_CADENCE is not set
> # CONFIG_NET_CALXEDA_XGMAC is not set
> # CONFIG_NET_VENDOR_CAVIUM is not set
> CONFIG_NET_VENDOR_CIRRUS=y
> # CONFIG_EP93XX_ETH is not set
> CONFIG_NET_VENDOR_CORTINA=y
> CONFIG_GEMINI_ETHERNET=y
> # CONFIG_DM9000 is not set
> # CONFIG_DNET is not set
> CONFIG_NET_VENDOR_EZCHIP=y
> # CONFIG_EZCHIP_NPS_MANAGEMENT_ENET is not set
> CONFIG_NET_VENDOR_FARADAY=y
> # CONFIG_FTMAC100 is not set
> # CONFIG_FTGMAC100 is not set
> CONFIG_NET_VENDOR_FREESCALE=y
> # CONFIG_FEC is not set
> # CONFIG_FS_ENET is not set
> CONFIG_FSL_FMAN=y
> CONFIG_FSL_PQ_MDIO=y
> # CONFIG_FSL_XGMAC_MDIO is not set
> CONFIG_UCC_GETH=y
> # CONFIG_UGETH_TX_ON_DEMAND is not set
> # CONFIG_GIANFAR is not set
> CONFIG_FSL_ENETC_IERB=y
> CONFIG_NET_VENDOR_GOOGLE=y
> CONFIG_NET_VENDOR_HISILICON=y
> # CONFIG_HIX5HD2_GMAC is not set
> # CONFIG_HISI_FEMAC is not set
> # CONFIG_HIP04_ETH is not set
> # CONFIG_HNS_DSAF is not set
> # CONFIG_HNS_ENET is not set
> CONFIG_NET_VENDOR_HUAWEI=y
> CONFIG_NET_VENDOR_I825XX=y
> CONFIG_NET_VENDOR_INTEL=y
> CONFIG_NET_VENDOR_MICROSOFT=y
> # CONFIG_KORINA is not set
> # CONFIG_NET_VENDOR_LITEX is not set
> CONFIG_NET_VENDOR_MARVELL=y
> # CONFIG_MVMDIO is not set
> # CONFIG_MVNETA is not set
> # CONFIG_MVPP2 is not set
> # CONFIG_PXA168_ETH is not set
> CONFIG_NET_VENDOR_MELLANOX=y
> # CONFIG_MLXSW_CORE is not set
> CONFIG_MLXFW=y
> # CONFIG_MLXBF_GIGE is not set
> # CONFIG_NET_VENDOR_MICREL is not set
> # CONFIG_NET_VENDOR_MICROCHIP is not set
> # CONFIG_NET_VENDOR_MICROSEMI is not set
> CONFIG_NET_VENDOR_NATSEMI=y
> CONFIG_NET_VENDOR_NETRONOME=y
> # CONFIG_NET_VENDOR_NI is not set
> CONFIG_NET_VENDOR_8390=y
> # CONFIG_AX88796 is not set
> # CONFIG_LPC_ENET is not set
> CONFIG_ETHOC=y
> CONFIG_NET_VENDOR_PENSANDO=y
> CONFIG_NET_VENDOR_QUALCOMM=y
> CONFIG_QCOM_EMAC=y
> CONFIG_RMNET=y
> CONFIG_NET_VENDOR_RENESAS=y
> # CONFIG_SH_ETH is not set
> # CONFIG_RAVB is not set
> CONFIG_NET_VENDOR_ROCKER=y
> CONFIG_NET_VENDOR_SAMSUNG=y
> # CONFIG_SXGBE_ETH is not set
> # CONFIG_NET_VENDOR_SEEQ is not set
> # CONFIG_NET_VENDOR_SOLARFLARE is not set
> CONFIG_NET_VENDOR_SMSC=y
> # CONFIG_SMC91X is not set
> # CONFIG_SMC911X is not set
> # CONFIG_SMSC911X is not set
> CONFIG_NET_VENDOR_SOCIONEXT=y
> # CONFIG_SNI_AVE is not set
> # CONFIG_SNI_NETSEC is not set
> # CONFIG_NET_VENDOR_STMICRO is not set
> # CONFIG_NET_VENDOR_SYNOPSYS is not set
> CONFIG_NET_VENDOR_VIA=y
> CONFIG_VIA_VELOCITY=y
> CONFIG_NET_VENDOR_WIZNET=y
> # CONFIG_WIZNET_W5100 is not set
> CONFIG_WIZNET_W5300=y
> # CONFIG_WIZNET_BUS_DIRECT is not set
> CONFIG_WIZNET_BUS_INDIRECT=y
> # CONFIG_WIZNET_BUS_ANY is not set
> CONFIG_NET_VENDOR_XILINX=y
> CONFIG_XILINX_EMACLITE=y
> CONFIG_XILINX_AXI_EMAC=y
> CONFIG_XILINX_LL_TEMAC=y
> CONFIG_PHYLINK=y
> CONFIG_PHYLIB=y
> CONFIG_SWPHY=y
> # CONFIG_LED_TRIGGER_PHY is not set
> CONFIG_FIXED_PHY=y
> CONFIG_SFP=y
> 
> #
> # MII PHY device drivers
> #
> # CONFIG_AMD_PHY is not set
> # CONFIG_MESON_GXL_PHY is not set
> CONFIG_ADIN_PHY=y
> CONFIG_AQUANTIA_PHY=y
> CONFIG_AX88796B_PHY=y
> CONFIG_BROADCOM_PHY=y
> # CONFIG_BCM54140_PHY is not set
> # CONFIG_BCM63XX_PHY is not set
> CONFIG_BCM7XXX_PHY=y
> CONFIG_BCM84881_PHY=y
> # CONFIG_BCM87XX_PHY is not set
> CONFIG_BCM_NET_PHYLIB=y
> CONFIG_CICADA_PHY=y
> # CONFIG_CORTINA_PHY is not set
> CONFIG_DAVICOM_PHY=y
> CONFIG_ICPLUS_PHY=y
> # CONFIG_LXT_PHY is not set
> # CONFIG_INTEL_XWAY_PHY is not set
> CONFIG_LSI_ET1011C_PHY=y
> CONFIG_MARVELL_PHY=y
> # CONFIG_MARVELL_10G_PHY is not set
> CONFIG_MARVELL_88X2222_PHY=y
> # CONFIG_MAXLINEAR_GPHY is not set
> CONFIG_MEDIATEK_GE_PHY=y
> # CONFIG_MICREL_PHY is not set
> CONFIG_MICROCHIP_PHY=y
> # CONFIG_MICROCHIP_T1_PHY is not set
> # CONFIG_MICROSEMI_PHY is not set
> CONFIG_MOTORCOMM_PHY=y
> CONFIG_NATIONAL_PHY=y
> # CONFIG_NXP_C45_TJA11XX_PHY is not set
> # CONFIG_NXP_TJA11XX_PHY is not set
> # CONFIG_QSEMI_PHY is not set
> CONFIG_REALTEK_PHY=y
> CONFIG_RENESAS_PHY=y
> CONFIG_ROCKCHIP_PHY=y
> CONFIG_SMSC_PHY=y
> CONFIG_STE10XP=y
> CONFIG_TERANETICS_PHY=y
> CONFIG_DP83822_PHY=y
> CONFIG_DP83TC811_PHY=y
> # CONFIG_DP83848_PHY is not set
> CONFIG_DP83867_PHY=y
> CONFIG_DP83869_PHY=y
> CONFIG_VITESSE_PHY=y
> CONFIG_XILINX_GMII2RGMII=y
> CONFIG_MDIO_DEVICE=y
> CONFIG_MDIO_BUS=y
> CONFIG_FWNODE_MDIO=y
> CONFIG_OF_MDIO=y
> CONFIG_MDIO_DEVRES=y
> # CONFIG_MDIO_SUN4I is not set
> # CONFIG_MDIO_XGENE is not set
> # CONFIG_MDIO_ASPEED is not set
> # CONFIG_MDIO_BITBANG is not set
> # CONFIG_MDIO_BCM_IPROC is not set
> CONFIG_MDIO_BCM_UNIMAC=y
> CONFIG_MDIO_HISI_FEMAC=y
> CONFIG_MDIO_I2C=y
> CONFIG_MDIO_MVUSB=y
> CONFIG_MDIO_MSCC_MIIM=y
> # CONFIG_MDIO_MOXART is not set
> # CONFIG_MDIO_OCTEON is not set
> CONFIG_MDIO_IPQ8064=y
> 
> #
> # MDIO Multiplexers
> #
> CONFIG_MDIO_BUS_MUX=y
> # CONFIG_MDIO_BUS_MUX_BCM6368 is not set
> # CONFIG_MDIO_BUS_MUX_BCM_IPROC is not set
> # CONFIG_MDIO_BUS_MUX_GPIO is not set
> CONFIG_MDIO_BUS_MUX_MULTIPLEXER=y
> # CONFIG_MDIO_BUS_MUX_MMIOREG is not set
> 
> #
> # PCS device drivers
> #
> # CONFIG_PCS_XPCS is not set
> # end of PCS device drivers
> 
> CONFIG_PLIP=y
> CONFIG_PPP=y
> CONFIG_PPP_BSDCOMP=y
> CONFIG_PPP_DEFLATE=y
> # CONFIG_PPP_FILTER is not set
> CONFIG_PPP_MPPE=y
> # CONFIG_PPP_MULTILINK is not set
> # CONFIG_PPPOATM is not set
> CONFIG_PPPOE=y
> CONFIG_PPP_ASYNC=y
> CONFIG_PPP_SYNC_TTY=y
> # CONFIG_SLIP is not set
> CONFIG_SLHC=y
> CONFIG_USB_NET_DRIVERS=y
> CONFIG_USB_CATC=y
> # CONFIG_USB_KAWETH is not set
> CONFIG_USB_PEGASUS=y
> # CONFIG_USB_RTL8150 is not set
> # CONFIG_USB_RTL8152 is not set
> # CONFIG_USB_LAN78XX is not set
> CONFIG_USB_USBNET=y
> CONFIG_USB_NET_AX8817X=y
> CONFIG_USB_NET_AX88179_178A=y
> CONFIG_USB_NET_CDCETHER=y
> CONFIG_USB_NET_CDC_EEM=y
> CONFIG_USB_NET_CDC_NCM=y
> CONFIG_USB_NET_HUAWEI_CDC_NCM=y
> CONFIG_USB_NET_CDC_MBIM=y
> CONFIG_USB_NET_DM9601=y
> CONFIG_USB_NET_SR9700=y
> CONFIG_USB_NET_SR9800=y
> # CONFIG_USB_NET_SMSC75XX is not set
> CONFIG_USB_NET_SMSC95XX=y
> # CONFIG_USB_NET_GL620A is not set
> CONFIG_USB_NET_NET1080=y
> # CONFIG_USB_NET_PLUSB is not set
> CONFIG_USB_NET_MCS7830=y
> # CONFIG_USB_NET_RNDIS_HOST is not set
> CONFIG_USB_NET_CDC_SUBSET_ENABLE=y
> CONFIG_USB_NET_CDC_SUBSET=y
> # CONFIG_USB_ALI_M5632 is not set
> # CONFIG_USB_AN2720 is not set
> # CONFIG_USB_BELKIN is not set
> CONFIG_USB_ARMLINUX=y
> CONFIG_USB_EPSON2888=y
> CONFIG_USB_KC2190=y
> CONFIG_USB_NET_ZAURUS=y
> # CONFIG_USB_NET_CX82310_ETH is not set
> CONFIG_USB_NET_KALMIA=y
> CONFIG_USB_NET_QMI_WWAN=y
> # CONFIG_USB_HSO is not set
> CONFIG_USB_NET_INT51X1=y
> CONFIG_USB_CDC_PHONET=y
> # CONFIG_USB_IPHETH is not set
> CONFIG_USB_SIERRA_NET=y
> CONFIG_USB_VL600=y
> CONFIG_USB_NET_CH9200=y
> CONFIG_USB_NET_AQC111=y
> CONFIG_USB_RTL8153_ECM=y
> # CONFIG_WLAN is not set
> CONFIG_WAN=y
> CONFIG_HDLC=y
> # CONFIG_HDLC_RAW is not set
> CONFIG_HDLC_RAW_ETH=y
> CONFIG_HDLC_CISCO=y
> # CONFIG_HDLC_FR is not set
> # CONFIG_HDLC_PPP is not set
> CONFIG_HDLC_X25=y
> CONFIG_FSL_UCC_HDLC=y
> 
> #
> # Wireless WAN
> #
> CONFIG_WWAN=y
> CONFIG_WWAN_HWSIM=y
> # CONFIG_MHI_WWAN_CTRL is not set
> CONFIG_MHI_WWAN_MBIM=y
> CONFIG_RPMSG_WWAN_CTRL=y
> # end of Wireless WAN
> 
> # CONFIG_NET_FAILOVER is not set
> CONFIG_ISDN=y
> CONFIG_ISDN_CAPI=y
> CONFIG_MISDN=y
> CONFIG_MISDN_DSP=y
> CONFIG_MISDN_L1OIP=y
> 
> #
> # mISDN hardware drivers
> #
> CONFIG_MISDN_HFCMULTI=y
> CONFIG_MISDN_HFCMULTI_8xx=y
> CONFIG_MISDN_HFCUSB=y
> 
> #
> # Input device support
> #
> # CONFIG_INPUT is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
> # CONFIG_SERIO_I8042 is not set
> CONFIG_SERIO_SERPORT=y
> # CONFIG_SERIO_PARKBD is not set
> CONFIG_SERIO_LIBPS2=y
> CONFIG_SERIO_RAW=y
> # CONFIG_SERIO_XILINX_XPS_PS2 is not set
> CONFIG_SERIO_ALTERA_PS2=y
> CONFIG_SERIO_PS2MULT=y
> CONFIG_SERIO_ARC_PS2=y
> CONFIG_SERIO_APBPS2=y
> # CONFIG_SERIO_OLPC_APSP is not set
> # CONFIG_SERIO_SUN4I_PS2 is not set
> CONFIG_SERIO_GPIO_PS2=y
> # CONFIG_USERIO is not set
> # CONFIG_GAMEPORT is not set
> # end of Hardware I/O ports
> # end of Input device support
> 
> #
> # Character devices
> #
> CONFIG_TTY=y
> # CONFIG_VT is not set
> # CONFIG_UNIX98_PTYS is not set
> # CONFIG_LEGACY_PTYS is not set
> # CONFIG_LDISC_AUTOLOAD is not set
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_EARLYCON=y
> CONFIG_SERIAL_8250=y
> # CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
> CONFIG_SERIAL_8250_16550A_VARIANTS=y
> CONFIG_SERIAL_8250_FINTEK=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_SERIAL_8250_MEN_MCB=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> # CONFIG_SERIAL_8250_MANY_PORTS is not set
> # CONFIG_SERIAL_8250_ASPEED_VUART is not set
> CONFIG_SERIAL_8250_SHARE_IRQ=y
> # CONFIG_SERIAL_8250_DETECT_IRQ is not set
> # CONFIG_SERIAL_8250_RSA is not set
> # CONFIG_SERIAL_8250_BCM2835AUX is not set
> CONFIG_SERIAL_8250_FSL=y
> # CONFIG_SERIAL_8250_DW is not set
> # CONFIG_SERIAL_8250_IOC3 is not set
> CONFIG_SERIAL_8250_RT288X=y
> # CONFIG_SERIAL_8250_OMAP is not set
> # CONFIG_SERIAL_8250_LPC18XX is not set
> # CONFIG_SERIAL_8250_MT6577 is not set
> # CONFIG_SERIAL_8250_UNIPHIER is not set
> # CONFIG_SERIAL_8250_INGENIC is not set
> # CONFIG_SERIAL_8250_PXA is not set
> CONFIG_SERIAL_8250_TEGRA=y
> # CONFIG_SERIAL_8250_BCM7271 is not set
> # CONFIG_SERIAL_OF_PLATFORM is not set
> 
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_AMBA_PL010 is not set
> # CONFIG_SERIAL_ATMEL is not set
> # CONFIG_SERIAL_MESON is not set
> # CONFIG_SERIAL_CLPS711X is not set
> # CONFIG_SERIAL_SAMSUNG is not set
> # CONFIG_SERIAL_TEGRA is not set
> # CONFIG_SERIAL_TEGRA_TCU is not set
> # CONFIG_SERIAL_IMX is not set
> # CONFIG_SERIAL_IMX_EARLYCON is not set
> # CONFIG_SERIAL_UARTLITE is not set
> # CONFIG_SERIAL_SH_SCI is not set
> # CONFIG_SERIAL_HS_LPC32XX is not set
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> CONFIG_CONSOLE_POLL=y
> CONFIG_SERIAL_CPM=y
> CONFIG_SERIAL_CPM_CONSOLE=y
> # CONFIG_SERIAL_MSM is not set
> # CONFIG_SERIAL_VT8500 is not set
> # CONFIG_SERIAL_OMAP is not set
> CONFIG_SERIAL_SIFIVE=y
> # CONFIG_SERIAL_SIFIVE_CONSOLE is not set
> # CONFIG_SERIAL_LANTIQ is not set
> CONFIG_SERIAL_QE=y
> CONFIG_SERIAL_SCCNXP=y
> # CONFIG_SERIAL_SCCNXP_CONSOLE is not set
> CONFIG_SERIAL_SC16IS7XX_CORE=y
> CONFIG_SERIAL_SC16IS7XX=y
> CONFIG_SERIAL_SC16IS7XX_I2C=y
> # CONFIG_SERIAL_TIMBERDALE is not set
> CONFIG_SERIAL_ALTERA_JTAGUART=y
> CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
> # CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS is not set
> # CONFIG_SERIAL_ALTERA_UART is not set
> # CONFIG_SERIAL_MXS_AUART is not set
> CONFIG_SERIAL_XILINX_PS_UART=y
> CONFIG_SERIAL_XILINX_PS_UART_CONSOLE=y
> # CONFIG_SERIAL_MPS2_UART is not set
> # CONFIG_SERIAL_ARC is not set
> CONFIG_SERIAL_FSL_LPUART=y
> # CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
> CONFIG_SERIAL_CONEXANT_DIGICOLOR=y
> # CONFIG_SERIAL_CONEXANT_DIGICOLOR_CONSOLE is not set
> # CONFIG_SERIAL_ST_ASC is not set
> CONFIG_SERIAL_MEN_Z135=y
> # CONFIG_SERIAL_STM32 is not set
> # CONFIG_SERIAL_MVEBU_UART is not set
> # CONFIG_SERIAL_OWL is not set
> # CONFIG_SERIAL_RDA is not set
> # CONFIG_SERIAL_MILBEAUT_USIO is not set
> CONFIG_SERIAL_LITEUART=y
> CONFIG_SERIAL_LITEUART_MAX_PORTS=1
> CONFIG_SERIAL_LITEUART_CONSOLE=y
> # end of Serial drivers
> 
> CONFIG_SERIAL_MCTRL_GPIO=y
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_PPC_EPAPR_HV_BYTECHAN is not set
> # CONFIG_N_GSM is not set
> CONFIG_NULL_TTY=y
> CONFIG_HVC_DRIVER=y
> CONFIG_HVC_UDBG=y
> # CONFIG_SERIAL_DEV_BUS is not set
> CONFIG_TTY_PRINTK=y
> CONFIG_TTY_PRINTK_LEVEL=6
> # CONFIG_PRINTER is not set
> # CONFIG_PPDEV is not set
> CONFIG_VIRTIO_CONSOLE=y
> CONFIG_IPMI_HANDLER=y
> CONFIG_IPMI_PLAT_DATA=y
> # CONFIG_IPMI_PANIC_EVENT is not set
> CONFIG_IPMI_DEVICE_INTERFACE=y
> CONFIG_IPMI_SI=y
> CONFIG_IPMI_SSIF=y
> CONFIG_IPMI_WATCHDOG=y
> CONFIG_IPMI_POWEROFF=y
> # CONFIG_ASPEED_KCS_IPMI_BMC is not set
> # CONFIG_NPCM7XX_KCS_IPMI_BMC is not set
> # CONFIG_ASPEED_BT_IPMI_BMC is not set
> CONFIG_IPMB_DEVICE_INTERFACE=y
> # CONFIG_HW_RANDOM is not set
> CONFIG_DEVMEM=y
> # CONFIG_NVRAM is not set
> # CONFIG_TCG_TPM is not set
> CONFIG_XILLYBUS_CLASS=y
> CONFIG_XILLYBUS=y
> # CONFIG_XILLYBUS_OF is not set
> # CONFIG_XILLYUSB is not set
> # CONFIG_RANDOM_TRUST_BOOTLOADER is not set
> # end of Character devices
> 
> #
> # I2C support
> #
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_COMPAT=y
> CONFIG_I2C_CHARDEV=y
> CONFIG_I2C_MUX=y
> 
> #
> # Multiplexer I2C Chip support
> #
> # CONFIG_I2C_ARB_GPIO_CHALLENGE is not set
> CONFIG_I2C_MUX_GPIO=y
> CONFIG_I2C_MUX_GPMUX=y
> # CONFIG_I2C_MUX_LTC4306 is not set
> CONFIG_I2C_MUX_PCA9541=y
> CONFIG_I2C_MUX_PCA954x=y
> CONFIG_I2C_MUX_PINCTRL=y
> CONFIG_I2C_MUX_REG=y
> CONFIG_I2C_DEMUX_PINCTRL=y
> CONFIG_I2C_MUX_MLXCPLD=y
> # end of Multiplexer I2C Chip support
> 
> # CONFIG_I2C_HELPER_AUTO is not set
> CONFIG_I2C_SMBUS=y
> 
> #
> # I2C Algorithms
> #
> CONFIG_I2C_ALGOBIT=y
> # CONFIG_I2C_ALGOPCF is not set
> CONFIG_I2C_ALGOPCA=y
> # end of I2C Algorithms
> 
> #
> # I2C Hardware Bus support
> #
> # CONFIG_I2C_HIX5HD2 is not set
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> # CONFIG_I2C_ALTERA is not set
> # CONFIG_I2C_ASPEED is not set
> # CONFIG_I2C_AT91 is not set
> # CONFIG_I2C_AXXIA is not set
> # CONFIG_I2C_BCM_IPROC is not set
> # CONFIG_I2C_BCM_KONA is not set
> CONFIG_I2C_BRCMSTB=y
> # CONFIG_I2C_CBUS_GPIO is not set
> CONFIG_I2C_CPM=y
> # CONFIG_I2C_DAVINCI is not set
> # CONFIG_I2C_DESIGNWARE_PLATFORM is not set
> # CONFIG_I2C_DIGICOLOR is not set
> # CONFIG_I2C_EXYNOS5 is not set
> CONFIG_I2C_GPIO=y
> CONFIG_I2C_GPIO_FAULT_INJECTOR=y
> # CONFIG_I2C_HIGHLANDER is not set
> # CONFIG_I2C_HISI is not set
> # CONFIG_I2C_IMG is not set
> # CONFIG_I2C_IMX_LPI2C is not set
> # CONFIG_I2C_IOP3XX is not set
> # CONFIG_I2C_JZ4780 is not set
> # CONFIG_I2C_LPC2K is not set
> CONFIG_I2C_MPC=y
> # CONFIG_I2C_MT65XX is not set
> # CONFIG_I2C_MT7621 is not set
> # CONFIG_I2C_MV64XXX is not set
> # CONFIG_I2C_MXS is not set
> # CONFIG_I2C_NPCM7XX is not set
> # CONFIG_I2C_OCORES is not set
> # CONFIG_I2C_OMAP is not set
> # CONFIG_I2C_OWL is not set
> CONFIG_I2C_PCA_PLATFORM=y
> # CONFIG_I2C_PNX is not set
> # CONFIG_I2C_PXA is not set
> # CONFIG_I2C_QCOM_CCI is not set
> # CONFIG_I2C_RIIC is not set
> # CONFIG_I2C_S3C2410 is not set
> # CONFIG_I2C_SH_MOBILE is not set
> # CONFIG_I2C_SIMTEC is not set
> # CONFIG_I2C_ST is not set
> # CONFIG_I2C_STM32F4 is not set
> # CONFIG_I2C_STM32F7 is not set
> # CONFIG_I2C_SUN6I_P2WI is not set
> # CONFIG_I2C_SYNQUACER is not set
> # CONFIG_I2C_TEGRA_BPMP is not set
> # CONFIG_I2C_UNIPHIER is not set
> # CONFIG_I2C_UNIPHIER_F is not set
> # CONFIG_I2C_VERSATILE is not set
> # CONFIG_I2C_WMT is not set
> # CONFIG_I2C_XILINX is not set
> # CONFIG_I2C_XLR is not set
> # CONFIG_I2C_XLP9XX is not set
> # CONFIG_I2C_RCAR is not set
> 
> #
> # External I2C/SMBus adapter drivers
> #
> # CONFIG_I2C_DIOLAN_U2C is not set
> CONFIG_I2C_DLN2=y
> CONFIG_I2C_CP2615=y
> CONFIG_I2C_PARPORT=y
> # CONFIG_I2C_ROBOTFUZZ_OSIF is not set
> CONFIG_I2C_TAOS_EVM=y
> CONFIG_I2C_TINY_USB=y
> CONFIG_I2C_VIPERBOARD=y
> 
> #
> # Other I2C/SMBus bus drivers
> #
> # CONFIG_I2C_MLXCPLD is not set
> # CONFIG_I2C_FSI is not set
> CONFIG_I2C_VIRTIO=y
> # end of I2C Hardware Bus support
> 
> CONFIG_I2C_SLAVE=y
> CONFIG_I2C_SLAVE_EEPROM=y
> CONFIG_I2C_SLAVE_TESTUNIT=y
> # CONFIG_I2C_DEBUG_CORE is not set
> CONFIG_I2C_DEBUG_ALGO=y
> # CONFIG_I2C_DEBUG_BUS is not set
> # end of I2C support
> 
> CONFIG_I3C=y
> # CONFIG_CDNS_I3C_MASTER is not set
> # CONFIG_DW_I3C_MASTER is not set
> # CONFIG_SVC_I3C_MASTER is not set
> CONFIG_MIPI_I3C_HCI=y
> # CONFIG_SPI is not set
> CONFIG_SPMI=y
> CONFIG_SPMI_HISI3670=y
> # CONFIG_SPMI_MSM_PMIC_ARB is not set
> # CONFIG_HSI is not set
> CONFIG_PPS=y
> # CONFIG_PPS_DEBUG is not set
> # CONFIG_NTP_PPS is not set
> 
> #
> # PPS clients support
> #
> # CONFIG_PPS_CLIENT_KTIMER is not set
> # CONFIG_PPS_CLIENT_LDISC is not set
> # CONFIG_PPS_CLIENT_PARPORT is not set
> # CONFIG_PPS_CLIENT_GPIO is not set
> 
> #
> # PPS generators support
> #
> 
> #
> # PTP clock support
> #
> # CONFIG_PTP_1588_CLOCK is not set
> CONFIG_PTP_1588_CLOCK_OPTIONAL=y
> 
> #
> # Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
> #
> # end of PTP clock support
> 
> CONFIG_PINCTRL=y
> CONFIG_GENERIC_PINCTRL_GROUPS=y
> CONFIG_PINMUX=y
> CONFIG_GENERIC_PINMUX_FUNCTIONS=y
> CONFIG_PINCONF=y
> CONFIG_GENERIC_PINCONF=y
> # CONFIG_DEBUG_PINCTRL is not set
> CONFIG_PINCTRL_AS3722=y
> CONFIG_PINCTRL_AXP209=y
> # CONFIG_PINCTRL_AT91PIO4 is not set
> # CONFIG_PINCTRL_AMD is not set
> # CONFIG_PINCTRL_BM1880 is not set
> # CONFIG_PINCTRL_DA850_PUPD is not set
> # CONFIG_PINCTRL_DA9062 is not set
> # CONFIG_PINCTRL_LPC18XX is not set
> # CONFIG_PINCTRL_MCP23S08 is not set
> # CONFIG_PINCTRL_ROCKCHIP is not set
> # CONFIG_PINCTRL_SINGLE is not set
> CONFIG_PINCTRL_SX150X=y
> # CONFIG_PINCTRL_PISTACHIO is not set
> CONFIG_PINCTRL_STMFX=y
> # CONFIG_PINCTRL_INGENIC is not set
> # CONFIG_PINCTRL_OCELOT is not set
> CONFIG_PINCTRL_MICROCHIP_SGPIO=y
> # CONFIG_PINCTRL_OWL is not set
> # CONFIG_PINCTRL_ASPEED_G4 is not set
> # CONFIG_PINCTRL_ASPEED_G5 is not set
> # CONFIG_PINCTRL_ASPEED_G6 is not set
> # CONFIG_PINCTRL_BCM281XX is not set
> # CONFIG_PINCTRL_BCM2835 is not set
> # CONFIG_PINCTRL_BCM6318 is not set
> # CONFIG_PINCTRL_BCM6328 is not set
> # CONFIG_PINCTRL_BCM6358 is not set
> # CONFIG_PINCTRL_BCM6362 is not set
> # CONFIG_PINCTRL_BCM6368 is not set
> # CONFIG_PINCTRL_BCM63268 is not set
> # CONFIG_PINCTRL_IPROC_GPIO is not set
> # CONFIG_PINCTRL_CYGNUS_MUX is not set
> # CONFIG_PINCTRL_NS is not set
> # CONFIG_PINCTRL_NSP_GPIO is not set
> # CONFIG_PINCTRL_NS2_MUX is not set
> # CONFIG_PINCTRL_NSP_MUX is not set
> # CONFIG_PINCTRL_AS370 is not set
> # CONFIG_PINCTRL_BERLIN_BG4CT is not set
> # CONFIG_PINCTRL_NPCM7XX is not set
> # CONFIG_PINCTRL_PXA25X is not set
> # CONFIG_PINCTRL_PXA27X is not set
> # CONFIG_PINCTRL_MSM is not set
> # CONFIG_PINCTRL_QCOM_SPMI_PMIC is not set
> # CONFIG_PINCTRL_QCOM_SSBI_PMIC is not set
> # CONFIG_PINCTRL_LPASS_LPI is not set
> 
> #
> # Renesas pinctrl drivers
> #
> # CONFIG_PINCTRL_RENESAS is not set
> # CONFIG_PINCTRL_PFC_EMEV2 is not set
> # CONFIG_PINCTRL_PFC_R8A77995 is not set
> # CONFIG_PINCTRL_PFC_R8A7794 is not set
> # CONFIG_PINCTRL_PFC_R8A77990 is not set
> # CONFIG_PINCTRL_PFC_R8A7779 is not set
> # CONFIG_PINCTRL_PFC_R8A7790 is not set
> # CONFIG_PINCTRL_PFC_R8A77950 is not set
> # CONFIG_PINCTRL_PFC_R8A77951 is not set
> # CONFIG_PINCTRL_PFC_R8A7778 is not set
> # CONFIG_PINCTRL_PFC_R8A7793 is not set
> # CONFIG_PINCTRL_PFC_R8A7791 is not set
> # CONFIG_PINCTRL_PFC_R8A77965 is not set
> # CONFIG_PINCTRL_PFC_R8A77960 is not set
> # CONFIG_PINCTRL_PFC_R8A77961 is not set
> # CONFIG_PINCTRL_PFC_R8A7792 is not set
> # CONFIG_PINCTRL_PFC_R8A77980 is not set
> # CONFIG_PINCTRL_PFC_R8A77970 is not set
> # CONFIG_PINCTRL_PFC_R8A779A0 is not set
> # CONFIG_PINCTRL_PFC_R8A7740 is not set
> # CONFIG_PINCTRL_PFC_R8A73A4 is not set
> # CONFIG_PINCTRL_RZA1 is not set
> # CONFIG_PINCTRL_RZA2 is not set
> # CONFIG_PINCTRL_RZG2L is not set
> # CONFIG_PINCTRL_PFC_R8A77470 is not set
> # CONFIG_PINCTRL_PFC_R8A7745 is not set
> # CONFIG_PINCTRL_PFC_R8A7742 is not set
> # CONFIG_PINCTRL_PFC_R8A7743 is not set
> # CONFIG_PINCTRL_PFC_R8A7744 is not set
> # CONFIG_PINCTRL_PFC_R8A774C0 is not set
> # CONFIG_PINCTRL_PFC_R8A774E1 is not set
> # CONFIG_PINCTRL_PFC_R8A774A1 is not set
> # CONFIG_PINCTRL_PFC_R8A774B1 is not set
> # CONFIG_PINCTRL_RZN1 is not set
> # CONFIG_PINCTRL_PFC_SH7203 is not set
> # CONFIG_PINCTRL_PFC_SH7264 is not set
> # CONFIG_PINCTRL_PFC_SH7269 is not set
> # CONFIG_PINCTRL_PFC_SH7720 is not set
> # CONFIG_PINCTRL_PFC_SH7722 is not set
> # CONFIG_PINCTRL_PFC_SH7734 is not set
> # CONFIG_PINCTRL_PFC_SH7757 is not set
> # CONFIG_PINCTRL_PFC_SH7785 is not set
> # CONFIG_PINCTRL_PFC_SH7786 is not set
> # CONFIG_PINCTRL_PFC_SH73A0 is not set
> # CONFIG_PINCTRL_PFC_SH7723 is not set
> # CONFIG_PINCTRL_PFC_SH7724 is not set
> # CONFIG_PINCTRL_PFC_SHX3 is not set
> # end of Renesas pinctrl drivers
> 
> # CONFIG_PINCTRL_EXYNOS is not set
> # CONFIG_PINCTRL_S3C24XX is not set
> # CONFIG_PINCTRL_S3C64XX is not set
> # CONFIG_PINCTRL_SPRD_SC9860 is not set
> # CONFIG_PINCTRL_STM32F429 is not set
> # CONFIG_PINCTRL_STM32F469 is not set
> # CONFIG_PINCTRL_STM32F746 is not set
> # CONFIG_PINCTRL_STM32F769 is not set
> # CONFIG_PINCTRL_STM32H743 is not set
> # CONFIG_PINCTRL_STM32MP135 is not set
> # CONFIG_PINCTRL_STM32MP157 is not set
> # CONFIG_PINCTRL_TI_IODELAY is not set
> CONFIG_PINCTRL_UNIPHIER=y
> # CONFIG_PINCTRL_UNIPHIER_LD4 is not set
> # CONFIG_PINCTRL_UNIPHIER_PRO4 is not set
> # CONFIG_PINCTRL_UNIPHIER_SLD8 is not set
> # CONFIG_PINCTRL_UNIPHIER_PRO5 is not set
> # CONFIG_PINCTRL_UNIPHIER_PXS2 is not set
> # CONFIG_PINCTRL_UNIPHIER_LD6B is not set
> # CONFIG_PINCTRL_UNIPHIER_LD11 is not set
> # CONFIG_PINCTRL_UNIPHIER_LD20 is not set
> # CONFIG_PINCTRL_UNIPHIER_PXS3 is not set
> 
> #
> # MediaTek pinctrl drivers
> #
> CONFIG_EINT_MTK=y
> CONFIG_PINCTRL_MTK=y
> # CONFIG_PINCTRL_MT2701 is not set
> # CONFIG_PINCTRL_MT7623 is not set
> # CONFIG_PINCTRL_MT7629 is not set
> # CONFIG_PINCTRL_MT8135 is not set
> # CONFIG_PINCTRL_MT8127 is not set
> # CONFIG_PINCTRL_MT2712 is not set
> # CONFIG_PINCTRL_MT6765 is not set
> # CONFIG_PINCTRL_MT6779 is not set
> # CONFIG_PINCTRL_MT6797 is not set
> # CONFIG_PINCTRL_MT7622 is not set
> # CONFIG_PINCTRL_MT8167 is not set
> # CONFIG_PINCTRL_MT8173 is not set
> # CONFIG_PINCTRL_MT8183 is not set
> # CONFIG_PINCTRL_MT8192 is not set
> # CONFIG_PINCTRL_MT8195 is not set
> # CONFIG_PINCTRL_MT8365 is not set
> # CONFIG_PINCTRL_MT8516 is not set
> CONFIG_PINCTRL_MT6397=y
> # end of MediaTek pinctrl drivers
> 
> CONFIG_PINCTRL_LOCHNAGAR=y
> CONFIG_PINCTRL_MADERA=y
> CONFIG_PINCTRL_CS47L35=y
> CONFIG_PINCTRL_CS47L85=y
> CONFIG_PINCTRL_CS47L90=y
> # CONFIG_PINCTRL_TMPV7700 is not set
> # CONFIG_PINCTRL_EQUILIBRIUM is not set
> CONFIG_GPIOLIB=y
> CONFIG_GPIOLIB_FASTPATH_LIMIT=512
> CONFIG_OF_GPIO=y
> CONFIG_GPIOLIB_IRQCHIP=y
> CONFIG_DEBUG_GPIO=y
> # CONFIG_GPIO_SYSFS is not set
> CONFIG_GPIO_CDEV=y
> # CONFIG_GPIO_CDEV_V1 is not set
> CONFIG_GPIO_GENERIC=y
> CONFIG_GPIO_MAX730X=y
> 
> #
> # Memory mapped GPIO drivers
> #
> # CONFIG_GPIO_74XX_MMIO is not set
> CONFIG_GPIO_ALTERA=y
> # CONFIG_GPIO_ASPEED is not set
> # CONFIG_GPIO_ASPEED_SGPIO is not set
> # CONFIG_GPIO_ATH79 is not set
> # CONFIG_GPIO_RASPBERRYPI_EXP is not set
> # CONFIG_GPIO_BCM_KONA is not set
> # CONFIG_GPIO_BCM_XGS_IPROC is not set
> # CONFIG_GPIO_BRCMSTB is not set
> # CONFIG_GPIO_CADENCE is not set
> # CONFIG_GPIO_CLPS711X is not set
> # CONFIG_GPIO_DWAPB is not set
> # CONFIG_GPIO_EIC_SPRD is not set
> # CONFIG_GPIO_EM is not set
> # CONFIG_GPIO_FTGPIO010 is not set
> # CONFIG_GPIO_GENERIC_PLATFORM is not set
> CONFIG_GPIO_GRGPIO=y
> # CONFIG_GPIO_HISI is not set
> CONFIG_GPIO_HLWD=y
> # CONFIG_GPIO_IOP is not set
> # CONFIG_GPIO_LOGICVC is not set
> # CONFIG_GPIO_LPC18XX is not set
> # CONFIG_GPIO_LPC32XX is not set
> CONFIG_GPIO_MB86S7X=y
> # CONFIG_GPIO_MENZ127 is not set
> # CONFIG_GPIO_MPC8XXX is not set
> # CONFIG_GPIO_MT7621 is not set
> # CONFIG_GPIO_MXC is not set
> # CONFIG_GPIO_MXS is not set
> # CONFIG_GPIO_PMIC_EIC_SPRD is not set
> # CONFIG_GPIO_PXA is not set
> # CONFIG_GPIO_RCAR is not set
> # CONFIG_GPIO_RDA is not set
> # CONFIG_GPIO_ROCKCHIP is not set
> # CONFIG_GPIO_SAMA5D2_PIOBU is not set
> # CONFIG_GPIO_SIFIVE is not set
> # CONFIG_GPIO_SNPS_CREG is not set
> # CONFIG_GPIO_SPRD is not set
> # CONFIG_GPIO_STP_XWAY is not set
> CONFIG_GPIO_SYSCON=y
> # CONFIG_GPIO_TEGRA is not set
> # CONFIG_GPIO_TEGRA186 is not set
> # CONFIG_GPIO_TS4800 is not set
> # CONFIG_GPIO_UNIPHIER is not set
> # CONFIG_GPIO_VISCONTI is not set
> # CONFIG_GPIO_WCD934X is not set
> # CONFIG_GPIO_XGENE_SB is not set
> CONFIG_GPIO_XILINX=y
> # CONFIG_GPIO_XLP is not set
> CONFIG_GPIO_AMD_FCH=y
> # CONFIG_GPIO_IDT3243X is not set
> # end of Memory mapped GPIO drivers
> 
> #
> # I2C GPIO expanders
> #
> # CONFIG_GPIO_ADP5588 is not set
> CONFIG_GPIO_ADNP=y
> CONFIG_GPIO_GW_PLD=y
> CONFIG_GPIO_MAX7300=y
> CONFIG_GPIO_MAX732X=y
> # CONFIG_GPIO_MAX732X_IRQ is not set
> CONFIG_GPIO_PCA953X=y
> # CONFIG_GPIO_PCA953X_IRQ is not set
> # CONFIG_GPIO_PCA9570 is not set
> # CONFIG_GPIO_PCF857X is not set
> # CONFIG_GPIO_TPIC2810 is not set
> # CONFIG_GPIO_TS4900 is not set
> # end of I2C GPIO expanders
> 
> #
> # MFD GPIO expanders
> #
> CONFIG_GPIO_ADP5520=y
> # CONFIG_GPIO_BD71815 is not set
> CONFIG_GPIO_BD71828=y
> CONFIG_GPIO_DA9052=y
> CONFIG_GPIO_DA9055=y
> # CONFIG_GPIO_DLN2 is not set
> CONFIG_GPIO_LP3943=y
> CONFIG_GPIO_LP873X=y
> CONFIG_GPIO_LP87565=y
> # CONFIG_GPIO_MADERA is not set
> CONFIG_GPIO_MAX77650=y
> # CONFIG_GPIO_SL28CPLD is not set
> # CONFIG_GPIO_STMPE is not set
> # CONFIG_GPIO_TC3589X is not set
> CONFIG_GPIO_TPS65086=y
> # CONFIG_GPIO_TPS65218 is not set
> # CONFIG_GPIO_TPS6586X is not set
> CONFIG_GPIO_TPS65910=y
> CONFIG_GPIO_TPS65912=y
> CONFIG_GPIO_TQMX86=y
> CONFIG_GPIO_TWL4030=y
> CONFIG_GPIO_WM8350=y
> CONFIG_GPIO_WM8994=y
> # end of MFD GPIO expanders
> 
> #
> # USB GPIO expanders
> #
> CONFIG_GPIO_VIPERBOARD=y
> # end of USB GPIO expanders
> 
> #
> # Virtual GPIO drivers
> #
> CONFIG_GPIO_AGGREGATOR=y
> CONFIG_GPIO_MOCKUP=y
> CONFIG_GPIO_VIRTIO=y
> # end of Virtual GPIO drivers
> 
> CONFIG_W1=y
> # CONFIG_W1_CON is not set
> 
> #
> # 1-wire Bus Masters
> #
> # CONFIG_W1_MASTER_DS2490 is not set
> CONFIG_W1_MASTER_DS2482=y
> # CONFIG_W1_MASTER_MXC is not set
> CONFIG_W1_MASTER_DS1WM=y
> CONFIG_W1_MASTER_GPIO=y
> CONFIG_W1_MASTER_SGI=y
> # end of 1-wire Bus Masters
> 
> #
> # 1-wire Slaves
> #
> CONFIG_W1_SLAVE_THERM=y
> CONFIG_W1_SLAVE_SMEM=y
> # CONFIG_W1_SLAVE_DS2405 is not set
> CONFIG_W1_SLAVE_DS2408=y
> # CONFIG_W1_SLAVE_DS2408_READBACK is not set
> # CONFIG_W1_SLAVE_DS2413 is not set
> CONFIG_W1_SLAVE_DS2406=y
> CONFIG_W1_SLAVE_DS2423=y
> # CONFIG_W1_SLAVE_DS2805 is not set
> CONFIG_W1_SLAVE_DS2430=y
> # CONFIG_W1_SLAVE_DS2431 is not set
> CONFIG_W1_SLAVE_DS2433=y
> # CONFIG_W1_SLAVE_DS2433_CRC is not set
> CONFIG_W1_SLAVE_DS2438=y
> CONFIG_W1_SLAVE_DS250X=y
> CONFIG_W1_SLAVE_DS2780=y
> CONFIG_W1_SLAVE_DS2781=y
> # CONFIG_W1_SLAVE_DS28E04 is not set
> CONFIG_W1_SLAVE_DS28E17=y
> # end of 1-wire Slaves
> 
> CONFIG_POWER_RESET=y
> # CONFIG_POWER_RESET_AS3722 is not set
> CONFIG_POWER_RESET_ATC260X=y
> # CONFIG_POWER_RESET_BRCMKONA is not set
> # CONFIG_POWER_RESET_BRCMSTB is not set
> # CONFIG_POWER_RESET_GEMINI_POWEROFF is not set
> CONFIG_POWER_RESET_GPIO=y
> CONFIG_POWER_RESET_GPIO_RESTART=y
> # CONFIG_POWER_RESET_LINKSTATION is not set
> # CONFIG_POWER_RESET_OCELOT_RESET is not set
> # CONFIG_POWER_RESET_LTC2952 is not set
> CONFIG_POWER_RESET_MT6323=y
> # CONFIG_POWER_RESET_RESTART is not set
> CONFIG_POWER_RESET_TPS65086=y
> # CONFIG_POWER_RESET_KEYSTONE is not set
> # CONFIG_POWER_RESET_SYSCON is not set
> # CONFIG_POWER_RESET_SYSCON_POWEROFF is not set
> # CONFIG_POWER_RESET_RMOBILE is not set
> CONFIG_REBOOT_MODE=y
> CONFIG_SYSCON_REBOOT_MODE=y
> # CONFIG_POWER_RESET_SC27XX is not set
> CONFIG_NVMEM_REBOOT_MODE=y
> CONFIG_POWER_SUPPLY=y
> CONFIG_POWER_SUPPLY_DEBUG=y
> # CONFIG_POWER_SUPPLY_HWMON is not set
> CONFIG_PDA_POWER=y
> CONFIG_GENERIC_ADC_BATTERY=y
> CONFIG_WM8350_POWER=y
> CONFIG_TEST_POWER=y
> CONFIG_BATTERY_88PM860X=y
> CONFIG_CHARGER_ADP5061=y
> CONFIG_BATTERY_ACT8945A=y
> # CONFIG_BATTERY_CW2015 is not set
> CONFIG_BATTERY_DS2760=y
> CONFIG_BATTERY_DS2780=y
> CONFIG_BATTERY_DS2781=y
> CONFIG_BATTERY_DS2782=y
> # CONFIG_BATTERY_LEGO_EV3 is not set
> # CONFIG_BATTERY_SBS is not set
> CONFIG_CHARGER_SBS=y
> CONFIG_MANAGER_SBS=y
> CONFIG_BATTERY_BQ27XXX=y
> # CONFIG_BATTERY_BQ27XXX_I2C is not set
> CONFIG_BATTERY_BQ27XXX_HDQ=y
> CONFIG_BATTERY_DA9030=y
> CONFIG_BATTERY_DA9052=y
> CONFIG_CHARGER_DA9150=y
> CONFIG_BATTERY_DA9150=y
> CONFIG_AXP20X_POWER=y
> CONFIG_BATTERY_MAX17040=y
> CONFIG_BATTERY_MAX17042=y
> CONFIG_BATTERY_MAX1721X=y
> # CONFIG_BATTERY_TWL4030_MADC is not set
> CONFIG_CHARGER_88PM860X=y
> CONFIG_CHARGER_PCF50633=y
> CONFIG_BATTERY_RX51=y
> # CONFIG_CHARGER_ISP1704 is not set
> # CONFIG_CHARGER_MAX8903 is not set
> CONFIG_CHARGER_TWL4030=y
> CONFIG_CHARGER_LP8727=y
> # CONFIG_CHARGER_GPIO is not set
> # CONFIG_CHARGER_LT3651 is not set
> CONFIG_CHARGER_LTC4162L=y
> # CONFIG_CHARGER_MAX14577 is not set
> # CONFIG_CHARGER_DETECTOR_MAX14656 is not set
> CONFIG_CHARGER_MAX77650=y
> CONFIG_CHARGER_BQ2415X=y
> CONFIG_CHARGER_BQ24190=y
> # CONFIG_CHARGER_BQ24257 is not set
> CONFIG_CHARGER_BQ24735=y
> CONFIG_CHARGER_BQ2515X=y
> CONFIG_CHARGER_BQ25890=y
> CONFIG_CHARGER_BQ25980=y
> # CONFIG_CHARGER_BQ256XX is not set
> # CONFIG_CHARGER_TPS65217 is not set
> CONFIG_BATTERY_GAUGE_LTC2941=y
> # CONFIG_BATTERY_GOLDFISH is not set
> CONFIG_BATTERY_RT5033=y
> # CONFIG_CHARGER_RT9455 is not set
> # CONFIG_CHARGER_SC2731 is not set
> # CONFIG_FUEL_GAUGE_SC27XX is not set
> CONFIG_CHARGER_BD99954=y
> # CONFIG_RN5T618_POWER is not set
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=y
> # CONFIG_HWMON_DEBUG_CHIP is not set
> 
> #
> # Native drivers
> #
> CONFIG_SENSORS_AD7414=y
> CONFIG_SENSORS_AD7418=y
> # CONFIG_SENSORS_ADM1021 is not set
> CONFIG_SENSORS_ADM1025=y
> # CONFIG_SENSORS_ADM1026 is not set
> # CONFIG_SENSORS_ADM1029 is not set
> # CONFIG_SENSORS_ADM1031 is not set
> CONFIG_SENSORS_ADM1177=y
> CONFIG_SENSORS_ADM9240=y
> CONFIG_SENSORS_ADT7X10=y
> CONFIG_SENSORS_ADT7410=y
> # CONFIG_SENSORS_ADT7411 is not set
> CONFIG_SENSORS_ADT7462=y
> # CONFIG_SENSORS_ADT7470 is not set
> CONFIG_SENSORS_ADT7475=y
> # CONFIG_SENSORS_AHT10 is not set
> CONFIG_SENSORS_AS370=y
> CONFIG_SENSORS_ASC7621=y
> CONFIG_SENSORS_AXI_FAN_CONTROL=y
> # CONFIG_SENSORS_ASPEED is not set
> CONFIG_SENSORS_ATXP1=y
> # CONFIG_SENSORS_BT1_PVT is not set
> # CONFIG_SENSORS_DRIVETEMP is not set
> # CONFIG_SENSORS_DS620 is not set
> CONFIG_SENSORS_DS1621=y
> CONFIG_SENSORS_DA9052_ADC=y
> CONFIG_SENSORS_DA9055=y
> # CONFIG_SENSORS_SPARX5 is not set
> CONFIG_SENSORS_F75375S=y
> # CONFIG_SENSORS_GSC is not set
> CONFIG_SENSORS_MC13783_ADC=y
> CONFIG_SENSORS_GL518SM=y
> CONFIG_SENSORS_GL520SM=y
> CONFIG_SENSORS_G760A=y
> CONFIG_SENSORS_G762=y
> CONFIG_SENSORS_GPIO_FAN=y
> CONFIG_SENSORS_HIH6130=y
> CONFIG_SENSORS_IBMAEM=y
> # CONFIG_SENSORS_IBMPEX is not set
> CONFIG_SENSORS_IIO_HWMON=y
> CONFIG_SENSORS_JC42=y
> CONFIG_SENSORS_POWR1220=y
> # CONFIG_SENSORS_LINEAGE is not set
> CONFIG_SENSORS_LOCHNAGAR=y
> CONFIG_SENSORS_LTC2945=y
> CONFIG_SENSORS_LTC2947=y
> CONFIG_SENSORS_LTC2947_I2C=y
> CONFIG_SENSORS_LTC2990=y
> CONFIG_SENSORS_LTC2992=y
> # CONFIG_SENSORS_LTC4151 is not set
> CONFIG_SENSORS_LTC4215=y
> CONFIG_SENSORS_LTC4222=y
> # CONFIG_SENSORS_LTC4245 is not set
> CONFIG_SENSORS_LTC4260=y
> CONFIG_SENSORS_LTC4261=y
> CONFIG_SENSORS_MAX127=y
> CONFIG_SENSORS_MAX16065=y
> CONFIG_SENSORS_MAX1619=y
> CONFIG_SENSORS_MAX1668=y
> CONFIG_SENSORS_MAX197=y
> CONFIG_SENSORS_MAX31730=y
> CONFIG_SENSORS_MAX6621=y
> CONFIG_SENSORS_MAX6639=y
> # CONFIG_SENSORS_MAX6642 is not set
> CONFIG_SENSORS_MAX6650=y
> CONFIG_SENSORS_MAX6697=y
> CONFIG_SENSORS_MAX31790=y
> # CONFIG_SENSORS_MCP3021 is not set
> # CONFIG_SENSORS_TC654 is not set
> CONFIG_SENSORS_TPS23861=y
> CONFIG_SENSORS_MENF21BMC_HWMON=y
> CONFIG_SENSORS_MR75203=y
> CONFIG_SENSORS_LM63=y
> # CONFIG_SENSORS_LM73 is not set
> CONFIG_SENSORS_LM75=y
> CONFIG_SENSORS_LM77=y
> CONFIG_SENSORS_LM78=y
> CONFIG_SENSORS_LM80=y
> CONFIG_SENSORS_LM83=y
> CONFIG_SENSORS_LM85=y
> CONFIG_SENSORS_LM87=y
> CONFIG_SENSORS_LM90=y
> CONFIG_SENSORS_LM92=y
> CONFIG_SENSORS_LM93=y
> CONFIG_SENSORS_LM95234=y
> CONFIG_SENSORS_LM95241=y
> # CONFIG_SENSORS_LM95245 is not set
> # CONFIG_SENSORS_NTC_THERMISTOR is not set
> CONFIG_SENSORS_NCT7802=y
> CONFIG_SENSORS_NPCM7XX=y
> # CONFIG_SENSORS_NSA320 is not set
> # CONFIG_SENSORS_OCC_P8_I2C is not set
> CONFIG_SENSORS_PCF8591=y
> CONFIG_PMBUS=y
> # CONFIG_SENSORS_PMBUS is not set
> CONFIG_SENSORS_ADM1266=y
> CONFIG_SENSORS_ADM1275=y
> CONFIG_SENSORS_BEL_PFE=y
> CONFIG_SENSORS_BPA_RS600=y
> CONFIG_SENSORS_FSP_3Y=y
> CONFIG_SENSORS_IBM_CFFPS=y
> CONFIG_SENSORS_DPS920AB=y
> # CONFIG_SENSORS_INSPUR_IPSPS is not set
> CONFIG_SENSORS_IR35221=y
> # CONFIG_SENSORS_IR36021 is not set
> CONFIG_SENSORS_IR38064=y
> # CONFIG_SENSORS_IRPS5401 is not set
> CONFIG_SENSORS_ISL68137=y
> # CONFIG_SENSORS_LM25066 is not set
> CONFIG_SENSORS_LTC2978=y
> CONFIG_SENSORS_LTC3815=y
> # CONFIG_SENSORS_MAX15301 is not set
> CONFIG_SENSORS_MAX16064=y
> CONFIG_SENSORS_MAX16601=y
> CONFIG_SENSORS_MAX20730=y
> CONFIG_SENSORS_MAX20751=y
> CONFIG_SENSORS_MAX31785=y
> # CONFIG_SENSORS_MAX34440 is not set
> # CONFIG_SENSORS_MAX8688 is not set
> CONFIG_SENSORS_MP2888=y
> CONFIG_SENSORS_MP2975=y
> # CONFIG_SENSORS_PIM4328 is not set
> CONFIG_SENSORS_PM6764TR=y
> # CONFIG_SENSORS_PXE1610 is not set
> CONFIG_SENSORS_Q54SJ108A2=y
> # CONFIG_SENSORS_STPDDC60 is not set
> CONFIG_SENSORS_TPS40422=y
> CONFIG_SENSORS_TPS53679=y
> CONFIG_SENSORS_UCD9000=y
> CONFIG_SENSORS_UCD9200=y
> CONFIG_SENSORS_XDPE122=y
> CONFIG_SENSORS_ZL6100=y
> # CONFIG_SENSORS_PWM_FAN is not set
> # CONFIG_SENSORS_RASPBERRYPI_HWMON is not set
> # CONFIG_SENSORS_SL28CPLD is not set
> CONFIG_SENSORS_SBTSI=y
> # CONFIG_SENSORS_SBRMI is not set
> CONFIG_SENSORS_SHT15=y
> # CONFIG_SENSORS_SHT21 is not set
> # CONFIG_SENSORS_SHT3x is not set
> # CONFIG_SENSORS_SHT4x is not set
> CONFIG_SENSORS_SHTC1=y
> # CONFIG_SENSORS_EMC1403 is not set
> CONFIG_SENSORS_EMC2103=y
> CONFIG_SENSORS_EMC6W201=y
> # CONFIG_SENSORS_SMSC47M192 is not set
> CONFIG_SENSORS_STTS751=y
> # CONFIG_SENSORS_SMM665 is not set
> CONFIG_SENSORS_ADC128D818=y
> CONFIG_SENSORS_ADS7828=y
> CONFIG_SENSORS_AMC6821=y
> # CONFIG_SENSORS_INA209 is not set
> CONFIG_SENSORS_INA2XX=y
> # CONFIG_SENSORS_INA3221 is not set
> CONFIG_SENSORS_TC74=y
> # CONFIG_SENSORS_THMC50 is not set
> CONFIG_SENSORS_TMP102=y
> CONFIG_SENSORS_TMP103=y
> # CONFIG_SENSORS_TMP108 is not set
> CONFIG_SENSORS_TMP401=y
> # CONFIG_SENSORS_TMP421 is not set
> # CONFIG_SENSORS_TMP513 is not set
> # CONFIG_SENSORS_W83773G is not set
> CONFIG_SENSORS_W83781D=y
> # CONFIG_SENSORS_W83791D is not set
> # CONFIG_SENSORS_W83792D is not set
> CONFIG_SENSORS_W83793=y
> # CONFIG_SENSORS_W83795 is not set
> # CONFIG_SENSORS_W83L785TS is not set
> CONFIG_SENSORS_W83L786NG=y
> CONFIG_SENSORS_WM8350=y
> CONFIG_THERMAL=y
> # CONFIG_THERMAL_NETLINK is not set
> CONFIG_THERMAL_STATISTICS=y
> CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
> CONFIG_THERMAL_HWMON=y
> # CONFIG_THERMAL_OF is not set
> CONFIG_THERMAL_WRITABLE_TRIPS=y
> CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
> # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
> CONFIG_THERMAL_GOV_FAIR_SHARE=y
> CONFIG_THERMAL_GOV_STEP_WISE=y
> # CONFIG_THERMAL_GOV_BANG_BANG is not set
> CONFIG_THERMAL_GOV_USER_SPACE=y
> # CONFIG_DEVFREQ_THERMAL is not set
> # CONFIG_THERMAL_EMULATION is not set
> # CONFIG_THERMAL_MMIO is not set
> CONFIG_HISI_THERMAL=y
> # CONFIG_IMX_THERMAL is not set
> # CONFIG_IMX8MM_THERMAL is not set
> # CONFIG_K3_THERMAL is not set
> # CONFIG_SPEAR_THERMAL is not set
> # CONFIG_SUN8I_THERMAL is not set
> # CONFIG_ROCKCHIP_THERMAL is not set
> # CONFIG_RCAR_THERMAL is not set
> # CONFIG_RCAR_GEN3_THERMAL is not set
> # CONFIG_KIRKWOOD_THERMAL is not set
> # CONFIG_DOVE_THERMAL is not set
> # CONFIG_ARMADA_THERMAL is not set
> CONFIG_DA9062_THERMAL=y
> CONFIG_MTK_THERMAL=y
> 
> #
> # Intel thermal drivers
> #
> 
> #
> # ACPI INT340X thermal drivers
> #
> # end of ACPI INT340X thermal drivers
> # end of Intel thermal drivers
> 
> #
> # Broadcom thermal drivers
> #
> # CONFIG_BRCMSTB_THERMAL is not set
> # CONFIG_BCM_NS_THERMAL is not set
> # CONFIG_BCM_SR_THERMAL is not set
> # end of Broadcom thermal drivers
> 
> #
> # Texas Instruments thermal drivers
> #
> # CONFIG_TI_SOC_THERMAL is not set
> # end of Texas Instruments thermal drivers
> 
> #
> # Samsung thermal drivers
> #
> # end of Samsung thermal drivers
> 
> #
> # NVIDIA Tegra thermal drivers
> #
> # CONFIG_TEGRA_SOCTHERM is not set
> # CONFIG_TEGRA_BPMP_THERMAL is not set
> # CONFIG_TEGRA30_TSENSOR is not set
> # end of NVIDIA Tegra thermal drivers
> 
> CONFIG_GENERIC_ADC_THERMAL=y
> 
> #
> # Qualcomm thermal drivers
> #
> # CONFIG_QCOM_SPMI_ADC_TM5 is not set
> # CONFIG_QCOM_SPMI_TEMP_ALARM is not set
> # end of Qualcomm thermal drivers
> 
> # CONFIG_SPRD_THERMAL is not set
> # CONFIG_WATCHDOG is not set
> CONFIG_SSB_POSSIBLE=y
> CONFIG_SSB=y
> CONFIG_SSB_SDIOHOST_POSSIBLE=y
> CONFIG_SSB_SDIOHOST=y
> # CONFIG_SSB_DRIVER_GPIO is not set
> CONFIG_BCMA_POSSIBLE=y
> CONFIG_BCMA=y
> CONFIG_BCMA_HOST_SOC=y
> # CONFIG_BCMA_DRIVER_MIPS is not set
> CONFIG_BCMA_SFLASH=y
> # CONFIG_BCMA_DRIVER_GMAC_CMN is not set
> CONFIG_BCMA_DRIVER_GPIO=y
> # CONFIG_BCMA_DEBUG is not set
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=y
> CONFIG_MFD_ACT8945A=y
> # CONFIG_MFD_SUN4I_GPADC is not set
> # CONFIG_MFD_AS3711 is not set
> CONFIG_MFD_AS3722=y
> CONFIG_PMIC_ADP5520=y
> # CONFIG_MFD_AAT2870_CORE is not set
> # CONFIG_MFD_AT91_USART is not set
> # CONFIG_MFD_ATMEL_FLEXCOM is not set
> CONFIG_MFD_ATMEL_HLCDC=y
> # CONFIG_MFD_BCM590XX is not set
> # CONFIG_MFD_BD9571MWV is not set
> CONFIG_MFD_AXP20X=y
> CONFIG_MFD_AXP20X_I2C=y
> CONFIG_MFD_MADERA=y
> CONFIG_MFD_MADERA_I2C=y
> # CONFIG_MFD_CS47L15 is not set
> CONFIG_MFD_CS47L35=y
> CONFIG_MFD_CS47L85=y
> CONFIG_MFD_CS47L90=y
> # CONFIG_MFD_CS47L92 is not set
> # CONFIG_MFD_ASIC3 is not set
> CONFIG_PMIC_DA903X=y
> CONFIG_PMIC_DA9052=y
> CONFIG_MFD_DA9052_I2C=y
> CONFIG_MFD_DA9055=y
> CONFIG_MFD_DA9062=y
> # CONFIG_MFD_DA9063 is not set
> CONFIG_MFD_DA9150=y
> CONFIG_MFD_DLN2=y
> # CONFIG_MFD_ENE_KB3930 is not set
> # CONFIG_MFD_EXYNOS_LPASS is not set
> CONFIG_MFD_GATEWORKS_GSC=y
> CONFIG_MFD_MC13XXX=y
> CONFIG_MFD_MC13XXX_I2C=y
> CONFIG_MFD_MP2629=y
> # CONFIG_MFD_MXS_LRADC is not set
> # CONFIG_MFD_MX25_TSADC is not set
> # CONFIG_MFD_HI6421_PMIC is not set
> # CONFIG_MFD_HI6421_SPMI is not set
> # CONFIG_MFD_HI655X_PMIC is not set
> CONFIG_HTC_PASIC3=y
> # CONFIG_HTC_I2CPLD is not set
> CONFIG_MFD_IQS62X=y
> # CONFIG_MFD_KEMPLD is not set
> # CONFIG_MFD_88PM800 is not set
> CONFIG_MFD_88PM805=y
> CONFIG_MFD_88PM860X=y
> CONFIG_MFD_MAX14577=y
> # CONFIG_MFD_MAX77620 is not set
> CONFIG_MFD_MAX77650=y
> # CONFIG_MFD_MAX77686 is not set
> # CONFIG_MFD_MAX77693 is not set
> # CONFIG_MFD_MAX77843 is not set
> # CONFIG_MFD_MAX8907 is not set
> # CONFIG_MFD_MAX8925 is not set
> CONFIG_MFD_MAX8997=y
> CONFIG_MFD_MAX8998=y
> # CONFIG_MFD_MT6360 is not set
> CONFIG_MFD_MT6397=y
> CONFIG_MFD_MENF21BMC=y
> CONFIG_MFD_VIPERBOARD=y
> # CONFIG_MFD_NTXEC is not set
> # CONFIG_MFD_RETU is not set
> CONFIG_MFD_PCF50633=y
> # CONFIG_PCF50633_ADC is not set
> CONFIG_PCF50633_GPIO=y
> # CONFIG_MFD_PM8XXX is not set
> # CONFIG_MFD_SPMI_PMIC is not set
> # CONFIG_MFD_RT4831 is not set
> CONFIG_MFD_RT5033=y
> # CONFIG_MFD_RC5T583 is not set
> # CONFIG_MFD_RK808 is not set
> CONFIG_MFD_RN5T618=y
> # CONFIG_MFD_SEC_CORE is not set
> CONFIG_MFD_SI476X_CORE=y
> # CONFIG_MFD_SL28CPLD is not set
> CONFIG_MFD_SM501=y
> # CONFIG_MFD_SM501_GPIO is not set
> CONFIG_MFD_SKY81452=y
> # CONFIG_ABX500_CORE is not set
> CONFIG_MFD_STMPE=y
> 
> #
> # STMicroelectronics STMPE Interface Drivers
> #
> CONFIG_STMPE_I2C=y
> # end of STMicroelectronics STMPE Interface Drivers
> 
> # CONFIG_MFD_SUN6I_PRCM is not set
> CONFIG_MFD_SYSCON=y
> CONFIG_MFD_TI_AM335X_TSCADC=y
> CONFIG_MFD_LP3943=y
> # CONFIG_MFD_LP8788 is not set
> CONFIG_MFD_TI_LMU=y
> # CONFIG_MFD_PALMAS is not set
> # CONFIG_TPS6105X is not set
> CONFIG_TPS65010=y
> # CONFIG_TPS6507X is not set
> CONFIG_MFD_TPS65086=y
> # CONFIG_MFD_TPS65090 is not set
> CONFIG_MFD_TPS65217=y
> CONFIG_MFD_TI_LP873X=y
> CONFIG_MFD_TI_LP87565=y
> CONFIG_MFD_TPS65218=y
> CONFIG_MFD_TPS6586X=y
> CONFIG_MFD_TPS65910=y
> CONFIG_MFD_TPS65912=y
> CONFIG_MFD_TPS65912_I2C=y
> # CONFIG_MFD_TPS80031 is not set
> CONFIG_TWL4030_CORE=y
> # CONFIG_MFD_TWL4030_AUDIO is not set
> # CONFIG_TWL6040_CORE is not set
> # CONFIG_MFD_WL1273_CORE is not set
> CONFIG_MFD_LM3533=y
> CONFIG_MFD_TC3589X=y
> CONFIG_MFD_TQMX86=y
> CONFIG_MFD_LOCHNAGAR=y
> # CONFIG_MFD_ARIZONA_I2C is not set
> # CONFIG_MFD_WM8400 is not set
> # CONFIG_MFD_WM831X_I2C is not set
> CONFIG_MFD_WM8350=y
> CONFIG_MFD_WM8350_I2C=y
> CONFIG_MFD_WM8994=y
> # CONFIG_MFD_STW481X is not set
> # CONFIG_MFD_ROHM_BD718XX is not set
> # CONFIG_MFD_ROHM_BD70528 is not set
> CONFIG_MFD_ROHM_BD71828=y
> CONFIG_MFD_ROHM_BD957XMUF=y
> # CONFIG_MFD_STM32_LPTIMER is not set
> # CONFIG_MFD_STM32_TIMERS is not set
> CONFIG_MFD_STPMIC1=y
> CONFIG_MFD_STMFX=y
> CONFIG_MFD_WCD934X=y
> CONFIG_MFD_ATC260X=y
> CONFIG_MFD_ATC260X_I2C=y
> # CONFIG_MFD_KHADAS_MCU is not set
> # CONFIG_MFD_ACER_A500_EC is not set
> CONFIG_MFD_QCOM_PM8008=y
> CONFIG_MFD_RSMU_I2C=y
> # end of Multifunction device drivers
> 
> # CONFIG_REGULATOR is not set
> CONFIG_CEC_CORE=y
> CONFIG_CEC_NOTIFIER=y
> CONFIG_MEDIA_CEC_SUPPORT=y
> CONFIG_CEC_CH7322=y
> # CONFIG_CEC_MESON_AO is not set
> # CONFIG_CEC_GPIO is not set
> # CONFIG_CEC_SAMSUNG_S5P is not set
> # CONFIG_CEC_STI is not set
> # CONFIG_CEC_STM32 is not set
> # CONFIG_CEC_TEGRA is not set
> # CONFIG_USB_PULSE8_CEC is not set
> CONFIG_USB_RAINSHADOW_CEC=y
> CONFIG_MEDIA_SUPPORT=y
> CONFIG_MEDIA_SUPPORT_FILTER=y
> # CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
> 
> #
> # Media device types
> #
> CONFIG_MEDIA_CAMERA_SUPPORT=y
> CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
> CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
> CONFIG_MEDIA_RADIO_SUPPORT=y
> # CONFIG_MEDIA_SDR_SUPPORT is not set
> CONFIG_MEDIA_PLATFORM_SUPPORT=y
> CONFIG_MEDIA_TEST_SUPPORT=y
> # end of Media device types
> 
> CONFIG_VIDEO_DEV=y
> CONFIG_MEDIA_CONTROLLER=y
> CONFIG_DVB_CORE=y
> 
> #
> # Video4Linux options
> #
> CONFIG_VIDEO_V4L2=y
> CONFIG_VIDEO_V4L2_I2C=y
> CONFIG_VIDEO_V4L2_SUBDEV_API=y
> CONFIG_VIDEO_ADV_DEBUG=y
> CONFIG_VIDEO_FIXED_MINOR_RANGES=y
> CONFIG_V4L2_MEM2MEM_DEV=y
> CONFIG_V4L2_FWNODE=y
> CONFIG_V4L2_ASYNC=y
> CONFIG_VIDEOBUF_GEN=y
> CONFIG_VIDEOBUF_DMA_CONTIG=y
> # end of Video4Linux options
> 
> #
> # Media controller options
> #
> # CONFIG_MEDIA_CONTROLLER_DVB is not set
> CONFIG_MEDIA_CONTROLLER_REQUEST_API=y
> 
> #
> # Please notice that the enabled Media controller Request API is EXPERIMENTAL
> #
> # end of Media controller options
> 
> #
> # Digital TV options
> #
> CONFIG_DVB_MMAP=y
> CONFIG_DVB_MAX_ADAPTERS=16
> CONFIG_DVB_DYNAMIC_MINORS=y
> CONFIG_DVB_DEMUX_SECTION_LOSS_LOG=y
> CONFIG_DVB_ULE_DEBUG=y
> # end of Digital TV options
> 
> #
> # Media drivers
> #
> 
> #
> # Drivers filtered as selected at 'Filter media drivers'
> #
> # CONFIG_MEDIA_USB_SUPPORT is not set
> # CONFIG_RADIO_ADAPTERS is not set
> CONFIG_MEDIA_COMMON_OPTIONS=y
> 
> #
> # common driver options
> #
> CONFIG_VIDEOBUF2_CORE=y
> CONFIG_VIDEOBUF2_V4L2=y
> CONFIG_VIDEOBUF2_MEMOPS=y
> CONFIG_VIDEOBUF2_DMA_CONTIG=y
> CONFIG_VIDEOBUF2_VMALLOC=y
> CONFIG_VIDEOBUF2_DMA_SG=y
> CONFIG_SMS_SIANO_MDTV=y
> CONFIG_VIDEO_V4L2_TPG=y
> CONFIG_V4L_PLATFORM_DRIVERS=y
> # CONFIG_VIDEO_CADENCE is not set
> # CONFIG_VIDEO_DAVINCI_VPIF_DISPLAY is not set
> # CONFIG_VIDEO_DAVINCI_VPIF_CAPTURE is not set
> # CONFIG_VIDEO_DM6446_CCDC is not set
> # CONFIG_VIDEO_DM355_CCDC is not set
> # CONFIG_VIDEO_DM365_ISIF is not set
> # CONFIG_VIDEO_DAVINCI_VPBE_DISPLAY is not set
> # CONFIG_VIDEO_OMAP2_VOUT is not set
> CONFIG_VIDEO_ASPEED=y
> # CONFIG_VIDEO_SH_VOU is not set
> CONFIG_VIDEO_VIU=y
> CONFIG_VIDEO_MUX=y
> # CONFIG_VIDEO_PXA27x is not set
> # CONFIG_VIDEO_QCOM_CAMSS is not set
> # CONFIG_VIDEO_S3C_CAMIF is not set
> # CONFIG_VIDEO_STM32_DCMI is not set
> # CONFIG_VIDEO_RENESAS_CEU is not set
> # CONFIG_VIDEO_ROCKCHIP_ISP1 is not set
> # CONFIG_VIDEO_AM437X_VPFE is not set
> CONFIG_VIDEO_XILINX=y
> # CONFIG_VIDEO_XILINX_CSI2RXSS is not set
> CONFIG_VIDEO_XILINX_TPG=y
> CONFIG_VIDEO_XILINX_VTC=y
> # CONFIG_VIDEO_RCAR_CSI2 is not set
> # CONFIG_VIDEO_RCAR_VIN is not set
> # CONFIG_VIDEO_ATMEL_ISI is not set
> # CONFIG_VIDEO_TI_CAL is not set
> CONFIG_V4L_MEM2MEM_DRIVERS=y
> # CONFIG_VIDEO_ALLEGRO_DVT is not set
> # CONFIG_VIDEO_CODA is not set
> # CONFIG_VIDEO_IMX_PXP is not set
> # CONFIG_VIDEO_IMX8_JPEG is not set
> # CONFIG_VIDEO_MEDIATEK_JPEG is not set
> # CONFIG_VIDEO_MEDIATEK_VPU is not set
> # CONFIG_VIDEO_MEDIATEK_MDP is not set
> CONFIG_VIDEO_MEM2MEM_DEINTERLACE=y
> # CONFIG_VIDEO_MESON_GE2D is not set
> # CONFIG_VIDEO_SAMSUNG_S5P_G2D is not set
> # CONFIG_VIDEO_SAMSUNG_S5P_JPEG is not set
> # CONFIG_VIDEO_SAMSUNG_S5P_MFC is not set
> # CONFIG_VIDEO_MX2_EMMAPRP is not set
> # CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC is not set
> # CONFIG_VIDEO_STI_BDISP is not set
> # CONFIG_VIDEO_STI_HVA is not set
> # CONFIG_VIDEO_STI_DELTA is not set
> # CONFIG_VIDEO_RENESAS_FDP1 is not set
> # CONFIG_VIDEO_RENESAS_JPU is not set
> # CONFIG_VIDEO_RENESAS_FCP is not set
> # CONFIG_VIDEO_RENESAS_VSP1 is not set
> # CONFIG_VIDEO_ROCKCHIP_RGA is not set
> # CONFIG_VIDEO_TI_VPE is not set
> # CONFIG_DVB_PLATFORM_DRIVERS is not set
> 
> #
> # MMC/SDIO DVB adapters
> #
> CONFIG_SMS_SDIO_DRV=y
> CONFIG_V4L_TEST_DRIVERS=y
> # CONFIG_VIDEO_VIMC is not set
> CONFIG_VIDEO_VIVID=y
> CONFIG_VIDEO_VIVID_CEC=y
> CONFIG_VIDEO_VIVID_MAX_DEVS=64
> CONFIG_VIDEO_VIM2M=y
> CONFIG_VIDEO_VICODEC=y
> CONFIG_DVB_TEST_DRIVERS=y
> CONFIG_DVB_VIDTV=y
> # end of Media drivers
> 
> #
> # Media ancillary drivers
> #
> 
> #
> # Audio decoders, processors and mixers
> #
> CONFIG_VIDEO_TVAUDIO=y
> CONFIG_VIDEO_TDA7432=y
> CONFIG_VIDEO_TDA9840=y
> CONFIG_VIDEO_TEA6415C=y
> CONFIG_VIDEO_TEA6420=y
> # CONFIG_VIDEO_MSP3400 is not set
> # CONFIG_VIDEO_CS3308 is not set
> CONFIG_VIDEO_CS5345=y
> CONFIG_VIDEO_CS53L32A=y
> CONFIG_VIDEO_TLV320AIC23B=y
> CONFIG_VIDEO_UDA1342=y
> CONFIG_VIDEO_WM8775=y
> # CONFIG_VIDEO_WM8739 is not set
> CONFIG_VIDEO_VP27SMPX=y
> CONFIG_VIDEO_SONY_BTF_MPX=y
> # end of Audio decoders, processors and mixers
> 
> #
> # RDS decoders
> #
> CONFIG_VIDEO_SAA6588=y
> # end of RDS decoders
> 
> #
> # Video decoders
> #
> CONFIG_VIDEO_ADV7180=y
> # CONFIG_VIDEO_ADV7183 is not set
> # CONFIG_VIDEO_ADV748X is not set
> # CONFIG_VIDEO_ADV7604 is not set
> CONFIG_VIDEO_ADV7842=y
> # CONFIG_VIDEO_ADV7842_CEC is not set
> # CONFIG_VIDEO_BT819 is not set
> CONFIG_VIDEO_BT856=y
> CONFIG_VIDEO_BT866=y
> # CONFIG_VIDEO_KS0127 is not set
> CONFIG_VIDEO_ML86V7667=y
> # CONFIG_VIDEO_SAA7110 is not set
> CONFIG_VIDEO_SAA711X=y
> # CONFIG_VIDEO_TC358743 is not set
> # CONFIG_VIDEO_TVP514X is not set
> # CONFIG_VIDEO_TVP5150 is not set
> CONFIG_VIDEO_TVP7002=y
> CONFIG_VIDEO_TW2804=y
> # CONFIG_VIDEO_TW9903 is not set
> # CONFIG_VIDEO_TW9906 is not set
> CONFIG_VIDEO_TW9910=y
> CONFIG_VIDEO_VPX3220=y
> # CONFIG_VIDEO_MAX9286 is not set
> 
> #
> # Video and audio decoders
> #
> CONFIG_VIDEO_SAA717X=y
> CONFIG_VIDEO_CX25840=y
> # end of Video decoders
> 
> #
> # Video encoders
> #
> # CONFIG_VIDEO_SAA7127 is not set
> CONFIG_VIDEO_SAA7185=y
> CONFIG_VIDEO_ADV7170=y
> # CONFIG_VIDEO_ADV7175 is not set
> # CONFIG_VIDEO_ADV7343 is not set
> CONFIG_VIDEO_ADV7393=y
> # CONFIG_VIDEO_ADV7511 is not set
> CONFIG_VIDEO_AD9389B=y
> CONFIG_VIDEO_AK881X=y
> # CONFIG_VIDEO_THS8200 is not set
> # end of Video encoders
> 
> #
> # Video improvement chips
> #
> CONFIG_VIDEO_UPD64031A=y
> # CONFIG_VIDEO_UPD64083 is not set
> # end of Video improvement chips
> 
> #
> # Audio/Video compression chips
> #
> # CONFIG_VIDEO_SAA6752HS is not set
> # end of Audio/Video compression chips
> 
> #
> # SDR tuner chips
> #
> # end of SDR tuner chips
> 
> #
> # Miscellaneous helper chips
> #
> # CONFIG_VIDEO_THS7303 is not set
> # CONFIG_VIDEO_M52790 is not set
> # CONFIG_VIDEO_I2C is not set
> # CONFIG_VIDEO_ST_MIPID02 is not set
> # end of Miscellaneous helper chips
> 
> #
> # Camera sensor devices
> #
> CONFIG_VIDEO_APTINA_PLL=y
> CONFIG_VIDEO_HI556=y
> # CONFIG_VIDEO_IMX208 is not set
> CONFIG_VIDEO_IMX214=y
> CONFIG_VIDEO_IMX219=y
> CONFIG_VIDEO_IMX258=y
> # CONFIG_VIDEO_IMX274 is not set
> CONFIG_VIDEO_IMX290=y
> CONFIG_VIDEO_IMX319=y
> CONFIG_VIDEO_IMX334=y
> CONFIG_VIDEO_IMX335=y
> CONFIG_VIDEO_IMX355=y
> # CONFIG_VIDEO_IMX412 is not set
> # CONFIG_VIDEO_OV02A10 is not set
> CONFIG_VIDEO_OV2640=y
> CONFIG_VIDEO_OV2659=y
> # CONFIG_VIDEO_OV2680 is not set
> CONFIG_VIDEO_OV2685=y
> # CONFIG_VIDEO_OV2740 is not set
> CONFIG_VIDEO_OV5640=y
> CONFIG_VIDEO_OV5645=y
> CONFIG_VIDEO_OV5647=y
> CONFIG_VIDEO_OV5648=y
> CONFIG_VIDEO_OV6650=y
> # CONFIG_VIDEO_OV5670 is not set
> CONFIG_VIDEO_OV5675=y
> # CONFIG_VIDEO_OV5695 is not set
> CONFIG_VIDEO_OV7251=y
> # CONFIG_VIDEO_OV772X is not set
> # CONFIG_VIDEO_OV7640 is not set
> CONFIG_VIDEO_OV7670=y
> CONFIG_VIDEO_OV7740=y
> CONFIG_VIDEO_OV8856=y
> CONFIG_VIDEO_OV8865=y
> CONFIG_VIDEO_OV9282=y
> # CONFIG_VIDEO_OV9640 is not set
> CONFIG_VIDEO_OV9650=y
> # CONFIG_VIDEO_OV9734 is not set
> CONFIG_VIDEO_OV13858=y
> CONFIG_VIDEO_VS6624=y
> CONFIG_VIDEO_MT9M001=y
> CONFIG_VIDEO_MT9M032=y
> CONFIG_VIDEO_MT9M111=y
> CONFIG_VIDEO_MT9P031=y
> # CONFIG_VIDEO_MT9T001 is not set
> # CONFIG_VIDEO_MT9T112 is not set
> CONFIG_VIDEO_MT9V011=y
> CONFIG_VIDEO_MT9V032=y
> # CONFIG_VIDEO_MT9V111 is not set
> # CONFIG_VIDEO_SR030PC30 is not set
> CONFIG_VIDEO_NOON010PC30=y
> # CONFIG_VIDEO_M5MOLS is not set
> CONFIG_VIDEO_MAX9271_LIB=y
> CONFIG_VIDEO_RDACM20=y
> # CONFIG_VIDEO_RDACM21 is not set
> CONFIG_VIDEO_RJ54N1=y
> # CONFIG_VIDEO_S5K6AA is not set
> CONFIG_VIDEO_S5K6A3=y
> CONFIG_VIDEO_S5K4ECGX=y
> CONFIG_VIDEO_S5K5BAF=y
> # CONFIG_VIDEO_ET8EK8 is not set
> # end of Camera sensor devices
> 
> #
> # Lens drivers
> #
> # CONFIG_VIDEO_AD5820 is not set
> CONFIG_VIDEO_AK7375=y
> CONFIG_VIDEO_DW9714=y
> CONFIG_VIDEO_DW9768=y
> CONFIG_VIDEO_DW9807_VCM=y
> # end of Lens drivers
> 
> #
> # Flash devices
> #
> CONFIG_VIDEO_ADP1653=y
> CONFIG_VIDEO_LM3560=y
> CONFIG_VIDEO_LM3646=y
> # end of Flash devices
> 
> #
> # SPI helper chips
> #
> # end of SPI helper chips
> 
> CONFIG_MEDIA_TUNER=y
> 
> #
> # Customize TV tuners
> #
> # CONFIG_MEDIA_TUNER_SIMPLE is not set
> CONFIG_MEDIA_TUNER_TDA18250=y
> CONFIG_MEDIA_TUNER_TDA8290=y
> CONFIG_MEDIA_TUNER_TDA827X=y
> CONFIG_MEDIA_TUNER_TDA18271=y
> CONFIG_MEDIA_TUNER_TDA9887=y
> CONFIG_MEDIA_TUNER_TEA5761=y
> CONFIG_MEDIA_TUNER_TEA5767=y
> CONFIG_MEDIA_TUNER_MT20XX=y
> CONFIG_MEDIA_TUNER_MT2060=y
> CONFIG_MEDIA_TUNER_MT2063=y
> # CONFIG_MEDIA_TUNER_MT2266 is not set
> CONFIG_MEDIA_TUNER_MT2131=y
> CONFIG_MEDIA_TUNER_QT1010=y
> CONFIG_MEDIA_TUNER_XC2028=y
> CONFIG_MEDIA_TUNER_XC5000=y
> # CONFIG_MEDIA_TUNER_XC4000 is not set
> # CONFIG_MEDIA_TUNER_MXL5005S is not set
> CONFIG_MEDIA_TUNER_MXL5007T=y
> CONFIG_MEDIA_TUNER_MC44S803=y
> CONFIG_MEDIA_TUNER_MAX2165=y
> CONFIG_MEDIA_TUNER_TDA18218=y
> # CONFIG_MEDIA_TUNER_FC0011 is not set
> CONFIG_MEDIA_TUNER_FC0012=y
> CONFIG_MEDIA_TUNER_FC0013=y
> CONFIG_MEDIA_TUNER_TDA18212=y
> CONFIG_MEDIA_TUNER_E4000=y
> # CONFIG_MEDIA_TUNER_FC2580 is not set
> CONFIG_MEDIA_TUNER_M88RS6000T=y
> CONFIG_MEDIA_TUNER_TUA9001=y
> CONFIG_MEDIA_TUNER_SI2157=y
> # CONFIG_MEDIA_TUNER_IT913X is not set
> CONFIG_MEDIA_TUNER_R820T=y
> CONFIG_MEDIA_TUNER_MXL301RF=y
> CONFIG_MEDIA_TUNER_QM1D1C0042=y
> CONFIG_MEDIA_TUNER_QM1D1B0004=y
> # end of Customize TV tuners
> 
> #
> # Customise DVB Frontends
> #
> 
> #
> # Multistandard (satellite) frontends
> #
> # CONFIG_DVB_STB0899 is not set
> CONFIG_DVB_STB6100=y
> # CONFIG_DVB_STV090x is not set
> # CONFIG_DVB_STV0910 is not set
> CONFIG_DVB_STV6110x=y
> # CONFIG_DVB_STV6111 is not set
> # CONFIG_DVB_MXL5XX is not set
> CONFIG_DVB_M88DS3103=y
> 
> #
> # Multistandard (cable + terrestrial) frontends
> #
> CONFIG_DVB_DRXK=y
> CONFIG_DVB_TDA18271C2DD=y
> CONFIG_DVB_SI2165=y
> CONFIG_DVB_MN88472=y
> # CONFIG_DVB_MN88473 is not set
> 
> #
> # DVB-S (satellite) frontends
> #
> CONFIG_DVB_CX24110=y
> CONFIG_DVB_CX24123=y
> CONFIG_DVB_MT312=y
> CONFIG_DVB_ZL10036=y
> # CONFIG_DVB_ZL10039 is not set
> CONFIG_DVB_S5H1420=y
> CONFIG_DVB_STV0288=y
> CONFIG_DVB_STB6000=y
> CONFIG_DVB_STV0299=y
> CONFIG_DVB_STV6110=y
> CONFIG_DVB_STV0900=y
> # CONFIG_DVB_TDA8083 is not set
> CONFIG_DVB_TDA10086=y
> # CONFIG_DVB_TDA8261 is not set
> # CONFIG_DVB_VES1X93 is not set
> # CONFIG_DVB_TUNER_ITD1000 is not set
> CONFIG_DVB_TUNER_CX24113=y
> CONFIG_DVB_TDA826X=y
> # CONFIG_DVB_TUA6100 is not set
> CONFIG_DVB_CX24116=y
> CONFIG_DVB_CX24117=y
> # CONFIG_DVB_CX24120 is not set
> # CONFIG_DVB_SI21XX is not set
> CONFIG_DVB_TS2020=y
> CONFIG_DVB_DS3000=y
> # CONFIG_DVB_MB86A16 is not set
> CONFIG_DVB_TDA10071=y
> 
> #
> # DVB-T (terrestrial) frontends
> #
> CONFIG_DVB_SP887X=y
> CONFIG_DVB_CX22700=y
> # CONFIG_DVB_CX22702 is not set
> CONFIG_DVB_S5H1432=y
> CONFIG_DVB_DRXD=y
> CONFIG_DVB_L64781=y
> CONFIG_DVB_TDA1004X=y
> CONFIG_DVB_NXT6000=y
> CONFIG_DVB_MT352=y
> # CONFIG_DVB_ZL10353 is not set
> # CONFIG_DVB_DIB3000MB is not set
> CONFIG_DVB_DIB3000MC=y
> CONFIG_DVB_DIB7000M=y
> CONFIG_DVB_DIB7000P=y
> CONFIG_DVB_DIB9000=y
> CONFIG_DVB_TDA10048=y
> CONFIG_DVB_AF9013=y
> # CONFIG_DVB_EC100 is not set
> CONFIG_DVB_STV0367=y
> CONFIG_DVB_CXD2820R=y
> CONFIG_DVB_CXD2841ER=y
> # CONFIG_DVB_RTL2830 is not set
> CONFIG_DVB_RTL2832=y
> # CONFIG_DVB_SI2168 is not set
> # CONFIG_DVB_ZD1301_DEMOD is not set
> 
> #
> # DVB-C (cable) frontends
> #
> CONFIG_DVB_VES1820=y
> CONFIG_DVB_TDA10021=y
> # CONFIG_DVB_TDA10023 is not set
> CONFIG_DVB_STV0297=y
> 
> #
> # ATSC (North American/Korean Terrestrial/Cable DTV) frontends
> #
> CONFIG_DVB_NXT200X=y
> # CONFIG_DVB_OR51211 is not set
> CONFIG_DVB_OR51132=y
> CONFIG_DVB_BCM3510=y
> # CONFIG_DVB_LGDT330X is not set
> # CONFIG_DVB_LGDT3305 is not set
> CONFIG_DVB_LGDT3306A=y
> # CONFIG_DVB_LG2160 is not set
> CONFIG_DVB_S5H1409=y
> CONFIG_DVB_AU8522=y
> # CONFIG_DVB_AU8522_DTV is not set
> CONFIG_DVB_AU8522_V4L=y
> # CONFIG_DVB_S5H1411 is not set
> CONFIG_DVB_MXL692=y
> 
> #
> # ISDB-T (terrestrial) frontends
> #
> CONFIG_DVB_S921=y
> # CONFIG_DVB_DIB8000 is not set
> CONFIG_DVB_MB86A20S=y
> 
> #
> # ISDB-S (satellite) & ISDB-T (terrestrial) frontends
> #
> CONFIG_DVB_TC90522=y
> CONFIG_DVB_MN88443X=y
> 
> #
> # Digital terrestrial only tuners/PLL
> #
> CONFIG_DVB_PLL=y
> CONFIG_DVB_TUNER_DIB0070=y
> CONFIG_DVB_TUNER_DIB0090=y
> 
> #
> # SEC control devices for DVB-S
> #
> CONFIG_DVB_DRX39XYJ=y
> CONFIG_DVB_LNBH25=y
> CONFIG_DVB_LNBH29=y
> CONFIG_DVB_LNBP21=y
> CONFIG_DVB_LNBP22=y
> # CONFIG_DVB_ISL6405 is not set
> CONFIG_DVB_ISL6421=y
> # CONFIG_DVB_ISL6423 is not set
> # CONFIG_DVB_A8293 is not set
> CONFIG_DVB_LGS8GL5=y
> # CONFIG_DVB_LGS8GXX is not set
> # CONFIG_DVB_ATBM8830 is not set
> CONFIG_DVB_TDA665x=y
> CONFIG_DVB_IX2505V=y
> CONFIG_DVB_M88RS2000=y
> CONFIG_DVB_AF9033=y
> CONFIG_DVB_HORUS3A=y
> CONFIG_DVB_ASCOT2E=y
> CONFIG_DVB_HELENE=y
> 
> #
> # Common Interface (EN50221) controller drivers
> #
> CONFIG_DVB_CXD2099=y
> CONFIG_DVB_SP2=y
> # end of Customise DVB Frontends
> 
> #
> # Tools to develop new frontends
> #
> CONFIG_DVB_DUMMY_FE=y
> # end of Media ancillary drivers
> 
> #
> # Graphics support
> #
> # CONFIG_IMX_IPUV3_CORE is not set
> CONFIG_DRM=y
> CONFIG_DRM_MIPI_DSI=y
> CONFIG_DRM_DP_AUX_BUS=y
> # CONFIG_DRM_DP_AUX_CHARDEV is not set
> CONFIG_DRM_DEBUG_MM=y
> # CONFIG_DRM_DEBUG_SELFTEST is not set
> CONFIG_DRM_KMS_HELPER=y
> CONFIG_DRM_DEBUG_DP_MST_TOPOLOGY_REFS=y
> # CONFIG_DRM_FBDEV_EMULATION is not set
> CONFIG_DRM_LOAD_EDID_FIRMWARE=y
> CONFIG_DRM_DP_CEC=y
> CONFIG_DRM_GEM_SHMEM_HELPER=y
> CONFIG_DRM_SCHED=y
> 
> #
> # I2C encoder or helper chips
> #
> CONFIG_DRM_I2C_CH7006=y
> # CONFIG_DRM_I2C_SIL164 is not set
> # CONFIG_DRM_I2C_NXP_TDA998X is not set
> # CONFIG_DRM_I2C_NXP_TDA9950 is not set
> # end of I2C encoder or helper chips
> 
> #
> # ARM devices
> #
> # end of ARM devices
> 
> # CONFIG_DRM_KMB_DISPLAY is not set
> CONFIG_DRM_VGEM=y
> # CONFIG_DRM_VKMS is not set
> # CONFIG_DRM_UDL is not set
> CONFIG_DRM_RCAR_DW_HDMI=y
> # CONFIG_DRM_RCAR_LVDS is not set
> CONFIG_DRM_PANEL=y
> 
> #
> # Display Panels
> #
> CONFIG_DRM_PANEL_ARM_VERSATILE=y
> CONFIG_DRM_PANEL_ASUS_Z00T_TM5P5_NT35596=y
> # CONFIG_DRM_PANEL_BOE_HIMAX8279D is not set
> CONFIG_DRM_PANEL_BOE_TV101WUM_NL6=y
> CONFIG_DRM_PANEL_DSI_CM=y
> CONFIG_DRM_PANEL_LVDS=y
> # CONFIG_DRM_PANEL_SIMPLE is not set
> # CONFIG_DRM_PANEL_ELIDA_KD35T133 is not set
> CONFIG_DRM_PANEL_FEIXIN_K101_IM2BA02=y
> CONFIG_DRM_PANEL_FEIYANG_FY07024DI26A30D=y
> CONFIG_DRM_PANEL_ILITEK_ILI9881C=y
> CONFIG_DRM_PANEL_INNOLUX_P079ZCA=y
> CONFIG_DRM_PANEL_JDI_LT070ME05000=y
> # CONFIG_DRM_PANEL_KHADAS_TS050 is not set
> CONFIG_DRM_PANEL_KINGDISPLAY_KD097D04=y
> # CONFIG_DRM_PANEL_LEADTEK_LTK050H3146W is not set
> CONFIG_DRM_PANEL_LEADTEK_LTK500HD1829=y
> CONFIG_DRM_PANEL_NOVATEK_NT35510=y
> # CONFIG_DRM_PANEL_NOVATEK_NT36672A is not set
> # CONFIG_DRM_PANEL_MANTIX_MLAF057WE51 is not set
> CONFIG_DRM_PANEL_OLIMEX_LCD_OLINUXINO=y
> # CONFIG_DRM_PANEL_ORISETECH_OTM8009A is not set
> CONFIG_DRM_PANEL_OSD_OSD101T2587_53TS=y
> CONFIG_DRM_PANEL_PANASONIC_VVX10F034N00=y
> CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN=y
> CONFIG_DRM_PANEL_RAYDIUM_RM67191=y
> CONFIG_DRM_PANEL_RAYDIUM_RM68200=y
> # CONFIG_DRM_PANEL_RONBO_RB070D30 is not set
> CONFIG_DRM_PANEL_SAMSUNG_ATNA33XC20=y
> CONFIG_DRM_PANEL_SAMSUNG_S6D16D0=y
> CONFIG_DRM_PANEL_SAMSUNG_S6E3HA2=y
> CONFIG_DRM_PANEL_SAMSUNG_S6E63J0X03=y
> CONFIG_DRM_PANEL_SAMSUNG_S6E63M0=y
> # CONFIG_DRM_PANEL_SAMSUNG_S6E63M0_DSI is not set
> # CONFIG_DRM_PANEL_SAMSUNG_S6E88A0_AMS452EF01 is not set
> CONFIG_DRM_PANEL_SAMSUNG_S6E8AA0=y
> # CONFIG_DRM_PANEL_SAMSUNG_SOFEF00 is not set
> CONFIG_DRM_PANEL_SEIKO_43WVF1G=y
> CONFIG_DRM_PANEL_SHARP_LQ101R1SX01=y
> CONFIG_DRM_PANEL_SHARP_LS043T1LE01=y
> CONFIG_DRM_PANEL_SITRONIX_ST7701=y
> CONFIG_DRM_PANEL_SITRONIX_ST7703=y
> # CONFIG_DRM_PANEL_SONY_ACX424AKP is not set
> CONFIG_DRM_PANEL_TDO_TL070WSH30=y
> CONFIG_DRM_PANEL_TRULY_NT35597_WQXGA=y
> CONFIG_DRM_PANEL_VISIONOX_RM69299=y
> CONFIG_DRM_PANEL_XINPENG_XPP055C272=y
> # end of Display Panels
> 
> CONFIG_DRM_BRIDGE=y
> CONFIG_DRM_PANEL_BRIDGE=y
> 
> #
> # Display Interface Bridges
> #
> # CONFIG_DRM_CDNS_DSI is not set
> # CONFIG_DRM_CHIPONE_ICN6211 is not set
> CONFIG_DRM_CHRONTEL_CH7033=y
> # CONFIG_DRM_CROS_EC_ANX7688 is not set
> CONFIG_DRM_DISPLAY_CONNECTOR=y
> CONFIG_DRM_LONTIUM_LT8912B=y
> # CONFIG_DRM_LONTIUM_LT9611 is not set
> CONFIG_DRM_LONTIUM_LT9611UXC=y
> CONFIG_DRM_ITE_IT66121=y
> CONFIG_DRM_LVDS_CODEC=y
> # CONFIG_DRM_MEGACHIPS_STDPXXXX_GE_B850V3_FW is not set
> CONFIG_DRM_NXP_PTN3460=y
> CONFIG_DRM_PARADE_PS8622=y
> # CONFIG_DRM_PARADE_PS8640 is not set
> CONFIG_DRM_SIL_SII8620=y
> CONFIG_DRM_SII902X=y
> # CONFIG_DRM_SII9234 is not set
> CONFIG_DRM_SIMPLE_BRIDGE=y
> # CONFIG_DRM_THINE_THC63LVD1024 is not set
> CONFIG_DRM_TOSHIBA_TC358762=y
> # CONFIG_DRM_TOSHIBA_TC358764 is not set
> CONFIG_DRM_TOSHIBA_TC358767=y
> # CONFIG_DRM_TOSHIBA_TC358768 is not set
> # CONFIG_DRM_TOSHIBA_TC358775 is not set
> # CONFIG_DRM_TI_TFP410 is not set
> CONFIG_DRM_TI_SN65DSI83=y
> CONFIG_DRM_TI_SN65DSI86=y
> # CONFIG_DRM_TI_TPD12S015 is not set
> # CONFIG_DRM_ANALOGIX_ANX6345 is not set
> CONFIG_DRM_ANALOGIX_ANX78XX=y
> CONFIG_DRM_ANALOGIX_DP=y
> CONFIG_DRM_ANALOGIX_ANX7625=y
> # CONFIG_DRM_I2C_ADV7511 is not set
> CONFIG_DRM_CDNS_MHDP8546=y
> CONFIG_DRM_CDNS_MHDP8546_J721E=y
> CONFIG_DRM_DW_HDMI=y
> CONFIG_DRM_DW_HDMI_CEC=y
> # end of Display Interface Bridges
> 
> CONFIG_DRM_ETNAVIV=y
> CONFIG_DRM_ETNAVIV_THERMAL=y
> # CONFIG_DRM_ARCPGU is not set
> CONFIG_DRM_GM12U320=y
> # CONFIG_DRM_SIMPLEDRM is not set
> # CONFIG_DRM_TVE200 is not set
> # CONFIG_DRM_ASPEED_GFX is not set
> # CONFIG_DRM_TIDSS is not set
> CONFIG_DRM_GUD=y
> # CONFIG_DRM_LEGACY is not set
> CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y
> 
> #
> # Frame buffer Devices
> #
> CONFIG_FB_CMDLINE=y
> CONFIG_FB_NOTIFY=y
> CONFIG_FB=y
> CONFIG_FIRMWARE_EDID=y
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> CONFIG_FB_SYS_FILLRECT=y
> CONFIG_FB_SYS_COPYAREA=y
> CONFIG_FB_SYS_IMAGEBLIT=y
> # CONFIG_FB_FOREIGN_ENDIAN is not set
> CONFIG_FB_SYS_FOPS=y
> CONFIG_FB_DEFERRED_IO=y
> CONFIG_FB_MACMODES=y
> CONFIG_FB_MODE_HELPERS=y
> CONFIG_FB_TILEBLITTING=y
> 
> #
> # Frame buffer hardware drivers
> #
> # CONFIG_FB_CLPS711X is not set
> # CONFIG_FB_ARC is not set
> CONFIG_FB_OF=y
> # CONFIG_FB_CONTROL is not set
> CONFIG_FB_VGA16=y
> # CONFIG_FB_UVESA is not set
> # CONFIG_FB_GBE is not set
> # CONFIG_FB_PVR2 is not set
> # CONFIG_FB_OPENCORES is not set
> CONFIG_FB_S1D13XXX=y
> # CONFIG_FB_WM8505 is not set
> CONFIG_FB_FSL_DIU=y
> # CONFIG_FB_W100 is not set
> # CONFIG_FB_TMIO is not set
> # CONFIG_FB_SM501 is not set
> # CONFIG_FB_SMSCUFX is not set
> CONFIG_FB_UDL=y
> # CONFIG_FB_IBM_GXT4500 is not set
> # CONFIG_FB_GOLDFISH is not set
> CONFIG_FB_VIRTUAL=y
> # CONFIG_FB_METRONOME is not set
> # CONFIG_FB_MB862XX is not set
> # CONFIG_FB_BROADSHEET is not set
> CONFIG_FB_SIMPLE=y
> # CONFIG_FB_SSD1307 is not set
> # CONFIG_FB_OMAP2 is not set
> # CONFIG_MMP_DISP is not set
> # end of Frame buffer Devices
> 
> #
> # Backlight & LCD device support
> #
> # CONFIG_LCD_CLASS_DEVICE is not set
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> CONFIG_BACKLIGHT_KTD253=y
> CONFIG_BACKLIGHT_LM3533=y
> CONFIG_BACKLIGHT_PWM=y
> CONFIG_BACKLIGHT_DA903X=y
> CONFIG_BACKLIGHT_DA9052=y
> # CONFIG_BACKLIGHT_QCOM_WLED is not set
> # CONFIG_BACKLIGHT_ADP5520 is not set
> # CONFIG_BACKLIGHT_ADP8860 is not set
> CONFIG_BACKLIGHT_ADP8870=y
> CONFIG_BACKLIGHT_88PM860X=y
> CONFIG_BACKLIGHT_PCF50633=y
> CONFIG_BACKLIGHT_LM3630A=y
> CONFIG_BACKLIGHT_LM3639=y
> # CONFIG_BACKLIGHT_LP855X is not set
> # CONFIG_BACKLIGHT_PANDORA is not set
> CONFIG_BACKLIGHT_SKY81452=y
> CONFIG_BACKLIGHT_TPS65217=y
> # CONFIG_BACKLIGHT_GPIO is not set
> CONFIG_BACKLIGHT_LV5207LP=y
> # CONFIG_BACKLIGHT_BD6107 is not set
> # CONFIG_BACKLIGHT_ARCXCNN is not set
> # CONFIG_BACKLIGHT_LED is not set
> # end of Backlight & LCD device support
> 
> CONFIG_VGASTATE=y
> CONFIG_VIDEOMODE_HELPERS=y
> CONFIG_HDMI=y
> CONFIG_LOGO=y
> # CONFIG_LOGO_LINUX_MONO is not set
> CONFIG_LOGO_LINUX_VGA16=y
> CONFIG_LOGO_LINUX_CLUT224=y
> # end of Graphics support
> 
> CONFIG_SOUND=y
> # CONFIG_SND is not set
> CONFIG_USB_OHCI_BIG_ENDIAN_DESC=y
> CONFIG_USB_OHCI_BIG_ENDIAN_MMIO=y
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_COMMON=y
> # CONFIG_USB_LED_TRIG is not set
> CONFIG_USB_ULPI_BUS=y
> CONFIG_USB_CONN_GPIO=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB=y
> # CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set
> 
> #
> # Miscellaneous USB options
> #
> CONFIG_USB_DEFAULT_PERSIST=y
> # CONFIG_USB_FEW_INIT_RETRIES is not set
> # CONFIG_USB_DYNAMIC_MINORS is not set
> CONFIG_USB_OTG=y
> CONFIG_USB_OTG_PRODUCTLIST=y
> CONFIG_USB_OTG_DISABLE_EXTERNAL_HUB=y
> CONFIG_USB_OTG_FSM=y
> # CONFIG_USB_LEDS_TRIGGER_USBPORT is not set
> CONFIG_USB_AUTOSUSPEND_DELAY=2
> # CONFIG_USB_MON is not set
> 
> #
> # USB Host Controller Drivers
> #
> CONFIG_USB_C67X00_HCD=y
> CONFIG_USB_XHCI_HCD=y
> CONFIG_USB_XHCI_DBGCAP=y
> # CONFIG_USB_XHCI_PCI_RENESAS is not set
> CONFIG_USB_XHCI_PLATFORM=y
> # CONFIG_USB_XHCI_HISTB is not set
> # CONFIG_USB_XHCI_MTK is not set
> # CONFIG_USB_XHCI_MVEBU is not set
> # CONFIG_USB_XHCI_RCAR is not set
> # CONFIG_USB_BRCMSTB is not set
> # CONFIG_USB_EHCI_HCD is not set
> CONFIG_USB_OXU210HP_HCD=y
> CONFIG_USB_ISP116X_HCD=y
> # CONFIG_USB_ISP1362_HCD is not set
> CONFIG_USB_FOTG210_HCD=y
> CONFIG_USB_OHCI_HCD=y
> # CONFIG_USB_OHCI_HCD_SPEAR is not set
> # CONFIG_USB_OHCI_HCD_STI is not set
> # CONFIG_USB_OHCI_HCD_S3C2410 is not set
> CONFIG_USB_OHCI_HCD_LPC32XX=y
> # CONFIG_USB_OHCI_HCD_AT91 is not set
> # CONFIG_USB_OHCI_HCD_OMAP3 is not set
> # CONFIG_USB_OHCI_HCD_DAVINCI is not set
> CONFIG_USB_OHCI_HCD_PPC_OF_BE=y
> CONFIG_USB_OHCI_HCD_PPC_OF_LE=y
> CONFIG_USB_OHCI_HCD_PPC_OF=y
> CONFIG_USB_OHCI_HCD_SSB=y
> # CONFIG_USB_OHCI_SH is not set
> # CONFIG_USB_OHCI_EXYNOS is not set
> # CONFIG_USB_CNS3XXX_OHCI is not set
> CONFIG_USB_OHCI_HCD_PLATFORM=y
> CONFIG_USB_U132_HCD=y
> # CONFIG_USB_SL811_HCD is not set
> CONFIG_USB_R8A66597_HCD=y
> CONFIG_USB_HCD_BCMA=y
> CONFIG_USB_HCD_SSB=y
> CONFIG_USB_HCD_TEST_MODE=y
> # CONFIG_USB_RENESAS_USBHS is not set
> 
> #
> # USB Device Class drivers
> #
> CONFIG_USB_ACM=y
> CONFIG_USB_PRINTER=y
> CONFIG_USB_WDM=y
> CONFIG_USB_TMC=y
> 
> #
> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> #
> 
> #
> # also be needed; see USB_STORAGE Help for more info
> #
> CONFIG_USB_STORAGE=y
> CONFIG_USB_STORAGE_DEBUG=y
> CONFIG_USB_STORAGE_REALTEK=y
> # CONFIG_REALTEK_AUTOPM is not set
> # CONFIG_USB_STORAGE_DATAFAB is not set
> CONFIG_USB_STORAGE_FREECOM=y
> CONFIG_USB_STORAGE_ISD200=y
> CONFIG_USB_STORAGE_USBAT=y
> CONFIG_USB_STORAGE_SDDR09=y
> CONFIG_USB_STORAGE_SDDR55=y
> # CONFIG_USB_STORAGE_JUMPSHOT is not set
> CONFIG_USB_STORAGE_ALAUDA=y
> # CONFIG_USB_STORAGE_KARMA is not set
> CONFIG_USB_STORAGE_CYPRESS_ATACB=y
> CONFIG_USB_STORAGE_ENE_UB6250=y
> CONFIG_USB_UAS=y
> 
> #
> # USB Imaging devices
> #
> CONFIG_USB_MDC800=y
> CONFIG_USB_MICROTEK=y
> CONFIG_USBIP_CORE=y
> # CONFIG_USBIP_VHCI_HCD is not set
> CONFIG_USBIP_HOST=y
> # CONFIG_USBIP_VUDC is not set
> # CONFIG_USBIP_DEBUG is not set
> # CONFIG_USB_CDNS_SUPPORT is not set
> # CONFIG_USB_MTU3 is not set
> CONFIG_USB_MUSB_HDRC=y
> # CONFIG_USB_MUSB_HOST is not set
> CONFIG_USB_MUSB_GADGET=y
> # CONFIG_USB_MUSB_DUAL_ROLE is not set
> 
> #
> # Platform Glue Layer
> #
> # CONFIG_USB_MUSB_DSPS is not set
> # CONFIG_USB_MUSB_UX500 is not set
> # CONFIG_USB_MUSB_JZ4740 is not set
> 
> #
> # MUSB DMA mode
> #
> CONFIG_MUSB_PIO_ONLY=y
> # CONFIG_USB_DWC3 is not set
> CONFIG_USB_DWC2=y
> # CONFIG_USB_DWC2_HOST is not set
> 
> #
> # Gadget/Dual-role mode requires USB Gadget support to be enabled
> #
> # CONFIG_USB_DWC2_PERIPHERAL is not set
> CONFIG_USB_DWC2_DUAL_ROLE=y
> # CONFIG_USB_DWC2_DEBUG is not set
> CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
> # CONFIG_USB_CHIPIDEA is not set
> CONFIG_USB_ISP1760=y
> CONFIG_USB_ISP1760_HCD=y
> CONFIG_USB_ISP1761_UDC=y
> # CONFIG_USB_ISP1760_HOST_ROLE is not set
> # CONFIG_USB_ISP1760_GADGET_ROLE is not set
> CONFIG_USB_ISP1760_DUAL_ROLE=y
> 
> #
> # USB port drivers
> #
> # CONFIG_USB_USS720 is not set
> CONFIG_USB_SERIAL=y
> # CONFIG_USB_SERIAL_CONSOLE is not set
> # CONFIG_USB_SERIAL_GENERIC is not set
> CONFIG_USB_SERIAL_SIMPLE=y
> CONFIG_USB_SERIAL_AIRCABLE=y
> CONFIG_USB_SERIAL_ARK3116=y
> CONFIG_USB_SERIAL_BELKIN=y
> # CONFIG_USB_SERIAL_CH341 is not set
> # CONFIG_USB_SERIAL_WHITEHEAT is not set
> CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
> CONFIG_USB_SERIAL_CP210X=y
> CONFIG_USB_SERIAL_CYPRESS_M8=y
> CONFIG_USB_SERIAL_EMPEG=y
> CONFIG_USB_SERIAL_FTDI_SIO=y
> CONFIG_USB_SERIAL_VISOR=y
> CONFIG_USB_SERIAL_IPAQ=y
> # CONFIG_USB_SERIAL_IR is not set
> # CONFIG_USB_SERIAL_EDGEPORT is not set
> CONFIG_USB_SERIAL_EDGEPORT_TI=y
> # CONFIG_USB_SERIAL_F81232 is not set
> CONFIG_USB_SERIAL_F8153X=y
> CONFIG_USB_SERIAL_GARMIN=y
> CONFIG_USB_SERIAL_IPW=y
> CONFIG_USB_SERIAL_IUU=y
> CONFIG_USB_SERIAL_KEYSPAN_PDA=y
> CONFIG_USB_SERIAL_KEYSPAN=y
> CONFIG_USB_SERIAL_KLSI=y
> CONFIG_USB_SERIAL_KOBIL_SCT=y
> # CONFIG_USB_SERIAL_MCT_U232 is not set
> CONFIG_USB_SERIAL_METRO=y
> CONFIG_USB_SERIAL_MOS7720=y
> # CONFIG_USB_SERIAL_MOS7715_PARPORT is not set
> # CONFIG_USB_SERIAL_MOS7840 is not set
> # CONFIG_USB_SERIAL_MXUPORT is not set
> # CONFIG_USB_SERIAL_NAVMAN is not set
> CONFIG_USB_SERIAL_PL2303=y
> CONFIG_USB_SERIAL_OTI6858=y
> CONFIG_USB_SERIAL_QCAUX=y
> CONFIG_USB_SERIAL_QUALCOMM=y
> # CONFIG_USB_SERIAL_SPCP8X5 is not set
> # CONFIG_USB_SERIAL_SAFE is not set
> CONFIG_USB_SERIAL_SIERRAWIRELESS=y
> CONFIG_USB_SERIAL_SYMBOL=y
> CONFIG_USB_SERIAL_TI=y
> CONFIG_USB_SERIAL_CYBERJACK=y
> CONFIG_USB_SERIAL_WWAN=y
> CONFIG_USB_SERIAL_OPTION=y
> CONFIG_USB_SERIAL_OMNINET=y
> CONFIG_USB_SERIAL_OPTICON=y
> CONFIG_USB_SERIAL_XSENS_MT=y
> # CONFIG_USB_SERIAL_WISHBONE is not set
> # CONFIG_USB_SERIAL_SSU100 is not set
> CONFIG_USB_SERIAL_QT2=y
> CONFIG_USB_SERIAL_UPD78F0730=y
> CONFIG_USB_SERIAL_XR=y
> CONFIG_USB_SERIAL_DEBUG=y
> 
> #
> # USB Miscellaneous drivers
> #
> # CONFIG_USB_EMI62 is not set
> CONFIG_USB_EMI26=y
> # CONFIG_USB_ADUTUX is not set
> CONFIG_USB_SEVSEG=y
> CONFIG_USB_LEGOTOWER=y
> CONFIG_USB_LCD=y
> CONFIG_USB_CYPRESS_CY7C63=y
> CONFIG_USB_CYTHERM=y
> # CONFIG_USB_IDMOUSE is not set
> CONFIG_USB_FTDI_ELAN=y
> CONFIG_USB_APPLEDISPLAY=y
> CONFIG_APPLE_MFI_FASTCHARGE=y
> CONFIG_USB_SISUSBVGA=y
> CONFIG_USB_LD=y
> CONFIG_USB_TRANCEVIBRATOR=y
> CONFIG_USB_IOWARRIOR=y
> # CONFIG_USB_TEST is not set
> # CONFIG_USB_EHSET_TEST_FIXTURE is not set
> CONFIG_USB_ISIGHTFW=y
> # CONFIG_USB_YUREX is not set
> CONFIG_USB_EZUSB_FX2=y
> CONFIG_USB_HUB_USB251XB=y
> CONFIG_USB_HSIC_USB3503=y
> # CONFIG_USB_HSIC_USB4604 is not set
> CONFIG_USB_LINK_LAYER_TEST=y
> # CONFIG_BRCM_USB_PINMAP is not set
> # CONFIG_USB_ATM is not set
> 
> #
> # USB Physical Layer drivers
> #
> CONFIG_USB_PHY=y
> # CONFIG_NOP_USB_XCEIV is not set
> CONFIG_USB_GPIO_VBUS=y
> CONFIG_USB_ISP1301=y
> # CONFIG_USB_TEGRA_PHY is not set
> # CONFIG_USB_ULPI is not set
> # CONFIG_JZ4770_PHY is not set
> # end of USB Physical Layer drivers
> 
> CONFIG_USB_GADGET=y
> CONFIG_USB_GADGET_DEBUG=y
> CONFIG_USB_GADGET_VERBOSE=y
> # CONFIG_USB_GADGET_DEBUG_FILES is not set
> # CONFIG_USB_GADGET_DEBUG_FS is not set
> CONFIG_USB_GADGET_VBUS_DRAW=2
> CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2
> CONFIG_U_SERIAL_CONSOLE=y
> 
> #
> # USB Peripheral Controller
> #
> # CONFIG_USB_LPC32XX is not set
> CONFIG_USB_FSL_USB2=y
> # CONFIG_USB_FUSB300 is not set
> CONFIG_USB_FOTG210_UDC=y
> # CONFIG_USB_GR_UDC is not set
> # CONFIG_USB_R8A66597 is not set
> # CONFIG_USB_RENESAS_USB3 is not set
> CONFIG_USB_PXA27X=y
> CONFIG_USB_MV_UDC=y
> CONFIG_USB_MV_U3D=y
> CONFIG_USB_SNP_CORE=y
> CONFIG_USB_SNP_UDC_PLAT=y
> CONFIG_USB_M66592=y
> # CONFIG_USB_BDC_UDC is not set
> CONFIG_USB_FSL_QE=y
> # CONFIG_USB_NET2272 is not set
> CONFIG_USB_GADGET_XILINX=y
> # CONFIG_USB_ASPEED_VHUB is not set
> # CONFIG_USB_DUMMY_HCD is not set
> # end of USB Peripheral Controller
> 
> CONFIG_USB_LIBCOMPOSITE=y
> CONFIG_USB_F_ACM=y
> CONFIG_USB_U_SERIAL=y
> CONFIG_USB_U_ETHER=y
> CONFIG_USB_F_SERIAL=y
> CONFIG_USB_F_OBEX=y
> CONFIG_USB_F_ECM=y
> CONFIG_USB_F_EEM=y
> CONFIG_USB_F_SUBSET=y
> CONFIG_USB_F_RNDIS=y
> CONFIG_USB_F_MASS_STORAGE=y
> CONFIG_USB_F_FS=y
> CONFIG_USB_F_UVC=y
> CONFIG_USB_F_HID=y
> CONFIG_USB_F_PRINTER=y
> CONFIG_USB_F_TCM=y
> CONFIG_USB_CONFIGFS=y
> # CONFIG_USB_CONFIGFS_SERIAL is not set
> # CONFIG_USB_CONFIGFS_ACM is not set
> # CONFIG_USB_CONFIGFS_OBEX is not set
> # CONFIG_USB_CONFIGFS_NCM is not set
> CONFIG_USB_CONFIGFS_ECM=y
> CONFIG_USB_CONFIGFS_ECM_SUBSET=y
> # CONFIG_USB_CONFIGFS_RNDIS is not set
> CONFIG_USB_CONFIGFS_EEM=y
> # CONFIG_USB_CONFIGFS_PHONET is not set
> CONFIG_USB_CONFIGFS_MASS_STORAGE=y
> # CONFIG_USB_CONFIGFS_F_LB_SS is not set
> CONFIG_USB_CONFIGFS_F_FS=y
> # CONFIG_USB_CONFIGFS_F_HID is not set
> CONFIG_USB_CONFIGFS_F_UVC=y
> # CONFIG_USB_CONFIGFS_F_PRINTER is not set
> CONFIG_USB_CONFIGFS_F_TCM=y
> 
> #
> # USB Gadget precomposed configurations
> #
> # CONFIG_USB_ZERO is not set
> CONFIG_USB_ETH=y
> CONFIG_USB_ETH_RNDIS=y
> # CONFIG_USB_ETH_EEM is not set
> # CONFIG_USB_G_NCM is not set
> CONFIG_USB_GADGETFS=y
> CONFIG_USB_FUNCTIONFS=y
> CONFIG_USB_FUNCTIONFS_ETH=y
> # CONFIG_USB_FUNCTIONFS_RNDIS is not set
> # CONFIG_USB_FUNCTIONFS_GENERIC is not set
> CONFIG_USB_MASS_STORAGE=y
> # CONFIG_USB_GADGET_TARGET is not set
> CONFIG_USB_G_SERIAL=y
> CONFIG_USB_G_PRINTER=y
> # CONFIG_USB_CDC_COMPOSITE is not set
> # CONFIG_USB_G_NOKIA is not set
> CONFIG_USB_G_ACM_MS=y
> # CONFIG_USB_G_MULTI is not set
> CONFIG_USB_G_HID=y
> # CONFIG_USB_G_DBGP is not set
> CONFIG_USB_G_WEBCAM=y
> CONFIG_USB_RAW_GADGET=y
> # end of USB Gadget precomposed configurations
> 
> # CONFIG_TYPEC is not set
> CONFIG_USB_ROLE_SWITCH=y
> CONFIG_MMC=y
> CONFIG_PWRSEQ_EMMC=y
> CONFIG_PWRSEQ_SIMPLE=y
> # CONFIG_MMC_BLOCK is not set
> CONFIG_SDIO_UART=y
> CONFIG_MMC_TEST=y
> 
> #
> # MMC/SD/SDIO Host Controller Drivers
> #
> # CONFIG_MMC_DEBUG is not set
> CONFIG_MMC_SDHCI=y
> CONFIG_MMC_SDHCI_IO_ACCESSORS=y
> CONFIG_MMC_SDHCI_PLTFM=y
> # CONFIG_MMC_SDHCI_OF_ASPEED is not set
> CONFIG_MMC_SDHCI_OF_ESDHC=y
> # CONFIG_MMC_SDHCI_OF_HLWD is not set
> # CONFIG_MMC_SDHCI_OF_SPARX5 is not set
> # CONFIG_MMC_SDHCI_CADENCE is not set
> # CONFIG_MMC_SDHCI_CNS3XXX is not set
> # CONFIG_MMC_SDHCI_ESDHC_IMX is not set
> # CONFIG_MMC_SDHCI_DOVE is not set
> # CONFIG_MMC_SDHCI_TEGRA is not set
> # CONFIG_MMC_SDHCI_S3C is not set
> # CONFIG_MMC_SDHCI_SPEAR is not set
> # CONFIG_MMC_SDHCI_BCM_KONA is not set
> CONFIG_MMC_SDHCI_F_SDH30=y
> CONFIG_MMC_SDHCI_MILBEAUT=y
> # CONFIG_MMC_SDHCI_IPROC is not set
> # CONFIG_MMC_MOXART is not set
> # CONFIG_MMC_SDHCI_ST is not set
> # CONFIG_MMC_OMAP_HS is not set
> # CONFIG_MMC_SDHCI_MSM is not set
> # CONFIG_MMC_DAVINCI is not set
> # CONFIG_MMC_S3C is not set
> # CONFIG_MMC_SDHCI_SPRD is not set
> # CONFIG_MMC_TMIO is not set
> # CONFIG_MMC_SDHI is not set
> # CONFIG_MMC_UNIPHIER is not set
> # CONFIG_MMC_DW is not set
> # CONFIG_MMC_SH_MMCIF is not set
> # CONFIG_MMC_VUB300 is not set
> CONFIG_MMC_USHC=y
> CONFIG_MMC_USDHI6ROL0=y
> # CONFIG_MMC_REALTEK_USB is not set
> # CONFIG_MMC_SUNXI is not set
> CONFIG_MMC_CQHCI=y
> CONFIG_MMC_HSQ=y
> # CONFIG_MMC_BCM2835 is not set
> CONFIG_MMC_SDHCI_XENON=y
> CONFIG_MMC_SDHCI_OMAP=y
> CONFIG_MMC_SDHCI_AM654=y
> # CONFIG_MMC_OWL is not set
> CONFIG_MEMSTICK=y
> CONFIG_MEMSTICK_DEBUG=y
> 
> #
> # MemoryStick drivers
> #
> # CONFIG_MEMSTICK_UNSAFE_RESUME is not set
> CONFIG_MSPRO_BLOCK=y
> CONFIG_MS_BLOCK=y
> 
> #
> # MemoryStick Host Controller Drivers
> #
> CONFIG_MEMSTICK_REALTEK_USB=y
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> # CONFIG_LEDS_CLASS_FLASH is not set
> CONFIG_LEDS_CLASS_MULTICOLOR=y
> # CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set
> 
> #
> # LED drivers
> #
> CONFIG_LEDS_88PM860X=y
> CONFIG_LEDS_AN30259A=y
> # CONFIG_LEDS_ARIEL is not set
> CONFIG_LEDS_AW2013=y
> # CONFIG_LEDS_BCM6328 is not set
> # CONFIG_LEDS_BCM6358 is not set
> # CONFIG_LEDS_TURRIS_OMNIA is not set
> # CONFIG_LEDS_LM3530 is not set
> CONFIG_LEDS_LM3532=y
> CONFIG_LEDS_LM3533=y
> CONFIG_LEDS_LM3642=y
> CONFIG_LEDS_LM3692X=y
> CONFIG_LEDS_MT6323=y
> # CONFIG_LEDS_S3C24XX is not set
> # CONFIG_LEDS_COBALT_QUBE is not set
> # CONFIG_LEDS_COBALT_RAQ is not set
> CONFIG_LEDS_GPIO=y
> CONFIG_LEDS_LP3944=y
> # CONFIG_LEDS_LP3952 is not set
> # CONFIG_LEDS_LP50XX is not set
> CONFIG_LEDS_LP55XX_COMMON=y
> CONFIG_LEDS_LP5521=y
> CONFIG_LEDS_LP5523=y
> CONFIG_LEDS_LP5562=y
> CONFIG_LEDS_LP8501=y
> CONFIG_LEDS_LP8860=y
> CONFIG_LEDS_PCA955X=y
> # CONFIG_LEDS_PCA955X_GPIO is not set
> CONFIG_LEDS_PCA963X=y
> CONFIG_LEDS_WM8350=y
> # CONFIG_LEDS_DA903X is not set
> # CONFIG_LEDS_DA9052 is not set
> CONFIG_LEDS_PWM=y
> # CONFIG_LEDS_BD2802 is not set
> # CONFIG_LEDS_LT3593 is not set
> CONFIG_LEDS_ADP5520=y
> CONFIG_LEDS_MC13783=y
> CONFIG_LEDS_NS2=y
> CONFIG_LEDS_NETXBIG=y
> CONFIG_LEDS_TCA6507=y
> CONFIG_LEDS_TLC591XX=y
> CONFIG_LEDS_MAX77650=y
> # CONFIG_LEDS_MAX8997 is not set
> CONFIG_LEDS_LM355x=y
> # CONFIG_LEDS_OT200 is not set
> CONFIG_LEDS_MENF21BMC=y
> CONFIG_LEDS_IS31FL319X=y
> CONFIG_LEDS_IS31FL32XX=y
> 
> #
> # LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
> #
> # CONFIG_LEDS_BLINKM is not set
> CONFIG_LEDS_SYSCON=y
> # CONFIG_LEDS_MLXREG is not set
> # CONFIG_LEDS_USER is not set
> CONFIG_LEDS_TI_LMU_COMMON=y
> CONFIG_LEDS_LM3697=y
> CONFIG_LEDS_LM36274=y
> # CONFIG_LEDS_IP30 is not set
> # CONFIG_LEDS_LGM is not set
> 
> #
> # Flash and Torch LED drivers
> #
> 
> #
> # LED Triggers
> #
> CONFIG_LEDS_TRIGGERS=y
> CONFIG_LEDS_TRIGGER_TIMER=y
> CONFIG_LEDS_TRIGGER_ONESHOT=y
> # CONFIG_LEDS_TRIGGER_DISK is not set
> CONFIG_LEDS_TRIGGER_MTD=y
> # CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
> # CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
> # CONFIG_LEDS_TRIGGER_CPU is not set
> # CONFIG_LEDS_TRIGGER_ACTIVITY is not set
> CONFIG_LEDS_TRIGGER_GPIO=y
> CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
> 
> #
> # iptables trigger is under Netfilter config (LED target)
> #
> # CONFIG_LEDS_TRIGGER_TRANSIENT is not set
> CONFIG_LEDS_TRIGGER_CAMERA=y
> CONFIG_LEDS_TRIGGER_PANIC=y
> CONFIG_LEDS_TRIGGER_NETDEV=y
> # CONFIG_LEDS_TRIGGER_PATTERN is not set
> CONFIG_LEDS_TRIGGER_AUDIO=y
> CONFIG_LEDS_TRIGGER_TTY=y
> # CONFIG_ACCESSIBILITY is not set
> CONFIG_EDAC_ATOMIC_SCRUB=y
> CONFIG_EDAC_SUPPORT=y
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> # CONFIG_RTC_HCTOSYS is not set
> # CONFIG_RTC_SYSTOHC is not set
> # CONFIG_RTC_DEBUG is not set
> CONFIG_RTC_LIB_KUNIT_TEST=y
> CONFIG_RTC_NVMEM=y
> 
> #
> # RTC interfaces
> #
> # CONFIG_RTC_INTF_SYSFS is not set
> CONFIG_RTC_INTF_PROC=y
> CONFIG_RTC_INTF_DEV=y
> # CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
> # CONFIG_RTC_DRV_TEST is not set
> 
> #
> # I2C RTC drivers
> #
> CONFIG_RTC_DRV_88PM860X=y
> # CONFIG_RTC_DRV_ABB5ZES3 is not set
> CONFIG_RTC_DRV_ABEOZ9=y
> CONFIG_RTC_DRV_ABX80X=y
> # CONFIG_RTC_DRV_BRCMSTB is not set
> CONFIG_RTC_DRV_AS3722=y
> # CONFIG_RTC_DRV_DS1307 is not set
> CONFIG_RTC_DRV_DS1374=y
> CONFIG_RTC_DRV_DS1672=y
> CONFIG_RTC_DRV_HYM8563=y
> CONFIG_RTC_DRV_MAX6900=y
> # CONFIG_RTC_DRV_MAX8907 is not set
> CONFIG_RTC_DRV_MAX8998=y
> CONFIG_RTC_DRV_MAX8997=y
> # CONFIG_RTC_DRV_MAX77686 is not set
> CONFIG_RTC_DRV_RS5C372=y
> CONFIG_RTC_DRV_ISL1208=y
> CONFIG_RTC_DRV_ISL12022=y
> CONFIG_RTC_DRV_ISL12026=y
> CONFIG_RTC_DRV_X1205=y
> CONFIG_RTC_DRV_PCF8523=y
> CONFIG_RTC_DRV_PCF85063=y
> # CONFIG_RTC_DRV_PCF85363 is not set
> CONFIG_RTC_DRV_PCF8563=y
> CONFIG_RTC_DRV_PCF8583=y
> # CONFIG_RTC_DRV_M41T80 is not set
> CONFIG_RTC_DRV_BD70528=y
> CONFIG_RTC_DRV_BQ32K=y
> CONFIG_RTC_DRV_TWL4030=y
> # CONFIG_RTC_DRV_TPS6586X is not set
> # CONFIG_RTC_DRV_TPS65910 is not set
> CONFIG_RTC_DRV_RC5T619=y
> CONFIG_RTC_DRV_S35390A=y
> # CONFIG_RTC_DRV_FM3130 is not set
> # CONFIG_RTC_DRV_RX8010 is not set
> # CONFIG_RTC_DRV_RX8581 is not set
> # CONFIG_RTC_DRV_RX8025 is not set
> CONFIG_RTC_DRV_EM3027=y
> CONFIG_RTC_DRV_RV3028=y
> CONFIG_RTC_DRV_RV3032=y
> CONFIG_RTC_DRV_RV8803=y
> # CONFIG_RTC_DRV_S5M is not set
> # CONFIG_RTC_DRV_SD3078 is not set
> 
> #
> # SPI RTC drivers
> #
> CONFIG_RTC_I2C_AND_SPI=y
> 
> #
> # SPI and I2C RTC drivers
> #
> CONFIG_RTC_DRV_DS3232=y
> # CONFIG_RTC_DRV_DS3232_HWMON is not set
> # CONFIG_RTC_DRV_PCF2127 is not set
> # CONFIG_RTC_DRV_RV3029C2 is not set
> CONFIG_RTC_DRV_RX6110=y
> 
> #
> # Platform RTC drivers
> #
> # CONFIG_RTC_DRV_CMOS is not set
> CONFIG_RTC_DRV_DS1286=y
> # CONFIG_RTC_DRV_DS1511 is not set
> CONFIG_RTC_DRV_DS1553=y
> # CONFIG_RTC_DRV_DS1685_FAMILY is not set
> # CONFIG_RTC_DRV_DS1742 is not set
> CONFIG_RTC_DRV_DS2404=y
> CONFIG_RTC_DRV_DA9052=y
> # CONFIG_RTC_DRV_DA9055 is not set
> # CONFIG_RTC_DRV_DA9063 is not set
> CONFIG_RTC_DRV_STK17TA8=y
> CONFIG_RTC_DRV_M48T86=y
> CONFIG_RTC_DRV_M48T35=y
> # CONFIG_RTC_DRV_M48T59 is not set
> # CONFIG_RTC_DRV_MSM6242 is not set
> # CONFIG_RTC_DRV_BQ4802 is not set
> # CONFIG_RTC_DRV_RP5C01 is not set
> CONFIG_RTC_DRV_V3020=y
> # CONFIG_RTC_DRV_WM8350 is not set
> # CONFIG_RTC_DRV_SC27XX is not set
> CONFIG_RTC_DRV_SPEAR=y
> CONFIG_RTC_DRV_PCF50633=y
> # CONFIG_RTC_DRV_ZYNQMP is not set
> 
> #
> # on-CPU RTC drivers
> #
> # CONFIG_RTC_DRV_ASM9260 is not set
> # CONFIG_RTC_DRV_DAVINCI is not set
> # CONFIG_RTC_DRV_DIGICOLOR is not set
> # CONFIG_RTC_DRV_FSL_FTM_ALARM is not set
> # CONFIG_RTC_DRV_MESON is not set
> # CONFIG_RTC_DRV_MESON_VRTC is not set
> # CONFIG_RTC_DRV_OMAP is not set
> # CONFIG_RTC_DRV_S3C is not set
> # CONFIG_RTC_DRV_EP93XX is not set
> # CONFIG_RTC_DRV_VR41XX is not set
> # CONFIG_RTC_DRV_AT91RM9200 is not set
> # CONFIG_RTC_DRV_AT91SAM9 is not set
> CONFIG_RTC_DRV_GENERIC=y
> # CONFIG_RTC_DRV_VT8500 is not set
> # CONFIG_RTC_DRV_SUNXI is not set
> # CONFIG_RTC_DRV_MV is not set
> # CONFIG_RTC_DRV_ARMADA38X is not set
> CONFIG_RTC_DRV_CADENCE=y
> CONFIG_RTC_DRV_FTRTC010=y
> # CONFIG_RTC_DRV_STMP is not set
> CONFIG_RTC_DRV_MC13XXX=y
> # CONFIG_RTC_DRV_JZ4740 is not set
> # CONFIG_RTC_DRV_LPC24XX is not set
> # CONFIG_RTC_DRV_LPC32XX is not set
> # CONFIG_RTC_DRV_PM8XXX is not set
> # CONFIG_RTC_DRV_TEGRA is not set
> # CONFIG_RTC_DRV_MXC is not set
> # CONFIG_RTC_DRV_MXC_V2 is not set
> # CONFIG_RTC_DRV_SNVS is not set
> # CONFIG_RTC_DRV_MOXART is not set
> # CONFIG_RTC_DRV_MT2712 is not set
> # CONFIG_RTC_DRV_MT6397 is not set
> # CONFIG_RTC_DRV_MT7622 is not set
> # CONFIG_RTC_DRV_XGENE is not set
> CONFIG_RTC_DRV_R7301=y
> # CONFIG_RTC_DRV_STM32 is not set
> # CONFIG_RTC_DRV_RTD119X is not set
> # CONFIG_RTC_DRV_ASPEED is not set
> 
> #
> # HID Sensor RTC drivers
> #
> # CONFIG_RTC_DRV_GOLDFISH is not set
> # CONFIG_DMADEVICES is not set
> 
> #
> # DMABUF options
> #
> CONFIG_SYNC_FILE=y
> CONFIG_SW_SYNC=y
> # CONFIG_UDMABUF is not set
> # CONFIG_DMABUF_MOVE_NOTIFY is not set
> # CONFIG_DMABUF_DEBUG is not set
> # CONFIG_DMABUF_SELFTESTS is not set
> CONFIG_DMABUF_HEAPS=y
> # CONFIG_DMABUF_SYSFS_STATS is not set
> # CONFIG_DMABUF_HEAPS_SYSTEM is not set
> # end of DMABUF options
> 
> # CONFIG_AUXDISPLAY is not set
> # CONFIG_PANEL is not set
> # CONFIG_UIO is not set
> # CONFIG_VFIO is not set
> # CONFIG_VIRT_DRIVERS is not set
> CONFIG_VIRTIO=y
> # CONFIG_VIRTIO_MENU is not set
> CONFIG_VDPA=y
> CONFIG_VDPA_SIM=y
> CONFIG_VDPA_SIM_NET=y
> # CONFIG_VDPA_SIM_BLOCK is not set
> CONFIG_VDPA_USER=y
> CONFIG_VHOST_IOTLB=y
> CONFIG_VHOST_RING=y
> # CONFIG_VHOST_MENU is not set
> 
> #
> # Microsoft Hyper-V guest support
> #
> # end of Microsoft Hyper-V guest support
> 
> CONFIG_GREYBUS=y
> CONFIG_GREYBUS_ES2=y
> CONFIG_COMEDI=y
> # CONFIG_COMEDI_DEBUG is not set
> CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
> CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
> # CONFIG_COMEDI_MISC_DRIVERS is not set
> CONFIG_COMEDI_ISA_DRIVERS=y
> CONFIG_COMEDI_PCL711=y
> CONFIG_COMEDI_PCL724=y
> CONFIG_COMEDI_PCL726=y
> # CONFIG_COMEDI_PCL730 is not set
> # CONFIG_COMEDI_PCL812 is not set
> # CONFIG_COMEDI_PCL816 is not set
> # CONFIG_COMEDI_PCL818 is not set
> # CONFIG_COMEDI_PCM3724 is not set
> CONFIG_COMEDI_AMPLC_DIO200_ISA=y
> # CONFIG_COMEDI_AMPLC_PC236_ISA is not set
> # CONFIG_COMEDI_AMPLC_PC263_ISA is not set
> CONFIG_COMEDI_RTI800=y
> CONFIG_COMEDI_RTI802=y
> # CONFIG_COMEDI_DAC02 is not set
> CONFIG_COMEDI_DAS16M1=y
> CONFIG_COMEDI_DAS08_ISA=y
> # CONFIG_COMEDI_DAS16 is not set
> CONFIG_COMEDI_DAS800=y
> # CONFIG_COMEDI_DAS1800 is not set
> # CONFIG_COMEDI_DAS6402 is not set
> CONFIG_COMEDI_DT2801=y
> CONFIG_COMEDI_DT2811=y
> CONFIG_COMEDI_DT2814=y
> CONFIG_COMEDI_DT2815=y
> CONFIG_COMEDI_DT2817=y
> CONFIG_COMEDI_DT282X=y
> # CONFIG_COMEDI_DMM32AT is not set
> CONFIG_COMEDI_FL512=y
> CONFIG_COMEDI_AIO_AIO12_8=y
> # CONFIG_COMEDI_AIO_IIRO_16 is not set
> CONFIG_COMEDI_II_PCI20KC=y
> CONFIG_COMEDI_C6XDIGIO=y
> # CONFIG_COMEDI_MPC624 is not set
> # CONFIG_COMEDI_ADQ12B is not set
> # CONFIG_COMEDI_NI_AT_A2150 is not set
> # CONFIG_COMEDI_NI_AT_AO is not set
> CONFIG_COMEDI_NI_ATMIO=y
> CONFIG_COMEDI_NI_ATMIO16D=y
> CONFIG_COMEDI_NI_LABPC_ISA=y
> # CONFIG_COMEDI_PCMAD is not set
> CONFIG_COMEDI_PCMDA12=y
> CONFIG_COMEDI_PCMMIO=y
> # CONFIG_COMEDI_PCMUIO is not set
> CONFIG_COMEDI_MULTIQ3=y
> CONFIG_COMEDI_S526=y
> CONFIG_COMEDI_USB_DRIVERS=y
> CONFIG_COMEDI_DT9812=y
> CONFIG_COMEDI_NI_USB6501=y
> CONFIG_COMEDI_USBDUX=y
> CONFIG_COMEDI_USBDUXFAST=y
> # CONFIG_COMEDI_USBDUXSIGMA is not set
> CONFIG_COMEDI_VMK80XX=y
> CONFIG_COMEDI_8254=y
> CONFIG_COMEDI_8255=y
> # CONFIG_COMEDI_8255_SA is not set
> CONFIG_COMEDI_KCOMEDILIB=y
> CONFIG_COMEDI_AMPLC_DIO200=y
> CONFIG_COMEDI_DAS08=y
> CONFIG_COMEDI_NI_LABPC=y
> CONFIG_COMEDI_NI_TIO=y
> CONFIG_COMEDI_NI_ROUTING=y
> CONFIG_COMEDI_TESTS=y
> # CONFIG_COMEDI_TESTS_EXAMPLE is not set
> CONFIG_COMEDI_TESTS_NI_ROUTES=y
> # CONFIG_STAGING is not set
> # CONFIG_GOLDFISH is not set
> # CONFIG_CHROME_PLATFORMS is not set
> # CONFIG_MELLANOX_PLATFORM is not set
> # CONFIG_OLPC_XO175 is not set
> # CONFIG_COMMON_CLK is not set
> # CONFIG_HWSPINLOCK is not set
> 
> #
> # Clock Source drivers
> #
> CONFIG_TIMER_OF=y
> CONFIG_TIMER_PROBE=y
> CONFIG_CLKSRC_MMIO=y
> # CONFIG_BCM2835_TIMER is not set
> # CONFIG_BCM_KONA_TIMER is not set
> # CONFIG_DAVINCI_TIMER is not set
> # CONFIG_DIGICOLOR_TIMER is not set
> # CONFIG_DW_APB_TIMER is not set
> # CONFIG_FTTMR010_TIMER is not set
> # CONFIG_IXP4XX_TIMER is not set
> # CONFIG_MESON6_TIMER is not set
> # CONFIG_OWL_TIMER is not set
> # CONFIG_RDA_TIMER is not set
> # CONFIG_SUN4I_TIMER is not set
> # CONFIG_TEGRA_TIMER is not set
> # CONFIG_VT8500_TIMER is not set
> # CONFIG_NPCM7XX_TIMER is not set
> # CONFIG_ASM9260_TIMER is not set
> # CONFIG_CLKSRC_DBX500_PRCMU is not set
> # CONFIG_CLPS711X_TIMER is not set
> # CONFIG_MXS_TIMER is not set
> # CONFIG_NSPIRE_TIMER is not set
> # CONFIG_INTEGRATOR_AP_TIMER is not set
> # CONFIG_CLKSRC_PISTACHIO is not set
> # CONFIG_CLKSRC_STM32_LP is not set
> # CONFIG_ARMV7M_SYSTICK is not set
> # CONFIG_ATMEL_PIT is not set
> # CONFIG_ATMEL_ST is not set
> # CONFIG_CLKSRC_SAMSUNG_PWM is not set
> # CONFIG_FSL_FTM_TIMER is not set
> # CONFIG_OXNAS_RPS_TIMER is not set
> # CONFIG_MTK_TIMER is not set
> # CONFIG_SPRD_TIMER is not set
> # CONFIG_CLKSRC_JCORE_PIT is not set
> # CONFIG_SH_TIMER_CMT is not set
> # CONFIG_SH_TIMER_MTU2 is not set
> # CONFIG_RENESAS_OSTM is not set
> # CONFIG_SH_TIMER_TMU is not set
> # CONFIG_EM_TIMER_STI is not set
> # CONFIG_CLKSRC_PXA is not set
> # CONFIG_H8300_TMR8 is not set
> # CONFIG_H8300_TMR16 is not set
> # CONFIG_H8300_TPU is not set
> # CONFIG_TIMER_IMX_SYS_CTR is not set
> # CONFIG_CLKSRC_ST_LPC is not set
> # CONFIG_ATCPIT100_TIMER is not set
> CONFIG_MICROCHIP_PIT64B=y
> # end of Clock Source drivers
> 
> CONFIG_MAILBOX=y
> # CONFIG_IMX_MBOX is not set
> # CONFIG_PLATFORM_MHU is not set
> # CONFIG_ARMADA_37XX_RWTM_MBOX is not set
> # CONFIG_ROCKCHIP_MBOX is not set
> # CONFIG_ALTERA_MBOX is not set
> # CONFIG_HI3660_MBOX is not set
> # CONFIG_HI6220_MBOX is not set
> # CONFIG_MAILBOX_TEST is not set
> # CONFIG_POLARFIRE_SOC_MAILBOX is not set
> # CONFIG_QCOM_APCS_IPC is not set
> # CONFIG_BCM_PDC_MBOX is not set
> # CONFIG_STM32_IPCC is not set
> # CONFIG_MTK_CMDQ_MBOX is not set
> # CONFIG_SUN6I_MSGBOX is not set
> # CONFIG_SPRD_MBOX is not set
> # CONFIG_QCOM_IPCC is not set
> CONFIG_IOMMU_IOVA=y
> CONFIG_IOMMU_SUPPORT=y
> 
> #
> # Generic IOMMU Pagetable Support
> #
> # CONFIG_IOMMU_IO_PGTABLE_ARMV7S is not set
> # end of Generic IOMMU Pagetable Support
> 
> CONFIG_IOMMU_DEBUGFS=y
> # CONFIG_OMAP_IOMMU is not set
> # CONFIG_ROCKCHIP_IOMMU is not set
> # CONFIG_SUN50I_IOMMU is not set
> # CONFIG_S390_CCW_IOMMU is not set
> # CONFIG_S390_AP_IOMMU is not set
> # CONFIG_MTK_IOMMU is not set
> # CONFIG_SPRD_IOMMU is not set
> 
> #
> # Remoteproc drivers
> #
> CONFIG_REMOTEPROC=y
> # CONFIG_REMOTEPROC_CDEV is not set
> # CONFIG_INGENIC_VPU_RPROC is not set
> # CONFIG_MTK_SCP is not set
> # end of Remoteproc drivers
> 
> #
> # Rpmsg drivers
> #
> CONFIG_RPMSG=y
> # CONFIG_RPMSG_CHAR is not set
> CONFIG_RPMSG_NS=y
> # CONFIG_RPMSG_QCOM_GLINK_RPM is not set
> CONFIG_RPMSG_VIRTIO=y
> # end of Rpmsg drivers
> 
> CONFIG_SOUNDWIRE=y
> 
> #
> # SoundWire Devices
> #
> 
> #
> # SOC (System On Chip) specific Drivers
> #
> # CONFIG_OWL_PM_DOMAINS is not set
> 
> #
> # Amlogic SoC drivers
> #
> # CONFIG_MESON_CANVAS is not set
> # CONFIG_MESON_CLK_MEASURE is not set
> # CONFIG_MESON_GX_SOCINFO is not set
> # CONFIG_MESON_GX_PM_DOMAINS is not set
> # CONFIG_MESON_EE_PM_DOMAINS is not set
> # CONFIG_MESON_MX_SOCINFO is not set
> # end of Amlogic SoC drivers
> 
> #
> # ASPEED SoC drivers
> #
> # CONFIG_ASPEED_LPC_CTRL is not set
> # CONFIG_ASPEED_LPC_SNOOP is not set
> # CONFIG_ASPEED_P2A_CTRL is not set
> # CONFIG_ASPEED_SOCINFO is not set
> # end of ASPEED SoC drivers
> 
> # CONFIG_AT91_SOC_ID is not set
> # CONFIG_AT91_SOC_SFR is not set
> 
> #
> # Broadcom SoC drivers
> #
> # CONFIG_BCM2835_POWER is not set
> # CONFIG_SOC_BCM63XX is not set
> # CONFIG_SOC_BRCMSTB is not set
> # CONFIG_BCM_PMB is not set
> # end of Broadcom SoC drivers
> 
> #
> # NXP/Freescale QorIQ SoC drivers
> #
> CONFIG_QUICC_ENGINE=y
> CONFIG_UCC_SLOW=y
> CONFIG_UCC_FAST=y
> CONFIG_UCC=y
> CONFIG_QE_TDM=y
> CONFIG_QE_USB=y
> CONFIG_FSL_GUTS=y
> CONFIG_DPAA2_CONSOLE=y
> # end of NXP/Freescale QorIQ SoC drivers
> 
> #
> # i.MX SoC drivers
> #
> # CONFIG_IMX_GPCV2_PM_DOMAINS is not set
> # CONFIG_SOC_IMX8M is not set
> # end of i.MX SoC drivers
> 
> #
> # IXP4xx SoC drivers
> #
> # CONFIG_IXP4XX_QMGR is not set
> # CONFIG_IXP4XX_NPE is not set
> # end of IXP4xx SoC drivers
> 
> #
> # Enable LiteX SoC Builder specific drivers
> #
> CONFIG_LITEX=y
> CONFIG_LITEX_SOC_CONTROLLER=y
> # end of Enable LiteX SoC Builder specific drivers
> 
> #
> # MediaTek SoC drivers
> #
> # CONFIG_MTK_CMDQ is not set
> # CONFIG_MTK_DEVAPC is not set
> # CONFIG_MTK_INFRACFG is not set
> # CONFIG_MTK_PMIC_WRAP is not set
> # CONFIG_MTK_SCPSYS is not set
> # CONFIG_MTK_SCPSYS_PM_DOMAINS is not set
> # CONFIG_MTK_MMSYS is not set
> # end of MediaTek SoC drivers
> 
> #
> # Qualcomm SoC drivers
> #
> # CONFIG_QCOM_COMMAND_DB is not set
> # CONFIG_QCOM_GENI_SE is not set
> # CONFIG_QCOM_GSBI is not set
> # CONFIG_QCOM_LLCC is not set
> # CONFIG_QCOM_RPMH is not set
> # CONFIG_QCOM_SMD_RPM is not set
> # CONFIG_QCOM_WCNSS_CTRL is not set
> # CONFIG_QCOM_APR is not set
> # end of Qualcomm SoC drivers
> 
> # CONFIG_SOC_RENESAS is not set
> # CONFIG_ROCKCHIP_GRF is not set
> # CONFIG_ROCKCHIP_IODOMAIN is not set
> # CONFIG_ROCKCHIP_PM_DOMAINS is not set
> # CONFIG_SOC_SAMSUNG is not set
> # CONFIG_SOC_TI is not set
> # CONFIG_UX500_SOC_ID is not set
> 
> #
> # Xilinx SoC drivers
> #
> # end of Xilinx SoC drivers
> # end of SOC (System On Chip) specific Drivers
> 
> CONFIG_PM_DEVFREQ=y
> 
> #
> # DEVFREQ Governors
> #
> # CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
> # CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
> CONFIG_DEVFREQ_GOV_POWERSAVE=y
> CONFIG_DEVFREQ_GOV_USERSPACE=y
> # CONFIG_DEVFREQ_GOV_PASSIVE is not set
> 
> #
> # DEVFREQ Drivers
> #
> # CONFIG_ARM_EXYNOS_BUS_DEVFREQ is not set
> # CONFIG_ARM_IMX_BUS_DEVFREQ is not set
> CONFIG_PM_DEVFREQ_EVENT=y
> # CONFIG_DEVFREQ_EVENT_EXYNOS_NOCP is not set
> # CONFIG_DEVFREQ_EVENT_EXYNOS_PPMU is not set
> # CONFIG_DEVFREQ_EVENT_ROCKCHIP_DFI is not set
> CONFIG_EXTCON=y
> 
> #
> # Extcon Device Drivers
> #
> CONFIG_EXTCON_ADC_JACK=y
> CONFIG_EXTCON_GPIO=y
> # CONFIG_EXTCON_MAX14577 is not set
> # CONFIG_EXTCON_MAX3355 is not set
> CONFIG_EXTCON_MAX8997=y
> # CONFIG_EXTCON_PTN5150 is not set
> # CONFIG_EXTCON_QCOM_SPMI_MISC is not set
> CONFIG_EXTCON_RT8973A=y
> CONFIG_EXTCON_SM5502=y
> # CONFIG_EXTCON_USB_GPIO is not set
> # CONFIG_EXTCON_USBC_TUSB320 is not set
> CONFIG_MEMORY=y
> # CONFIG_ATMEL_SDRAMC is not set
> # CONFIG_ATMEL_EBI is not set
> # CONFIG_BRCMSTB_DPFE is not set
> # CONFIG_BT1_L2_CTL is not set
> # CONFIG_TI_AEMIF is not set
> # CONFIG_TI_EMIF is not set
> # CONFIG_OMAP_GPMC is not set
> # CONFIG_MVEBU_DEVBUS is not set
> # CONFIG_FSL_CORENET_CF is not set
> CONFIG_FSL_IFC=y
> # CONFIG_JZ4780_NEMC is not set
> # CONFIG_MTK_SMI is not set
> # CONFIG_DA8XX_DDRCTL is not set
> # CONFIG_RENESAS_RPCIF is not set
> # CONFIG_STM32_FMC2_EBI is not set
> # CONFIG_SAMSUNG_MC is not set
> CONFIG_IIO=y
> CONFIG_IIO_BUFFER=y
> # CONFIG_IIO_BUFFER_CB is not set
> CONFIG_IIO_BUFFER_DMA=y
> CONFIG_IIO_BUFFER_DMAENGINE=y
> CONFIG_IIO_BUFFER_HW_CONSUMER=y
> CONFIG_IIO_KFIFO_BUF=y
> CONFIG_IIO_TRIGGERED_BUFFER=y
> CONFIG_IIO_CONFIGFS=y
> CONFIG_IIO_TRIGGER=y
> CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
> # CONFIG_IIO_SW_DEVICE is not set
> CONFIG_IIO_SW_TRIGGER=y
> CONFIG_IIO_TRIGGERED_EVENT=y
> 
> #
> # Accelerometers
> #
> CONFIG_ADXL345=y
> CONFIG_ADXL345_I2C=y
> CONFIG_ADXL372=y
> CONFIG_ADXL372_I2C=y
> CONFIG_BMA180=y
> CONFIG_BMA400=y
> CONFIG_BMA400_I2C=y
> # CONFIG_BMC150_ACCEL is not set
> CONFIG_DA280=y
> # CONFIG_DA311 is not set
> CONFIG_DMARD06=y
> CONFIG_DMARD09=y
> CONFIG_DMARD10=y
> # CONFIG_FXLS8962AF_I2C is not set
> CONFIG_IIO_ST_ACCEL_3AXIS=y
> CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
> CONFIG_KXSD9=y
> CONFIG_KXSD9_I2C=y
> CONFIG_KXCJK1013=y
> CONFIG_MC3230=y
> CONFIG_MMA7455=y
> CONFIG_MMA7455_I2C=y
> CONFIG_MMA7660=y
> CONFIG_MMA8452=y
> CONFIG_MMA9551_CORE=y
> # CONFIG_MMA9551 is not set
> CONFIG_MMA9553=y
> CONFIG_MXC4005=y
> CONFIG_MXC6255=y
> CONFIG_STK8312=y
> CONFIG_STK8BA50=y
> # end of Accelerometers
> 
> #
> # Analog to digital converters
> #
> CONFIG_AD7091R5=y
> # CONFIG_AD7291 is not set
> CONFIG_AD7606=y
> CONFIG_AD7606_IFACE_PARALLEL=y
> CONFIG_AD799X=y
> CONFIG_ADI_AXI_ADC=y
> # CONFIG_AT91_SAMA5D2_ADC is not set
> # CONFIG_AXP20X_ADC is not set
> CONFIG_AXP288_ADC=y
> # CONFIG_BCM_IPROC_ADC is not set
> CONFIG_DA9150_GPADC=y
> CONFIG_DLN2_ADC=y
> CONFIG_ENVELOPE_DETECTOR=y
> # CONFIG_EXYNOS_ADC is not set
> CONFIG_HX711=y
> # CONFIG_INGENIC_ADC is not set
> # CONFIG_IMX7D_ADC is not set
> # CONFIG_LPC18XX_ADC is not set
> # CONFIG_LPC32XX_ADC is not set
> # CONFIG_LTC2471 is not set
> # CONFIG_LTC2485 is not set
> CONFIG_LTC2497=y
> # CONFIG_MAX1363 is not set
> CONFIG_MAX9611=y
> # CONFIG_MCP3422 is not set
> # CONFIG_MEDIATEK_MT6577_AUXADC is not set
> CONFIG_MEN_Z188_ADC=y
> # CONFIG_MP2629_ADC is not set
> # CONFIG_NAU7802 is not set
> # CONFIG_NPCM_ADC is not set
> CONFIG_QCOM_VADC_COMMON=y
> # CONFIG_QCOM_SPMI_IADC is not set
> CONFIG_QCOM_SPMI_VADC=y
> CONFIG_QCOM_SPMI_ADC5=y
> # CONFIG_RCAR_GYRO_ADC is not set
> CONFIG_RN5T618_ADC=y
> # CONFIG_ROCKCHIP_SARADC is not set
> # CONFIG_RZG2L_ADC is not set
> # CONFIG_SC27XX_ADC is not set
> # CONFIG_SPEAR_ADC is not set
> # CONFIG_SD_ADC_MODULATOR is not set
> # CONFIG_STM32_DFSDM_CORE is not set
> # CONFIG_STM32_DFSDM_ADC is not set
> CONFIG_STMPE_ADC=y
> # CONFIG_TI_ADC081C is not set
> # CONFIG_TI_ADS1015 is not set
> CONFIG_TI_AM335X_ADC=y
> CONFIG_TWL4030_MADC=y
> # CONFIG_TWL6030_GPADC is not set
> CONFIG_VF610_ADC=y
> # CONFIG_VIPERBOARD_ADC is not set
> CONFIG_XILINX_XADC=y
> # end of Analog to digital converters
> 
> #
> # Analog Front Ends
> #
> # CONFIG_IIO_RESCALE is not set
> # end of Analog Front Ends
> 
> #
> # Amplifiers
> #
> CONFIG_HMC425=y
> # end of Amplifiers
> 
> #
> # Capacitance to digital converters
> #
> # CONFIG_AD7150 is not set
> # end of Capacitance to digital converters
> 
> #
> # Chemical Sensors
> #
> CONFIG_ATLAS_PH_SENSOR=y
> CONFIG_ATLAS_EZO_SENSOR=y
> # CONFIG_BME680 is not set
> CONFIG_CCS811=y
> CONFIG_IAQCORE=y
> # CONFIG_SCD30_CORE is not set
> CONFIG_SENSIRION_SGP30=y
> CONFIG_SENSIRION_SGP40=y
> CONFIG_SPS30=y
> CONFIG_SPS30_I2C=y
> # CONFIG_VZ89X is not set
> # end of Chemical Sensors
> 
> #
> # Hid Sensor IIO Common
> #
> # end of Hid Sensor IIO Common
> 
> CONFIG_IIO_MS_SENSORS_I2C=y
> 
> #
> # IIO SCMI Sensors
> #
> # end of IIO SCMI Sensors
> 
> #
> # SSP Sensor Common
> #
> # end of SSP Sensor Common
> 
> CONFIG_IIO_ST_SENSORS_I2C=y
> CONFIG_IIO_ST_SENSORS_CORE=y
> 
> #
> # Digital to analog converters
> #
> CONFIG_AD5064=y
> CONFIG_AD5380=y
> CONFIG_AD5446=y
> CONFIG_AD5592R_BASE=y
> CONFIG_AD5593R=y
> CONFIG_AD5686=y
> CONFIG_AD5696_I2C=y
> CONFIG_DPOT_DAC=y
> # CONFIG_DS4424 is not set
> # CONFIG_LPC18XX_DAC is not set
> # CONFIG_M62332 is not set
> CONFIG_MAX517=y
> CONFIG_MAX5821=y
> CONFIG_MCP4725=y
> CONFIG_TI_DAC5571=y
> CONFIG_VF610_DAC=y
> # end of Digital to analog converters
> 
> #
> # IIO dummy driver
> #
> # end of IIO dummy driver
> 
> #
> # Frequency Synthesizers DDS/PLL
> #
> 
> #
> # Clock Generator/Distribution
> #
> # end of Clock Generator/Distribution
> 
> #
> # Phase-Locked Loop (PLL) frequency synthesizers
> #
> # end of Phase-Locked Loop (PLL) frequency synthesizers
> # end of Frequency Synthesizers DDS/PLL
> 
> #
> # Digital gyroscope sensors
> #
> CONFIG_BMG160=y
> CONFIG_BMG160_I2C=y
> CONFIG_FXAS21002C=y
> CONFIG_FXAS21002C_I2C=y
> # CONFIG_MPU3050_I2C is not set
> # CONFIG_IIO_ST_GYRO_3AXIS is not set
> CONFIG_ITG3200=y
> # end of Digital gyroscope sensors
> 
> #
> # Health Sensors
> #
> 
> #
> # Heart Rate Monitors
> #
> CONFIG_AFE4404=y
> # CONFIG_MAX30100 is not set
> CONFIG_MAX30102=y
> # end of Heart Rate Monitors
> # end of Health Sensors
> 
> #
> # Humidity sensors
> #
> CONFIG_AM2315=y
> # CONFIG_DHT11 is not set
> CONFIG_HDC100X=y
> CONFIG_HDC2010=y
> # CONFIG_HTS221 is not set
> CONFIG_HTU21=y
> CONFIG_SI7005=y
> CONFIG_SI7020=y
> # end of Humidity sensors
> 
> #
> # Inertial measurement units
> #
> CONFIG_BMI160=y
> CONFIG_BMI160_I2C=y
> CONFIG_FXOS8700=y
> CONFIG_FXOS8700_I2C=y
> CONFIG_KMX61=y
> # CONFIG_INV_ICM42600_I2C is not set
> CONFIG_INV_MPU6050_IIO=y
> CONFIG_INV_MPU6050_I2C=y
> CONFIG_IIO_ST_LSM6DSX=y
> CONFIG_IIO_ST_LSM6DSX_I2C=y
> CONFIG_IIO_ST_LSM6DSX_I3C=y
> CONFIG_IIO_ST_LSM9DS0=y
> CONFIG_IIO_ST_LSM9DS0_I2C=y
> # end of Inertial measurement units
> 
> #
> # Light sensors
> #
> CONFIG_ADJD_S311=y
> CONFIG_ADUX1020=y
> # CONFIG_AL3010 is not set
> # CONFIG_AL3320A is not set
> # CONFIG_APDS9300 is not set
> CONFIG_APDS9960=y
> CONFIG_AS73211=y
> CONFIG_BH1750=y
> # CONFIG_BH1780 is not set
> CONFIG_CM32181=y
> # CONFIG_CM3232 is not set
> # CONFIG_CM3323 is not set
> CONFIG_CM3605=y
> CONFIG_CM36651=y
> # CONFIG_GP2AP002 is not set
> CONFIG_GP2AP020A00F=y
> CONFIG_IQS621_ALS=y
> # CONFIG_SENSORS_ISL29018 is not set
> CONFIG_SENSORS_ISL29028=y
> CONFIG_ISL29125=y
> CONFIG_JSA1212=y
> CONFIG_RPR0521=y
> CONFIG_SENSORS_LM3533=y
> # CONFIG_LTR501 is not set
> # CONFIG_LV0104CS is not set
> CONFIG_MAX44000=y
> # CONFIG_MAX44009 is not set
> CONFIG_NOA1305=y
> # CONFIG_OPT3001 is not set
> CONFIG_PA12203001=y
> CONFIG_SI1133=y
> CONFIG_SI1145=y
> CONFIG_STK3310=y
> CONFIG_ST_UVIS25=y
> CONFIG_ST_UVIS25_I2C=y
> # CONFIG_TCS3414 is not set
> # CONFIG_TCS3472 is not set
> # CONFIG_SENSORS_TSL2563 is not set
> CONFIG_TSL2583=y
> CONFIG_TSL2591=y
> # CONFIG_TSL2772 is not set
> CONFIG_TSL4531=y
> # CONFIG_US5182D is not set
> CONFIG_VCNL4000=y
> CONFIG_VCNL4035=y
> CONFIG_VEML6030=y
> # CONFIG_VEML6070 is not set
> # CONFIG_VL6180 is not set
> CONFIG_ZOPT2201=y
> # end of Light sensors
> 
> #
> # Magnetometer sensors
> #
> CONFIG_AK8974=y
> CONFIG_AK8975=y
> # CONFIG_AK09911 is not set
> # CONFIG_BMC150_MAGN_I2C is not set
> CONFIG_MAG3110=y
> CONFIG_MMC35240=y
> CONFIG_IIO_ST_MAGN_3AXIS=y
> CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
> CONFIG_SENSORS_HMC5843=y
> CONFIG_SENSORS_HMC5843_I2C=y
> CONFIG_SENSORS_RM3100=y
> CONFIG_SENSORS_RM3100_I2C=y
> # CONFIG_YAMAHA_YAS530 is not set
> # end of Magnetometer sensors
> 
> #
> # Multiplexers
> #
> CONFIG_IIO_MUX=y
> # end of Multiplexers
> 
> #
> # Inclinometer sensors
> #
> # end of Inclinometer sensors
> 
> # CONFIG_IIO_TEST_FORMAT is not set
> 
> #
> # Triggers - standalone
> #
> # CONFIG_IIO_HRTIMER_TRIGGER is not set
> # CONFIG_IIO_INTERRUPT_TRIGGER is not set
> # CONFIG_IIO_STM32_LPTIMER_TRIGGER is not set
> # CONFIG_IIO_STM32_TIMER_TRIGGER is not set
> CONFIG_IIO_TIGHTLOOP_TRIGGER=y
> CONFIG_IIO_SYSFS_TRIGGER=y
> # end of Triggers - standalone
> 
> #
> # Linear and angular position sensors
> #
> CONFIG_IQS624_POS=y
> # end of Linear and angular position sensors
> 
> #
> # Digital potentiometers
> #
> CONFIG_AD5110=y
> # CONFIG_AD5272 is not set
> CONFIG_DS1803=y
> CONFIG_MAX5432=y
> CONFIG_MCP4018=y
> CONFIG_MCP4531=y
> CONFIG_TPL0102=y
> # end of Digital potentiometers
> 
> #
> # Digital potentiostats
> #
> # CONFIG_LMP91000 is not set
> # end of Digital potentiostats
> 
> #
> # Pressure sensors
> #
> CONFIG_ABP060MG=y
> # CONFIG_BMP280 is not set
> # CONFIG_DLHL60D is not set
> # CONFIG_DPS310 is not set
> CONFIG_HP03=y
> # CONFIG_ICP10100 is not set
> CONFIG_MPL115=y
> CONFIG_MPL115_I2C=y
> CONFIG_MPL3115=y
> CONFIG_MS5611=y
> CONFIG_MS5611_I2C=y
> # CONFIG_MS5637 is not set
> CONFIG_IIO_ST_PRESS=y
> CONFIG_IIO_ST_PRESS_I2C=y
> CONFIG_T5403=y
> CONFIG_HP206C=y
> CONFIG_ZPA2326=y
> CONFIG_ZPA2326_I2C=y
> # end of Pressure sensors
> 
> #
> # Lightning sensors
> #
> # end of Lightning sensors
> 
> #
> # Proximity and distance sensors
> #
> CONFIG_ISL29501=y
> # CONFIG_LIDAR_LITE_V2 is not set
> CONFIG_MB1232=y
> CONFIG_PING=y
> CONFIG_RFD77402=y
> CONFIG_SRF04=y
> CONFIG_SX9310=y
> CONFIG_SX9500=y
> CONFIG_SRF08=y
> CONFIG_VCNL3020=y
> CONFIG_VL53L0X_I2C=y
> # end of Proximity and distance sensors
> 
> #
> # Resolver to digital converters
> #
> # end of Resolver to digital converters
> 
> #
> # Temperature sensors
> #
> CONFIG_IQS620AT_TEMP=y
> CONFIG_MLX90614=y
> CONFIG_MLX90632=y
> CONFIG_TMP006=y
> CONFIG_TMP007=y
> CONFIG_TMP117=y
> # CONFIG_TSYS01 is not set
> # CONFIG_TSYS02D is not set
> # end of Temperature sensors
> 
> CONFIG_PWM=y
> CONFIG_PWM_SYSFS=y
> # CONFIG_PWM_DEBUG is not set
> # CONFIG_PWM_ATMEL is not set
> # CONFIG_PWM_ATMEL_TCB is not set
> # CONFIG_PWM_BCM2835 is not set
> # CONFIG_PWM_BERLIN is not set
> # CONFIG_PWM_BRCMSTB is not set
> # CONFIG_PWM_CLPS711X is not set
> # CONFIG_PWM_EP93XX is not set
> # CONFIG_PWM_FSL_FTM is not set
> # CONFIG_PWM_HIBVT is not set
> # CONFIG_PWM_IMX1 is not set
> # CONFIG_PWM_IMX27 is not set
> # CONFIG_PWM_INTEL_LGM is not set
> CONFIG_PWM_IQS620A=y
> CONFIG_PWM_LP3943=y
> # CONFIG_PWM_LPC18XX_SCT is not set
> # CONFIG_PWM_LPC32XX is not set
> # CONFIG_PWM_LPSS_PLATFORM is not set
> # CONFIG_PWM_MTK_DISP is not set
> # CONFIG_PWM_MEDIATEK is not set
> # CONFIG_PWM_MXS is not set
> # CONFIG_PWM_OMAP_DMTIMER is not set
> CONFIG_PWM_PCA9685=y
> # CONFIG_PWM_PXA is not set
> # CONFIG_PWM_RASPBERRYPI_POE is not set
> # CONFIG_PWM_RCAR is not set
> # CONFIG_PWM_RENESAS_TPU is not set
> # CONFIG_PWM_ROCKCHIP is not set
> # CONFIG_PWM_SAMSUNG is not set
> # CONFIG_PWM_SL28CPLD is not set
> # CONFIG_PWM_SPEAR is not set
> # CONFIG_PWM_SPRD is not set
> # CONFIG_PWM_STI is not set
> # CONFIG_PWM_STM32 is not set
> # CONFIG_PWM_STM32_LP is not set
> # CONFIG_PWM_STMPE is not set
> # CONFIG_PWM_TEGRA is not set
> # CONFIG_PWM_TIECAP is not set
> # CONFIG_PWM_TIEHRPWM is not set
> CONFIG_PWM_TWL=y
> CONFIG_PWM_TWL_LED=y
> # CONFIG_PWM_VISCONTI is not set
> # CONFIG_PWM_VT8500 is not set
> 
> #
> # IRQ chip support
> #
> CONFIG_IRQCHIP=y
> CONFIG_AL_FIC=y
> CONFIG_MADERA_IRQ=y
> # CONFIG_JCORE_AIC is not set
> # CONFIG_RENESAS_INTC_IRQPIN is not set
> # CONFIG_RENESAS_IRQC is not set
> # CONFIG_RENESAS_RZA1_IRQC is not set
> # CONFIG_SL28CPLD_INTC is not set
> # CONFIG_TS4800_IRQ is not set
> # CONFIG_INGENIC_TCU_IRQ is not set
> # CONFIG_RENESAS_H8S_INTC is not set
> # CONFIG_IRQ_UNIPHIER_AIDET is not set
> # CONFIG_IMX_IRQSTEER is not set
> # CONFIG_IMX_INTMUX is not set
> # CONFIG_EXYNOS_IRQ_COMBINER is not set
> # CONFIG_LOONGSON_PCH_PIC is not set
> # CONFIG_MST_IRQ is not set
> # end of IRQ chip support
> 
> CONFIG_IPACK_BUS=y
> # CONFIG_SERIAL_IPOCTAL is not set
> CONFIG_RESET_CONTROLLER=y
> # CONFIG_RESET_ATH79 is not set
> # CONFIG_RESET_AXS10X is not set
> # CONFIG_RESET_BCM6345 is not set
> # CONFIG_RESET_BERLIN is not set
> # CONFIG_RESET_BRCMSTB is not set
> # CONFIG_RESET_BRCMSTB_RESCAL is not set
> # CONFIG_RESET_HSDK is not set
> # CONFIG_RESET_IMX7 is not set
> # CONFIG_RESET_INTEL_GW is not set
> # CONFIG_RESET_K210 is not set
> # CONFIG_RESET_LANTIQ is not set
> # CONFIG_RESET_LPC18XX is not set
> # CONFIG_RESET_MCHP_SPARX5 is not set
> # CONFIG_RESET_MESON is not set
> # CONFIG_RESET_MESON_AUDIO_ARB is not set
> # CONFIG_RESET_NPCM is not set
> # CONFIG_RESET_PISTACHIO is not set
> # CONFIG_RESET_QCOM_AOSS is not set
> # CONFIG_RESET_QCOM_PDC is not set
> # CONFIG_RESET_RASPBERRYPI is not set
> # CONFIG_RESET_RZG2L_USBPHY_CTRL is not set
> # CONFIG_RESET_SCMI is not set
> # CONFIG_RESET_SIMPLE is not set
> # CONFIG_RESET_SOCFPGA is not set
> # CONFIG_RESET_SUNXI is not set
> CONFIG_RESET_TI_SYSCON=y
> # CONFIG_RESET_UNIPHIER is not set
> # CONFIG_RESET_UNIPHIER_GLUE is not set
> # CONFIG_RESET_ZYNQ is not set
> # CONFIG_COMMON_RESET_HI3660 is not set
> # CONFIG_COMMON_RESET_HI6220 is not set
> 
> #
> # PHY Subsystem
> #
> CONFIG_GENERIC_PHY=y
> # CONFIG_PHY_LPC18XX_USB_OTG is not set
> # CONFIG_PHY_PISTACHIO_USB is not set
> # CONFIG_PHY_XGENE is not set
> # CONFIG_USB_LGM_PHY is not set
> # CONFIG_PHY_CAN_TRANSCEIVER is not set
> # CONFIG_PHY_SUN4I_USB is not set
> # CONFIG_PHY_SUN9I_USB is not set
> # CONFIG_PHY_SUN50I_USB3 is not set
> # CONFIG_PHY_MESON8B_USB2 is not set
> # CONFIG_PHY_MESON_GXL_USB2 is not set
> # CONFIG_PHY_MESON_G12A_USB2 is not set
> # CONFIG_PHY_MESON_G12A_USB3_PCIE is not set
> # CONFIG_PHY_MESON_AXG_PCIE is not set
> # CONFIG_PHY_MESON_AXG_MIPI_PCIE_ANALOG is not set
> # CONFIG_PHY_MESON_AXG_MIPI_DPHY is not set
> # CONFIG_PHY_BCM63XX_USBH is not set
> # CONFIG_PHY_CYGNUS_PCIE is not set
> # CONFIG_PHY_BCM_SR_USB is not set
> CONFIG_BCM_KONA_USB2_PHY=y
> # CONFIG_PHY_BCM_NS_USB2 is not set
> # CONFIG_PHY_BCM_NS_USB3 is not set
> # CONFIG_PHY_NS2_PCIE is not set
> # CONFIG_PHY_NS2_USB_DRD is not set
> # CONFIG_PHY_BRCM_SATA is not set
> # CONFIG_PHY_BRCM_USB is not set
> # CONFIG_PHY_BCM_SR_PCIE is not set
> # CONFIG_PHY_CADENCE_DPHY is not set
> # CONFIG_PHY_CADENCE_SALVO is not set
> # CONFIG_PHY_FSL_IMX8MQ_USB is not set
> # CONFIG_PHY_MIXEL_MIPI_DPHY is not set
> # CONFIG_PHY_HI6220_USB is not set
> # CONFIG_PHY_HI3660_USB is not set
> # CONFIG_PHY_HI3670_USB is not set
> # CONFIG_PHY_HISTB_COMBPHY is not set
> # CONFIG_PHY_HISI_INNO_USB2 is not set
> # CONFIG_PHY_INGENIC_USB is not set
> # CONFIG_PHY_LANTIQ_VRX200_PCIE is not set
> # CONFIG_PHY_LANTIQ_RCU_USB2 is not set
> # CONFIG_ARMADA375_USBCLUSTER_PHY is not set
> # CONFIG_PHY_BERLIN_SATA is not set
> # CONFIG_PHY_BERLIN_USB is not set
> CONFIG_PHY_MVEBU_A3700_UTMI=y
> # CONFIG_PHY_MVEBU_A38X_COMPHY is not set
> # CONFIG_PHY_MVEBU_CP110_UTMI is not set
> # CONFIG_PHY_PXA_28NM_HSIC is not set
> CONFIG_PHY_PXA_28NM_USB2=y
> # CONFIG_PHY_PXA_USB is not set
> # CONFIG_PHY_MMP3_USB is not set
> # CONFIG_PHY_MMP3_HSIC is not set
> # CONFIG_PHY_MTK_TPHY is not set
> # CONFIG_PHY_MTK_UFS is not set
> # CONFIG_PHY_MTK_XSPHY is not set
> # CONFIG_PHY_SPARX5_SERDES is not set
> CONFIG_PHY_CPCAP_USB=y
> CONFIG_PHY_MAPPHONE_MDM6600=y
> CONFIG_PHY_OCELOT_SERDES=y
> CONFIG_PHY_ATH79_USB=y
> # CONFIG_PHY_QCOM_IPQ4019_USB is not set
> # CONFIG_PHY_QCOM_QUSB2 is not set
> CONFIG_PHY_QCOM_USB_HS=y
> # CONFIG_PHY_QCOM_USB_SNPS_FEMTO_V2 is not set
> CONFIG_PHY_QCOM_USB_HSIC=y
> # CONFIG_PHY_QCOM_USB_HS_28NM is not set
> # CONFIG_PHY_QCOM_USB_SS is not set
> # CONFIG_PHY_QCOM_IPQ806X_USB is not set
> # CONFIG_PHY_MT7621_PCI is not set
> # CONFIG_PHY_RALINK_USB is not set
> # CONFIG_PHY_RCAR_GEN3_USB3 is not set
> # CONFIG_PHY_ROCKCHIP_DPHY_RX0 is not set
> # CONFIG_PHY_ROCKCHIP_INNO_CSIDPHY is not set
> # CONFIG_PHY_ROCKCHIP_INNO_DSIDPHY is not set
> # CONFIG_PHY_ROCKCHIP_PCIE is not set
> # CONFIG_PHY_ROCKCHIP_TYPEC is not set
> # CONFIG_PHY_EXYNOS_DP_VIDEO is not set
> # CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
> # CONFIG_PHY_EXYNOS_PCIE is not set
> # CONFIG_PHY_SAMSUNG_UFS is not set
> CONFIG_PHY_SAMSUNG_USB2=y
> # CONFIG_PHY_S5PV210_USB2 is not set
> # CONFIG_PHY_UNIPHIER_USB2 is not set
> # CONFIG_PHY_UNIPHIER_USB3 is not set
> # CONFIG_PHY_UNIPHIER_PCIE is not set
> # CONFIG_PHY_UNIPHIER_AHCI is not set
> # CONFIG_PHY_ST_SPEAR1310_MIPHY is not set
> # CONFIG_PHY_ST_SPEAR1340_MIPHY is not set
> # CONFIG_PHY_STIH407_USB is not set
> # CONFIG_PHY_TEGRA194_P2U is not set
> # CONFIG_PHY_DA8XX_USB is not set
> # CONFIG_PHY_DM816X_USB is not set
> # CONFIG_OMAP_CONTROL_PHY is not set
> # CONFIG_TI_PIPE3 is not set
> # CONFIG_PHY_TUSB1210 is not set
> # CONFIG_PHY_INTEL_KEEMBAY_EMMC is not set
> # CONFIG_PHY_INTEL_KEEMBAY_USB is not set
> # CONFIG_PHY_INTEL_LGM_COMBO is not set
> # CONFIG_PHY_INTEL_LGM_EMMC is not set
> # CONFIG_PHY_XILINX_ZYNQMP is not set
> # end of PHY Subsystem
> 
> # CONFIG_POWERCAP is not set
> CONFIG_MCB=y
> # CONFIG_MCB_LPC is not set
> 
> #
> # Performance monitor support
> #
> # CONFIG_ARM_DMC620_PMU is not set
> # end of Performance monitor support
> 
> # CONFIG_RAS is not set
> 
> #
> # Android
> #
> # CONFIG_ANDROID is not set
> # end of Android
> 
> CONFIG_DAX=y
> CONFIG_NVMEM=y
> CONFIG_NVMEM_SYSFS=y
> # CONFIG_NVMEM_IMX_IIM is not set
> # CONFIG_NVMEM_IMX_OCOTP is not set
> # CONFIG_JZ4780_EFUSE is not set
> # CONFIG_NVMEM_LPC18XX_EEPROM is not set
> # CONFIG_NVMEM_LPC18XX_OTP is not set
> # CONFIG_NVMEM_MXS_OCOTP is not set
> # CONFIG_MTK_EFUSE is not set
> # CONFIG_NVMEM_NINTENDO_OTP is not set
> # CONFIG_QCOM_QFPROM is not set
> CONFIG_NVMEM_SPMI_SDAM=y
> # CONFIG_ROCKCHIP_EFUSE is not set
> # CONFIG_ROCKCHIP_OTP is not set
> # CONFIG_NVMEM_BCM_OCOTP is not set
> # CONFIG_NVMEM_STM32_ROMEM is not set
> # CONFIG_UNIPHIER_EFUSE is not set
> # CONFIG_NVMEM_VF610_OCOTP is not set
> # CONFIG_MESON_MX_EFUSE is not set
> # CONFIG_NVMEM_SNVS_LPGPR is not set
> # CONFIG_SC27XX_EFUSE is not set
> # CONFIG_SPRD_EFUSE is not set
> CONFIG_NVMEM_RMEM=y
> # CONFIG_NVMEM_BRCM_NVRAM is not set
> 
> #
> # HW tracing support
> #
> CONFIG_STM=y
> # CONFIG_STM_PROTO_BASIC is not set
> CONFIG_STM_PROTO_SYS_T=y
> # CONFIG_STM_DUMMY is not set
> CONFIG_STM_SOURCE_CONSOLE=y
> CONFIG_STM_SOURCE_HEARTBEAT=y
> # CONFIG_STM_SOURCE_FTRACE is not set
> # CONFIG_INTEL_TH is not set
> # end of HW tracing support
> 
> # CONFIG_FPGA is not set
> CONFIG_FSI=y
> # CONFIG_FSI_NEW_DEV_NODE is not set
> CONFIG_FSI_MASTER_GPIO=y
> CONFIG_FSI_MASTER_HUB=y
> CONFIG_FSI_MASTER_ASPEED=y
> CONFIG_FSI_SCOM=y
> CONFIG_FSI_SBEFIFO=y
> # CONFIG_FSI_OCC is not set
> # CONFIG_TEE is not set
> CONFIG_MULTIPLEXER=y
> 
> #
> # Multiplexer drivers
> #
> # CONFIG_MUX_ADG792A is not set
> CONFIG_MUX_GPIO=y
> CONFIG_MUX_MMIO=y
> # end of Multiplexer drivers
> 
> CONFIG_PM_OPP=y
> # CONFIG_SIOX is not set
> CONFIG_SLIMBUS=y
> # CONFIG_SLIM_QCOM_CTRL is not set
> CONFIG_INTERCONNECT=y
> # CONFIG_INTERCONNECT_IMX is not set
> # CONFIG_INTERCONNECT_QCOM_OSM_L3 is not set
> # CONFIG_INTERCONNECT_SAMSUNG is not set
> # CONFIG_COUNTER is not set
> # CONFIG_MOST is not set
> # end of Device Drivers
> 
> #
> # File systems
> #
> # CONFIG_VALIDATE_FS_PARSER is not set
> CONFIG_FS_IOMAP=y
> CONFIG_EXT2_FS=y
> # CONFIG_EXT2_FS_XATTR is not set
> # CONFIG_EXT3_FS is not set
> CONFIG_EXT4_FS=y
> CONFIG_EXT4_FS_POSIX_ACL=y
> # CONFIG_EXT4_FS_SECURITY is not set
> # CONFIG_EXT4_DEBUG is not set
> CONFIG_EXT4_KUNIT_TESTS=y
> CONFIG_JBD2=y
> CONFIG_JBD2_DEBUG=y
> CONFIG_FS_MBCACHE=y
> CONFIG_REISERFS_FS=y
> # CONFIG_REISERFS_CHECK is not set
> CONFIG_REISERFS_PROC_INFO=y
> CONFIG_REISERFS_FS_XATTR=y
> CONFIG_REISERFS_FS_POSIX_ACL=y
> CONFIG_REISERFS_FS_SECURITY=y
> CONFIG_JFS_FS=y
> # CONFIG_JFS_POSIX_ACL is not set
> # CONFIG_JFS_SECURITY is not set
> # CONFIG_JFS_DEBUG is not set
> # CONFIG_JFS_STATISTICS is not set
> CONFIG_XFS_FS=y
> # CONFIG_XFS_SUPPORT_V4 is not set
> CONFIG_XFS_QUOTA=y
> # CONFIG_XFS_POSIX_ACL is not set
> # CONFIG_XFS_RT is not set
> CONFIG_XFS_ONLINE_SCRUB=y
> CONFIG_XFS_ONLINE_REPAIR=y
> # CONFIG_XFS_WARN is not set
> # CONFIG_XFS_DEBUG is not set
> # CONFIG_GFS2_FS is not set
> CONFIG_BTRFS_FS=y
> # CONFIG_BTRFS_FS_POSIX_ACL is not set
> CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
> CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
> CONFIG_BTRFS_DEBUG=y
> # CONFIG_BTRFS_ASSERT is not set
> # CONFIG_BTRFS_FS_REF_VERIFY is not set
> # CONFIG_NILFS2_FS is not set
> # CONFIG_F2FS_FS is not set
> CONFIG_ZONEFS_FS=y
> # CONFIG_FS_DAX is not set
> CONFIG_FS_POSIX_ACL=y
> CONFIG_EXPORTFS=y
> # CONFIG_EXPORTFS_BLOCK_OPS is not set
> # CONFIG_FILE_LOCKING is not set
> # CONFIG_FS_ENCRYPTION is not set
> # CONFIG_FS_VERITY is not set
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> CONFIG_INOTIFY_USER=y
> # CONFIG_FANOTIFY is not set
> CONFIG_QUOTA=y
> # CONFIG_QUOTA_NETLINK_INTERFACE is not set
> CONFIG_PRINT_QUOTA_WARNING=y
> # CONFIG_QUOTA_DEBUG is not set
> CONFIG_QUOTA_TREE=y
> CONFIG_QFMT_V1=y
> CONFIG_QFMT_V2=y
> CONFIG_QUOTACTL=y
> CONFIG_AUTOFS4_FS=y
> CONFIG_AUTOFS_FS=y
> CONFIG_FUSE_FS=y
> CONFIG_CUSE=y
> # CONFIG_VIRTIO_FS is not set
> # CONFIG_OVERLAY_FS is not set
> 
> #
> # Caches
> #
> CONFIG_NETFS_SUPPORT=y
> CONFIG_NETFS_STATS=y
> CONFIG_FSCACHE=y
> CONFIG_FSCACHE_STATS=y
> # CONFIG_FSCACHE_DEBUG is not set
> # CONFIG_CACHEFILES is not set
> # end of Caches
> 
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=y
> CONFIG_JOLIET=y
> # CONFIG_ZISOFS is not set
> CONFIG_UDF_FS=y
> # end of CD-ROM/DVD Filesystems
> 
> #
> # DOS/FAT/EXFAT/NT Filesystems
> #
> CONFIG_FAT_FS=y
> # CONFIG_MSDOS_FS is not set
> CONFIG_VFAT_FS=y
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> CONFIG_FAT_DEFAULT_UTF8=y
> CONFIG_FAT_KUNIT_TEST=y
> # CONFIG_EXFAT_FS is not set
> CONFIG_NTFS_FS=y
> CONFIG_NTFS_DEBUG=y
> CONFIG_NTFS_RW=y
> CONFIG_NTFS3_FS=y
> # CONFIG_NTFS3_LZX_XPRESS is not set
> CONFIG_NTFS3_FS_POSIX_ACL=y
> # end of DOS/FAT/EXFAT/NT Filesystems
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> # CONFIG_PROC_KCORE is not set
> CONFIG_PROC_SYSCTL=y
> # CONFIG_PROC_PAGE_MONITOR is not set
> CONFIG_PROC_CHILDREN=y
> CONFIG_KERNFS=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> # CONFIG_TMPFS_POSIX_ACL is not set
> # CONFIG_TMPFS_XATTR is not set
> CONFIG_ARCH_SUPPORTS_HUGETLBFS=y
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> CONFIG_MEMFD_CREATE=y
> CONFIG_CONFIGFS_FS=y
> # end of Pseudo filesystems
> 
> # CONFIG_MISC_FILESYSTEMS is not set
> # CONFIG_NETWORK_FILESYSTEMS is not set
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> CONFIG_NLS_CODEPAGE_437=y
> CONFIG_NLS_CODEPAGE_737=y
> CONFIG_NLS_CODEPAGE_775=y
> # CONFIG_NLS_CODEPAGE_850 is not set
> # CONFIG_NLS_CODEPAGE_852 is not set
> CONFIG_NLS_CODEPAGE_855=y
> CONFIG_NLS_CODEPAGE_857=y
> CONFIG_NLS_CODEPAGE_860=y
> CONFIG_NLS_CODEPAGE_861=y
> CONFIG_NLS_CODEPAGE_862=y
> CONFIG_NLS_CODEPAGE_863=y
> # CONFIG_NLS_CODEPAGE_864 is not set
> # CONFIG_NLS_CODEPAGE_865 is not set
> CONFIG_NLS_CODEPAGE_866=y
> CONFIG_NLS_CODEPAGE_869=y
> CONFIG_NLS_CODEPAGE_936=y
> # CONFIG_NLS_CODEPAGE_950 is not set
> CONFIG_NLS_CODEPAGE_932=y
> # CONFIG_NLS_CODEPAGE_949 is not set
> # CONFIG_NLS_CODEPAGE_874 is not set
> CONFIG_NLS_ISO8859_8=y
> CONFIG_NLS_CODEPAGE_1250=y
> # CONFIG_NLS_CODEPAGE_1251 is not set
> CONFIG_NLS_ASCII=y
> # CONFIG_NLS_ISO8859_1 is not set
> CONFIG_NLS_ISO8859_2=y
> # CONFIG_NLS_ISO8859_3 is not set
> CONFIG_NLS_ISO8859_4=y
> # CONFIG_NLS_ISO8859_5 is not set
> CONFIG_NLS_ISO8859_6=y
> CONFIG_NLS_ISO8859_7=y
> # CONFIG_NLS_ISO8859_9 is not set
> CONFIG_NLS_ISO8859_13=y
> CONFIG_NLS_ISO8859_14=y
> CONFIG_NLS_ISO8859_15=y
> CONFIG_NLS_KOI8_R=y
> CONFIG_NLS_KOI8_U=y
> CONFIG_NLS_MAC_ROMAN=y
> CONFIG_NLS_MAC_CELTIC=y
> CONFIG_NLS_MAC_CENTEURO=y
> # CONFIG_NLS_MAC_CROATIAN is not set
> CONFIG_NLS_MAC_CYRILLIC=y
> CONFIG_NLS_MAC_GAELIC=y
> CONFIG_NLS_MAC_GREEK=y
> CONFIG_NLS_MAC_ICELAND=y
> CONFIG_NLS_MAC_INUIT=y
> # CONFIG_NLS_MAC_ROMANIAN is not set
> # CONFIG_NLS_MAC_TURKISH is not set
> CONFIG_NLS_UTF8=y
> CONFIG_UNICODE=y
> # CONFIG_UNICODE_NORMALIZATION_SELFTEST is not set
> CONFIG_IO_WQ=y
> # end of File systems
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> # CONFIG_KEYS_REQUEST_CACHE is not set
> # CONFIG_PERSISTENT_KEYRINGS is not set
> CONFIG_ENCRYPTED_KEYS=y
> CONFIG_KEY_DH_OPERATIONS=y
> CONFIG_KEY_NOTIFICATIONS=y
> # CONFIG_SECURITY_DMESG_RESTRICT is not set
> # CONFIG_SECURITYFS is not set
> CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
> # CONFIG_HARDENED_USERCOPY is not set
> # CONFIG_FORTIFY_SOURCE is not set
> CONFIG_STATIC_USERMODEHELPER=y
> CONFIG_STATIC_USERMODEHELPER_PATH="/sbin/usermode-helper"
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_LSM="landlock,lockdown,yama,loadpin,safesetid,integrity,bpf"
> 
> #
> # Kernel hardening options
> #
> 
> #
> # Memory initialization
> #
> CONFIG_CC_HAS_AUTO_VAR_INIT_PATTERN=y
> CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO=y
> # CONFIG_INIT_STACK_NONE is not set
> # CONFIG_INIT_STACK_ALL_PATTERN is not set
> CONFIG_INIT_STACK_ALL_ZERO=y
> # CONFIG_INIT_ON_ALLOC_DEFAULT_ON is not set
> CONFIG_INIT_ON_FREE_DEFAULT_ON=y
> CONFIG_CC_HAS_ZERO_CALL_USED_REGS=y
> # CONFIG_ZERO_CALL_USED_REGS is not set
> # end of Memory initialization
> # end of Kernel hardening options
> # end of Security options
> 
> CONFIG_XOR_BLOCKS=y
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ALGAPI2=y
> CONFIG_CRYPTO_AEAD=y
> CONFIG_CRYPTO_AEAD2=y
> CONFIG_CRYPTO_SKCIPHER=y
> CONFIG_CRYPTO_SKCIPHER2=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_HASH2=y
> CONFIG_CRYPTO_RNG=y
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_RNG_DEFAULT=y
> CONFIG_CRYPTO_AKCIPHER2=y
> CONFIG_CRYPTO_AKCIPHER=y
> CONFIG_CRYPTO_KPP2=y
> CONFIG_CRYPTO_KPP=y
> CONFIG_CRYPTO_ACOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> CONFIG_CRYPTO_USER=y
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> CONFIG_CRYPTO_GF128MUL=y
> CONFIG_CRYPTO_NULL=y
> CONFIG_CRYPTO_NULL2=y
> # CONFIG_CRYPTO_CRYPTD is not set
> CONFIG_CRYPTO_AUTHENC=y
> CONFIG_CRYPTO_TEST=y
> 
> #
> # Public-key cryptography
> #
> CONFIG_CRYPTO_RSA=y
> CONFIG_CRYPTO_DH=y
> CONFIG_CRYPTO_ECC=y
> CONFIG_CRYPTO_ECDH=y
> CONFIG_CRYPTO_ECDSA=y
> CONFIG_CRYPTO_ECRDSA=y
> # CONFIG_CRYPTO_SM2 is not set
> # CONFIG_CRYPTO_CURVE25519 is not set
> 
> #
> # Authenticated Encryption with Associated Data
> #
> # CONFIG_CRYPTO_CCM is not set
> # CONFIG_CRYPTO_GCM is not set
> CONFIG_CRYPTO_CHACHA20POLY1305=y
> CONFIG_CRYPTO_AEGIS128=y
> CONFIG_CRYPTO_SEQIV=y
> CONFIG_CRYPTO_ECHAINIV=y
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> # CONFIG_CRYPTO_CFB is not set
> CONFIG_CRYPTO_CTR=y
> CONFIG_CRYPTO_CTS=y
> CONFIG_CRYPTO_ECB=y
> # CONFIG_CRYPTO_LRW is not set
> CONFIG_CRYPTO_OFB=y
> CONFIG_CRYPTO_PCBC=y
> CONFIG_CRYPTO_XTS=y
> CONFIG_CRYPTO_KEYWRAP=y
> CONFIG_CRYPTO_NHPOLY1305=y
> CONFIG_CRYPTO_ADIANTUM=y
> # CONFIG_CRYPTO_ESSIV is not set
> 
> #
> # Hash modes
> #
> CONFIG_CRYPTO_CMAC=y
> CONFIG_CRYPTO_HMAC=y
> # CONFIG_CRYPTO_XCBC is not set
> CONFIG_CRYPTO_VMAC=y
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> CONFIG_CRYPTO_CRC32=y
> CONFIG_CRYPTO_XXHASH=y
> CONFIG_CRYPTO_BLAKE2B=y
> # CONFIG_CRYPTO_BLAKE2S is not set
> CONFIG_CRYPTO_CRCT10DIF=y
> CONFIG_CRYPTO_GHASH=y
> CONFIG_CRYPTO_POLY1305=y
> CONFIG_CRYPTO_MD4=y
> CONFIG_CRYPTO_MD5=y
> CONFIG_CRYPTO_MD5_PPC=y
> # CONFIG_CRYPTO_MICHAEL_MIC is not set
> # CONFIG_CRYPTO_RMD160 is not set
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA1_PPC=y
> CONFIG_CRYPTO_SHA256=y
> CONFIG_CRYPTO_SHA512=y
> CONFIG_CRYPTO_SHA3=y
> # CONFIG_CRYPTO_SM3 is not set
> CONFIG_CRYPTO_STREEBOG=y
> CONFIG_CRYPTO_WP512=y
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_TI=y
> CONFIG_CRYPTO_ANUBIS=y
> CONFIG_CRYPTO_ARC4=y
> # CONFIG_CRYPTO_BLOWFISH is not set
> CONFIG_CRYPTO_CAMELLIA=y
> CONFIG_CRYPTO_CAST_COMMON=y
> # CONFIG_CRYPTO_CAST5 is not set
> CONFIG_CRYPTO_CAST6=y
> CONFIG_CRYPTO_DES=y
> CONFIG_CRYPTO_FCRYPT=y
> # CONFIG_CRYPTO_KHAZAD is not set
> CONFIG_CRYPTO_CHACHA20=y
> # CONFIG_CRYPTO_SEED is not set
> # CONFIG_CRYPTO_SERPENT is not set
> CONFIG_CRYPTO_SM4=y
> CONFIG_CRYPTO_TEA=y
> # CONFIG_CRYPTO_TWOFISH is not set
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=y
> CONFIG_CRYPTO_LZO=y
> CONFIG_CRYPTO_842=y
> CONFIG_CRYPTO_LZ4=y
> CONFIG_CRYPTO_LZ4HC=y
> CONFIG_CRYPTO_ZSTD=y
> 
> #
> # Random Number Generation
> #
> # CONFIG_CRYPTO_ANSI_CPRNG is not set
> CONFIG_CRYPTO_DRBG_MENU=y
> CONFIG_CRYPTO_DRBG_HMAC=y
> # CONFIG_CRYPTO_DRBG_HASH is not set
> CONFIG_CRYPTO_DRBG_CTR=y
> CONFIG_CRYPTO_DRBG=y
> CONFIG_CRYPTO_JITTERENTROPY=y
> CONFIG_CRYPTO_USER_API=y
> # CONFIG_CRYPTO_USER_API_HASH is not set
> # CONFIG_CRYPTO_USER_API_SKCIPHER is not set
> CONFIG_CRYPTO_USER_API_RNG=y
> CONFIG_CRYPTO_USER_API_RNG_CAVP=y
> # CONFIG_CRYPTO_USER_API_AEAD is not set
> CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE=y
> # CONFIG_CRYPTO_STATS is not set
> CONFIG_CRYPTO_HASH_INFO=y
> 
> #
> # Crypto library routines
> #
> CONFIG_CRYPTO_LIB_AES=y
> CONFIG_CRYPTO_LIB_ARC4=y
> # CONFIG_CRYPTO_LIB_BLAKE2S is not set
> CONFIG_CRYPTO_LIB_CHACHA_GENERIC=y
> # CONFIG_CRYPTO_LIB_CHACHA is not set
> # CONFIG_CRYPTO_LIB_CURVE25519 is not set
> CONFIG_CRYPTO_LIB_DES=y
> CONFIG_CRYPTO_LIB_POLY1305_RSIZE=1
> CONFIG_CRYPTO_LIB_POLY1305_GENERIC=y
> CONFIG_CRYPTO_LIB_POLY1305=y
> # CONFIG_CRYPTO_LIB_CHACHA20POLY1305 is not set
> CONFIG_CRYPTO_LIB_SHA256=y
> CONFIG_CRYPTO_LIB_SM4=y
> # CONFIG_CRYPTO_HW is not set
> CONFIG_ASYMMETRIC_KEY_TYPE=y
> CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
> CONFIG_X509_CERTIFICATE_PARSER=y
> # CONFIG_PKCS8_PRIVATE_KEY_PARSER is not set
> # CONFIG_PKCS7_MESSAGE_PARSER is not set
> 
> #
> # Certificates for signature checking
> #
> # CONFIG_SYSTEM_TRUSTED_KEYRING is not set
> CONFIG_SYSTEM_BLACKLIST_KEYRING=y
> CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
> # end of Certificates for signature checking
> 
> CONFIG_BINARY_PRINTF=y
> 
> #
> # Library routines
> #
> CONFIG_RAID6_PQ=y
> CONFIG_RAID6_PQ_BENCHMARK=y
> CONFIG_LINEAR_RANGES=y
> # CONFIG_PACKING is not set
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_STRNCPY_FROM_USER=y
> CONFIG_GENERIC_STRNLEN_USER=y
> CONFIG_GENERIC_NET_UTILS=y
> CONFIG_CORDIC=y
> CONFIG_PRIME_NUMBERS=y
> CONFIG_RATIONAL=y
> CONFIG_CRC_CCITT=y
> CONFIG_CRC16=y
> CONFIG_CRC_T10DIF=y
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> # CONFIG_CRC32_SELFTEST is not set
> CONFIG_CRC32_SLICEBY8=y
> # CONFIG_CRC32_SLICEBY4 is not set
> # CONFIG_CRC32_SARWATE is not set
> # CONFIG_CRC32_BIT is not set
> CONFIG_CRC64=y
> CONFIG_CRC4=y
> CONFIG_CRC7=y
> CONFIG_LIBCRC32C=y
> CONFIG_CRC8=y
> CONFIG_XXHASH=y
> # CONFIG_RANDOM32_SELFTEST is not set
> CONFIG_842_COMPRESS=y
> CONFIG_842_DECOMPRESS=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_LZ4_COMPRESS=y
> CONFIG_LZ4HC_COMPRESS=y
> CONFIG_LZ4_DECOMPRESS=y
> CONFIG_ZSTD_COMPRESS=y
> CONFIG_ZSTD_DECOMPRESS=y
> CONFIG_XZ_DEC=y
> # CONFIG_XZ_DEC_X86 is not set
> # CONFIG_XZ_DEC_POWERPC is not set
> # CONFIG_XZ_DEC_IA64 is not set
> CONFIG_XZ_DEC_ARM=y
> # CONFIG_XZ_DEC_ARMTHUMB is not set
> # CONFIG_XZ_DEC_SPARC is not set
> CONFIG_XZ_DEC_BCJ=y
> # CONFIG_XZ_DEC_TEST is not set
> CONFIG_DECOMPRESS_BZIP2=y
> CONFIG_DECOMPRESS_LZMA=y
> CONFIG_DECOMPRESS_XZ=y
> CONFIG_DECOMPRESS_LZO=y
> CONFIG_DECOMPRESS_ZSTD=y
> CONFIG_GENERIC_ALLOCATOR=y
> CONFIG_REED_SOLOMON=y
> CONFIG_REED_SOLOMON_ENC16=y
> CONFIG_REED_SOLOMON_DEC16=y
> CONFIG_BCH=y
> CONFIG_INTERVAL_TREE=y
> CONFIG_ASSOCIATIVE_ARRAY=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT_MAP=y
> CONFIG_HAS_DMA=y
> CONFIG_DMA_OPS=y
> CONFIG_NEED_SG_DMA_LENGTH=y
> CONFIG_NEED_DMA_MAP_STATE=y
> CONFIG_DMA_DECLARE_COHERENT=y
> CONFIG_ARCH_HAS_SYNC_DMA_FOR_DEVICE=y
> CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU=y
> CONFIG_ARCH_HAS_DMA_PREP_COHERENT=y
> CONFIG_DMA_NONCOHERENT_MMAP=y
> CONFIG_DMA_COHERENT_POOL=y
> CONFIG_DMA_REMAP=y
> CONFIG_DMA_DIRECT_REMAP=y
> # CONFIG_DMA_API_DEBUG is not set
> CONFIG_DMA_MAP_BENCHMARK=y
> CONFIG_SGL_ALLOC=y
> CONFIG_DQL=y
> CONFIG_GLOB=y
> CONFIG_GLOB_SELFTEST=y
> CONFIG_NLATTR=y
> CONFIG_GENERIC_ATOMIC64=y
> CONFIG_CLZ_TAB=y
> # CONFIG_IRQ_POLL is not set
> CONFIG_MPILIB=y
> CONFIG_DIMLIB=y
> CONFIG_LIBFDT=y
> CONFIG_OID_REGISTRY=y
> CONFIG_HAVE_GENERIC_VDSO=y
> CONFIG_GENERIC_GETTIMEOFDAY=y
> CONFIG_GENERIC_VDSO_TIME_NS=y
> CONFIG_FONT_SUPPORT=y
> CONFIG_FONT_8x16=y
> CONFIG_FONT_AUTOSELECT=y
> CONFIG_SG_POOL=y
> CONFIG_ARCH_HAS_PMEM_API=y
> CONFIG_ARCH_HAS_MEMREMAP_COMPAT_ALIGN=y
> CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
> CONFIG_ARCH_STACKWALK=y
> CONFIG_STACKDEPOT=y
> CONFIG_STACK_HASH_ORDER=20
> CONFIG_SBITMAP=y
> # CONFIG_PARMAN is not set
> # CONFIG_OBJAGG is not set
> # end of Library routines
> 
> #
> # Kernel hacking
> #
> 
> #
> # printk and dmesg options
> #
> CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
> CONFIG_CONSOLE_LOGLEVEL_QUIET=4
> CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
> # CONFIG_SYMBOLIC_ERRNAME is not set
> # CONFIG_DEBUG_BUGVERBOSE is not set
> # end of printk and dmesg options
> 
> #
> # Compile-time checks and compiler options
> #
> CONFIG_FRAME_WARN=1024
> # CONFIG_STRIP_ASM_SYMS is not set
> CONFIG_READABLE_ASM=y
> CONFIG_HEADERS_INSTALL=y
> CONFIG_DEBUG_SECTION_MISMATCH=y
> CONFIG_SECTION_MISMATCH_WARN_ONLY=y
> # CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B is not set
> # CONFIG_VMLINUX_MAP is not set
> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> # end of Compile-time checks and compiler options
> 
> #
> # Generic Kernel Debugging Instruments
> #
> # CONFIG_MAGIC_SYSRQ is not set
> CONFIG_DEBUG_FS=y
> CONFIG_DEBUG_FS_ALLOW_ALL=y
> # CONFIG_DEBUG_FS_DISALLOW_MOUNT is not set
> # CONFIG_DEBUG_FS_ALLOW_NONE is not set
> CONFIG_HAVE_ARCH_KGDB=y
> CONFIG_KGDB=y
> # CONFIG_KGDB_TESTS is not set
> # CONFIG_KGDB_KDB is not set
> CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
> CONFIG_UBSAN=y
> CONFIG_CC_HAS_UBSAN_BOUNDS=y
> # CONFIG_UBSAN_BOUNDS is not set
> # CONFIG_UBSAN_SHIFT is not set
> CONFIG_UBSAN_DIV_ZERO=y
> # CONFIG_UBSAN_UNREACHABLE is not set
> CONFIG_UBSAN_BOOL=y
> CONFIG_UBSAN_ENUM=y
> CONFIG_UBSAN_SANITIZE_ALL=y
> CONFIG_HAVE_KCSAN_COMPILER=y
> # end of Generic Kernel Debugging Instruments
> 
> CONFIG_DEBUG_KERNEL=y
> # CONFIG_DEBUG_MISC is not set
> 
> #
> # Memory Debugging
> #
> # CONFIG_PAGE_EXTENSION is not set
> # CONFIG_DEBUG_PAGEALLOC is not set
> # CONFIG_PAGE_OWNER is not set
> # CONFIG_PAGE_POISONING is not set
> # CONFIG_DEBUG_PAGE_REF is not set
> CONFIG_DEBUG_RODATA_TEST=y
> CONFIG_ARCH_HAS_DEBUG_WX=y
> CONFIG_DEBUG_WX=y
> CONFIG_GENERIC_PTDUMP=y
> CONFIG_PTDUMP_CORE=y
> # CONFIG_PTDUMP_DEBUGFS is not set
> # CONFIG_DEBUG_OBJECTS is not set
> CONFIG_DEBUG_SLAB=y
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> # CONFIG_DEBUG_KMEMLEAK is not set
> # CONFIG_DEBUG_STACK_USAGE is not set
> CONFIG_SCHED_STACK_END_CHECK=y
> CONFIG_ARCH_HAS_DEBUG_VM_PGTABLE=y
> CONFIG_DEBUG_VM=y
> # CONFIG_DEBUG_VM_VMACACHE is not set
> # CONFIG_DEBUG_VM_RB is not set
> # CONFIG_DEBUG_VM_PGFLAGS is not set
> CONFIG_DEBUG_VM_PGTABLE=y
> CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
> # CONFIG_DEBUG_VIRTUAL is not set
> # CONFIG_DEBUG_MEMORY_INIT is not set
> CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
> # CONFIG_DEBUG_STACKOVERFLOW is not set
> CONFIG_HAVE_ARCH_KASAN=y
> CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
> CONFIG_CC_HAS_KASAN_GENERIC=y
> CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
> CONFIG_HAVE_ARCH_KFENCE=y
> # CONFIG_KFENCE is not set
> # end of Memory Debugging
> 
> # CONFIG_DEBUG_SHIRQ is not set
> 
> #
> # Debug Oops, Lockups and Hangs
> #
> # CONFIG_PANIC_ON_OOPS is not set
> CONFIG_PANIC_ON_OOPS_VALUE=0
> # CONFIG_SOFTLOCKUP_DETECTOR is not set
> # CONFIG_DETECT_HUNG_TASK is not set
> CONFIG_WQ_WATCHDOG=y
> # end of Debug Oops, Lockups and Hangs
> 
> #
> # Scheduler Debugging
> #
> CONFIG_SCHED_DEBUG=y
> # CONFIG_SCHEDSTATS is not set
> # end of Scheduler Debugging
> 
> # CONFIG_DEBUG_TIMEKEEPING is not set
> 
> #
> # Lock Debugging (spinlocks, mutexes, etc...)
> #
> CONFIG_LOCK_DEBUGGING_SUPPORT=y
> CONFIG_PROVE_LOCKING=y
> CONFIG_PROVE_RAW_LOCK_NESTING=y
> # CONFIG_LOCK_STAT is not set
> CONFIG_DEBUG_RT_MUTEXES=y
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
> CONFIG_DEBUG_RWSEMS=y
> CONFIG_DEBUG_LOCK_ALLOC=y
> CONFIG_LOCKDEP=y
> CONFIG_LOCKDEP_BITS=15
> CONFIG_LOCKDEP_CHAINS_BITS=16
> CONFIG_LOCKDEP_STACK_TRACE_BITS=19
> CONFIG_LOCKDEP_STACK_TRACE_HASH_BITS=14
> CONFIG_LOCKDEP_CIRCULAR_QUEUE_BITS=12
> CONFIG_DEBUG_LOCKDEP=y
> CONFIG_DEBUG_ATOMIC_SLEEP=y
> CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
> CONFIG_LOCK_TORTURE_TEST=y
> # CONFIG_WW_MUTEX_SELFTEST is not set
> CONFIG_SCF_TORTURE_TEST=y
> # end of Lock Debugging (spinlocks, mutexes, etc...)
> 
> CONFIG_TRACE_IRQFLAGS=y
> CONFIG_DEBUG_IRQFLAGS=y
> CONFIG_STACKTRACE=y
> CONFIG_WARN_ALL_UNSEEDED_RANDOM=y
> # CONFIG_DEBUG_KOBJECT is not set
> 
> #
> # Debug kernel data structures
> #
> CONFIG_DEBUG_LIST=y
> CONFIG_DEBUG_PLIST=y
> CONFIG_DEBUG_SG=y
> # CONFIG_DEBUG_NOTIFIERS is not set
> # CONFIG_BUG_ON_DATA_CORRUPTION is not set
> # end of Debug kernel data structures
> 
> CONFIG_DEBUG_CREDENTIALS=y
> 
> #
> # RCU Debugging
> #
> CONFIG_PROVE_RCU=y
> CONFIG_TORTURE_TEST=y
> CONFIG_RCU_SCALE_TEST=y
> CONFIG_RCU_TORTURE_TEST=y
> CONFIG_RCU_REF_SCALE_TEST=y
> # CONFIG_RCU_TRACE is not set
> # CONFIG_RCU_EQS_DEBUG is not set
> # end of RCU Debugging
> 
> # CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
> # CONFIG_LATENCYTOP is not set
> CONFIG_NOP_TRACER=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> CONFIG_HAVE_C_RECORDMCOUNT=y
> CONFIG_TRACER_MAX_TRACE=y
> CONFIG_TRACE_CLOCK=y
> CONFIG_RING_BUFFER=y
> CONFIG_EVENT_TRACING=y
> CONFIG_CONTEXT_SWITCH_TRACER=y
> CONFIG_RING_BUFFER_ALLOW_SWAP=y
> CONFIG_PREEMPTIRQ_TRACEPOINTS=y
> CONFIG_TRACING=y
> CONFIG_GENERIC_TRACER=y
> CONFIG_TRACING_SUPPORT=y
> CONFIG_FTRACE=y
> CONFIG_BOOTTIME_TRACING=y
> CONFIG_FUNCTION_TRACER=y
> # CONFIG_FUNCTION_GRAPH_TRACER is not set
> CONFIG_DYNAMIC_FTRACE=y
> CONFIG_FUNCTION_PROFILER=y
> # CONFIG_STACK_TRACER is not set
> CONFIG_IRQSOFF_TRACER=y
> # CONFIG_SCHED_TRACER is not set
> # CONFIG_HWLAT_TRACER is not set
> CONFIG_OSNOISE_TRACER=y
> CONFIG_TIMERLAT_TRACER=y
> CONFIG_FTRACE_SYSCALLS=y
> CONFIG_TRACER_SNAPSHOT=y
> CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
> CONFIG_TRACE_BRANCH_PROFILING=y
> # CONFIG_BRANCH_PROFILE_NONE is not set
> # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
> CONFIG_PROFILE_ALL_BRANCHES=y
> CONFIG_TRACING_BRANCHES=y
> CONFIG_BRANCH_TRACER=y
> # CONFIG_BLK_DEV_IO_TRACE is not set
> CONFIG_UPROBE_EVENTS=y
> CONFIG_BPF_EVENTS=y
> CONFIG_DYNAMIC_EVENTS=y
> CONFIG_PROBE_EVENTS=y
> CONFIG_FTRACE_MCOUNT_RECORD=y
> CONFIG_FTRACE_MCOUNT_USE_RECORDMCOUNT=y
> CONFIG_SYNTH_EVENTS=y
> # CONFIG_HIST_TRIGGERS is not set
> CONFIG_TRACE_EVENT_INJECT=y
> CONFIG_TRACEPOINT_BENCHMARK=y
> CONFIG_RING_BUFFER_BENCHMARK=y
> CONFIG_TRACE_EVAL_MAP_FILE=y
> # CONFIG_FTRACE_RECORD_RECURSION is not set
> # CONFIG_FTRACE_STARTUP_TEST is not set
> CONFIG_RING_BUFFER_STARTUP_TEST=y
> CONFIG_RING_BUFFER_VALIDATE_TIME_DELTAS=y
> # CONFIG_SYNTH_EVENT_GEN_TEST is not set
> # CONFIG_SAMPLES is not set
> CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
> CONFIG_STRICT_DEVMEM=y
> # CONFIG_IO_STRICT_DEVMEM is not set
> 
> #
> # powerpc Debugging
> #
> CONFIG_PPC_DISABLE_WERROR=y
> CONFIG_PRINT_STACK_DEPTH=64
> # CONFIG_PPC_EMULATED_STATS is not set
> # CONFIG_CODE_PATCHING_SELFTEST is not set
> CONFIG_FTR_FIXUP_SELFTEST=y
> CONFIG_MSI_BITMAP_SELFTEST=y
> CONFIG_XMON=y
> # CONFIG_XMON_DEFAULT is not set
> # CONFIG_XMON_DISASSEMBLY is not set
> # CONFIG_XMON_DEFAULT_RO_MODE is not set
> CONFIG_DEBUGGER=y
> CONFIG_BDI_SWITCH=y
> # CONFIG_PPC_EARLY_DEBUG is not set
> # end of powerpc Debugging
> 
> #
> # Kernel Testing and Coverage
> #
> CONFIG_KUNIT=y
> CONFIG_KUNIT_DEBUGFS=y
> CONFIG_KUNIT_TEST=y
> CONFIG_KUNIT_EXAMPLE_TEST=y
> CONFIG_KUNIT_ALL_TESTS=y
> CONFIG_NOTIFIER_ERROR_INJECTION=y
> # CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
> CONFIG_OF_RECONFIG_NOTIFIER_ERROR_INJECT=y
> # CONFIG_NETDEV_NOTIFIER_ERROR_INJECT is not set
> CONFIG_FAULT_INJECTION=y
> CONFIG_FAILSLAB=y
> CONFIG_FAIL_PAGE_ALLOC=y
> CONFIG_FAULT_INJECTION_USERCOPY=y
> CONFIG_FAIL_MAKE_REQUEST=y
> CONFIG_FAIL_IO_TIMEOUT=y
> # CONFIG_FAULT_INJECTION_DEBUG_FS is not set
> CONFIG_ARCH_HAS_KCOV=y
> CONFIG_CC_HAS_SANCOV_TRACE_PC=y
> # CONFIG_KCOV is not set
> CONFIG_RUNTIME_TESTING_MENU=y
> CONFIG_LKDTM=y
> CONFIG_TEST_LIST_SORT=y
> # CONFIG_TEST_MIN_HEAP is not set
> CONFIG_TEST_SORT=y
> CONFIG_TEST_DIV64=y
> # CONFIG_BACKTRACE_SELF_TEST is not set
> CONFIG_RBTREE_TEST=y
> CONFIG_REED_SOLOMON_TEST=y
> CONFIG_INTERVAL_TREE_TEST=y
> # CONFIG_ATOMIC64_SELFTEST is not set
> CONFIG_TEST_HEXDUMP=y
> # CONFIG_STRING_SELFTEST is not set
> CONFIG_TEST_STRING_HELPERS=y
> # CONFIG_TEST_STRSCPY is not set
> CONFIG_TEST_KSTRTOX=y
> # CONFIG_TEST_PRINTF is not set
> CONFIG_TEST_SCANF=y
> # CONFIG_TEST_BITMAP is not set
> CONFIG_TEST_UUID=y
> # CONFIG_TEST_XARRAY is not set
> # CONFIG_TEST_OVERFLOW is not set
> # CONFIG_TEST_RHASHTABLE is not set
> # CONFIG_TEST_HASH is not set
> # CONFIG_TEST_IDA is not set
> CONFIG_FIND_BIT_BENCHMARK=y
> CONFIG_TEST_FIRMWARE=y
> # CONFIG_TEST_SYSCTL is not set
> CONFIG_BITFIELD_KUNIT=y
> CONFIG_RESOURCE_KUNIT_TEST=y
> CONFIG_SYSCTL_KUNIT_TEST=y
> CONFIG_LIST_KUNIT_TEST=y
> # CONFIG_LINEAR_RANGES_TEST is not set
> CONFIG_CMDLINE_KUNIT_TEST=y
> CONFIG_BITS_TEST=y
> CONFIG_RATIONAL_KUNIT_TEST=y
> # CONFIG_TEST_UDELAY is not set
> # CONFIG_TEST_MEMCAT_P is not set
> # CONFIG_TEST_STACKINIT is not set
> # CONFIG_TEST_MEMINIT is not set
> CONFIG_TEST_FREE_PAGES=y
> CONFIG_ARCH_USE_MEMTEST=y
> # CONFIG_MEMTEST is not set
> # end of Kernel Testing and Coverage
> 
> # CONFIG_WARN_MISSING_DOCUMENTS is not set
> # CONFIG_WARN_ABI_ERRORS is not set
> # end of Kernel hacking


-- 
Kees Cook
