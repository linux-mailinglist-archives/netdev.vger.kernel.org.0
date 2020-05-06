Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1D21C69D1
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 09:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgEFHKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 03:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727832AbgEFHKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 03:10:05 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B78C061A10
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 00:10:03 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id w4so1064913ioc.6
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 00:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TNeZGBvQE65OD4RI/VJlF9TAoXRNVe2+IJUTG86DGbA=;
        b=WQsD3+apXpq3/3yaFrL3/0+eSLnGTDQTR0Fsp8/qK2Rthwbduv7jAJSEPLt4Z4Kevh
         NPCy2rzwD2NCLi8cWzq0DSsLTh0aoWwbMoRMOpvTno8FVluR5qx/lR7XFhsyAEV9sSHm
         c4VEg2dEhbt+Yk6QWE+yeBtAVjIv2B7YyuEttTHMLuDTailXpL5mtUQKNO9Y6OXVNZsO
         rY9KPUlOp9yTonJ3djuZnrAf68VmjVZc1wbWDHX43bgfMzTyteYwq7VthJBFsuribOf/
         ljdtuRUMLFbAroFkewRsGn2i4ldJtX0iI6wHQxUFNnYnSeRqYSkRSrPw6Yrupk0QHyVw
         EFmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TNeZGBvQE65OD4RI/VJlF9TAoXRNVe2+IJUTG86DGbA=;
        b=LX/LIto9ms2iMhTO+0p6KkigipXIDhN8rXuj3fAWkL1Nu6lZ9l9NOyawEyNHCTkN4K
         GT3aXQIT+TfwhqjWKYJ86ZRRi+HZCe8fqkGbF8RE1i26QF29V929qzLQowFI8NFMQhs9
         hdfL1wxBkBpyevyKQdCaH6acH88heE8Ci7PR3M3QQGB43+L+DEcDTov482nfIFr3puvc
         gqKNpTapLCoPaf9e94efxCjW391cjFtQi+DVWQ+/XncIKQAlGBnu5AaOlxoNlnv1ZAvR
         roadAICBRm0ffoFNmLSzl5D6dQpgX05/cWQOr/M9L8QvTl/h28IC6pGAHZg/ZZit1Uc9
         828A==
X-Gm-Message-State: AGi0PuaalIpntQA7DEZH3LvYh4+Ycis2kQg+bMLsxFo6YEh/0J0Jlo+b
        CnoQ1f3DS0xPk7feC2vQb/vSo6uUyG9SaTr5ywNEgw==
X-Google-Smtp-Source: APiQypK8JUTpUHWQidMAM1RM6r/RYgCmN3qiFqNGsyI2sRX+0s50wlApjk2j2yJQrSBljYxkxedUj9ER2mJ5DgL7aSU=
X-Received: by 2002:a6b:8bd2:: with SMTP id n201mr7183055iod.131.1588749002876;
 Wed, 06 May 2020 00:10:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200505140231.16600-1-brgl@bgdev.pl> <20200505140231.16600-7-brgl@bgdev.pl>
 <20200505110447.2404985c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200505110447.2404985c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Wed, 6 May 2020 09:09:52 +0200
Message-ID: <CAMRc=MfmuKd64YaqrkhGFThDZd0_tRecR5H0QLY0cDJWSM-VgQ@mail.gmail.com>
Subject: Re: [PATCH 06/11] net: ethernet: mtk-eth-mac: new driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

thanks for the review.

wt., 5 maj 2020 o 20:04 Jakub Kicinski <kuba@kernel.org> napisa=C5=82(a):
>
> > +/* Represents the actual structure of descriptors used by the MAC. We =
can
> > + * reuse the same structure for both TX and RX - the layout is the sam=
e, only
> > + * the flags differ slightly.
> > + */
> > +struct mtk_mac_ring_desc {
> > +     /* Contains both the status flags as well as packet length. */
> > +     u32 status;
> > +     u32 data_ptr;
> > +     u32 vtag;
> > +     u32 reserved;
> > +} __aligned(4) __packed;
>
> It will be aligned to 4, because the members are all 4B. And there is
> no possibility of holes. You can safely remove those attrs.
>

I noticed some other drivers whose descriptors are well aligned define
these attributes anyway so I assumed it's a convention. I'll drop them
in v2.

>
> > +     status =3D desc->status;
> > +
> > +     if (!(status & MTK_MAC_DESC_BIT_COWN))
> > +             return -1;
> > +
> > +     desc_data->len =3D status & MTK_MAC_DESC_MSK_LEN;
> > +     desc_data->flags =3D status & ~MTK_MAC_DESC_MSK_LEN;
> > +     desc_data->dma_addr =3D desc->data_ptr;
> > +     desc_data->skb =3D ring->skbs[ring->tail];
> > +
> > +     desc->data_ptr =3D 0;
> > +     desc->status =3D MTK_MAC_DESC_BIT_COWN;
> > +     if (status & MTK_MAC_DESC_BIT_EOR)
> > +             desc->status |=3D MTK_MAC_DESC_BIT_EOR;
> > +
> > +     dma_wmb();
>
> What is this separating?

I'll add comments to barriers in v2.

>
> > +/* All processing for TX and RX happens in the napi poll callback. */
> > +static irqreturn_t mtk_mac_handle_irq(int irq, void *data)
> > +{
> > +     struct mtk_mac_priv *priv;
> > +     struct net_device *ndev;
> > +     unsigned int status;
> > +
> > +     ndev =3D data;
> > +     priv =3D netdev_priv(ndev);
> > +
> > +     if (netif_running(ndev)) {
> > +             mtk_mac_intr_mask_all(priv);
> > +             status =3D mtk_mac_intr_read_and_clear(priv);
> > +
> > +             /* RX Complete */
> > +             if (status & MTK_MAC_BIT_INT_STS_FNRC)
> > +                     napi_schedule(&priv->napi);
> > +
> > +             /* TX Complete */
> > +             if (status & MTK_MAC_BIT_INT_STS_TNTC)
> > +                     schedule_work(&priv->tx_work);
> > +
> > +             /* One of the counter reached 0x8000000 */
> > +             if (status & MTK_MAC_REG_INT_STS_MIB_CNT_TH) {
> > +                     mtk_mac_update_stats(priv);
> > +                     mtk_mac_reset_counters(priv);
> > +             }
> > +
> > +             mtk_mac_intr_unmask_all(priv);
>
> Why do you unmask all IRQs here? The usual way to operate is to leave
> TX and RX IRQs masked until NAPI finishes.
>

I actually did it before as the leftover comment says above the
function. Then I thought this way we mask interrupt for a shorter
period of time. I can go back to the previous approach.

> > +     }
> > +
> > +     return IRQ_HANDLED;
> > +}
>
> > +static int mtk_mac_enable(struct net_device *ndev)
> > +{
> > +     /* Reset all counters */
> > +     mtk_mac_reset_counters(priv);
>
> This doesn't reset the counters to zero, right?
>

Yes, it does actually. I'll drop it in v2 - it's not necessary.

>
> > +static void mtk_mac_tx_work(struct work_struct *work)
> > +{
> > +     struct mtk_mac_priv *priv;
> > +     struct mtk_mac_ring *ring;
> > +     struct net_device *ndev;
> > +     bool wake =3D false;
> > +     int ret;
> > +
> > +     priv =3D container_of(work, struct mtk_mac_priv, tx_work);
> > +     ndev =3D mtk_mac_get_netdev(priv);
> > +     ring =3D &priv->tx_ring;
> > +
> > +     for (;;) {
> > +             mtk_mac_lock(priv);
> > +
> > +             if (!mtk_mac_ring_descs_available(ring)) {
> > +                     mtk_mac_unlock(priv);
> > +                     break;
> > +             }
> > +
> > +             ret =3D mtk_mac_tx_complete(priv);
> > +             mtk_mac_unlock(priv);
> > +             if (ret)
> > +                     break;
> > +
> > +             wake =3D true;
> > +     }
> > +
> > +     if (wake)
> > +             netif_wake_queue(ndev);
>
> This looks racy, if the TX path runs in parallel the queue may have
> already been filled up at the point you wake it up.
>
> > +}
>
> Why do you clean the TX ring from a work rather than from the NAPI
> context?
>

So this was unclear to me, that's why I went with a workqueue. The
budget argument in napi poll is for RX. Should I put some cap on the
number of TX descriptors processed in napi context?

>
> > +static int mtk_mac_receive_packet(struct mtk_mac_priv *priv)
> > +{
> > +     struct net_device *ndev =3D mtk_mac_get_netdev(priv);
> > +     struct mtk_mac_ring *ring =3D &priv->rx_ring;
> > +     struct device *dev =3D mtk_mac_get_dev(priv);
> > +     struct mtk_mac_ring_desc_data desc_data;
> > +     struct sk_buff *new_skb;
> > +     int ret;
> > +
> > +     mtk_mac_lock(priv);
> > +     ret =3D mtk_mac_ring_pop_tail(ring, &desc_data);
> > +     mtk_mac_unlock(priv);
> > +     if (ret)
> > +             return -1;
> > +
> > +     mtk_mac_dma_unmap_rx(priv, &desc_data);
> > +
> > +     if ((desc_data.flags & MTK_MAC_DESC_BIT_RX_CRCE) ||
> > +         (desc_data.flags & MTK_MAC_DESC_BIT_RX_OSIZE)) {
> > +             /* Error packet -> drop and reuse skb. */
> > +             new_skb =3D desc_data.skb;
> > +             goto map_skb;
> > +     }
> > +
> > +     new_skb =3D mtk_mac_alloc_skb(ndev);
> > +     if (!new_skb) {
> > +             netdev_err(ndev, "out of memory for skb\n");
>
> No need for printing, kernel will complain loudly about oom.
>
> > +             ndev->stats.rx_dropped++;
> > +             new_skb =3D desc_data.skb;
> > +             goto map_skb;
> > +     }
> > +
> > +     skb_put(desc_data.skb, desc_data.len);
> > +     desc_data.skb->ip_summed =3D CHECKSUM_NONE;
> > +     desc_data.skb->protocol =3D eth_type_trans(desc_data.skb, ndev);
> > +     desc_data.skb->dev =3D ndev;
> > +     netif_receive_skb(desc_data.skb);
> > +
> > +map_skb:
> > +     desc_data.dma_addr =3D mtk_mac_dma_map_rx(priv, new_skb);
> > +     if (dma_mapping_error(dev, desc_data.dma_addr)) {
> > +             dev_kfree_skb(new_skb);
> > +             netdev_err(ndev, "DMA mapping error of RX descriptor\n");
> > +             return -ENOMEM;
>
> In this case nothing will ever replenish the RX ring right? If we hit
> this condition 128 times the ring will be empty?
>

Indeed. What should I do if this fails though?

I'll address all other issues in v2.

Bart
