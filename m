Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD8854202D
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 02:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241057AbiFHASy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Jun 2022 20:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588570AbiFGXyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 19:54:47 -0400
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673F8152B9F;
        Tue,  7 Jun 2022 16:40:31 -0700 (PDT)
Received: by mail-yb1-f170.google.com with SMTP id v22so33715034ybd.5;
        Tue, 07 Jun 2022 16:40:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1/qjcxsmWGOF/l/i6wu2yu8n5nSie7FdU/Wmm/ZoLiA=;
        b=FEGo4BIPhQ6rBbGz/te7oqzvA6sPIIClqGH2fSRL/KFEGxOhtEiybtDTS+vgZEm1r5
         aay+2R1bCo22yVd2roumhMahJRxzKur8qeFNlu0thHw0t9SU5Uxq2381c3a0R18/igl3
         Vb+bEz5tG0nVv0uPSPJ8nacweRcKl1saeUN10duxf5e5RERJoXosIMlnLBRnSfFTh0ix
         4Myu1gTArDUXXqnISIEn5yZ63tltcuVLWHHGA7gMh0a+ooUu1JRG0g6mEAxKi/E0cA6B
         SnRfuWO7qqUYBM/i5eSIoO7NcItzN4YsjE3XLCBYFDU0rT8Fa9wEJWiBRy1rVMwQTEIL
         dVJA==
X-Gm-Message-State: AOAM532co8w+i4fP0Aw9d6cNPMEHs4u9CMNqFVyTbc3qzbQEPaq/nI+g
        /QVOGBRaCefsFUz/y5t4LbEdrzx6JkyU6ImZL8E=
X-Google-Smtp-Source: ABdhPJx2grNnlWzYraRXZjQ0ZQiMaFvd8I8Sz3hAXA1NCs5u0ESEaB4A+/hoH1sM/bQfc6KjRyjZAXo4eFe0VimxJzM=
X-Received: by 2002:a25:9841:0:b0:663:eaf2:4866 with SMTP id
 k1-20020a259841000000b00663eaf24866mr3790359ybo.381.1654645230591; Tue, 07
 Jun 2022 16:40:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220604163000.211077-1-mailhol.vincent@wanadoo.fr> <20220604163000.211077-5-mailhol.vincent@wanadoo.fr>
 <CAMuHMdXkq7+yvD=ju-LY14yOPkiiHwL6H+9G-4KgX=GJjX=h9g@mail.gmail.com>
 <CAMZ6RqLEEHOZjrMH+-GLC--jjfOaWYOPLf+PpefHwy=cLpWTYg@mail.gmail.com>
 <20220607182216.5fb1084e.max@enpas.org> <20220607150614.6248c504@kernel.org>
In-Reply-To: <20220607150614.6248c504@kernel.org>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 8 Jun 2022 08:40:19 +0900
Message-ID: <CAMZ6Rq+vYNvrTcToqVqqKSPJXAdjs3RkUY_SNuwB7n9FMuqQiQ@mail.gmail.com>
Subject: Re: [PATCH v5 4/7] can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Max Staudt <max@enpas.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 8 Jun 2022 à 07:06, Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 7 Jun 2022 18:22:16 +0200 Max Staudt wrote:
> > > Honestly, I am totally happy to have the "default y" tag, the "if
> > > unsure, say Y" comment and the "select CAN_RX_OFFLOAD" all together.
> > >
> > > Unless I am violating some kind of best practices, I prefer to keep it
> > > as-is. Hope this makes sense.
>
> AFAIU Linus likes for everything that results in code being added to
> the kernel to default to n.

A "make defconfig" would not select CONFIG_CAN (on which
CAN_RX_OFFLOAD indirectly depends) and so by default this code is not
added to the kernel.

> If the drivers hard-select that Kconfig
> why bother user with the question at all? My understanding is that
> Linus also likes to keep Kconfig as simple as possible.

I do not think that this is so convoluted. What would bother me is
that RX offload is not a new feature. Before this series, RX offload
is built-in the can-dev.o by default. If this new CAN_RX_OFFLOAD does
not default to yes, then the default features built-in can-dev.o would
change before and after this series.
But you being one of the maintainers, if you insist I will go in your
direction. So will removing the "default yes" and the comment "If
unsure, say yes" from the CAN_RX_OFFLOAD satisfy you?

> > I wholeheartedly agree with Vincent's decision.
> >
> > One example case would be users of my can327 driver, as long as it is
> > not upstream yet. They need to have RX_OFFLOAD built into their
> > distribution's can_dev.ko, otherwise they will have no choice but to
> > build their own kernel.
>
> Upstream mentioning out-of-tree modules may have the opposite effect
> to what you intend :( Forgive my ignorance, what's the reason to keep
> the driver out of tree?

I can answer for Max. The can327 patch is under review with the clear
intent to have it upstream. c.f.:
https://lore.kernel.org/linux-can/20220602213544.68273-1-max@enpas.org/

But until the patch gets accepted, it is defacto an out of tree module.


Yours sincerely,
Vincent Mailhol
