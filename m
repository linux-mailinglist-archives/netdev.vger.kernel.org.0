Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632EA52F62F
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 01:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345521AbiETXbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 19:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354126AbiETXa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 19:30:56 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECF4F5B9
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 16:30:54 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id r71so8971318pgr.0
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 16:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uMcOV0y8jZstpZ0RRqcNBQxit/mdZQhgF7gAMaKc8Ok=;
        b=E0dpTGaqH+CbvZ09IMQmAR3ni1yURhuqowRxlZkG77yWRu6RU/u1nLGPStxGEXxFNV
         HSjTDCzoGHTng4yu0YgMSTZxXZXHjA0oBUN5bw38cA7FTR3Te2HEh5zCjPJEV++bbqCJ
         YgcEBlxn3hZCXIyrJdZN4oAOVDrMVGfsyLsec=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uMcOV0y8jZstpZ0RRqcNBQxit/mdZQhgF7gAMaKc8Ok=;
        b=bkznRCxxRILoT/ldN1ZeVhGQjvQ6Lw64Opwo4AYlsUYpqS7BYOHezIEqqPpUNWmkqO
         NYkszJl2nFn0GkfBM1xUMoSCUQ/cmyc6q2HS6Ri1Eoe+M4tOJbgrq25cvCnVSBYZ/8yJ
         vRvP+eHAA9iNFOWc2nI0Bq2wtkF3ZReleDmCX7mcbBlMKFxB2hgpH9sL6vI+1ydi1fEv
         ga97wIMHsd1eMCiZJRuVSQT1NDl51gD5cNWIJn8zi4rmlm8ZHwZPf5iE4NwevQlLaFYB
         1TdMX6c5ye/SZDrqdbOzfbs2T0Mi0LveoGo23GSCyPhaV95DPr+iRO5xzIT1xd60qNhJ
         W+UQ==
X-Gm-Message-State: AOAM532FZBWaVPe6/8ORAV1IWnw3FAEkXEIvu/fgIOs8u8nO27Cn6B+z
        gptDHQgVK2zlia2vunKpDnaXjwfjx01cSg==
X-Google-Smtp-Source: ABdhPJzLyiH9DwZkSROYZd0oDLvQvauLo92Aj8qZU6bCChlyDZLXUgynBgBEnHndym0z+jEZRn575Q==
X-Received: by 2002:a05:6a00:8c2:b0:510:98ac:96c9 with SMTP id s2-20020a056a0008c200b0051098ac96c9mr12280639pfu.18.1653089454292;
        Fri, 20 May 2022 16:30:54 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n2-20020a6543c2000000b003c14af5063dsm267382pgp.85.2022.05.20.16.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 16:30:53 -0700 (PDT)
Date:   Fri, 20 May 2022 16:30:52 -0700
From:   Kees Cook <keescook@chromium.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Jakub Kicinski' <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: GCC 12 warnings
Message-ID: <202205201629.F743A84AB@keescook>
References: <20220519193618.6539f9d9@kernel.org>
 <202205200938.1EE1FD1@keescook>
 <20220520102355.273cae07@kernel.org>
 <8608c7da4cfc45889f450a538fb0b443@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8608c7da4cfc45889f450a538fb0b443@AcuMS.aculab.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 09:43:03PM +0000, David Laight wrote:
> From: Jakub Kicinski
> > Sent: 20 May 2022 18:24
> ...
> > > +ifeq ($(KBUILD_EXTRA_WARN),)
> > > +CFLAGS_kvaser_usb_hydra.o += -Wno-array-bounds
> > > +endif
> > 
> > Ah, thanks, I must have tried -Wno-array-bounds before I figured out
> > the condition and reverted back to full $(call cc-disable-warning, ..)
> > Let me redo the patches.
> 
> I think you need a check that the compiler actually supports
> -Wno-array-bounds.
> But that only needs be done once, not for every file
> that needs the option.

godbolt tells me that all kernel supported versions of GCC and Clang
handle -Wno-array-bounds. Let me know if there is a combination that
doesn't?

-- 
Kees Cook
