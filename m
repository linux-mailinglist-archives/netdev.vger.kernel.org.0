Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 891D483296
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 15:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732103AbfHFNUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 09:20:00 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:33454 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731664AbfHFNT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 09:19:59 -0400
Received: by mail-ot1-f68.google.com with SMTP id q20so92245961otl.0;
        Tue, 06 Aug 2019 06:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QvfWUluNiZ47vRKT4p1jVMCt91fm2+RbdyP2wkGHV/0=;
        b=dWEDqGy3mRJn7Rqw5/KiJMZXcuFDrlBeP0ExW92HOWFXfjZcVh+kEY57deRyXgc8Ln
         g/Yovl1YYiOdVdnqb5LhqlJoqqfQRmjwbc/raIzJAIwnYiMgi5MaJr3E4xLgtcHSwVzl
         K0pMJLDSOBjUIbs4aKU0aQBlY8bCDPQW7whBYDnY7sLZ4B4F4WO/U+ggpRte5lEG/LMw
         RdCpt4HuE1yVB/sMSDKTv7KLQ2IcoHli6nNSrZSMjyX0j6EUNRqBUlk/cNk3JWxuDtuG
         HUyHkXtNQe9N4531JI604Gz7n5g6DLbOatRWMoOP8/MaTv+eTP5Pio5LV/9K1lm+HR3l
         EGlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QvfWUluNiZ47vRKT4p1jVMCt91fm2+RbdyP2wkGHV/0=;
        b=XscMtGooRhD3vMDiYd3+Dk3OShofMTdGCn+HgprU7+AF1XHcabbX3A8WapdigagmTW
         fvmS5SoRQHx6MHnQUn+y/wTsmyQj69cfF29DawAPN4S2drMVQp5rmLaXIaPfA23uw5r2
         RIBtQd51hLiIkx9kTC3+4disGGJ9orz13VabWzzWvizbMc5VbnLEdH0QNxWNQRhL3ncD
         HEShcEEzfshkoYeDruxLenCoIisaGm6XkqKPPvmHVugdD48vfht13N+2/6/r8uXBHCed
         AmXprszosCKRiddNDdazkXZnX6V9vs4SwXitqBF+XJPhCTgQb69o3mXzW5fkLonIpDid
         sqeA==
X-Gm-Message-State: APjAAAUX44J8t37aMT+XoJJApsPfsCcBc8faAaOWiicTPQHOU5nQg/PI
        r2AmRrepcaniYp9L4YKw3PXRV0f4e41oil+wHA==
X-Google-Smtp-Source: APXvYqweVzdP6b2WXz9u/D89smWZcHjjSjG+MoXEe3BFHr5j8/BvrQFvUfQAbKfj4FNcFBqe5RbDJ9AteibNLMuHeYc=
X-Received: by 2002:a5d:9c46:: with SMTP id 6mr3771366iof.6.1565097598297;
 Tue, 06 Aug 2019 06:19:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190801072611.27935-1-avifishman70@gmail.com>
 <20190801072611.27935-3-avifishman70@gmail.com> <CA+FuTSd89gJBX-zaZTzgNxpqtR_MvVfMf=6hdRe5+1MPRszw8g@mail.gmail.com>
In-Reply-To: <CA+FuTSd89gJBX-zaZTzgNxpqtR_MvVfMf=6hdRe5+1MPRszw8g@mail.gmail.com>
From:   Avi Fishman <avifishman70@gmail.com>
Date:   Tue, 6 Aug 2019 16:19:12 +0300
Message-ID: <CAKKbWA6hjxupFQNnTUOfeKLXd2wtZ9+g7uUpe34CeErn5kBAaA@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] net: npcm: add NPCM7xx EMC 10/100 Ethernet driver
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Patrick Venture <venture@google.com>,
        Nancy Yuen <yuenn@google.com>,
        Benjamin Fair <benjaminfair@google.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Tali Perry <tali.perry1@gmail.com>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        Network Development <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the input Willem,

Before I will submit a new version please help me with some questions:

On Thu, Aug 1, 2019 at 8:26 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Thu, Aug 1, 2019 at 3:28 AM Avi Fishman <avifishman70@gmail.com> wrote:
> >
> > EMC Ethernet Media Access Controller supports 10/100 Mbps and
> > RMII.
> > This driver has been working on Nuvoton BMC NPCM7xx.
> >
> > Signed-off-by: Avi Fishman <avifishman70@gmail.com>
>
>
>
> > +/* global setting for driver */
> > +#define RX_QUEUE_LEN   128
> > +#define TX_QUEUE_LEN   64
> > +#define MAX_RBUFF_SZ   0x600
> > +#define MAX_TBUFF_SZ   0x600
> > +#define TX_TIMEOUT     50
> > +#define DELAY          1000
> > +#define CAM0           0x0
> > +#define RX_POLL_SIZE    16
> > +
> > +#ifdef CONFIG_VLAN_8021Q
> > +#define IS_VLAN 1
> > +#else
> > +#define IS_VLAN 0
> > +#endif
> > +
> > +#define MAX_PACKET_SIZE           (1514 + (IS_VLAN * 4))
>
> 1514 -> ETH_FRAME_LEN
>
> 4 -> VLAN_HLEN

OK

>
> Does this device support stacked VLAN?
I am not familiar with stacked VLAN.
Our HW for sure there is no support. can the SW stack handle it for me?
Does it mean that  the packets can be larger?

>
> Is this really the device maximum?

The device can support upto 64KB, but of course I will not allocate
for each RX data such a big buffer.
Can I know what is the maximum value the network stack may request? I
saw many driver allocating 1536 for each packet.

>
> > +#define MAX_PACKET_SIZE_W_CRC     (MAX_PACKET_SIZE + 4) /* 1518 */
>
> 4 -> ETH_FCS_LEN

OK

>
> > +#if defined CONFIG_NPCM7XX_EMC_ETH_DEBUG || defined CONFIG_DEBUG_FS
> > +#define REG_PRINT(reg_name) {t = scnprintf(next, size, "%-10s = %08X\n", \
> > +       #reg_name, readl(ether->reg + (reg_name))); size -= t;  next += t; }
> > +#define DUMP_PRINT(f, x...) {t = scnprintf(next, size, f, ## x); size -= t; \
> > +       next += t; }
> > +
> > +static int npcm7xx_info_dump(char *buf, int count, struct net_device *netdev)
> > +{
> > +       struct npcm7xx_ether *ether = netdev_priv(netdev);
> > +       struct npcm7xx_txbd *txbd;
> > +       struct npcm7xx_rxbd *rxbd;
> > +       unsigned long flags;
> > +       unsigned int i, cur, txd_offset, rxd_offset;
> > +       char *next = buf;
> > +       unsigned int size = count;
> > +       int t;
> > +       int is_locked = spin_is_locked(&ether->lock);
> > +
> > +       if (!is_locked)
> > +               spin_lock_irqsave(&ether->lock, flags);
> > +
> > +       /* ------basic driver information ---- */
> > +       DUMP_PRINT("NPCM7XX EMC %s driver version: %s\n", netdev->name,
> > +                  DRV_MODULE_VERSION);
> > +
> > +       REG_PRINT(REG_CAMCMR);
> > +       REG_PRINT(REG_CAMEN);
> > +       REG_PRINT(REG_CAMM_BASE);
> > +       REG_PRINT(REG_CAML_BASE);
> > +       REG_PRINT(REG_TXDLSA);
> > +       REG_PRINT(REG_RXDLSA);
> > +       REG_PRINT(REG_MCMDR);
> > +       REG_PRINT(REG_MIID);
> > +       REG_PRINT(REG_MIIDA);
> > +       REG_PRINT(REG_FFTCR);
> > +       REG_PRINT(REG_TSDR);
> > +       REG_PRINT(REG_RSDR);
> > +       REG_PRINT(REG_DMARFC);
> > +       REG_PRINT(REG_MIEN);
> > +       REG_PRINT(REG_MISTA);
> > +       REG_PRINT(REG_MGSTA);
> > +       REG_PRINT(REG_MPCNT);
> > +       writel(0x7FFF, (ether->reg + REG_MPCNT));
> > +       REG_PRINT(REG_MRPC);
> > +       REG_PRINT(REG_MRPCC);
> > +       REG_PRINT(REG_MREPC);
> > +       REG_PRINT(REG_DMARFS);
> > +       REG_PRINT(REG_CTXDSA);
> > +       REG_PRINT(REG_CTXBSA);
> > +       REG_PRINT(REG_CRXDSA);
> > +       REG_PRINT(REG_CRXBSA);
> > +       REG_PRINT(REG_RXFSM);
> > +       REG_PRINT(REG_TXFSM);
> > +       REG_PRINT(REG_FSM0);
> > +       REG_PRINT(REG_FSM1);
> > +       REG_PRINT(REG_DCR);
> > +       REG_PRINT(REG_DMMIR);
> > +       REG_PRINT(REG_BISTR);
> > +       DUMP_PRINT("\n");
> > +
> > +       DUMP_PRINT("netif_queue %s\n\n", netif_queue_stopped(netdev) ?
> > +                                       "Stopped" : "Running");
> > +       if (ether->rdesc)
> > +               DUMP_PRINT("napi is %s\n\n", test_bit(NAPI_STATE_SCHED,
> > +                                                     &ether->napi.state) ?
> > +                                                       "scheduled" :
> > +                                                       "not scheduled");
> > +
> > +       txd_offset = (readl((ether->reg + REG_CTXDSA)) -
> > +                     readl((ether->reg + REG_TXDLSA))) /
> > +               sizeof(struct npcm7xx_txbd);
> > +       DUMP_PRINT("TXD offset    %6d\n", txd_offset);
> > +       DUMP_PRINT("cur_tx        %6d\n", ether->cur_tx);
> > +       DUMP_PRINT("finish_tx     %6d\n", ether->finish_tx);
> > +       DUMP_PRINT("pending_tx    %6d\n", ether->pending_tx);
> > +       /* debug counters */
> > +       DUMP_PRINT("tx_tdu        %6d\n", ether->tx_tdu);
> > +       ether->tx_tdu = 0;
> > +       DUMP_PRINT("tx_tdu_i      %6d\n", ether->tx_tdu_i);
> > +       ether->tx_tdu_i = 0;
> > +       DUMP_PRINT("tx_cp_i       %6d\n", ether->tx_cp_i);
> > +        ether->tx_cp_i = 0;
> > +       DUMP_PRINT("tx_int_count  %6d\n", ether->tx_int_count);
> > +       ether->tx_int_count = 0;
> > +       DUMP_PRINT("count_xmit tx %6d\n", ether->count_xmit);
> > +       ether->count_xmit = 0;
> > +       DUMP_PRINT("count_finish  %6d\n", ether->count_finish);
> > +       ether->count_finish = 0;
> > +       DUMP_PRINT("\n");
> > +
> > +       rxd_offset = (readl((ether->reg + REG_CRXDSA)) -
> > +                     readl((ether->reg + REG_RXDLSA)))
> > +               / sizeof(struct npcm7xx_txbd);
> > +       DUMP_PRINT("RXD offset    %6d\n", rxd_offset);
> > +       DUMP_PRINT("cur_rx        %6d\n", ether->cur_rx);
> > +       DUMP_PRINT("rx_err        %6d\n", ether->rx_err);
> > +       ether->rx_err = 0;
> > +       DUMP_PRINT("rx_berr       %6d\n", ether->rx_berr);
> > +       ether->rx_berr = 0;
> > +       DUMP_PRINT("rx_stuck      %6d\n", ether->rx_stuck);
> > +       ether->rx_stuck = 0;
> > +       DUMP_PRINT("rdu           %6d\n", ether->rdu);
> > +       ether->rdu = 0;
> > +       DUMP_PRINT("rxov rx       %6d\n", ether->rxov);
> > +       ether->rxov = 0;
> > +       /* debug counters */
> > +       DUMP_PRINT("rx_int_count  %6d\n", ether->rx_int_count);
> > +       ether->rx_int_count = 0;
> > +       DUMP_PRINT("rx_err_count  %6d\n", ether->rx_err_count);
> > +       ether->rx_err_count = 0;
>
> Basic counters like tx_packets and rx_errors are probably better
> exported regardless of debug level as net_device_stats. And then don't
> need to be copied in debug output.

They are also exported there, see below ether->stats.tx_packets++; and
ether->stats.rx_errors++;
those are different counters for debug since we had HW issues that we
needed to workaround and might need them for future use.
Currently the driver is stable on millions of parts in the field.

>
> Less standard counters like tx interrupt count are probably better
> candidates for ethtool -S.

I don't have support for ethtool.
is it a must? it is quite some work and this driver is already in the
field for quite some years.

>
> > +#ifdef CONFIG_NPCM7XX_EMC_ETH_DEBUG
> > +static void npcm7xx_info_print(struct net_device *netdev)
> > +{
> > +       char *emc_dump_buf;
> > +       int count;
> > +       struct npcm7xx_ether *ether;
> > +       struct platform_device *pdev;
> > +       char c;
> > +       char *tmp_buf;
> > +       const size_t print_size = 5 * PAGE_SIZE;

I will change print_size to 0x5000 since PAGE_SIZE is not a fixed
value on all arch.

> > +
> > +       ether = netdev_priv(netdev);
> > +       pdev = ether->pdev;
> > +
> > +       emc_dump_buf = kmalloc(print_size, GFP_KERNEL);
> > +       if (!emc_dump_buf)
> > +               return;
> > +
> > +       tmp_buf = emc_dump_buf;
> > +       count = ether->stats.rx_errors++;(emc_dump_buf, print_size, netdev);
> > +       while (count > 512) {
> > +               c = tmp_buf[512];
> > +               tmp_buf[512] = 0;
> > +               dev_info(&pdev->dev, "%s", tmp_buf);
> > +               tmp_buf += 512;
> > +               tmp_buf[0] = c;
> > +               count -= 512;
>
> Missing closing parenthesis.

WOW! good catch, before submitting I made few change due to
checkpatch.pl and didn't compile with CONFIG_NPCM7XX_EMC_ETH_DEBUG

>
> Also, why this buffering to printk?

I prepare the buffer in advance for real-time reasons because of the
lock in order to get a correct snapshot of the registers.
The buffer is big and I saw that printk has limited length so I split it.

>
> > +static void npcm7xx_write_cam(struct net_device *netdev,
> > +                             unsigned int x, unsigned char *pval)
> > +{
> > +       struct npcm7xx_ether *ether = netdev_priv(netdev);
> > +       __le32 msw, lsw;
> > +
> > +       msw = (pval[0] << 24) | (pval[1] << 16) | (pval[2] << 8) | pval[3];
> > +
> > +       lsw = (pval[4] << 24) | (pval[5] << 16);
>
> Does __le32 plus this explicit shifting define host endianness? Better
> to keep independent?

OK

>
> > +
> > +       writel(lsw, (ether->reg + REG_CAML_BASE) + x * CAM_ENTRY_SIZE);
> > +       writel(msw, (ether->reg + REG_CAMM_BASE) + x * CAM_ENTRY_SIZE);
> > +       dev_dbg(&ether->pdev->dev,
> > +               "REG_CAML_BASE = 0x%08X REG_CAMM_BASE = 0x%08X", lsw, msw);
> > +}
> > +
> > +static struct sk_buff *get_new_skb(struct net_device *netdev, u32 i)
> > +{
> > +       __le32 buffer;
> > +       struct npcm7xx_ether *ether = netdev_priv(netdev);
> > +       struct sk_buff *skb = netdev_alloc_skb(netdev,
> > +               roundup(MAX_PACKET_SIZE_W_CRC, 4));
> > +
> > +       if (unlikely(!skb)) {
> > +               if (net_ratelimit())
> > +                       netdev_warn(netdev, "failed to allocate rx skb\n");
>
> can use net_warn_ratelimited (here and elsewhere)

should I replace every netdev_warn/err/info with net_warn/err/inf_ratelimited?
I saw in drivers that are using net_warn_ratelimited, that many time
uses also netdev_warn/err/info

>
> > +               buffer = ether->rx_scratch_dma;
> > +       } else {
> > +               /* Do not unmark the following skb_reserve() Receive Buffer
> > +                * Starting Address must be aligned to 4 bytes and the following
> > +                * line if unmarked will make it align to 2 and this likely will
> > +                * hult the RX and crash the linux
>
> halt?

will fix typo.

>
> > +                * skb_reserve(skb, NET_IP_ALIGN);
> > +                */
> > +               skb->dev = netdev;
> > +               buffer = dma_map_single(&netdev->dev,
> > +                                       skb->data,
> > +                                       roundup(MAX_PACKET_SIZE_W_CRC, 4),
> > +                                       DMA_FROM_DEVICE);
> > +               if (unlikely(dma_mapping_error(&netdev->dev, buffer))) {
> > +                       if (net_ratelimit())
> > +                               netdev_err(netdev, "failed to map rx page\n");
> > +                       dev_kfree_skb_any(skb);
> > +                       buffer = ether->rx_scratch_dma;
> > +                       skb = NULL;
> > +               }
> > +       }
> > +       ether->rx_skb[i] = skb;
> > +       ether->rdesc[i].buffer = buffer;
> > +
> > +       return skb;
> > +}
> > +
>
> > +static int npcm7xx_ether_close(struct net_device *netdev)
> > +{
> > +       struct npcm7xx_ether *ether = netdev_priv(netdev);
> > +
> > +       npcm7xx_return_default_idle(netdev);
> > +
> > +       if (ether->phy_dev)
> > +               phy_stop(ether->phy_dev);
> > +       else if (ether->use_ncsi)
> > +               ncsi_stop_dev(ether->ncsidev);
> > +
> > +       msleep(20);
> > +
> > +       free_irq(ether->txirq, netdev);
> > +       free_irq(ether->rxirq, netdev);
> > +
> > +       netif_stop_queue(netdev);
> > +       napi_disable(&ether->napi);
>
> Cleanup state in reverse of allocation.

OK

>
> > +static int npcm7xx_ether_start_xmit(struct sk_buff *skb, struct net_device *netdev)
> > +{
> > +       struct npcm7xx_ether *ether = netdev_priv(netdev);
> > +       struct npcm7xx_txbd *txbd;
> > +       unsigned long flags;
> > +
> > +       ether->count_xmit++;
> > +
> > +       /* Insert new buffer */
> > +       txbd = (ether->tdesc + ether->cur_tx);
> > +       txbd->buffer = dma_map_single(&netdev->dev, skb->data, skb->len,
> > +                                     DMA_TO_DEVICE);
> > +       ether->tx_skb[ether->cur_tx]  = skb;
> > +       if (skb->len > MAX_PACKET_SIZE)
> > +               dev_err(&ether->pdev->dev,
> > +                       "skb->len (= %d) > MAX_PACKET_SIZE (= %d)\n",
> > +                       skb->len, MAX_PACKET_SIZE);
>
> > +       txbd->sl = skb->len > MAX_PACKET_SIZE ? MAX_PACKET_SIZE : skb->len;
>
> Check for errors before mapping to device, and drop packet? Probably
> don't want to output truncated packets.
>
> Also rate limit such messages.

OK

>
> > +       dma_wmb();
> > +
> > +       txbd->mode = TX_OWN_DMA | PADDINGMODE | CRCMODE;
> > +
> > +       /* make sure that data is in memory before we trigger TX */
> > +       wmb();
> > +
> > +       /* trigger TX */
> > +       writel(ENSTART, (ether->reg + REG_TSDR));
> > +
> > +       if (++ether->cur_tx >= TX_QUEUE_LEN)
> > +               ether->cur_tx = 0;
> > +
> > +       spin_lock_irqsave(&ether->lock, flags);
> > +       ether->pending_tx++;
> > +
> > +       /* sometimes we miss the tx interrupt due to HW issue, so NAPI will not
> > +        * clean the pending tx, so we clean it also here
> > +        */
> > +       npcm7xx_clean_tx(netdev, true);
> > +
> > +       if (ether->pending_tx >= TX_QUEUE_LEN - 1) {
> > +               __le32 reg_mien;
> > +               unsigned int index_to_wake = ether->cur_tx +
> > +                       ((TX_QUEUE_LEN * 3) / 4);
> > +
> > +               if (index_to_wake >= TX_QUEUE_LEN)
> > +                       index_to_wake -= TX_QUEUE_LEN;
> > +
> > +               txbd = (ether->tdesc + index_to_wake);
> > +               txbd->mode = TX_OWN_DMA | PADDINGMODE | CRCMODE | MACTXINTEN;
> > +
> > +               /* make sure that data is in memory before we trigger TX */
> > +               wmb();
> > +
> > +               /* Clear TDU interrupt */
> > +               writel(MISTA_TDU, (ether->reg + REG_MISTA));
> > +
> > +               /* due to HW issue somtimes, we miss the TX interrupt we just
>
> somtimes -> sometimes

OK

>
> > +                * set (MACTXINTEN), so we also set TDU for Transmit
> > +                * Descriptor Unavailable interrupt
> > +                */
> > +               reg_mien = readl((ether->reg + REG_MIEN));
> > +               if (reg_mien != 0)
> > +                       /* Enable TDU interrupt */
> > +                       writel(reg_mien | ENTDU, (ether->reg + REG_MIEN));
> > +
> > +               ether->tx_tdu++;
> > +               netif_stop_queue(netdev);
> > +       }
> > +
> > +       spin_unlock_irqrestore(&ether->lock, flags);
> > +
> > +       return 0;
> > +}
> > +
> > +static irqreturn_t npcm7xx_tx_interrupt(int irq, void *dev_id)
> > +{
> > +       struct npcm7xx_ether *ether;
> > +       struct platform_device *pdev;
> > +       struct net_device *netdev;
> > +       __le32 status;
> > +       unsigned long flags;
> > +
> > +       netdev = dev_id;
> > +       ether = netdev_priv(netdev);
> > +       pdev = ether->pdev;
> > +
> > +       npcm7xx_get_and_clear_int(netdev, &status, 0xFFFF0000);
> > +
> > +       ether->tx_int_count++;
> > +
> > +       if (status & MISTA_EXDEF)
> > +               dev_err(&pdev->dev, "emc defer exceed interrupt status=0x%08X\n"
> > +                       , status);
> > +       else if (status & MISTA_TXBERR) {
> > +               dev_err(&pdev->dev, "emc bus error interrupt status=0x%08X\n",
> > +                       status);
> > +#ifdef CONFIG_NPCM7XX_EMC_ETH_DEBUG
> > +               npcm7xx_info_print(netdev);
> > +#endif
> > +               spin_lock_irqsave(&ether->lock, flags);
>
> irqsave in hard interrupt context?

I need to protect my REG_MIEN register that is changed in other places.
I think that spin_lock_irqsave() is relevant when working in SMP,
since other CPU may still be running.
Isn't it?

>
> > +               writel(0, (ether->reg + REG_MIEN)); /* disable any interrupt */
> > +               spin_unlock_irqrestore(&ether->lock, flags);
> > +               ether->need_reset = 1;
> > +       } else if (status & ~(MISTA_TXINTR | MISTA_TXCP | MISTA_TDU))
> > +               dev_err(&pdev->dev, "emc other error interrupt status=0x%08X\n",
> > +                       status);
> > +
> > +    /* if we got MISTA_TXCP | MISTA_TDU remove those interrupt and call napi */
>
> The goal of napi is to keep interrupts disabled until napi completes.

We have a HW issue that because of it I still enabled TX complete interrupt,
I will see if I can disable all interrupts and only leave the error interrupts

>
> > +       if (status & (MISTA_TXCP | MISTA_TDU) &
> > +           readl((ether->reg + REG_MIEN))) {
> > +               __le32 reg_mien;
> > +
> > +               spin_lock_irqsave(&ether->lock, flags);
> > +               reg_mien = readl((ether->reg + REG_MIEN));
> > +               if (reg_mien & ENTDU)
> > +                       /* Disable TDU interrupt */
> > +                       writel(reg_mien & (~ENTDU), (ether->reg + REG_MIEN));
> > +
> > +               spin_unlock_irqrestore(&ether->lock, flags);
> > +
> > +               if (status & MISTA_TXCP)
> > +                       ether->tx_cp_i++;
> > +               if (status & MISTA_TDU)
> > +                       ether->tx_tdu_i++;
> > +       } else {
> > +               dev_dbg(&pdev->dev, "status=0x%08X\n", status);
> > +       }
> > +
> > +       napi_schedule(&ether->napi);
> > +
> > +       return IRQ_HANDLED;
> > +}
> > +
> > +static irqreturn_t npcm7xx_rx_interrupt(int irq, void *dev_id)
> > +{
> > +       struct net_device *netdev = (struct net_device *)dev_id;
> > +       struct npcm7xx_ether *ether = netdev_priv(netdev);
> > +       struct platform_device *pdev = ether->pdev;
> > +       __le32 status;
> > +       unsigned long flags;
> > +       unsigned int any_err = 0;
> > +       __le32 rxfsm;
> > +
> > +       npcm7xx_get_and_clear_int(netdev, &status, 0xFFFF);
>
> Same here

in non error case I do leave only the error interrupts and schedule napi.

>
> > +static int npcm7xx_poll(struct napi_struct *napi, int budget)
> > +{
> > +       struct npcm7xx_ether *ether =
> > +               container_of(napi, struct npcm7xx_ether, napi);
> > +       struct npcm7xx_rxbd *rxbd;
> > +       struct net_device *netdev = ether->netdev;
> > +       struct platform_device *pdev = ether->pdev;
> > +       struct sk_buff *s;
> > +       unsigned int length;
> > +       __le32 status;
> > +       unsigned long flags;
> > +       int rx_cnt = 0;
> > +       int complete = 0;
> > +       unsigned int rx_offset = (readl((ether->reg + REG_CRXDSA)) -
> > +                                 ether->start_rx_ptr) /
> > +                               sizeof(struct npcm7xx_txbd);
> > +       unsigned int local_count = (rx_offset >= ether->cur_rx) ?
> > +               rx_offset - ether->cur_rx : rx_offset +
> > +               RX_QUEUE_LEN - ether->cur_rx;
> > +
> > +       if (local_count > ether->max_waiting_rx)
> > +               ether->max_waiting_rx = local_count;
> > +
> > +       if (local_count > (4 * RX_POLL_SIZE))
> > +               /* we are porbably in a storm of short packets and we don't
>
> porbably - probably

OK

>
> > +                * want to get into RDU since short packets in RDU cause
> > +                * many RXOV which may cause EMC halt, so we filter out all
> > +                * coming packets
> > +                */
> > +               writel(0, (ether->reg + REG_CAMCMR));
> > +
> > +       if (local_count <= budget)
> > +               /* we can restore accepting of packets */
> > +               writel(ether->camcmr, (ether->reg + REG_CAMCMR));
> > +
> > +       spin_lock_irqsave(&ether->lock, flags);
> > +       npcm7xx_clean_tx(netdev, false);
> > +       spin_unlock_irqrestore(&ether->lock, flags);
> > +
> > +       rxbd = (ether->rdesc + ether->cur_rx);
> > +
> > +       while (rx_cnt < budget) {
> > +               status = rxbd->sl;
> > +               if ((status & RX_OWN_DMA) == RX_OWN_DMA) {
> > +                       complete = 1;
> > +                       break;
> > +               }
> > +               /* for debug puposes we save the previous value */
>
> puposes -> purposes

OK

>
> > +               rxbd->reserved = status;
> > +               s = ether->rx_skb[ether->cur_rx];
> > +               length = status & 0xFFFF;
> > +
> > +               /* If VLAN is not supporte RXDS_PTLE (packet too long) is also
>
> supporte -> supported (stopping pointing out typos after this).

OK will review rest


>
> > +static const struct net_device_ops npcm7xx_ether_netdev_ops = {
> > +       .ndo_open               = npcm7xx_ether_open,
> > +       .ndo_stop               = npcm7xx_ether_close,
> > +       .ndo_start_xmit         = npcm7xx_ether_start_xmit,
> > +       .ndo_get_stats          = npcm7xx_ether_stats,
> > +       .ndo_set_rx_mode        = npcm7xx_ether_set_rx_mode,
> > +       .ndo_set_mac_address    = npcm7xx_set_mac_address,
> > +       .ndo_do_ioctl           = npcm7xx_ether_ioctl,
> > +       .ndo_validate_addr      = eth_validate_addr,
> > +       .ndo_change_mtu         = eth_change_mtu,
>
> This is marked as deprecated. Also in light of the hardcoded
> MAX_PACKET_SIZE, probably want to set dev->max_mtu.

can I just not set .ndo_change_mtu? or I must add my own implementation?
setting of dev->max_mtu, can be done in probe, yes?
BTW, I see that currently the mtu is 1500 but I do get transactions
with len of 1514 (I didn't compile with VLAN)

>
> > +static int npcm7xx_ether_probe(struct platform_device *pdev)
> > +{
> > +       struct npcm7xx_ether *ether;
> > +       struct net_device *netdev;
> > +       int error;
> > +
> > +       struct clk *emc_clk = NULL;
> > +       struct device_node *np = pdev->dev.of_node;
> > +
> > +       pdev->id = of_alias_get_id(np, "ethernet");
> > +       if (pdev->id < 0)
> > +               pdev->id = 0;
> > +
> > +       emc_clk = devm_clk_get(&pdev->dev, NULL);
> > +
> > +       if (IS_ERR(emc_clk))
> > +               return PTR_ERR(emc_clk);
> > +
> > +       /* Enable Clock */
> > +       clk_prepare_enable(emc_clk);
> > +
> > +       error = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> > +       if (error)
> > +               return -ENODEV;
> > +
> > +       netdev = alloc_etherdev(sizeof(struct npcm7xx_ether));
> > +       if (!netdev)
> > +               return -ENOMEM;
> > +
> > +       ether = netdev_priv(netdev);
> > +
> > +       ether->reset = devm_reset_control_get(&pdev->dev, NULL);
> > +       if (IS_ERR(ether->reset))
> > +               return PTR_ERR(ether->reset);
>
> Memory leak on error path
>
> Also missing netif_napi_del in npcm7xx_ether_remove?

added


--
Regards,
Avi
