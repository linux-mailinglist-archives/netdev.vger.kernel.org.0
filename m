Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF607211D24
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 09:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgGBHin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 03:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgGBHin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 03:38:43 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF949C08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 00:38:42 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id k22so11568650oib.0
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 00:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gn0vhLgzAW9h7L9L8JymjzU2cfh1kNbx0gKDZNROMq0=;
        b=LVOkTki3Zrn4ohaIOTkHjzJZXTR1IU2EMDXQBsaHnBSnNLVskDndQ+lBpG6Y5qKa6F
         8vc9uJYvgA0nSBJwTUY166rQEgpqkrVQVwOe2GpoY6Y4PCKxNBELlsh0xzRCZW9SW/sS
         0A4Rhoyded3Eefp+VLA9XYQBxPoo5ayykvAue2zH9Rsl3nvvzyOhr1vxF9KLJZgbddGh
         ZYni+rhj/X5jC+RxMx5nzKweIqXkkgjoUkwREapgNu7uKeERbnBsjccMufI0GKOUhp4K
         O3JgmkKxN8Yy7+B1UESbVx9MRXpgLvSp/AtkjILKTgBLNhZDarKMMKuWN32ogiayWYqx
         QBMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gn0vhLgzAW9h7L9L8JymjzU2cfh1kNbx0gKDZNROMq0=;
        b=Z4DcmCgky32Rxv3IAcC/z71lau9NkR7QNQvyQ13SaP8C7KADBx97+tumQeMxwCbZo/
         FQFp5xtQHZp8KQETf7cymfqu/lSEe2CKpScG+N74JiPzf2lm/mWZ9A/iZN6Fh9Dok/hc
         Cfvgnp4pd/hYLQDzXDeJk7A2hJ9JNlGwV/fRu1kNZLokREsLBuFj8M2sb55elVebmN12
         BusxkMhY9J9By9pyoTQJJ7nMEFBc88FnvMNwpsMNq2cXC8okCkO6Vpbd52sUdEPzLdxV
         mnSk9tex3Y+wOwixes5Ypt4ts02KDD9xCcp7lTD9xLJewjuJY/bi5x6olwQGXMSjAmrk
         42Fg==
X-Gm-Message-State: AOAM532VDR+qNtUzjoOmA3BJRCbodPSNX9gSWJdqJVxkBdaeWkVLg6a5
        Yq4k1BUF1Tncqae+TX48RCRHW9k+wXPukQk2Ryk=
X-Google-Smtp-Source: ABdhPJyp0DXFZPVNIkFU3GEbmz0iEJwFqlsofLZlAmPwy35wSWOfQ5lPc7aXsJuyCoC2qGcDqhCtEvvX7jph6RJpo3E=
X-Received: by 2002:aca:b883:: with SMTP id i125mr23306955oif.65.1593675522174;
 Thu, 02 Jul 2020 00:38:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAMeyCbjiVXFkzA5ZyJ5b3N4fotWkzKHVp3J=nT1yWs1v8dmRXA@mail.gmail.com>
 <AM6PR0402MB3607E9BD414FF850D577F76EFF6D0@AM6PR0402MB3607.eurprd04.prod.outlook.com>
In-Reply-To: <AM6PR0402MB3607E9BD414FF850D577F76EFF6D0@AM6PR0402MB3607.eurprd04.prod.outlook.com>
From:   Kegl Rohit <keglrohit@gmail.com>
Date:   Thu, 2 Jul 2020 09:38:31 +0200
Message-ID: <CAMeyCbicX_8Kc_E5sanUMNtToLpj9BkcV+RR6h2FoNoxxcKJog@mail.gmail.com>
Subject: Re: [EXT] net: ethernet: freescale: fec: copybreak handling
 throughput, dma_sync_* optimisations allowed?
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 6:18 AM Andy Duan <fugang.duan@nxp.com> wrote:
>
> From: Kegl Rohit <keglrohit@gmail.com> Sent: Thursday, July 2, 2020 2:45 AM
> > fec_enet_copybreak(u32 length, ...) uses
> >
> > dma_sync_single_for_cpu(&fep->pdev->dev,
> > fec32_to_cpu(bdp->cbd_bufaddr), FEC_ENET_RX_FRSIZE - fep->rx_align,
> > DMA_FROM_DEVICE); if (!swap)
> >    memcpy(new_skb->data, (*skb)->data, length);
> >
> > to sync the descriptor data buffer and memcpy the data to the new skb
> > without calling dma_unmap().
> dma_sync_* is enough, no need to call dma_unmap and dma_map_* that
> will heavy load.
>
> > Later in fec_enet_rx_queue() the dma descriptor buffer is synced again in the
> > opposite direction.
> >
> > if (is_copybreak) {
> >   dma_sync_single_for_device(&fep->pdev->dev,
> > fec32_to_cpu(bdp->cbd_bufaddr),  FEC_ENET_RX_FRSIZE - fep->rx_align,
> > DMA_FROM_DEVICE); }
> >
> dma_sync_single_for_cpu(DMA_FROM_DEVICE)
>         __dma_inv_area  #invalidate the area
>
> dma_sync_single_for_device(DMA_FROM_DEVICE)
>         __dma_inv_area  #invalidate the area
>         __dma_clean_area #clean the area
>
> dma_sync_single_for_cpu() and dma_sync_single_for_device() are used in pairs,
> there have no problem for usage.
>
> > Now the two main questions:
> > 1. Is it necessary to call dma_sync_single_for_cpu for the whole buffer size
> > (FEC_ENET_RX_FRSIZE - fep->rx_align), wouldn't syncing the real packet
> > length which is accessed by memcpy be enough?
> > Like so: dma_sync_single_for_cpu(&fep->pdev->dev,
> > fec32_to_cpu(bdp->cbd_bufaddr), (u32) length, DMA_FROM_DEVICE);
>
> In general usage, you don't know the next frame size, and cannot ensure
> the buffer is dirty or not, so invalidate the whole area for next frame.
>
> On some arm64 A53, the dcache invalidate on A53 is flush + invalidate,
> and prefetch may fetch the area, that may causes dirty data flushed back
> to the dma memory if the area has dirty data.
>
> > 2. Is dma_sync_single_for_device even necessary? There is no data passed
> > back to the device because the skb descriptor buffer is not modified and the
> > fec peripheral does not need any valid data.
> > The example in
> > https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.
> > kernel.org%2Fdoc%2FDocumentation%2FDMA-API-HOWTO.txt&amp;data=0
> > 2%7C01%7Cfugang.duan%40nxp.com%7C7fb56778153a4139214808d81deed
> > a6d%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C1%7C637292258992
> > 313637&amp;sdata=4Nv4J7APzmNTv7Dv39tmwpJhFeZ8bNY1eaoAQnx4FdM
> > %3D&amp;reserved=0
> > states:
> >  /* CPU should not write to
> >   * DMA_FROM_DEVICE-mapped area,
> >   * so dma_sync_single_for_device() is
> >   * not needed here. It would be required
> >   * for DMA_BIDIRECTIONAL mapping if
> >   * the memory was modified.
> >  */
> That should ensure the whole area is not dirty.

dma_sync_single_for_cpu() and dma_sync_single_for_device() can or must
be used in pairs?
So in this case it is really necessary to sync back the skb data
buffer via dma_sync_single_for_device? Even when the CPU does not
change any bytes in the skb data buffer / readonly like in this case.
And there is no DMA_BIDIRECTIONAL mapping.

I thought copybreak it is not about the next frame size. It is about
the current frame. And the actual length is known via the size field
in the finished DMA descriptor.
Or do you mean that the next received frame could be no copybreak frame.
1. Rx copybreakable frame with sizeX < copybreak
2. copybreak dma_sync_single_for_cpu(dmabuffer, sizeX)
3. copybreak alloc new_skb, memcpy(new_skb, dmabuffer, sizeX)
4. copybreak dma_sync_single_for_device(dmabuffer, sizeX)
5. Rx non copybreakable frame with sizeY >= copybreak
4. dma_unmap_single(dmabuffer, FEC_ENET_RX_FRSIZE - fep->rx_align) is
called and can cause data corruption because not all bytes were marked
dirty even if nobody DMA & CPU touched them?

> > I am new to the DMA API on ARM. Are these changes regarding cache
> > flushing,... allowed? These would increase the copybreak throughput by
> > reducing CPU load.
>
> To avoid FIFO overrun, it requires to ensure PHY pause frame is enabled.

As the errata states this is also not always true, because the first
xoff could arrive too late. Pause frames/flow control is not really
common and could cause troubles with other random network components
acting different or not supporting pause frames correctly. For example
the driver itself does enable pause frames for Gigabit by default. But
we have no Gigabit Phy so no FEC_QUIRK_HAS_GBIT and therefore pause
frames are not supported by the driver as of now.


It looks like copybreak is implemented similar to e1000_main.c
e1000_copybreak().
There is only the real/needed packet length (length =
le16_to_cpu(rx_desc->length)) is synced via dma_sync_single_for_cpu
and no dma_sync_single_for_device.

Here is a diff with the previous changes assuming that
dma_sync_single_for_device must be used to avoid any cache flush backs
even when no data was changed.

diff --git a/drivers/net/ethernet/freescale/fec_main.c
b/drivers/net/ethernet/freescale/fec_main.c
index 2d0d313ee..464783c15 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1387,9 +1387,9 @@ static bool fec_enet_copybreak(struct net_device
*ndev, struct sk_buff **skb,
                return false;

        dma_sync_single_for_cpu(&fep->pdev->dev,
                                fec32_to_cpu(bdp->cbd_bufaddr),
-                               FEC_ENET_RX_FRSIZE - fep->rx_align,
+                               length,
                                DMA_FROM_DEVICE);
        if (!swap)
                memcpy(new_skb->data, (*skb)->data, length);
        else
@@ -1413,8 +1413,9 @@ fec_enet_rx_queue(struct net_device *ndev, int
budget, u16 queue_id)
        unsigned short status;
        struct  sk_buff *skb_new = NULL;
        struct  sk_buff *skb;
        ushort  pkt_len;
+       ushort  pkt_len_nofcs;
        __u8 *data;
        int     pkt_received = 0;
        struct  bufdesc_ex *ebdp = NULL;
        bool    vlan_packet_rcvd = false;
@@ -1479,9 +1480,10 @@ fec_enet_rx_queue(struct net_device *ndev, int
budget, u16 queue_id)
                /* The packet length includes FCS, but we don't want to
                 * include that when passing upstream as it messes up
                 * bridging applications.
                 */
-               is_copybreak = fec_enet_copybreak(ndev, &skb, bdp, pkt_len - 4,
+               pkt_len_nofcs = pkt_len - 4;
+               is_copybreak = fec_enet_copybreak(ndev, &skb, bdp,
pkt_len_nofcs,
                                                  need_swap);
                if (!is_copybreak) {
                        skb_new = netdev_alloc_skb(ndev, FEC_ENET_RX_FRSIZE);
                        if (unlikely(!skb_new)) {
@@ -1554,9 +1556,9 @@ fec_enet_rx_queue(struct net_device *ndev, int
budget, u16 queue_id)

                if (is_copybreak) {
                        dma_sync_single_for_device(&fep->pdev->dev,

fec32_to_cpu(bdp->cbd_bufaddr),
-                                                  FEC_ENET_RX_FRSIZE
- fep->rx_align,
+                                                  pkt_len_nofcs,
                                                   DMA_FROM_DEVICE);
                } else {
                        rxq->rx_skbuff[index] = skb_new;
                        fec_enet_new_rxbdp(ndev, bdp, skb_new);
