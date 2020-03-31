Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C151719992E
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 17:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730464AbgCaPGm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 31 Mar 2020 11:06:42 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:32941 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgCaPGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 11:06:42 -0400
Received: from mail-qk1-f177.google.com ([209.85.222.177]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1M58SY-1jKOP63Fae-00175l for <netdev@vger.kernel.org>; Tue, 31 Mar 2020
 17:06:40 +0200
Received: by mail-qk1-f177.google.com with SMTP id b62so23346293qkf.6
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 08:06:40 -0700 (PDT)
X-Gm-Message-State: ANhLgQ3sCOwkL7rXVXgFbHNbrUc1A2IrvKmy0N1XAKi10ZQzdxkm7FuU
        Bri57XaVCPLvS86GZJ2KrJ6Sf52gRdoTlGsbDeI=
X-Google-Smtp-Source: ADFU+vunPRTV/Y8YzMryLxEZcnhB6beFJ+GXNrwT8VzvsFEePk4RMaA/jWJbeO0TF1hnctLRKaMf+rkR7YkEdUVsIyc=
X-Received: by 2002:a37:6285:: with SMTP id w127mr5317561qkb.138.1585667199161;
 Tue, 31 Mar 2020 08:06:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200326103230.121447-1-s.chopin@alphalink.fr>
 <CAK8P3a2THNOTcx=XMxXRH3RaNYBhsE7gMNx91M8p8D8qUdB-7A@mail.gmail.com>
 <c70371c2-7783-b66a-3108-dbbda383673d@alphalink.fr> <CAK8P3a2oWT2yob76QQHDm0z7z6xcVoRDEejj7ro4heQYyWGQ3A@mail.gmail.com>
 <ce76fc46-74d4-e809-aebd-8c1d44782d86@alphalink.fr>
In-Reply-To: <ce76fc46-74d4-e809-aebd-8c1d44782d86@alphalink.fr>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 31 Mar 2020 17:06:22 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1LF0UzUV8GOA3aL4--_nO-H3wC9103u2vC3j+bNqZ+CQ@mail.gmail.com>
Message-ID: <CAK8P3a1LF0UzUV8GOA3aL4--_nO-H3wC9103u2vC3j+bNqZ+CQ@mail.gmail.com>
Subject: Re: [PATCH net-next] pppoe: new ioctl to extract per-channel stats
To:     Simon Chopin <s.chopin@alphalink.fr>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Guillaume Nault <gnault@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:hDCsjQvg+RoSIVQvB3Y9n12JVt69tXgS2JN13xGp7GRO+UWqE+o
 Eg9DnnN9mjcIf2Un+Hz0zaO7BSSO17Cl9/kqTr5m3c+iATv4RW/QULWjkw15l7xi0lHqHao
 20I5u2W7A5hgd/Y4UCEWlpY29EdjJhxs3iyULQNcQYMGn5jbvzHrB+7/sPemfxPkI0Yfrns
 qt8YRn/MTI5EE5w4rabTw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:UmeOQs57Nu8=:67Hh58G9/Fwc/o4y0z4+yp
 /9wu1pWwIUxp0fOgpeWKDMSjn3goCcPRylSIXy1vaOT/VVxq1NfnB2i6Vsn/kg3Z6pLccaELu
 xGArIJJgUtrNQrzqTHCZpYiYHZMInTpfvsDxpBzEdTS+Rf+RUiebs4l+ulXvjaozhyvlUN3cp
 xcDvqdAh1OHFSynuJSmOVym8fNEn0EeU+YLf1aqCJnxZ/Zu/5zWvzlGFhZvknu0/I12AlK0rW
 LTVEYH0/CxEghqtNj1xiTzRheV5Iq0gMEmL0bP7McPbZ4c9ZFEOzVASuEBbNXBTo73juliXlY
 6P1iqd+bb/PT2NicOaODC/H2FLR365OZvDImLxTs5C40S6yQthOJzOmnAeq1Ix4J0Ukn60mrC
 /WaJrWCQUzeOww3PphV9JoV3DFsXMhzYZLbq58tgPCgredC0Te3E3Tre5M636h7n0msn/rd85
 R9CA15MUiH4CNMFd0ko52o/nDUIeQ1c3/wrc7frUJUiaqUGvEOiFQwWWu+MtyLXYwxlCyhQdS
 vB+rCd5iGDlYbAksbOkdnPak1oxjzk85d2GUjFxrY7/vn/qWk6ZE8IqVfjQvgoKhgntqib1XW
 kKcChGc+hPdkAkJpFkyq2PUgY1eb6WDXIpJ8PbL6oUXcph+OiabqPL8utZbvpqwza5EexyH0I
 f8zDBJ+eVk0P47IohJ+Pk5YMqUXiS2vg1rG1GnlRWWJQPpu+c2LjMKXp4GFby1Kd2zIfGjQKQ
 AG15eQHvNciLlbqREG1BVtvXE3OptVNn5MWi0Fv8PCJjAMFQMKMwtwnAoprIHpHuCejje7VzN
 ulDAJ9hIAfW4uJ9JxAn+c7EDiIiKy4Bcx5N1e1tqSawYtaXub0=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 31, 2020 at 12:03 PM Simon Chopin <s.chopin@alphalink.fr> wrote:
> Le 26/03/2020 à 15:31, Arnd Bergmann a écrit :
> > On Thu, Mar 26, 2020 at 2:48 PM Simon Chopin <s.chopin@alphalink.fr> wrote:
> >> +_Static_assert(sizeof(struct pppol2tp_ioc_stats) == sizeof(struct pppchan_ioc_stats), "same size");
> >> +_Static_assert((size_t)&((struct pppol2tp_ioc_stats *)0)->tx_packets == (size_t)&((struct pppchan_ioc_stats *)0)->tx_packets, "same offset");
> >
> > Conceptually this is what I had in mind, but implementation-wise, I'd suggest
> > only having a single structure definition, possibly with a #define like
> >
> > #define pppoe_ioc_stats pppchan_ioc_stats
> I'm assuming that'd be #define pppol2tp_stats pppchan_ioc_stats ?

Right.

> > #define PPPIOCGCHANSTATS _IOR('t', 54, struct pppchan_ioc_stats)
> > #define PPPIOCGL2TPSTATS PPPIOCGCHANSTATS
>
> Thank you for your feedback. I'm probably going to implement a more
> generic version at the generic PPP channel instead, though, as,
> as noted by Guillaume, those statistics are not for the PPP channel
> but for the layer underneath.
>
> However, I'd like to be sure I understand your proposal here :
> we'd use a generic pppchan_ioc_stats struct that would be identical
> to the current pppol2tp_ioc_stats, including the 3 L2TP-specific fields,
> so that we'd retain ABI and API compatibility, and we would simply
> #define the current API to the new one?

Yes, that's the idea.

      Arnd
