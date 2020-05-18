Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC93D1D7B64
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 16:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgEROiq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 18 May 2020 10:38:46 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:49683 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbgEROiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 10:38:46 -0400
Received: from mail-qk1-f176.google.com ([209.85.222.176]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1Ma0HM-1jXTMN436K-00W1bi; Mon, 18 May 2020 16:38:44 +0200
Received: by mail-qk1-f176.google.com with SMTP id n14so10262052qke.8;
        Mon, 18 May 2020 07:38:43 -0700 (PDT)
X-Gm-Message-State: AOAM532gtYvic9MEdHYNR0Qc4moQduEJ+oK/yQsQt9DVOKy9z9UiZ1Kz
        QKgfp5UJmt7BNvCV1RTs1VLuXeVxj8j/xLXlIaA=
X-Google-Smtp-Source: ABdhPJxzhsnxVhq8ZSNDtJoBCI07uV5rPB2Xy6wBijq3wixD3dVCpTMzBq7wTOe/KdpPc4bGdgY7xrXJK4eQYms1WB8=
X-Received: by 2002:a37:aa82:: with SMTP id t124mr15128415qke.3.1589812722617;
 Mon, 18 May 2020 07:38:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200514075942.10136-1-brgl@bgdev.pl> <20200514075942.10136-11-brgl@bgdev.pl>
 <CAK8P3a0XgJtZNKePZUUpzADO25-JZKyDiVHFS_yuHRXTjvjDwg@mail.gmail.com> <CAMRc=MeVyNzTWw_hk=J9kX1NE9reCE_O4P3wrNpMMc9z4xA_DA@mail.gmail.com>
In-Reply-To: <CAMRc=MeVyNzTWw_hk=J9kX1NE9reCE_O4P3wrNpMMc9z4xA_DA@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 18 May 2020 16:38:25 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1xaWE0gNx-PnJz08XzUkPW6YB7U6NfFS+Y1VXwG+VR+w@mail.gmail.com>
Message-ID: <CAK8P3a1xaWE0gNx-PnJz08XzUkPW6YB7U6NfFS+Y1VXwG+VR+w@mail.gmail.com>
Subject: Re: [PATCH v3 10/15] net: ethernet: mtk-eth-mac: new driver
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        DTML <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:OB6VzK2054ZHQfz3CTgEBDfpQ26ehY5iVTYbtEgywu+eoe059Ia
 155h7+afzU9IY+xpKJNhOOLCYvG+CVCVONbhge2PqpV/n60X2eLhfQhAZBVBHEL/+1R+1nH
 bkHyXDZArv+FJ2Mpb4xmr+JeC+E3em4yPC+eZXrv/hHpQtslM+EM5i1INXSMt3IWXUG7q4G
 CmzKbMVFQg56UvK6vbNHA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:vxLiJ7JDE0g=:Up6ARmLIWMk+ak4wsEctGO
 rhiErvnlmZs6qhQQPDdfVywOzmJX7Mptu/6SGVVLaqdaZgtvqCNYjbQi2f4tTXASpL9hz5Arq
 EjfB0c9JxG0/BSAIHQWYto8dP+6fUmMCdGKRBYOS8RjGyTOrbcZN2wKbQxDJs9o4sgDfr/XYV
 byoDT4koyV0n2eYzFUoEVWDXi0s0hHd8htLVXjhybemtTQJosg8ZGke53TKCT0GfwHknHXzV5
 v/XQYMp7KOifvsdCG6DlXQ0o1azXT+QrzWAEIgedTlQq6c+oLQo7AAa+wsatiLz/NJEPOAggz
 GlbHPa6Xf1joz3dWalT7TE55mJRFvdzko0aabkIjts6ejiXIdyq5f0C0RgIlRKJR2HDEimDHu
 nR+FrNmnQV1bmd1IaFCLBlCS9mgkLBy7w3bwMxkOzg0Lu6OF7ubj/gmL1t5CJ5hcrE5pYeUL7
 bwBehMEyVplOBYbGDMn9v0ABdTji3YcYPKLe3nZeiET3FsYgGlsuuzPBnDcMZXdXhA3Ab+oYp
 wUctgNbumAXwoHwazZblpYReqHgMajU54iL5OSr19TlP9j6QUKk4zBkRE1KTx3YIxbkDfOAjC
 ks86QV6Sd6y+OLyrn/r5EA7Ghs05F+dGley2Vb6hskJmDtph+nYnAKbA9Jub0La7nKlE/xi+R
 Xw77Aih4WsE7WxOJOnp7rupPlNn39dwFEs+/ahTkDm3B/YafV6wwekr7ZUVLoKxHquc5kk5WI
 B1SH58SmfbDZkbaMmuVhoNHb//VPRj66Zyjm1MSAWb3bnLk4eIOK2b4VIYCHYhOHUFeD0W40g
 jX11DAu8ta1FlVRrDSBJhl3b1heQbBlno2h0SMSRBngQ3hA2ms=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 4:07 PM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
> pt., 15 maj 2020 o 15:32 Arnd Bergmann <arnd@arndb.de> napisał(a):

> > I would get rid of the 'count' here, as it duplicates the information
> > that is already known from the difference between head and tail, and you
> > can't update it atomically without holding a lock around the access to
> > the ring. The way I'd do this is to have the head and tail pointers
> > in separate cache lines, and then use READ_ONCE/WRITE_ONCE
> > and smp barriers to access them, with each one updated on one
> > thread but read by the other.
> >
>
> Your previous solution seems much more reliable though. For instance
> in the above: when we're doing the TX cleanup (we got the TX ready
> irq, we're iterating over descriptors until we know there are no more
> packets scheduled (count == 0) or we encounter one that's still owned
> by DMA), a parallel TX path can schedule new packets to be sent and I
> don't see how we can atomically check the count (understood as a
> difference between tail and head) and run a new iteration (where we'd
> modify the head or tail) without risking the other path getting in the
> way. We'd have to always check the descriptor.

It should be enough to read both pointers once at the start of each
side, then do whatever work you want to do (cleaning, sending,
receiving, refilling) and finally updating the one pointer that changed.
If both sides do that, you minimize the cache line bouncing and
always do a useful amount of work that guarantees forward progress
and does not interfere with the other side.

> I experimented a bit with this and couldn't come up with anything that
> would pass any stress test.
>
> On the other hand: spin_lock_bh() works fine and I like your approach
> from the previous e-mail - except for the work for updating stats as
> we could potentially lose some stats when we're updating in process
> context with RX/TX paths running in parallel in napi context but that
> would be rare enough to overlook it.
>
> I hope v4 will be good enough even with spinlocks. :)

Yes, it should be fine. Avoiding all the locks is mainly an optimization
for the number of CPU cycles spent per packet, the other points
are more important to get right, in particular the flow control.

      Arnd
