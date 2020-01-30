Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6C714DA77
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 13:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbgA3MNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 07:13:22 -0500
Received: from mail-qk1-f176.google.com ([209.85.222.176]:37728 "EHLO
        mail-qk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbgA3MNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 07:13:22 -0500
Received: by mail-qk1-f176.google.com with SMTP id 21so2680762qky.4
        for <netdev@vger.kernel.org>; Thu, 30 Jan 2020 04:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FIGO+nyUtextqBgM2I4MYO1KOBgLhoTlZftCQOiVU+8=;
        b=Wl5QpOGsIdoKRW50crrvCRt66xg2TeByxSMqwz+EFwA14WY67VW8ajn6UtEQclkf7S
         Mgye/beAMd5QsV9X7QOpYgu+JEVk1+SZdEL4K35xYrHyU32lXbedLr9NcKri8rTcCTnj
         Q3GFJ42Ou1Tie0pikB9NNAI3NCRJq94OQQ7k1l1AUB430gh/9mUC//ii9jKL8UxxVr3u
         c6NZCYTK/nowiuBUHqGcGMDyrThPcSAtN5CLAsVZ+hPMvMyP4t6FJBzXk1bJxdaYdVnK
         eHzN3MFJBnlbxAEY3N70zBY89+77g7izZxfOPvaYL27Pcb9oCY9K+Mf3fxZBTUE61zpA
         UhlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FIGO+nyUtextqBgM2I4MYO1KOBgLhoTlZftCQOiVU+8=;
        b=C9d+EOTdvl/nRxOy2Wra/wxG1HSPpdzKe884tFQIoGI7dffHA54WBojwkPW4BYTw74
         ALmOVWjcCh11uqse79B9gk2SN7f13JNZ35Oc2sEv3+2rmtilbWYySMSKl0o5XIwhzuYh
         /xRTHoVab9SPvredBjHSgQbFaZeYlGB6Bc4QACQNCOv46tQwMeedZgPBzOWDXZTkeLfQ
         DAgNrKEzJtrc5q3CUzmR0G5QPYqJor8u9zMZQRQHiY043LL/XeLeQntc+J+z4SMNUwDZ
         pz9AEqLWAFiFxZFuGPEF9vg+NzhZfp6mbqbRK+R4A5ghmzPKre1Q8RZCLIe5tqsUcFhI
         Y5XQ==
X-Gm-Message-State: APjAAAWN12O94AdkoofXDcBT6KtWrMuL+nNQpiq+irZmpW0SK566iJg8
        a7MtjsZIFeAnAwESe1lltKgwUhIHexfyvRx3jBK8Yg==
X-Google-Smtp-Source: APXvYqysEDziZfEkPF9l2isT+lEuzTkeTcAUcRlmntiES+0O5OQUCy0dQYQ8eAq1IfRhXDzkcd3UI3l5ZP3zQzNMkd4=
X-Received: by 2002:a37:7cc7:: with SMTP id x190mr4791673qkc.10.1580386401287;
 Thu, 30 Jan 2020 04:13:21 -0800 (PST)
MIME-Version: 1.0
References: <CACwWb3CYP9MENZJAzBt5buMNxkck7+Qig9yYG8nTYrdBw1fk5A@mail.gmail.com>
 <CAHapkUgCWS4DxGVL2qJsXmiAEq4rGY+sPTROx4iftO6mD_261g@mail.gmail.com>
 <CAB=W+o=-XEu_QZtrt6_Qt-HB4CUH+4nUs1o02tVFqJJkdi_bhg@mail.gmail.com> <20200130120659.b3dxp43mk74ahmqq@mew.swordarmor.fr>
In-Reply-To: <20200130120659.b3dxp43mk74ahmqq@mew.swordarmor.fr>
From:   Levente <leventelist@gmail.com>
Date:   Thu, 30 Jan 2020 13:13:09 +0100
Message-ID: <CACwWb3ACyO2fFM4j1ZybgcXZmO7h+QiT5UQ9Rd9ACKi9V6TF_Q@mail.gmail.com>
Subject: Re: IPv6 test fail
To:     Alarig Le Lay <alarig@swordarmor.fr>
Cc:     Captain Wiggum <captwiggum@gmail.com>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear All,


We fixed this issue. It seems that the connecting 3G modem had a bug.


Thanks for your help.


Bests,
Levente

On Thu, Jan 30, 2020 at 1:10 PM Alarig Le Lay <alarig@swordarmor.fr> wrote:
>
> Hello,
>
> It seems that I=E2=80=99m not here for enough time, I can=E2=80=99t find =
your thread.
> What were your issues on IPv6? I hit some from migrating to 4.19 (from
> 4.4) on routers, so I=E2=80=99m still on 4.4 for now.
>
> We discussed it a bit on bird ML:
> https://bird.network.cz/pipermail/bird-users/2019-June/013509.html
> https://bird.network.cz/pipermail/bird-users/2019-November/013992.html
> https://bird.network.cz/pipermail/bird-users/2019-December/014011.html
>
> (sorry for the multiple links, it seems that the archive is split by
> months)
>
> By chances, are we hitting the same bug?
>
> Regards,
> Alarig Le Lay
>
> On mer. 29 janv. 15:31:20 2020, Captain Wiggum wrote:
> > (resending without html.:)
> > I started the thread.
> > We are using 4.19.x and 4.9.x, but for reference I also tested then cur=
rent 5.x.
> > I believe we got it all worked out at the time.
> > --John Masinter
> >
> >
> > On Wed, Dec 18, 2019 at 2:00 PM Stephen Suryaputra <ssuryaextr@gmail.co=
m> wrote:
> > >
> > > I am curious: what kernel version are you testing?
> > > I recall that several months ago there is a thread on TAHI IPv6.
> > > Including the person who started the thread.
> > >
> > > Stephen.
> > >
> > > On Thu, Oct 24, 2019 at 7:43 AM Levente <leventelist@gmail.com> wrote=
:
> > > >
> > > > Dear list,
> > > >
> > > >
> > > > We are testing IPv6 again against the test specification of ipv6for=
um.
> > > >
> > > > https://www.ipv6ready.org/?page=3Ddocuments&tag=3Dipv6-core-protoco=
ls
> > > >
> > > > The test house state that some certain packages doesn't arrive to t=
he
> > > > device under test. We fail test cases
> > > >
> > > > V6LC.1.2.2: No Next Header After Extension Header
> > > > V6LC.1.2.3: Unreacognized Next Header in Extension Header - End Nod=
e
> > > > V6LC.1.2.4: Extension Header Processing Order
> > > > V6LC.1.2.5: Option Processing Order
> > > > V6LC.1.2.8: Option Processing Destination Options Header
> > > >
> > > > The question is that is it possible that the this is the intended w=
ay
> > > > of operation? I.e. the kernel swallows those malformed packages? We
> > > > use tcpdump to log the traffic.
> > > >
> > > >
> > > > Thank you for your help.
> > > >
> > > > Levente
