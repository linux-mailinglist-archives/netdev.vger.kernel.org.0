Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA9C5148ED
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 14:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358951AbiD2MQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 08:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358940AbiD2MQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 08:16:16 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8B6B7C67
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 05:12:56 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id x18so10583996wrc.0
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 05:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2iYrBmzGIsvh76SxQr1HgAW78qBhx/RZZaPhUZKcTOs=;
        b=c0OehlQurivWf2CUOZ9/HHGTia0hwWZV17koPi/ADRsnEJC4ltpz7CaXX3/9B3ocKB
         PRM1OdcCJe5CgkHuq1j7wuj/v+MxtjGQp7Hin8jys6oMJ1OJFdB0JxPG6VhopEQS0KOT
         O6uzMzdx9+yJJWEX3eJZ4qcT4dQOfdXVUyB+h68YrxLwZ6zzrTbcUx6/+zXz6AAXfD4x
         Nne9nz9CPh/V952+cs1sTGlvcFVamwYkcr8pVA+jFawWjOsaeCN3bVgJcZrmWNA6s+p/
         5OLKyH2wfVEcXsel+Ylj7JGeug91FYBAaLivevX0yBuQy4sXum0ZJPWxXRkU2vnBZqpJ
         WjtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=2iYrBmzGIsvh76SxQr1HgAW78qBhx/RZZaPhUZKcTOs=;
        b=ojYEoMlMpaLqc1IDb3eVdWzuLhJLBuq9QywDTQOtJbsvSCZFSbcywVysAkavXIaOcB
         ++2gtcqOB4FZOyoN64I3d8PjVW2+bp6VAFhzKSQckK6GOvFWreK2POcRA5N/7EqUPrvs
         6J0bDoEP5kpbB6gVYYfUCJWmw2zF6A+Rhf9I3Tn2flzvTBziwPMn2Xcg+XB2Mr9mcznX
         CQwE/M1Y8YeGLGClz/7lxiAW4lurPD4Mgt0OIBaxGiykH60k6Md0/nubDHaw7JSCvcqk
         cIL88FH7Mv3f3zz5nisllwrw4zoRfQpo1xag1eBNnBh3lPS6DHUBlm+FCWv4ztEqDH2B
         +udQ==
X-Gm-Message-State: AOAM5335EUTGH+8Hm5pz03yAVhqpUXS1M0vVtJsUMR+mxCbY9Enwk32F
        9NgFlY1RL8gZcYj872NegBlRWCfSv8o=
X-Google-Smtp-Source: ABdhPJy/kjW28m2VXk17Z3tpmS6wBSDb/MUrDemIKWUex6JUEvSy7GSXiCrAXc/nvjl7abUv/og2gw==
X-Received: by 2002:adf:d1c1:0:b0:20a:ef26:7976 with SMTP id b1-20020adfd1c1000000b0020aef267976mr10949475wrd.345.1651234374789;
        Fri, 29 Apr 2022 05:12:54 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id y9-20020a05600015c900b0020adb0e106asm3045801wry.93.2022.04.29.05.12.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 Apr 2022 05:12:54 -0700 (PDT)
Date:   Fri, 29 Apr 2022 13:12:52 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     pabeni@redhat.com, davem@davemloft.net, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next v2 00/13]: Move Siena into a separate
 subdirectory
Message-ID: <20220429121252.a2g2xyyx2da33q4w@gmail.com>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        davem@davemloft.net, netdev@vger.kernel.org, ecree.xilinx@gmail.com
References: <165111298464.21042.9988060027860048966.stgit@palantir17.mph.net>
 <20220428141742.24186939@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428141742.24186939@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 02:17:42PM -0700, Jakub Kicinski wrote:
> On Thu, 28 Apr 2022 03:30:30 +0100 Martin Habets wrote:
> > 	Testing
> > 
> > Various build tests were done such as allyesconfig, W=1 and sparse.
> > The new sfc-siena.ko and sfc.ko modules were tested on a machine with both
> > these NICs in them, and several tests were run on both drivers.
> 
> Does not build for the build bot, or when I try on my system.

Sorry, I posted the wrong version. The issues are from the rebase I did.

> (Ignore the pw-bot reply, BTW, the patches were never merged.)

Bots can be eager :)
