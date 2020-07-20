Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A0E226E79
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbgGTSnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728068AbgGTSnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:43:11 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BED2C0619D2
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 11:43:11 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id v8so18714985iox.2
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 11:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YPZVBJPETEcKVyPp/u0wCI3wVOTtiMFzFIW5rSd1rmo=;
        b=ofmi85aS5pDL9++61y1K0TBeiuYzYmt38pDjE31fp5y9ZKJBYp/UkqoaCl+GTIMHOy
         ROBjIVR/TKBNDoDnWVEMzyGpkSLukFRKTXBKEcIEgXBsDSh6EN0pEjZKVJb2BnxGxJqV
         I3QDeUhUC0o7ytWANDNGqF8zOO3m6Aa75ypRZU57VLf9B6vZCeJUldXTOJMMXTr4OQGN
         KIkpX283ItLYqYuOQtX2UmABZ5gQDT0pnHpvfHk6Abk+/N8iV85TuoOcOOuBLYAGD46t
         QJYIhVUueXptqMaCcr3oJoIpRQSSnFSJOst84l7QajDZT6nDqjp7VBRSMS1FHe5bXWB8
         GHeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YPZVBJPETEcKVyPp/u0wCI3wVOTtiMFzFIW5rSd1rmo=;
        b=ArEJ2oKV8nd2tJY5KwASCpSDbjyC6QA8nCa9329WgTXJZGTzOxjsHqjjctOe60fp06
         1w4JQxX11f6k6YRPV9WI157yuRjMOsCdh4mVl/f53npBwdMDmPF0WWR9jgnpNyJU/LzC
         +j6jwAZRuZzIF1scIzTI+ESa/YoWEKoKbciDwY94bpIQLZYvYK9giSt+d9zImrWMMvPb
         84TNFk+FAfp1YB4xdNKLdM6KnhzBORSc5iYZhlawckwGUk3zC0bX2Hg4WkZVVJzHM315
         yFVIuywXZwOU4RArr0wzQPK/s20WhVaI0qdDSwJZPUIb3qQQ4/xfEqpBcrhJhBIlnSPk
         P6fg==
X-Gm-Message-State: AOAM531jjHyErcBYnz9P6EumCGVXjy2g9U1cl2tvtgEX889eBhIIPfhZ
        fAV9Eh41078cfM/6pKWfzSjSejWk43gdTlsyMbY=
X-Google-Smtp-Source: ABdhPJzeHL5e9ggDPp6ijAuLOoSaD2p+TG7z4Te3vTYrzXHglC2KZ/IDr3fOvc9B49JA4+6PbsG56DkVP840AJHiSjE=
X-Received: by 2002:a02:7419:: with SMTP id o25mr27371306jac.4.1595270590581;
 Mon, 20 Jul 2020 11:43:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200716175526.14005-1-cphealy@gmail.com> <20200719211654.hwolppixqqwqz3rx@lion.mk-sys.cz>
In-Reply-To: <20200719211654.hwolppixqqwqz3rx@lion.mk-sys.cz>
From:   Chris Healy <cphealy@gmail.com>
Date:   Mon, 20 Jul 2020 11:42:59 -0700
Message-ID: <CAFXsbZqhHzhaRftx5515N8VTqHxRoDKvZ8-KjzvE0nUF3xBFpQ@mail.gmail.com>
Subject: Re: [PATCH] ethtool: dsa: mv88e6xxx: add pretty dump for 88E6352 SERDES
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 19, 2020 at 2:16 PM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Thu, Jul 16, 2020 at 10:55:26AM -0700, Chris Healy wrote:
> > From: Andrew Lunn <andrew@lunn.ch>
> >
> > In addition to the port registers, the device can provide the
> > SERDES/PCS registers. Dump these, and for a few of the important
> > SGMII/1000Base-X registers decode the bits.
> >
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > Signed-off-by: Chris Healy <cphealy@gmail.com>
> > ---
> [...]
> > +     case 32 + 0:
> > +             REG(reg - 32, "Fiber Control", val);
>
> Could you give these "32" (and similar below) a name?

Yep, will do in v2.
>
> [...]
> > @@ -667,6 +850,17 @@ static int dsa_mv88e6xxx_dump_regs(struct ethtool_regs *regs)
> >               else
> >                       REG(i, "", data[i]);
> >
> > +     /* Dump the SERDES registers, if provided */
> > +     if (regs->len > 32 * 2) {
>
> sizeof(u16) would be easier to read, IMHO

Agreed, will do in v2.
>
> > +             printf("\n%s Switch Port SERDES Registers\n", sw->name);
> > +             printf("-------------------------------------\n");
> > +             for (i = 32; i < regs->len / 2; i++)
> > +                     if (sw->dump)
> > +                             sw->dump(i, data[i]);
> > +                     else
> > +                             REG(i, "", data[i]);
>
> In the dump handler above you subtract 32 (offset of SERDES registers,
> IIUC) from register number but in the generic branch you don't, this
> seems inconsistent.

You are correct.  I tested this code path and it was reporting
incorrectly.  Fix coming in v2.

>
> Michal
>
> > +     }
> > +
> >       return 0;
> >  }
> >
> > --
> > 2.21.3
> >
