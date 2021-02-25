Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAB5324B8B
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 08:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235244AbhBYHwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 02:52:16 -0500
Received: from mail-oo1-f54.google.com ([209.85.161.54]:44769 "EHLO
        mail-oo1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235048AbhBYHwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 02:52:13 -0500
Received: by mail-oo1-f54.google.com with SMTP id n19so1150373ooj.11;
        Wed, 24 Feb 2021 23:51:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RNLIw+6yPNbCnrIrprnlWvk8nVCDAaT6F2Etp6AuKbo=;
        b=tArbcnqG5WgFqsBXJblN+fM4qryy+7a5UH4M8NV9hllSdlZsaPtedmoTNDETpoOQDL
         IrA9YNpc0k46BDQsGrxeJjbQLz5ifefOxJfm5m30y9M883SpyiYU0HQWassZ2ec0Za8c
         /uJcibv8bsAkiCwtfw3CksWYwMUwGQ4o1L+GiZmDr4icztxIpNC39vZD9F1VLN/SyLkX
         c5zkXfnWabcRHCwAynwPgG0vAHRZ30jKMiVjdt4a5DR+M9HA2lrwDuhVha4fDgnSnnf2
         UcI3iwmFwsZS1ow0z+iW3YHc4S2/eBYpecIHz77poRTxJQBEgm5PG9WhZVGOszp7AzgA
         hbkg==
X-Gm-Message-State: AOAM533ZUg5W7xlahlLKsbCQOOTFUSXH1f9dUyjTTkeCZ79jn1316jLR
        FQKD3sdGLvjmXkrSnrghcl9CiY3qQFaGHx1S0DI=
X-Google-Smtp-Source: ABdhPJxhxQAEQR74fgvjCGW0q2q027/ixLOgKLwLKhZ3kkBzj8Rfq2dKWsBCVNAaiZsGgWbDQShUHxCurmowJTxRh8I=
X-Received: by 2002:a4a:bb14:: with SMTP id f20mr1372910oop.1.1614239492696;
 Wed, 24 Feb 2021 23:51:32 -0800 (PST)
MIME-Version: 1.0
References: <20210224115146.9131-1-aford173@gmail.com> <20210224115146.9131-2-aford173@gmail.com>
 <YDZYgEm+wBFFJgXW@lunn.ch>
In-Reply-To: <YDZYgEm+wBFFJgXW@lunn.ch>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 25 Feb 2021 08:51:21 +0100
Message-ID: <CAMuHMdWO8hA8td+636TLu7kD4zajDuW5ArWnaYZ-C_sfupF0XA@mail.gmail.com>
Subject: Re: [PATCH V3 2/5] ARM: dts: renesas: Add fck to etheravb-rcar-gen2
 clock-names list
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Adam Ford <aford173@gmail.com>, netdev <netdev@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Wed, Feb 24, 2021 at 2:45 PM Andrew Lunn <andrew@lunn.ch> wrote:
> On Wed, Feb 24, 2021 at 05:51:42AM -0600, Adam Ford wrote:
> > The bindings have been updated to support two clocks, but the
> > original clock now requires the name fck.  Add a clock-names
> > list in the device tree with fck in it.
>
> I think requires is too strong. As far as i can see, you don't
> introduce a change using the name 'fck'. So the name is optional,
> which is good, because otherwise you would break backwards
> compatibility with DT blobs.
>
> Is the plan to merge this whole patchset via netdev? If so, you need
> to repost anyway, once netdev reopens. So maybe you can change the
> wording?

The DTS patches should go in through the renesas and soc trees.
I can apply them as soon as the DT binding patch has been accepted.

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
