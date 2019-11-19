Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE38102511
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 14:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbfKSNCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 08:02:01 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:36729 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727351AbfKSNCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 08:02:00 -0500
Received: by mail-ot1-f66.google.com with SMTP id f10so17771170oto.3;
        Tue, 19 Nov 2019 05:02:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A80rOA/HPVUI/KT/4AcxA87yUcN6KfN0Zy7hYDumNmw=;
        b=ZOjOvt1v/e7M74MHMVfRPHEAYhXCLYXjzmVG37Be5BcAsX3BqwhBk1054NMQHo5iwp
         KQEzGvz43buwr8OT+HJWjJ7QXIAy4T06E7qgYsPi6TyBvp46J4zufd54D5nb9c53rUMq
         2ANZNpnVzI5XReQjZ4yJFw07GrVlWRv8LBGt+Z/ohr+X1+QH5h+A/1Rbpvc6V5gka1Mx
         2CLrkfsFfgCoYzK7IgzZoFEi90YVZdI43HF9jWC6MeZKgyM3R0PBaLN6WkZoJaKJi6GX
         kmlyqTWJrd90XNXy5uwdhCnWniyIrBBeQ7FgHakDhNDOJ7mVzxiFTNkD558FCB9+T51K
         DE4Q==
X-Gm-Message-State: APjAAAVvqN6qcMeXeDeiciOd3p7y2pK6QzbOqQOcpCBn2nWYv+tr4Qth
        WkBBKAoTRXZqkat3PEZzJq8X6XVhrtRDaOgj+bk=
X-Google-Smtp-Source: APXvYqwtIRqepxJOw62ZUdb3ua57orsKqT5LbVR1CEZK/axGtNgixYaSSCYR8QZnvA02c+3kdJ1N4c/+PnZHWPpEHPg=
X-Received: by 2002:a9d:17ca:: with SMTP id j68mr3607192otj.250.1574168519957;
 Tue, 19 Nov 2019 05:01:59 -0800 (PST)
MIME-Version: 1.0
References: <20191116.133321.709008936600873428.davem@davemloft.net>
In-Reply-To: <20191116.133321.709008936600873428.davem@davemloft.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 19 Nov 2019 14:01:48 +0100
Message-ID: <CAMuHMdX8Fi1PDEcrPJ3frsg+LG04hCN2vbgJ=+NyEArnqmcb1Q@mail.gmail.com>
Subject: Re: [GIT] Networking
To:     David Miller <davem@davemloft.net>
Cc:     "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 16, 2019 at 10:37 PM David Miller <davem@davemloft.net> wrote:
> YueHaibing (1):
>       mdio_bus: Fix PTR_ERR applied after initialization to constant

FTR, this causes a boot regression if CONFIG_RESET_CONTROLLER=n.
Patch sent
https://lore.kernel.org/lkml/20191119112524.24841-1-geert+renesas@glider.be/

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
