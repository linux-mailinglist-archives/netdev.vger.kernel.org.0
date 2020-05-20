Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4D61DB732
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 16:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgETOhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 10:37:46 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:34825 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbgETOhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 10:37:45 -0400
Received: from mail-qt1-f175.google.com ([209.85.160.175]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1Mhl0I-1j6lvS0nBY-00doud; Wed, 20 May 2020 16:37:42 +0200
Received: by mail-qt1-f175.google.com with SMTP id n22so2640801qtv.12;
        Wed, 20 May 2020 07:37:41 -0700 (PDT)
X-Gm-Message-State: AOAM531uXSCF78PVPq9UExAuHUv8Mk23hiM5oqWUWToa3N7DfEFZ1R8Z
        aREj99XumdzQc7R/nviF3kylWglIgu4fGq9ES+s=
X-Google-Smtp-Source: ABdhPJwK69DLGTQm1ew09Tx3ieAV4bUG76cvGX5A2V+WrnHBW769WJQTOfdTdgV3HOoosoX6NyQXG6Qlso/22NfuIt0=
X-Received: by 2002:ac8:691:: with SMTP id f17mr5450469qth.204.1589985460744;
 Wed, 20 May 2020 07:37:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200520112523.30995-1-brgl@bgdev.pl> <20200520112523.30995-7-brgl@bgdev.pl>
In-Reply-To: <20200520112523.30995-7-brgl@bgdev.pl>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 20 May 2020 16:37:23 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3jhrQ3p1JsqMNMOOnfo9t=rAPWaOAwAdDuFMh7wUtZQw@mail.gmail.com>
Message-ID: <CAK8P3a3jhrQ3p1JsqMNMOOnfo9t=rAPWaOAwAdDuFMh7wUtZQw@mail.gmail.com>
Subject: Re: [PATCH v4 06/11] net: ethernet: mtk-eth-mac: new driver
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Rob Herring <robh+dt@kernel.org>,
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
X-Provags-ID: V03:K1:QqMtx8CuXcHGDbqgkNMgVzQpNveXp+z3WKw9tvOq+6H81dNXXlT
 D3GZJkD1wmXb9l6V7H0ms2jNbFYQHR8BeKc+BQSzr/NhFeDPKeb1j/gutGx0tOgnuheI+tL
 IbeIaS0YB7f3JzyyjQdblfPSZgirB5PZu1rdtpziZmYSSowc5KlsRWDtJQ5f/dfbgS5A1OM
 2S2ghs93t6V2jtPD9vpmA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:n16Z+a7OFkU=:x8ZHYakDBeSIU678yksPkO
 kowJL4wOE3MbiXf/U1P28ueSsRhqQSMEp66LbpRWQojjyoLmEYLwR5qeWfaWwBuHq6wMnfpGe
 VTlUUtLplDjG92ykFpP/5tv84KuYBIP5zjpXpiSMKXD9qmOSo8uVFES87ErNQIB4ogXMsX/TS
 TJLA6O8S8qhkg8Jkq2lPLA0ylo9HLEJBf3uBmOzAQe72KagjtEZRNroveDKdm058PJ+lPGDxf
 TRaJp54/9u7iMT0gsGEXjeHxXj622NAy4P5ATgAYWvoILEMZJWkmiZJMBbk4YIWADsWc26OfM
 w/vtpRxkCNKB66JLzcSohlc9R8Bn1zp4NOmXLkH/PEMh3g8qEuXbiHxAsvf8pxY+CdrP1gh59
 /odUwbcDs1RtyXzGIB1iq8Ammuq2XFt9ooU+PXLNrw6PkXAKFf98b1XUmOrYeNCUjOYRbWiRp
 H+4yVhbecFwdkc53IPxpdL5oz0qochRxBJ5B0fpLYVLF9B1KfyOHbr9XWO6wSGv9oref3TXM6
 Sqc4ukFicMhKt2YHxA3zakyHafr32+0iB9a9MNHUNQewLXMQSI0gbTqXUumHySBG6HzURhCLN
 ohIY1u9rFMequCwHE9TuvB4P6DCcOmFiRdek8L/9pZYc7Ijfx2ocbJV2a8kwOA+Y66iDnOCcH
 emPr7PYAA1xuj63uVhYsQkIPuhaKe06NPXBAn1WhCxBIkNgBLcxGsj6sEqH3ZkF19tqsvi4YK
 N0Ex+FSYJLiahXSAY4C4ooEMm7bMeA/Ok46EdheW8dXtWrOk/ajqpiVAfg3joGG3ShLjPilG5
 xB3r5BvdriI4mRhSHADf/MhBn7/lLPIkBjaAlMr3XeXFVPLIg4=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 1:25 PM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
>
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>
> This adds the driver for the MediaTek Ethernet MAC used on the MT8* SoC
> family. For now we only support full-duplex.
>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Looks much better, thanks for addressing my feedback. A few more things
about this version:

> ---
>  drivers/net/ethernet/mediatek/Kconfig       |    6 +
>  drivers/net/ethernet/mediatek/Makefile      |    1 +
>  drivers/net/ethernet/mediatek/mtk_eth_mac.c | 1668 +++++++++++++++++++
>  3 files changed, 1675 insertions(+)
>  create mode 100644 drivers/net/ethernet/mediatek/mtk_eth_mac.c
>
> diff --git a/drivers/net/ethernet/mediatek/Kconfig b/drivers/net/ethernet/mediatek/Kconfig
> index 5079b8090f16..5c3793076765 100644
> --- a/drivers/net/ethernet/mediatek/Kconfig
> +++ b/drivers/net/ethernet/mediatek/Kconfig
> @@ -14,4 +14,10 @@ config NET_MEDIATEK_SOC
>           This driver supports the gigabit ethernet MACs in the
>           MediaTek SoC family.
>
> +config NET_MEDIATEK_MAC
> +       tristate "MediaTek Ethernet MAC support"
> +       select PHYLIB
> +       help
> +         This driver supports the ethernet IP on MediaTek MT85** SoCs.

I just noticed how the naming of NET_MEDIATEK_MAC and NET_MEDIATEK_SOC
for two different drivers doing the same thing is really confusing.

Maybe someone can come up with a better name, such as one
based on the soc it first showed up in.

> +       struct mtk_mac_ring_desc *desc = &ring->descs[ring->head];
> +       unsigned int status;
> +
> +       status = desc->status;
> +
> +       ring->skbs[ring->head] = desc_data->skb;
> +       ring->dma_addrs[ring->head] = desc_data->dma_addr;
> +       desc->data_ptr = desc_data->dma_addr;
> +
> +       status |= desc_data->len;
> +       if (flags)
> +               status |= flags;
> +       desc->status = status;
> +
> +       /* Flush previous modifications before ownership change. */
> +       dma_wmb();
> +       desc->status &= ~MTK_MAC_DESC_BIT_COWN;

You still do the read-modify-write on the word here, which is
expensive on uncached memory. You have read the value already,
so better use an assignment rather than &=, or (better)
READ_ONCE() and WRITE_ONCE() to prevent the compiler
from adding further accesses.


> +static void mtk_mac_lock(struct mtk_mac_priv *priv)
> +{
> +       spin_lock_bh(&priv->lock);
> +}
> +
> +static void mtk_mac_unlock(struct mtk_mac_priv *priv)
> +{
> +       spin_unlock_bh(&priv->lock);
> +}

I think open-coding the locks would make this more readable,
and let you use spin_lock() instead of spin_lock_bh() in
those functions that are already in softirq context.

> +static void mtk_mac_intr_enable_tx(struct mtk_mac_priv *priv)
> +{
> +       regmap_update_bits(priv->regs, MTK_MAC_REG_INT_MASK,
> +                          MTK_MAC_BIT_INT_STS_TNTC, 0);
> +}
> +static void mtk_mac_intr_enable_rx(struct mtk_mac_priv *priv)
> +{
> +       regmap_update_bits(priv->regs, MTK_MAC_REG_INT_MASK,
> +                          MTK_MAC_BIT_INT_STS_FNRC, 0);
> +}

These imply reading the irq mask register and then writing it again,
which is much more expensive than just writing it. It's also not
atomic since the regmap does not use a lock.

I don't think you actually need to enable/disable rx and tx separately,
but if you do, then writing to the Ack register as I suggested instead
of updating the mask would let you do this.

> +/* All processing for TX and RX happens in the napi poll callback. */
> +static irqreturn_t mtk_mac_handle_irq(int irq, void *data)
> +{
> +       struct mtk_mac_priv *priv;
> +       struct net_device *ndev;
> +       bool need_napi = false;
> +       unsigned int status;
> +
> +       ndev = data;
> +       priv = netdev_priv(ndev);
> +
> +       if (netif_running(ndev)) {
> +               status = mtk_mac_intr_read(priv);
> +
> +               if (status & MTK_MAC_BIT_INT_STS_TNTC) {
> +                       mtk_mac_intr_disable_tx(priv);
> +                       need_napi = true;
> +               }
> +
> +               if (status & MTK_MAC_BIT_INT_STS_FNRC) {
> +                       mtk_mac_intr_disable_rx(priv);
> +                       need_napi = true;
> +               }

I think you mixed up the rx and tx bits here: when you get
an rx interrupt, that one is already blocked until it gets
acked and you just need to disable tx until the end of the
poll function.

However, I suspect that the overhead of turning them off
is higher than what  you can save, and simply ignoring
the mask with

if (status & (MTK_MAC_BIT_INT_STS_FNRC | MTK_MAC_BIT_INT_STS_TNTC))
        napi_schedule(&priv->napi);

would be simpler and faster.

 +               /* One of the counters reached 0x8000000 - update stats and
> +                * reset all counters.
> +                */
> +               if (unlikely(status & MTK_MAC_REG_INT_STS_MIB_CNT_TH)) {
> +                       mtk_mac_intr_disable_stats(priv);
> +                       schedule_work(&priv->stats_work);
> +               }
> + befor
> +               mtk_mac_intr_ack_all(priv);

The ack here needs to be dropped, otherwise you can get further
interrupts before the bottom half has had a chance to run.

You might be lucky because you had already disabled the individual
bits earlier, but I don't think that was intentional here.

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
> +
> +       mtk_mac_ring_push_head_tx(ring, &desc_data);
> +
> +       netdev_sent_queue(ndev, skb->len);
> +
> +       if (mtk_mac_ring_full(ring))
> +               netif_stop_queue(ndev);
> +
> +       mtk_mac_unlock(priv);
> +
> +       mtk_mac_dma_resume_tx(priv);

mtk_mac_dma_resume_tx() is an expensive read-modify-write
on an mmio register, so it would make sense to defer it based
on netdev_xmit_more(). (I had missed this in the previous
review)

> +static void mtk_mac_tx_complete_all(struct mtk_mac_priv *priv)
> +{
> +       struct mtk_mac_ring *ring = &priv->tx_ring;
> +       struct net_device *ndev = priv->ndev;
> +       int ret, pkts_compl, bytes_compl;
> +       bool wake = false;
> +
> +       mtk_mac_lock(priv);
> +
> +       for (pkts_compl = 0, bytes_compl = 0;;
> +            pkts_compl++, bytes_compl += ret, wake = true) {
> +               if (!mtk_mac_ring_descs_available(ring))
> +                       break;
> +
> +               ret = mtk_mac_tx_complete_one(priv);
> +               if (ret < 0)
> +                       break;
> +       }
> +
> +       netdev_completed_queue(ndev, pkts_compl, bytes_compl);
> +
> +       if (wake && netif_queue_stopped(ndev))
> +               netif_wake_queue(ndev);
> +
> +       mtk_mac_intr_enable_tx(priv);

No need to ack the interrupt here if napi is still active. Just
ack both rx and tx when calling napi_complete().

Some drivers actually use the napi budget for both rx and tx:
if you have more than 'budget' completed tx frames, return
early from this function and skip the napi_complete even
when less than 'budget' rx frames have arrived.

This way you get more fairness between devices and
can run for longer with irqs disabled as long as either rx
or tx is busy.

         Arnd
