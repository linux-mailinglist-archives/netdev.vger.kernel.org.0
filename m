Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9C61D364F
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 18:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgENQT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 12:19:59 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:41809 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgENQT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 12:19:59 -0400
Received: from mail-qv1-f52.google.com ([209.85.219.52]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1M4KFF-1jYzTG2CG1-000PWo; Thu, 14 May 2020 18:19:55 +0200
Received: by mail-qv1-f52.google.com with SMTP id ep1so1970273qvb.0;
        Thu, 14 May 2020 09:19:55 -0700 (PDT)
X-Gm-Message-State: AOAM532V6muxKycrthbDZnbAhyEqlzV9iIa8frjEiKZSO2FI+IiAyp4X
        QUd0cpXDOQOmz6WiMVlEsocOkqEsWJZJp+D6Kzk=
X-Google-Smtp-Source: ABdhPJxCBrrGbxf18hL0yNxLoGEF8lWC0aBA5Q8WEtaHoSpSU8DBa8Zy7ECG2BoQv6ItHE4yhgTm89xpWpnDDwuH11g=
X-Received: by 2002:a0c:eb11:: with SMTP id j17mr5595135qvp.197.1589473194138;
 Thu, 14 May 2020 09:19:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200514075942.10136-1-brgl@bgdev.pl> <20200514075942.10136-11-brgl@bgdev.pl>
In-Reply-To: <20200514075942.10136-11-brgl@bgdev.pl>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 14 May 2020 18:19:37 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3=xgbvqrSpCK5h96eRH32AA7xnoK2ossvT0-cLFLzmXA@mail.gmail.com>
Message-ID: <CAK8P3a3=xgbvqrSpCK5h96eRH32AA7xnoK2ossvT0-cLFLzmXA@mail.gmail.com>
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
X-Provags-ID: V03:K1:9dLBUW8TwUWaZ8Mz0SIvhiF013/9J8mNqRJwJ3LocWoP6VMx9DM
 EmvIOP3nISs2jxs8t72lpfd65opvk87hMgPZEPvUZMNzptrwtFRIJ9IwfzY4Pt08MRP/4kU
 a/DgfKZPlz3Habz63HfjeGNvXCYLiBEVsZ5x1mrs5G1g0oC9i0Xg1vJQOEWnlgL6OaNNC02
 /a0hjVVkIUx+yZo/7d/kw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:XnlW/e2jF0E=:7K4hOyXURFoYC4Xz5dgfSo
 3TBhEcTWBCxSBp8GRY2xacVo42nvzud1KBHrNhjJx7Wepd9WmeaXmBL/K+sUYAy26X72X7f9Z
 GIASTdwM/AXbSffP4MR6Eu6I0821rZ88Ku+ur6yYtWIw1kJbebSUtfHKsyZKDa4Ra3g7mlbbM
 1tsnnrkwkMVSkuhdFa5pfYayOP8BbZw4Acithr+QHfOyDCygHwklDY04ERpPmbsS1R1vNz76U
 HEH31Hc1eX3TvWNR99M1g1eQhIKD04fdtgzThrp9+fp5egya55gE7OhVjkIVB20N0f1tPHXkm
 9hDXgEbx8zD4ZnlQmitfV7qZYuqTRtfQm0WjjgNWkGVkcmwZTXF/zdyW0PhPS4ZRPEQbM/2t8
 0AiEvE7rkda+A1wqZaGuLMUsZ9OrnmH5xBhRuxd+hRpZYO17sUAGNfNBo0tlzab0/dZSiHP0G
 XzOSOhbPtUtIbIT1eEkssH/4IDdIs7WNH82dVl1AxdO6rkWegTgi86hetnULbNp0oJiR3ITk+
 2Btaz+AcMzjw1Zrrb3MXRYA5bz6xxO59hc0x03CHDCAvNbW+dOPhJM7n3VQYk08cYsfXXugSj
 nTE3vOSIwoPyiKPDNowX0KrIeARZ7K3SsAEe0afJqqBuaac9TJTTfTlMYrRYO3C6x6X7fCz9p
 xjCoSfeWkxjxN1s+jU9Uxg77XYvGK1oTTT2sEG95CbaNLZ+iiXEbGgQB2uxRsBNO4yWZRIIcG
 RWabQy+q8hHijOpGIhJ92VXwGQhlNIbDnteKvFFqRmUvY6RiY9OILO5mXj9kHB97r5ACbaBiS
 8O9+ygBdgWP/NrwcwIjERKqYRETNY1cBUz2SS3neGe6olDp05Y=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 10:00 AM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
>
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>
> This adds the driver for the MediaTek Ethernet MAC used on the MT8* SoC
> family. For now we only support full-duplex.
>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Looks very nice overall. Just a few things I noticed, and some ideas
that may or may not make sense:

> +/* This is defined to 0 on arm64 in arch/arm64/include/asm/processor.h but
> + * this IP doesn't work without this alignment being equal to 2.
> + */
> +#ifdef NET_IP_ALIGN
> +#undef NET_IP_ALIGN
> +#endif
> +#define NET_IP_ALIGN                           2

Maybe you should just define your own macro instead of replacing
the normal one then?

> +static void mtk_mac_lock(struct mtk_mac_priv *priv)
> +{
> +       spin_lock_irqsave(&priv->lock, priv->lock_flags);
> +}
> +
> +static void mtk_mac_unlock(struct mtk_mac_priv *priv)
> +{
> +       spin_unlock_irqrestore(&priv->lock, priv->lock_flags);
> +}

This looks wrong: you should not have shared 'flags' passed into
spin_lock_irqsave(), and I don't even see a need to use the
irqsave variant of the lock in the first place.

Maybe start by open-coding the lock and remove the wrappers
above.

Then see if you can use a cheaper spin_lock_bh() or plain spin_lock()
instead of irqsave.

Finally, see if this can be done in a lockless way by relying on
appropriate barriers and separating the writers into separate
cache lines. From a brief look at the driver I think it can be done
without too much trouble.

> +static unsigned int mtk_mac_intr_read_and_clear(struct mtk_mac_priv *priv)
> +{
> +       unsigned int val;
> +
> +       regmap_read(priv->regs, MTK_MAC_REG_INT_STS, &val);
> +       regmap_write(priv->regs, MTK_MAC_REG_INT_STS, val);
> +
> +       return val;
> +}

Do you actually need to read the register? That is usually a relatively
expensive operation, so if possible try to use clear the bits when
you don't care which bits were set.

> +/* All processing for TX and RX happens in the napi poll callback. */
> +static irqreturn_t mtk_mac_handle_irq(int irq, void *data)
> +{
> +       struct mtk_mac_priv *priv;
> +       struct net_device *ndev;
> +
> +       ndev = data;
> +       priv = netdev_priv(ndev);
> +
> +       if (netif_running(ndev)) {
> +               mtk_mac_intr_mask_all(priv);
> +               napi_schedule(&priv->napi);
> +       }
> +
> +       return IRQ_HANDLED;


> +static int mtk_mac_netdev_start_xmit(struct sk_buff *skb,
> +                                    struct net_device *ndev)
> +{
> +       struct mtk_mac_priv *priv = netdev_priv(ndev);
> +       struct mtk_mac_ring *ring = &priv->tx_ring;
> +       struct device *dev = mtk_mac_get_dev(priv);
> +       struct mtk_mac_ring_desc_data desc_data;
> +
> +       desc_data.dma_addr = mtk_mac_dma_map_tx(priv, skb);
> +       if (dma_mapping_error(dev, desc_data.dma_addr))
> +               goto err_drop_packet;
> +
> +       desc_data.skb = skb;
> +       desc_data.len = skb->len;
> +
> +       mtk_mac_lock(priv);
> +       mtk_mac_ring_push_head_tx(ring, &desc_data);
> +
> +       if (mtk_mac_ring_full(ring))
> +               netif_stop_queue(ndev);
> +       mtk_mac_unlock(priv);
> +
> +       mtk_mac_dma_resume_tx(priv);
> +
> +       return NETDEV_TX_OK;
> +
> +err_drop_packet:
> +       dev_kfree_skb(skb);
> +       ndev->stats.tx_dropped++;
> +       return NETDEV_TX_BUSY;
> +}

I would always add BQL flow control in new drivers, using
netdev_sent_queue here...

> +static int mtk_mac_tx_complete_one(struct mtk_mac_priv *priv)
> +{
> +       struct mtk_mac_ring *ring = &priv->tx_ring;
> +       struct mtk_mac_ring_desc_data desc_data;
> +       int ret;
> +
> +       ret = mtk_mac_ring_pop_tail(ring, &desc_data);
> +       if (ret)
> +               return ret;
> +
> +       mtk_mac_dma_unmap_tx(priv, &desc_data);
> +       dev_kfree_skb_irq(desc_data.skb);
> +
> +       return 0;
> +}

... and netdev_completed_queue()  here.

> +static void mtk_mac_tx_complete_all(struct mtk_mac_priv *priv)
> +{
> +       struct mtk_mac_ring *ring = &priv->tx_ring;
> +       struct net_device *ndev = priv->ndev;
> +       int ret;
> +
> +       for (;;) {
> +               mtk_mac_lock(priv);
> +
> +               if (!mtk_mac_ring_descs_available(ring)) {
> +                       mtk_mac_unlock(priv);
> +                       break;
> +               }
> +
> +               ret = mtk_mac_tx_complete_one(priv);
> +               if (ret) {
> +                       mtk_mac_unlock(priv);
> +                       break;
> +               }
> +
> +               if (netif_queue_stopped(ndev))
> +                       netif_wake_queue(ndev);
> +
> +               mtk_mac_unlock(priv);
> +       }
> +}

It looks like most of the stuff inside of the loop can be pulled out
and only done once here.

> +static int mtk_mac_poll(struct napi_struct *napi, int budget)
> +{
> +       struct mtk_mac_priv *priv;
> +       unsigned int status;
> +       int received = 0;
> +
> +       priv = container_of(napi, struct mtk_mac_priv, napi);
> +
> +       status = mtk_mac_intr_read_and_clear(priv);
> +
> +       /* Clean up TX */
> +       if (status & MTK_MAC_BIT_INT_STS_TNTC)
> +               mtk_mac_tx_complete_all(priv);
> +
> +       /* Receive up to $budget packets */
> +       if (status & MTK_MAC_BIT_INT_STS_FNRC)
> +               received = mtk_mac_process_rx(priv, budget);
> +
> +       /* One of the counter reached 0x8000000 - update stats and reset all
> +        * counters.
> +        */
> +       if (status & MTK_MAC_REG_INT_STS_MIB_CNT_TH) {
> +               mtk_mac_update_stats(priv);
> +               mtk_mac_reset_counters(priv);
> +       }
> +
> +       if (received < budget)
> +               napi_complete_done(napi, received);
> +
> +       mtk_mac_intr_unmask_all(priv);
> +
> +       return received;
> +}

I think you want to leave (at least some of) the interrupts masked
if your budget is exhausted, to avoid generating unnecessary
irqs.

It may also be faster to not mask/unmask at all but just
clear the interrupts that you have finished processing

      Arnd
