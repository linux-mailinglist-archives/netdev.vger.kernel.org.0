Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610671EC8E7
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 07:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbgFCFnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 01:43:47 -0400
Received: from conssluserg-03.nifty.com ([210.131.2.82]:59920 "EHLO
        conssluserg-03.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgFCFnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 01:43:46 -0400
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41]) (authenticated)
        by conssluserg-03.nifty.com with ESMTP id 0535hXwY013494;
        Wed, 3 Jun 2020 14:43:33 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com 0535hXwY013494
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1591163014;
        bh=eYbXXE03UGyzUA1dzqoqgfejB0APNGcA6B1VKTAlTkc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=zdOPR6DeUyzI/dyjwBHuWoyq8YGjWFCOy4pfG/HhnfvzwPKNkIYGEJ8BhT6LO2BXK
         0j4a3dSus6TnF+7LFZ9tkYW428wzRBe1DRNp0TWNGN+a5Ot0YOfAAUW+ZSQYgkDGm0
         62E+np3omSA2lEScuy1k1o95rHV5ZB80kXA3BI33ly2JBOgs6h5WUsW4Xh+6BI99QS
         CmaVpZGdnX3Tybb8TukMcSWN6zDxBH1eGQ29+p8akRZXL3D5xyRME/eONQR26FysnG
         xS94zfRMjogznu21nILC1i7PoTHewet6aKpkd8oT/WkTYol4+mJp6CmZduCPxSn8ud
         7s1QrauKw3nlA==
X-Nifty-SrcIP: [209.85.222.41]
Received: by mail-ua1-f41.google.com with SMTP id v25so444801uau.4;
        Tue, 02 Jun 2020 22:43:33 -0700 (PDT)
X-Gm-Message-State: AOAM532ifWKxHBAU/5s9TRBTisYQXs2W1mtoNFDJkLdQqFckna7Gk+5r
        uifN4AHHehpVIyC2iq8aKLWyi57wXhbmIP1+Qcc=
X-Google-Smtp-Source: ABdhPJwjuoXJOhkpEsk11pOSGEpVGsineig5/WGSrJwhwKvpNEfQUfdp0FRnLcltvrWedPQcwhKp/Kl1HKxDbDeyPJg=
X-Received: by 2002:ab0:7619:: with SMTP id o25mr6775847uap.109.1591163012351;
 Tue, 02 Jun 2020 22:43:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200403073741.18352-1-masahiroy@kernel.org> <f45febfa-a19a-0d76-d545-6427e5f1ce1e@hartkopp.net>
In-Reply-To: <f45febfa-a19a-0d76-d545-6427e5f1ce1e@hartkopp.net>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Wed, 3 Jun 2020 14:42:55 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQjSyLDgZcj9d3Vqo6VJafVFtkvCi-wEWpE7qes-kLwmw@mail.gmail.com>
Message-ID: <CAK7LNAQjSyLDgZcj9d3Vqo6VJafVFtkvCi-wEWpE7qes-kLwmw@mail.gmail.com>
Subject: Re: [PATCH] net: can: remove "WITH Linux-syscall-note" from SPDX tag
 of C files
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 3, 2020 at 11:35 PM Oliver Hartkopp <socketcan@hartkopp.net> wrote:
>
>
>
> On 03/04/2020 09.37, Masahiro Yamada wrote:
> > The "WITH Linux-syscall-note" exception is intended for UAPI headers.
> >
> > See LICENSES/exceptions/Linux-syscall-note
> >
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
>
> Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
>
> Thanks Masahiro!


Any chance for this patch picked up?



>
>
> > ---
> >
> >   net/can/bcm.c  | 2 +-
> >   net/can/gw.c   | 2 +-
> >   net/can/proc.c | 2 +-
> >   net/can/raw.c  | 2 +-
> >   4 files changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/can/bcm.c b/net/can/bcm.c
> > index c96fa0f33db3..d94b20933339 100644
> > --- a/net/can/bcm.c
> > +++ b/net/can/bcm.c
> > @@ -1,4 +1,4 @@
> > -// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
> > +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> >   /*
> >    * bcm.c - Broadcast Manager to filter/send (cyclic) CAN content
> >    *
> > diff --git a/net/can/gw.c b/net/can/gw.c
> > index 65d60c93af29..49b4e3d91ad6 100644
> > --- a/net/can/gw.c
> > +++ b/net/can/gw.c
> > @@ -1,4 +1,4 @@
> > -// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
> > +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> >   /* gw.c - CAN frame Gateway/Router/Bridge with netlink interface
> >    *
> >    * Copyright (c) 2019 Volkswagen Group Electronic Research
> > diff --git a/net/can/proc.c b/net/can/proc.c
> > index e6881bfc3ed1..a4eb06c9eb70 100644
> > --- a/net/can/proc.c
> > +++ b/net/can/proc.c
> > @@ -1,4 +1,4 @@
> > -// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
> > +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> >   /*
> >    * proc.c - procfs support for Protocol family CAN core module
> >    *
> > diff --git a/net/can/raw.c b/net/can/raw.c
> > index 59c039d73c6d..ab104cc18562 100644
> > --- a/net/can/raw.c
> > +++ b/net/can/raw.c
> > @@ -1,4 +1,4 @@
> > -// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
> > +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> >   /* raw.c - Raw sockets for protocol family CAN
> >    *
> >    * Copyright (c) 2002-2007 Volkswagen Group Electronic Research
> >



-- 
Best Regards
Masahiro Yamada
