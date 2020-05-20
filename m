Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209F41DC14B
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 23:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgETVXG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 20 May 2020 17:23:06 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:52935 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbgETVXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 17:23:06 -0400
Received: from mail-qk1-f177.google.com ([209.85.222.177]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MDhth-1jjWFd3pd1-00AjXF; Wed, 20 May 2020 23:23:03 +0200
Received: by mail-qk1-f177.google.com with SMTP id z80so5241757qka.0;
        Wed, 20 May 2020 14:23:02 -0700 (PDT)
X-Gm-Message-State: AOAM530+4XTsxvzjPhSLBin0cpDLo9y2f91Y0R2+LF80GcbwIikIORur
        pBa53MPvHr1pB0CXehBARuUBDyut2h3N5t2OiKQ=
X-Google-Smtp-Source: ABdhPJwZcCZSxDynCH3r3gKmPJPpPeE9FrIMPWva+zbjlW1lcOdkg0GE0sngrt5N6VQ/g7lU1Cjl02NdfnJS0lbfHTc=
X-Received: by 2002:a37:46c9:: with SMTP id t192mr3853110qka.3.1590009781522;
 Wed, 20 May 2020 14:23:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200520112523.30995-1-brgl@bgdev.pl> <20200520112523.30995-7-brgl@bgdev.pl>
 <CAK8P3a3jhrQ3p1JsqMNMOOnfo9t=rAPWaOAwAdDuFMh7wUtZQw@mail.gmail.com> <CAMRc=MeuQk9rFDFGWK0ijsiM-r296cVz9Rth8hWhW5Aeeti_cA@mail.gmail.com>
In-Reply-To: <CAMRc=MeuQk9rFDFGWK0ijsiM-r296cVz9Rth8hWhW5Aeeti_cA@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 20 May 2020 23:22:45 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1nhPj6kRhwyXzDK3BGbh66XG6Fmp44QuM1NhFPPBTtPQ@mail.gmail.com>
Message-ID: <CAK8P3a1nhPj6kRhwyXzDK3BGbh66XG6Fmp44QuM1NhFPPBTtPQ@mail.gmail.com>
Subject: Re: [PATCH v4 06/11] net: ethernet: mtk-eth-mac: new driver
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
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
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:/gC/5Naxf714EfIF7VfC28t3aDY3Z5zwTf0bIDD9BdZYwi1aXcQ
 wOAjoLgJmY8yqt0tKwvjPxlYQ+YHeUWSIugxeSDb9jafNiVALoWHpxKqOE0Fe00bZNgWbGx
 iEyFxQ3un9OWUbA9NjfuAGpCULoebm33vwCBY8/VOyy+DRplmE4KqkhuQQwTIRAMIvrYGOy
 w9+U66RvOrIdXm53Qth/A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:5ZVhrGWEVig=:MlewIc1FlCowA24CzIifiW
 my+BBmPcV4f7xG20qgT44Dniq/cekNL0vxCJFHqfgv295t3XjNGj1Z8+/C+QBDDIw2Fl+iEzd
 GjUpQm0FZn4bGKRO1MLD2kb4ETS6EzCBoOY73Hl1LZ8Zz8dssR2HVWtlmgHHWe8nEouK1TMGG
 BzCw6+EeQGg9ZbSNmNRnxy6JS7DR22doUghbO5SUD8gLQoeIiiiBHu6vTx1FiwZ901OBOHcTJ
 Otlcf8hZ0axSrjU7i2dwXA6vdPkorfuxxjgDTySPwp9f/2CFQFDg/CBjoWian5nmBPKgDKnzm
 LJeIfeACi2ptva/SS/mfAmeDe12mrScIm7HCzCYd9rtMhfvNhhWnhHRXIJVMsMWRh1IBOMg1s
 3REl8+v6LKhC1V7NoEvT2rfTTOQ/hmwQg7hDUjl1dJcWdZu20swCmK06z0LG+3XNwNu/54+y1
 lcG+JiEvK3ySHgdp0Q1jXRVXiVmNYZG+dvsiHYOcR8Q/Xt7refjI0rC7mO82P1IaCSk62ykvL
 wER9MK6H9YleFs2FHk0VvqGSir5+ifjDx+N7hJ13yJDUy6tRRI6DymSkJonDzJMWnd8b/Hde6
 pjn1HRmWOxEwj0fbFtNn3hKToZoNEJm2itITl/X9PxDdlrjSYL/hWxAV0kpOFPiQV7KWLRidK
 mOxI+/NnX7fqmQubUWr8ASozgGWcx67roHtxljG84+wZr1efzQ0XKgzzxEUKMURPZi1ZYZFEt
 5h3+ONVmZCrYln6pbM63bB+kz2syqE1ioEzLO/CjkVMfqqqS0JUf96/CUWrI5Eym50SeFdZdx
 k2Lev8IcWKg8EEU9a7GOqTeFqxseVkdqdS2zl6WWStvjErVoFM=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 7:35 PM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
> śr., 20 maj 2020 o 16:37 Arnd Bergmann <arnd@arndb.de> napisał(a):

> > I just noticed how the naming of NET_MEDIATEK_MAC and NET_MEDIATEK_SOC
> > for two different drivers doing the same thing is really confusing.
> >
> > Maybe someone can come up with a better name, such as one
> > based on the soc it first showed up in.
> >
>
> This has been discussed under one of the previous submissions.
> MediaTek wants to use this IP on future designs as well and it's
> already used on multiple SoCs so they want the name to be generic. I
> also argued that this is a driver strongly tied to a specific
> platform(s) so if someone wants to compile it - they probably know
> what they're doing.
>
> That being said: I verified with MediaTek and the name of the IP I can
> use is "star" so they proposed "mtk-star-eth". I would personally
> maybe go with "mtk-star-mac". How about those two?

Both seem fine to me. If this was previously discussed, I don't want
do further bike-shedding and I'd trust you to pick a sensible name
based on the earlier discussions.

> >  +               /* One of the counters reached 0x8000000 - update stats and
> > > +                * reset all counters.
> > > +                */
> > > +               if (unlikely(status & MTK_MAC_REG_INT_STS_MIB_CNT_TH)) {
> > > +                       mtk_mac_intr_disable_stats(priv);
> > > +                       schedule_work(&priv->stats_work);
> > > +               }
> > > + befor
> > > +               mtk_mac_intr_ack_all(priv);
> >
> > The ack here needs to be dropped, otherwise you can get further
> > interrupts before the bottom half has had a chance to run.
> >
>
> My thinking was this: if I mask the relevant interrupt (TX/RX
> complete) and ack it right away, the status bit will be asserted on
> the next packet received/sent but the process won't get interrupted
> and when I unmask it, it will fire right away and I won't have to
> recheck the status register. I noticed that if I ack it at the end of
> napi poll callback, I end up missing certain TX complete interrupts
> and end up seeing a lot of retransmissions even if I reread the status
> register. I'm not yet sure where this race happens.

Right, I see. If you just ack at the end of the poll function, you need
to check the rings again to ensure you did not miss an interrupt
between checking observing both rings to be empty and the irq-ack.

I suspect it's still cheaper to check the two rings with an uncached
read from memory than to to do the read-modify-write on the mmio,
but you'd have to measure that to be sure.

> > > +static void mtk_mac_tx_complete_all(struct mtk_mac_priv *priv)
> > > +{
> > > +       struct mtk_mac_ring *ring = &priv->tx_ring;
> > > +       struct net_device *ndev = priv->ndev;
> > > +       int ret, pkts_compl, bytes_compl;
> > > +       bool wake = false;
> > > +
> > > +       mtk_mac_lock(priv);
> > > +
> > > +       for (pkts_compl = 0, bytes_compl = 0;;
> > > +            pkts_compl++, bytes_compl += ret, wake = true) {
> > > +               if (!mtk_mac_ring_descs_available(ring))
> > > +                       break;
> > > +
> > > +               ret = mtk_mac_tx_complete_one(priv);
> > > +               if (ret < 0)
> > > +                       break;
> > > +       }
> > > +
> > > +       netdev_completed_queue(ndev, pkts_compl, bytes_compl);
> > > +
> > > +       if (wake && netif_queue_stopped(ndev))
> > > +               netif_wake_queue(ndev);
> > > +
> > > +       mtk_mac_intr_enable_tx(priv);
> >
> > No need to ack the interrupt here if napi is still active. Just
> > ack both rx and tx when calling napi_complete().
> >
> > Some drivers actually use the napi budget for both rx and tx:
> > if you have more than 'budget' completed tx frames, return
> > early from this function and skip the napi_complete even
> > when less than 'budget' rx frames have arrived.
> >
>
> IIRC Jakub said that the most seen approach is to free all TX descs
> and receive up to budget packets, so this is what I did. I think it
> makes the most sense.

Ok, he's probably right then.

My idea was that the dma_unmap operation for the tx cleanup is
rather expensive on chips without cache-coherent DMA, so you
might not want to do too much of it but rather do it in reasonably
sized batches. It would also avoid the case where you renable the
tx-complete interrupt after cleaning the already-sent frames but
then immediately get an irq when the next frame that is already
queued is done.

This probably depends on the specific workload which one works
better here.

         Arnd
