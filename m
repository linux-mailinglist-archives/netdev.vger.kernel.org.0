Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F59B1CEF89
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 10:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729244AbgELIx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 04:53:27 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:40183 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgELIx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 04:53:27 -0400
Received: from mail-qt1-f173.google.com ([209.85.160.173]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MwQKr-1jIGtF0fwL-00sMSI; Tue, 12 May 2020 10:53:24 +0200
Received: by mail-qt1-f173.google.com with SMTP id p12so10353330qtn.13;
        Tue, 12 May 2020 01:53:23 -0700 (PDT)
X-Gm-Message-State: AOAM531bPCd4rdVuHj9hareAQ+sWVeoFnGbSSKt/Qqoic1oyLGstidxL
        B+liFQWhzNautxUYYln/ijaQql0/njVmfGoQwmY=
X-Google-Smtp-Source: ABdhPJwWUHzxIPWAEFI/R+fzRRP8GfBwzpV+uSg5FS1J1qHipihkFrx8cQ+iXHbuwJ1oVqBkUQyCdCMp11cRcLaKWHI=
X-Received: by 2002:ac8:6914:: with SMTP id e20mr5088655qtr.7.1589273602661;
 Tue, 12 May 2020 01:53:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200508095914.20509-1-grygorii.strashko@ti.com>
 <CAK8P3a0qfFzJGya-Ydst8dwC8d7wydfNG-4Ef9zkycEd8WLOCA@mail.gmail.com>
 <7df7a64c-f564-b0cc-9100-93c9e417c2fc@ti.com> <CAK8P3a0-6vRpHJugnUFhNNAALmqx4CUW9ffTOojxu5a80tAQTw@mail.gmail.com>
 <b0e2bd21-f670-f05a-6e23-4c6c75a94868@ti.com>
In-Reply-To: <b0e2bd21-f670-f05a-6e23-4c6c75a94868@ti.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 12 May 2020 10:53:06 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1JPRcvWV3XNdei7A0rXwMBqkspttH7Yxp3EdDEhZbdRg@mail.gmail.com>
Message-ID: <CAK8P3a1JPRcvWV3XNdei7A0rXwMBqkspttH7Yxp3EdDEhZbdRg@mail.gmail.com>
Subject: Re: [PATCH net v3] net: ethernet: ti: fix build and remove
 TI_CPTS_MOD workaround
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Clay McClure <clay@daemons.net>, Dan Murphy <dmurphy@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:j7ItOmWztybeeC7TlwXbh9MOl7ZMS/SNL+gD3CmVVZFXGwIoZbu
 Eq31FERMstxwsfsK2dzmjYpfQUNQuG6gUDpnVUJDJ+ai+ze7cBwDwR8pRazQ8yQkQyOfWBI
 ghQEXMOaKzXLUXPkkE6o6IpHXkSMR2d+UB3ilWnWNrcjF3OR5kuWRx9ktjYDzTP38DVTrp3
 u5Em5105wUfH0UJsWlBYw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:mOfhyPR4MWs=:5G7GdlwxKWs2bHTxO0kr5+
 7LUq+o/2epAEue+YMqEw9Y97VJjUd0HVe8ykIvrHNS5vkmac/0MgE63rbhRavqT/LOWOWvVnY
 9K+BK2RtrNSwufBFk8ptN/FrNBZdRZKUzORmv5koZYGBoe2EkoOR3pHlr7Oud2MEz4r8HtzwG
 DZoWUto1x1RnztdlJPqGxrGuxptBq/TuOWTH6fQr+udW2N3ndzyfMKmmrAAEE0zbkVz79lqFq
 e92DMpuhZ57e3vpx56NUsMkym7QtnX/bioAkY0Ug6C9TwXElGMUKuX6hoylvonnIyskkKqx2/
 7dJpdp12tw3Go2ZsHsorN4MRcxh2dlxvUc6Td2wNRLYXIW9KPfOqmXp08v+RmgbwCKkX1nv4p
 6SWwBt1aeLiIPF92/0Om18aw630dvCEihfcYoZSyitGNB4it8KvVVHGhZCekRCI/7+fEa48Nx
 nVfQvPcfgJQa9DF4TiBHgA/QR1zonPHeUaLIkAiTSaHUKyovOGh+y3inMKwXgpruF9fQSBDbD
 ldxGtSHS6H/AmSBInEOq0CvT4W8/T0CDdoQrvGGA0caqpB9rAQwRra0rxCMZwDfFSoaSmp0zT
 RVgBKWe8BVQF2CEAydsrWZUZ9rPZy7T/M6ESroRhLXU7sgr7/dSlConALTSwc8eGNV/KTS664
 aEWyLbze2MJmZo7/N6gc30rco0gbmt32E9poLppH6QShZ/pWP/9/vI0GsiaUDkXuny6VceuZf
 5soVCbCFoA/zTfECxFHbc8WjZcyP+UcXRQFqefdM9fperETV0WmB9jB+aoD0zGD9lFDFkqZDb
 rLm+UynrPproOFYGKigoQvDtKhyDSccE3VoN/5dd1rxfRrxN24=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 10:35 AM Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
>
> Hi Arnd,
>
> On 08/05/2020 14:25, Arnd Bergmann wrote:
> > On Fri, May 8, 2020 at 1:14 PM Grygorii Strashko
> > <grygorii.strashko@ti.com> wrote:
> >> On 08/05/2020 13:10, Arnd Bergmann wrote:
> >>> On Fri, May 8, 2020 at 11:59 AM Grygorii Strashko
> >
> >>>> That's because TI_CPTS_MOD (which is the symbol gating the _compilation_ of
> >>>> cpts.c) now depends on PTP_1588_CLOCK, and so is not enabled in these
> >>>> configurations, but TI_CPTS (which is the symbol gating _calls_ to the cpts
> >>>> functions) _is_ enabled. So we end up compiling calls to functions that
> >>>> don't exist, resulting in the linker errors.
> >>>>
> >>>> This patch fixes build errors and restores previous behavior by:
> >>>>    - ensure PTP_1588_CLOCK=y in TI specific configs and CPTS will be built
> >>>>    - use IS_REACHABLE(CONFIG_TI_CPTS) in code instead of IS_ENABLED()
> >>>
> >>> I don't understand what IS_REACHABLE() is needed for once all the other
> >>> changes are in place. I'd hope we can avoid that. Do you still see
> >>> failures without
> >>> that or is it just a precaution. I can do some randconfig testing on your patch
> >>> to see what else might be needed to avoid IS_REACHABLE().
> >>
> >> I've not changed this part of original patch, but seems you're right.
> >>
> >> I can drop it and resend, but, unfortunately, i do not have time today for full build testing.
> >
> > I have applied to patch locally to my randconfig tree, with the IS_REACHABLE()
> > changes taken out.
> >
>
> What will be the conclusion here?

I have seen no other problems with it, please leave out the the IS_REACHABLE()
changes and just use the dependencies.

       Arnd
