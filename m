Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28B91577C51
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 09:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbiGRHSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 03:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233207AbiGRHSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 03:18:51 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051D7F73
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 00:18:50 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id u19so9018243lfs.0
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 00:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PyRXBleb1QpB4fKxelY4Fyd23fs+FV7dQ0emB1l5pSs=;
        b=nJNtLHqOy2pMkzxMYFZ7yPppaJCLu+2xQxX810kBBcLldCzjw5A5bgcXpyd2E/Vso+
         r58HSISLXELZ+9EhWEWCDeNc72YPVP6ccifkY/FRlERB4HumoWMg0GmAEWMMT+hEpuVQ
         daVWOsv7mBT1o5sbym3CZ5nOWJD3Og5WNyI5s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PyRXBleb1QpB4fKxelY4Fyd23fs+FV7dQ0emB1l5pSs=;
        b=l85EtYX601hI6DPSMZKQM4QRYoblzV2mbDpwmOnx3jbXYte29WhzA9BeiFXj1z11MV
         /oJqU4vDr2Hr7KMw3kFwWW8cImpum4egDOEvZB7Hhtc15eYqmFWLeWXrmZ56Byd2t+qf
         biqrscLok46acYXyv0zsqn6JkNqF+BdbGOKw6UoDrwQP65zSewszqQ22HidRbpk5/2tj
         B1v2PCs0KUas7F6UFgD48uBmx+B5RBbvB6Q583fytpCDF7E9MB5lKDtmk/BDRswTDJUf
         2Y/rdBM4Fssxu5KUmfjJ+zIWhskwZQ/aTR9ImRN+5x6oJwXV8Ng3beTn2+fw6JLBRSlH
         DsFQ==
X-Gm-Message-State: AJIora8z+bW5CRlAQ/fYArlK74Kagu3DrJUuESXFH50GNyoxZrUBISfN
        +ou49LpgRIQIiMBu0Ytf4UyYPvVMaeo/Elz+2OFhvA==
X-Google-Smtp-Source: AGRyM1uU27azdskip3dlgvLt74wyrnMbqEFBJQA/5XIeGmOG0T7mNyvF4bufdGwtDc+pgO4qXKoMvYE+/rSUQDev4eU=
X-Received: by 2002:a05:6512:2610:b0:47f:74dc:3205 with SMTP id
 bt16-20020a056512261000b0047f74dc3205mr13322511lfb.429.1658128728309; Mon, 18
 Jul 2022 00:18:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220716170201.2020510-1-dario.binacchi@amarulasolutions.com> <20220717235000.247bfa42.max@enpas.org>
In-Reply-To: <20220717235000.247bfa42.max@enpas.org>
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date:   Mon, 18 Jul 2022 09:18:37 +0200
Message-ID: <CABGWkvpK25WGjp76_=Jfd9sMk5Dvj84VnVuc3iuroKR0tJEv+Q@mail.gmail.com>
Subject: Re: [RFC PATCH] can: can327: remove useless header inclusions
To:     Max Staudt <max@enpas.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Max,

On Sun, Jul 17, 2022 at 11:50 PM Max Staudt <max@enpas.org> wrote:
>
> On Sat, 16 Jul 2022 19:02:01 +0200
> Dario Binacchi <dario.binacchi@amarulasolutions.com> wrote:
>
> > -#include <linux/init.h>
> >  #include <linux/module.h>
> > -
> > -#include <linux/bitops.h>
> > -#include <linux/ctype.h>
> > -#include <linux/errno.h>
> > -#include <linux/kernel.h>
> > -#include <linux/list.h>
> > -#include <linux/lockdep.h>
> > -#include <linux/netdevice.h>
> > -#include <linux/skbuff.h>
> > -#include <linux/spinlock.h>
> > -#include <linux/string.h>
> >  #include <linux/tty.h>
> > -#include <linux/tty_ldisc.h>
> > -#include <linux/workqueue.h>
> > -
> > -#include <uapi/linux/tty.h>
> > -
> > -#include <linux/can.h>
> >  #include <linux/can/dev.h>
> > -#include <linux/can/error.h>
> >  #include <linux/can/rx-offload.h>
>
> AFAIK, the coding style is to not rely on headers including other
> headers. Instead, the appropriate header for every symbol used should
> be included.

Thanks for the explanation.

>
> This is also valid for the similar patch you submitted for slcan.

Probably something can be removed (if_arp.h, if_ether.h, ...).
I will take can327.c as a reference.

Thanks and regards,
Dario

>
>
> Unless something has changed, this is a NAK from me, sorry.
>
>
> Max



-- 

Dario Binacchi

Embedded Linux Developer

dario.binacchi@amarulasolutions.com

__________________________________


Amarula Solutions SRL

Via Le Canevare 30, 31100 Treviso, Veneto, IT

T. +39 042 243 5310
info@amarulasolutions.com

www.amarulasolutions.com
