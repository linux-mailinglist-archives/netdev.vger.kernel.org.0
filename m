Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1391153D6C5
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 14:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235958AbiFDMbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 08:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiFDMbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 08:31:10 -0400
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E16C1D0F3;
        Sat,  4 Jun 2022 05:31:09 -0700 (PDT)
Received: by mail-yb1-f170.google.com with SMTP id t31so18112378ybi.2;
        Sat, 04 Jun 2022 05:31:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d/g5lCDspNEJNwMa9vfrlOAoLRDCzZro+20EzHFIRrs=;
        b=VdrgQFqRNsafn5SeUv4fg9FUvI/ctbDh2ur1uLBD38NLcobVi2NZ76HU35EsBz/D95
         X3wMwXoGC20JDw2813wvcoT61+R/Tz+XW8gvwJZo8kPctm20rnGWYDcv7Lp6jnRCOf34
         gH756xBQGJ5lZed+IxvOWZXAIItxAZr1wNusWZW8DKxW4c/gypDlak7Mqm6lVduTotA9
         uqDQbxSxHPFNGwu84bEEa9cCkphuYD9EjkJMVmzqc3aFitcBxQ4BYPUvTRqbfxNOcejA
         ShMjxa23ZNjE1nvX1Cae8kwQMHlN6fSuVSQApey11PW4SJwbnCCvxZ+D0NN9jc1c5Zrt
         74VA==
X-Gm-Message-State: AOAM531Z61LMGqpA0rRZAIGHiUJSDXZ6UXDxZUkgkS2AZpL8oo3qjq3e
        qG5IkD5L6YwsuFI3+AZbQNPkCxWe4M4mmxNtUAgEdCj0oYWSUQ==
X-Google-Smtp-Source: ABdhPJxJ9jeexrd0GvwtC7TFbcHQlIFTeplVhdQS4cY9QnLt3D8uzOrdbCmi13haETGdoCTwrWNLg8E5C0K8RFWxEIs=
X-Received: by 2002:a25:4542:0:b0:660:6b9e:62b8 with SMTP id
 s63-20020a254542000000b006606b9e62b8mr11616534yba.423.1654345868578; Sat, 04
 Jun 2022 05:31:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-1-mailhol.vincent@wanadoo.fr> <20220603102848.17907-3-mailhol.vincent@wanadoo.fr>
 <20220604112707.z4zjdjydqy5rkyfe@pengutronix.de>
In-Reply-To: <20220604112707.z4zjdjydqy5rkyfe@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sat, 4 Jun 2022 21:30:57 +0900
Message-ID: <CAMZ6RqLRf=oyo0HXDSBAMD=Ce-RxtgO=TrhT5Xf1sqR6jWDoCQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] can: Kconfig: turn menu "CAN Device Drivers" into
 a menuconfig using CAN_DEV
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat. 4 juin 2022 at 20:27, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 03.06.2022 19:28:43, Vincent Mailhol wrote:
> > In the next patches, the software/virtual drivers (slcan, v(x)can)
> > will depend on drivers/net/can/dev/skb.o.
> >
> > This patch changes the scope of the can-dev module to include the
> > above mentioned drivers.
> >
> > To do so, we reuse the menu "CAN Device Drivers" and turn it into a
> > configmenu using the config symbol CAN_DEV (which we released in
> > previous patch). Also, add a description to this new CAN_DEV
> > menuconfig.
> >
> > The symbol CAN_DEV now only triggers the build of skb.o. For this
> > reasons, all the macros from linux/module.h are deported from
> > drivers/net/can/dev/dev.c to drivers/net/can/dev/skb.c.
> >
> > Finally, drivers/net/can/dev/Makefile is adjusted accordingly.
> >
> > Suggested-by: Oliver Hartkopp <socketcan@hartkopp.net>
> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> > ---
> >  drivers/net/can/Kconfig      | 29 ++++++++++++++++++++++++++---
> >  drivers/net/can/dev/Makefile | 16 +++++++++-------
> >  drivers/net/can/dev/dev.c    |  9 +--------
> >  drivers/net/can/dev/skb.c    |  7 +++++++
> >  4 files changed, 43 insertions(+), 18 deletions(-)
> >
>
> > diff --git a/drivers/net/can/dev/Makefile b/drivers/net/can/dev/Makefile
> > index 5b4c813c6222..919f87e36eed 100644
> > --- a/drivers/net/can/dev/Makefile
> > +++ b/drivers/net/can/dev/Makefile
> > @@ -1,9 +1,11 @@
> >  # SPDX-License-Identifier: GPL-2.0
> >
> > -obj-$(CONFIG_CAN_NETLINK) += can-dev.o
> > +obj-$(CONFIG_CAN_DEV) += can-dev.o
>        ^^^^^^^^^^^^^^^^^^^^^
>
> Nitpick: I think you can directly use "y" here.

I see. So the idea would be that if we deselect CONFIG_CAN_DEV, then
despite of can-dev.o being always "yes", it would be empty and thus
ignored. I just didn't know this trick.

I will do as suggested.
