Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B07F340672
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 14:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbhCRNJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 09:09:21 -0400
Received: from mail-vs1-f41.google.com ([209.85.217.41]:47084 "EHLO
        mail-vs1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbhCRNIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 09:08:53 -0400
Received: by mail-vs1-f41.google.com with SMTP id l22so1502354vsr.13;
        Thu, 18 Mar 2021 06:08:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3W+gRU3tHOQftjVIDBjSp6oKqWWk/fcbiFHz3gji3RA=;
        b=CKLH0megC93YIgSK38RvzBgRSunx8AfYLFKJEXOkUwzC+6uykuBEJQcrvkIrrPiRym
         UBK9CtgPSuySJQZfk0262NzsI/l8ytFJg6V0I5+NR6BjEIGSOg9R7y3fNg9LCo10md1r
         D5IV6uAca2FX+CEuKGLuwfp7zmkHdDiakw3WD0AFFvEl/mP2AKKm86QKssqATIpP4ONN
         9sKccpUzMpj5eqo7fAhvzwGaI1Y1jYHE0BxEBmZFrWjMw6DzrC19xXvjfOLETMVhrAOB
         gxguLwVnNFZatVUPU0T0YFxK5EYEEVgwzKvPWxquyZRNon3vxeGnqTfUhGPPIurAxD8L
         JnJg==
X-Gm-Message-State: AOAM531xD/d6M6HngzRvmAy4DFKzNi3MicdnCj35Y/5y7VW0U92rYx+1
        ui9bQmLXvokyOTacitIQtipwFqI4tT90XcAg6XminUhR
X-Google-Smtp-Source: ABdhPJwSYclVqk3CG+KwOsQJDNF/gnlOqbyQv3/6dPaqrdvn9b/kEKBWwIe28FgiQQb6nLHFTrMEdwstEC2d9ss4Ju8=
X-Received: by 2002:a67:fe90:: with SMTP id b16mr6581294vsr.40.1616072932463;
 Thu, 18 Mar 2021 06:08:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210224115146.9131-1-aford173@gmail.com> <20210224115146.9131-5-aford173@gmail.com>
 <CAMuHMdW3SO7LemssHrGKkV0TUVNuT4oq1EfmJ-Js79=QBvNhqQ@mail.gmail.com> <CAHCN7xLtDyfB5h5rWTLpiUgWY==2KmxYCOQkVSeU8DV8KB-NKg@mail.gmail.com>
In-Reply-To: <CAHCN7xLtDyfB5h5rWTLpiUgWY==2KmxYCOQkVSeU8DV8KB-NKg@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 18 Mar 2021 14:08:40 +0100
Message-ID: <CAMuHMdV1e+bBapynOQwhuBpdBcpn-03hpOu4KAaK4GHhcdROEg@mail.gmail.com>
Subject: Re: [PATCH V3 5/5] arm64: dts: renesas: beacon kits: Setup AVB refclk
To:     Adam Ford <aford173@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
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

Hi Adam,

On Thu, Mar 18, 2021 at 1:44 PM Adam Ford <aford173@gmail.com> wrote:
> On Thu, Mar 4, 2021 at 2:04 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Wed, Feb 24, 2021 at 12:52 PM Adam Ford <aford173@gmail.com> wrote:
> > > The AVB refererence clock assumes an external clock that runs
> >
> > reference
> >
> > > automatically.  Because the Versaclock is wired to provide the
> > > AVB refclock, the device tree needs to reference it in order for the
> > > driver to start the clock.
> > >
> > > Signed-off-by: Adam Ford <aford173@gmail.com>
> >
> > Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > i.e. will queue in renesas-devel (with the typo fixed) once the DT
> > bindings have been accepted.
> >
>
> Who do I need to ping to get the DT bindings accepted?  They have an
> acked-by from Rob.

Sergei, can you please have a look at the DT binding change?

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
