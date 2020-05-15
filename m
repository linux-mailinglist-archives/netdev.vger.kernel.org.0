Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32D51D4D56
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 14:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgEOMEv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 15 May 2020 08:04:51 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:47225 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbgEOMEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 08:04:51 -0400
Received: from mail-qk1-f169.google.com ([209.85.222.169]) by
 mrelayeu.kundenserver.de (mreue011 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MAOa3-1jOKnj2QzD-00Bt7y; Fri, 15 May 2020 14:04:48 +0200
Received: by mail-qk1-f169.google.com with SMTP id b6so2163657qkh.11;
        Fri, 15 May 2020 05:04:48 -0700 (PDT)
X-Gm-Message-State: AOAM533xfTHdp4vJAZ7ctjyPmKPkiJ0pTHbIsha+cHXFBUt3tiBTvUzQ
        A7XxpdUqbBpM5srsRItE50nMCZ024ozWxfI82so=
X-Google-Smtp-Source: ABdhPJy/QisBXP8EQRdO9MZV12WEoweyNWMuyrh9ANXT/Y3Ielto24GQxnJVmqWTbMQYGO0VBAlJTfiYoaSJo5kMMAg=
X-Received: by 2002:ae9:ed95:: with SMTP id c143mr2964142qkg.394.1589544287159;
 Fri, 15 May 2020 05:04:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200514075942.10136-1-brgl@bgdev.pl> <20200514075942.10136-11-brgl@bgdev.pl>
 <CAK8P3a3=xgbvqrSpCK5h96eRH32AA7xnoK2ossvT0-cLFLzmXA@mail.gmail.com> <CAMRc=MeypzZBHo6dJGKm4JujYyejqHxtdo7Ts95DXuL0VuMYCw@mail.gmail.com>
In-Reply-To: <CAMRc=MeypzZBHo6dJGKm4JujYyejqHxtdo7Ts95DXuL0VuMYCw@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 15 May 2020 14:04:30 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0u53rHSW=72CnnbhrY28Z+9f=Yv2K-bbj5OD+2Ds4unA@mail.gmail.com>
Message-ID: <CAK8P3a0u53rHSW=72CnnbhrY28Z+9f=Yv2K-bbj5OD+2Ds4unA@mail.gmail.com>
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
X-Provags-ID: V03:K1:bFwAW4lak4mD0kDQMgoEKoUiWJv0wCONItp+75//CaP6A8tUD63
 DnXhOsgXgQIDJwekGdtbeM3sj8A/1T+52SeeHEBvPu0LehWCddJAgrUoY2OIN7ntJ7RMXl5
 LpnyNH9y0X3MWjlr8k0VDycun4U+bx0JGSExDZRNUwTsrOWh4fq7ciPxa99s7iZKjaqqRyM
 gVnA4JA0GICqWd+CR2nlA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:vIQmMKS1hgM=:r3ZD6GCxpeET4mrSFmPEY6
 wpY3pu7iMJfHRzdVvSM2HoBAxG80HcO74ukslsV9PcwZ8gIkJd5ENdZVja/Bi9fup9QTKLE/P
 xuGzm0pm0wjGVqHhRvxkK9jyLY0QYjUIJvsBYyYNLpv022UFVe3JHUCiyb6HDIWHn7s2z6fgg
 ERaYd5gRWMqM23si+0Q8fUaHZTG/ipqgYgyL25RS2aoMPT+LVcsc8/7zfyDaG5ShgOlu0WIDx
 67PHKdgfI2dfulClZduu5cUsToEUU1CT3HjbpLo9CE+iQEnccCmd3t2JswEpLv2orQBf76pGT
 e6wdm3Bve1EOcp0+4GUuCnIGz6V+OEKSU9oTIZOI7bEG/nLp/YVxsNFJ+Sx4xfvD9mFJGQqbi
 LSfBp6nCpRjdVA1snEOE9O3l4kPKHm5MWR9wZG4TaJJGmYWpzAkllQrUKlXnV9GPE42Por2iC
 5gNQ9f2CHfjFPO6BSKPn/oMFlLY9ns62kYDP+JAKYaK7dprsehsd6WypIjmv3idPyr2ro9+Pf
 pdkIqgiwogUlrHDoti9eGVv/Guw9kF0JrOkPoB4VlkyNrweZtjH+rTXsvmnJjxtV81rcT3/7Z
 tcIM5rIxwJADiioky6lYqMks3TA14xat59uoBsT0oXcJU6ZSnGe9/jdxdOkbF+Zohuj48JIZI
 jUWcA/3jOhn6jvBqusGRJCm6pgzBe7PGjwwIHQHFBk6i7zY8De8EHiciII5eqELhoN+cyED+b
 vMQmbSenDJRgSdKdQy7i7wHlP+gfi8ou19gjWpfM/dwp1zqkoOg8CO8phY0JRrVtTjk+7XrDE
 4F1qFO4dImOaaRyMfQqqNHHHqa5S+tW2z6g3FL2xixojedm3MA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 9:11 AM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
>
> czw., 14 maj 2020 o 18:19 Arnd Bergmann <arnd@arndb.de> napisał(a):
> >
> > On Thu, May 14, 2020 at 10:00 AM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
> > > +static unsigned int mtk_mac_intr_read_and_clear(struct mtk_mac_priv *priv)
> > > +{
> > > +       unsigned int val;
> > > +
> > > +       regmap_read(priv->regs, MTK_MAC_REG_INT_STS, &val);
> > > +       regmap_write(priv->regs, MTK_MAC_REG_INT_STS, val);
> > > +
> > > +       return val;
> > > +}
> >
> > Do you actually need to read the register? That is usually a relatively
> > expensive operation, so if possible try to use clear the bits when
> > you don't care which bits were set.
> >
>
> I do care, I'm afraid. The returned value is being used in the napi
> poll callback to see which ring to process.

I suppose the other callers are not performance critical.

For the rx and tx processing, it should be better to just always look at
the queue directly and ignore the irq status, in particular when you
are already in polling mode: suppose you receive ten frames at once
and only process five but clear the irq flag.

When the poll function is called again, you still need to process the
others, but I would assume that the status tells you that nothing
new has arrived so you don't process them until the next interrupt.

For the statistics, I assume you do need to look at the irq status,
but this doesn't have to be done in the poll function. How about
something like:

- in hardirq context, read the irq status word
- irq rx or tx irq pending, call napi_schedule
- if stats irq pending, schedule a work function
- in napi poll, process both queues until empty or
  budget exhausted
- if packet processing completed in poll function
  ack the irq and check again, call napi_complete
- in work function, handle stats irq, then ack it

> > > +static void mtk_mac_tx_complete_all(struct mtk_mac_priv *priv)
> > > +{
> > > +       struct mtk_mac_ring *ring = &priv->tx_ring;
> > > +       struct net_device *ndev = priv->ndev;
> > > +       int ret;
> > > +
> > > +       for (;;) {
> > > +               mtk_mac_lock(priv);
> > > +
> > > +               if (!mtk_mac_ring_descs_available(ring)) {
> > > +                       mtk_mac_unlock(priv);
> > > +                       break;
> > > +               }
> > > +
> > > +               ret = mtk_mac_tx_complete_one(priv);
> > > +               if (ret) {
> > > +                       mtk_mac_unlock(priv);
> > > +                       break;
> > > +               }
> > > +
> > > +               if (netif_queue_stopped(ndev))
> > > +                       netif_wake_queue(ndev);
> > > +
> > > +               mtk_mac_unlock(priv);
> > > +       }
> > > +}
> >
> > It looks like most of the stuff inside of the loop can be pulled out
> > and only done once here.
> >
>
> I did that in one of the previous submissions but it was pointed out
> to me that a parallel TX path may fill up the queue before I wake it.

Right, I see you plugged that hole, however the way you hold the
spinlock across the expensive DMA management but then give it
up in each loop iteration feels like this is not the most efficient
way.

The easy way would be to just hold the lock across the entire
loop and then be sure you do it right. Alternatively you could
minimize the locking and only do the wakeup after up do the final
update to the tail pointer, at which point you know the queue is not
full because you have just freed up at least one entry.

> > > +static int mtk_mac_poll(struct napi_struct *napi, int budget)
> > > +{
> > > +       struct mtk_mac_priv *priv;
> > > +       unsigned int status;
> > > +       int received = 0;
> > > +
> > > +       priv = container_of(napi, struct mtk_mac_priv, napi);
> > > +
> > > +       status = mtk_mac_intr_read_and_clear(priv);
> > > +
> > > +       /* Clean up TX */
> > > +       if (status & MTK_MAC_BIT_INT_STS_TNTC)
> > > +               mtk_mac_tx_complete_all(priv);
> > > +
> > > +       /* Receive up to $budget packets */
> > > +       if (status & MTK_MAC_BIT_INT_STS_FNRC)
> > > +               received = mtk_mac_process_rx(priv, budget);
> > > +
> > > +       /* One of the counter reached 0x8000000 - update stats and reset all
> > > +        * counters.
> > > +        */
> > > +       if (status & MTK_MAC_REG_INT_STS_MIB_CNT_TH) {
> > > +               mtk_mac_update_stats(priv);
> > > +               mtk_mac_reset_counters(priv);
> > > +       }
> > > +
> > > +       if (received < budget)
> > > +               napi_complete_done(napi, received);
> > > +
> > > +       mtk_mac_intr_unmask_all(priv);
> > > +
> > > +       return received;
> > > +}
> >
> > I think you want to leave (at least some of) the interrupts masked
> > if your budget is exhausted, to avoid generating unnecessary
> > irqs.
> >
>
> The networking stack shouldn't queue any new TX packets if the queue
> is stopped - is this really worth complicating the code? Looks like
> premature optimization IMO.

Avoiding IRQs is one of the central aspects of using NAPI -- the idea
is that either you know there is more work to do and you will be called
again in the near future with additional budget, or you enable interrupts
and the irq handler calls napi_schedule, but not both.

This is mostly about RX processing, which is limited by the budget,
for TX you already free all descriptors regardless of the budget.

     Arnd
