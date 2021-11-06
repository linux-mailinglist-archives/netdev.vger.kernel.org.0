Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9557446FBC
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 19:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234152AbhKFSK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 14:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbhKFSK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 14:10:26 -0400
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7158C061570;
        Sat,  6 Nov 2021 11:07:44 -0700 (PDT)
Received: by mail-ua1-x930.google.com with SMTP id v3so23279193uam.10;
        Sat, 06 Nov 2021 11:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p6t+adxQ0bKFUq5Op+nUBg/TmVOSwc6YKd9W3pFBChs=;
        b=Vbss1/v7FKSrIWZPV+oPY/Qq4T8MIjCXxgrpy44PPSXlyac2pTdz5tyevxbIzWJf7C
         G0guvwNhQx+566Un3ZjZKhOb1+xSn6W+b8cGJX2dSTD5Z2kI19hkYBufiMX0G0BB4qUl
         FsCn7p3C6ExBknozI/uB+LjR5dfvaOiPrcGtrWUMuJmxSI3adS+jR8rrikc1Zz7jfvwg
         we0G8x23elvwVDDwWLAKNyyPw+OgE4jylOZw4PwTbD9z2wJvel4wEyZYyw/B2d49OabC
         +jxVSLgYofFy4WS49fgsQgordEtWPj9VApPpDl+oqgg8Jz+SYTZaQJ+1snJvBcAskJCs
         EecA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p6t+adxQ0bKFUq5Op+nUBg/TmVOSwc6YKd9W3pFBChs=;
        b=3c0g8L2BoulYPp9v63XSVpsl/WMynI0DmHTPCGD9adNYTiDCoF1AX5z8/Av/4pfkS4
         uYwWLGjsXM9Sub5HONp+7pj92eIrSEHsk8tX0Mrpc+goSq54jbuBCaWOS5fz9JPsQC/C
         2ZFzz20G+mE+Q0rN6zKHWSVjzibyGfWX4AJuEaH31vc6dxqeSrAcqs8tQjLF0XOGrZAx
         Viiq1RvfSuhMpDCG2nXon/RG5gCODe2P3nDJnR41DJ/HfsDNEAnwa1feY2nhy/xKgajo
         Lr4CJsMRsa8ZnApg+lljbO9fWEGOZsYzk7DRROVPjjTzMYUNn5RSVLZg5GFDNNfo5N4m
         0OCw==
X-Gm-Message-State: AOAM530F6vg8gRyfz4I3IPgEPRT9Lv9MXycjoyApv5StmfxgkZZI7nyv
        eod2g2xTcP7F8at/ON/AtY6OOsT6VpG1YEWxxVI=
X-Google-Smtp-Source: ABdhPJy1a+mAuvPsSEgnKLIsu/XnAYwVU1pU/VbUS+A0IUw2U1NI5vF/DwVmrrb5EOFLmH5p2kSef6OS4isscz9lkBM=
X-Received: by 2002:a67:d48d:: with SMTP id g13mr50054993vsj.34.1636222063626;
 Sat, 06 Nov 2021 11:07:43 -0700 (PDT)
MIME-Version: 1.0
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com> <20211101035635.26999-10-ricardo.martinez@linux.intel.com>
In-Reply-To: <20211101035635.26999-10-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sat, 6 Nov 2021 21:08:46 +0300
Message-ID: <CAHNKnsTAj8OHzoyK3SHhA_yXJrqc38bYmY6pYZf9fwUemcK7iQ@mail.gmail.com>
Subject: Re: [PATCH v2 09/14] net: wwan: t7xx: Add WWAN network interface
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 1, 2021 at 6:57 AM Ricardo Martinez
<ricardo.martinez@linux.intel.com> wrote:
> Creates the Cross Core Modem Network Interface (CCMNI) which implements
> the wwan_ops for registration with the WWAN framework, CCMNI also
> implements the net_device_ops functions used by the network device.
> Network device operations include open, close, start transmission, TX
> timeout, change MTU, and select queue.

[skipped]

> diff --git a/drivers/net/wwan/t7xx/t7xx_netdev.c b/drivers/net/wwan/t7xx/t7xx_netdev.c
> ...
> +static void ccmni_make_etherframe(struct net_device *dev, void *skb_eth_hdr,
> +                                 u8 *mac_addr, unsigned int packet_type)
> +{
> +       struct ethhdr *eth_hdr;
> +
> +       eth_hdr = skb_eth_hdr;
> +       memcpy(eth_hdr->h_dest, mac_addr, sizeof(eth_hdr->h_dest));
> +       memset(eth_hdr->h_source, 0, sizeof(eth_hdr->h_source));
> +
> +       if (packet_type == IPV6_VERSION)
> +               eth_hdr->h_proto = cpu_to_be16(ETH_P_IPV6);
> +       else
> +               eth_hdr->h_proto = cpu_to_be16(ETH_P_IP);
> +}

If the modem is a pure IP device, you do not need to forge an Ethernet
header. Moreover this does not make any sense, only odd CPU time
spending. Just set netdev->type to ARPHRD_NONE and send a pure
IPv4/IPv6 packet up to the stack.

> +static enum txq_type get_txq_type(struct sk_buff *skb)
> +{
> +       u32 total_len, payload_len, l4_off;
> +       bool tcp_syn_fin_rst, is_tcp;
> +       struct ipv6hdr *ip6h;
> +       struct tcphdr *tcph;
> +       struct iphdr *ip4h;
> +       u32 packet_type;
> +       __be16 frag_off;
> +
> +       packet_type = skb->data[0] & SBD_PACKET_TYPE_MASK;
> +       if (packet_type == IPV6_VERSION) {
> +               ip6h = (struct ipv6hdr *)skb->data;
> +               total_len = sizeof(struct ipv6hdr) + ntohs(ip6h->payload_len);
> +               l4_off = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &ip6h->nexthdr, &frag_off);
> +               tcph = (struct tcphdr *)(skb->data + l4_off);
> +               is_tcp = ip6h->nexthdr == IPPROTO_TCP;
> +               payload_len = total_len - l4_off - (tcph->doff << 2);
> +       } else if (packet_type == IPV4_VERSION) {
> +               ip4h = (struct iphdr *)skb->data;
> +               tcph = (struct tcphdr *)(skb->data + (ip4h->ihl << 2));
> +               is_tcp = ip4h->protocol == IPPROTO_TCP;
> +               payload_len = ntohs(ip4h->tot_len) - (ip4h->ihl << 2) - (tcph->doff << 2);
> +       } else {
> +               return TXQ_NORMAL;
> +       }
> +
> +       tcp_syn_fin_rst = tcph->syn || tcph->fin || tcph->rst;
> +       if (is_tcp && !payload_len && !tcp_syn_fin_rst)
> +               return TXQ_FAST;
> +
> +       return TXQ_NORMAL;
> +}

I am wondering how much modem performance has improved with this
optimization compared to the performance loss on each packet due to
the cache miss? Do you have any measurement results?

> +static u16 ccmni_select_queue(struct net_device *dev, struct sk_buff *skb,
> +                             struct net_device *sb_dev)
> +{
> +       struct ccmni_instance *ccmni;
> +
> +       ccmni = netdev_priv(dev);
> +
> +       if (ccmni->ctlb->capability & NIC_CAP_DATA_ACK_DVD)
> +               return get_txq_type(skb);
> +
> +       return TXQ_NORMAL;
> +}
> +
> +static int ccmni_open(struct net_device *dev)
> +{
> +       struct ccmni_instance *ccmni;
> +
> +       ccmni = wwan_netdev_drvpriv(dev);

Move this assignment to the variable definition.

> +       netif_carrier_on(dev);
> +       netif_tx_start_all_queues(dev);
> +       atomic_inc(&ccmni->usage);
> +       return 0;
> +}
> +
> +static int ccmni_close(struct net_device *dev)
> +{
> +       struct ccmni_instance *ccmni;
> +
> +       ccmni = wwan_netdev_drvpriv(dev);

Same here.

> +       if (atomic_dec_return(&ccmni->usage) < 0)
> +               return -EINVAL;
> +
> +       netif_carrier_off(dev);
> +       netif_tx_disable(dev);
> +       return 0;
> +}
> +
> +static int ccmni_send_packet(struct ccmni_instance *ccmni, struct sk_buff *skb, enum txq_type txqt)
> +{
> +       struct ccmni_ctl_block *ctlb;
> +       struct ccci_header *ccci_h;
> +       unsigned int ccmni_idx;
> +
> +       skb_push(skb, sizeof(struct ccci_header));
> +       ccci_h = (struct ccci_header *)skb->data;
> +       ccci_h->status &= ~HDR_FLD_CHN;

Please do not push control data to the skb data. You anyway will
remove them during the enqueuing to HW. This approach will cause a
performance penalty. Also this looks like a ccci_header structure
abuse.

Use a dedicated structure and the skb control buffer (e.g. skb->cb) to
preserve control data while the packet stays in an intermediate queue.

> +       ccmni_idx = ccmni->index;
> +       ccci_h->data[0] = ccmni_idx;
> +       ccci_h->data[1] = skb->len;
> +       ccci_h->reserved = 0;
> +
> +       ctlb = ccmni->ctlb;
> +       if (dpmaif_tx_send_skb(ctlb->hif_ctrl, txqt, skb)) {
> +               skb_pull(skb, sizeof(struct ccci_header));
> +               /* we will reserve header again in the next retry */
> +               return NETDEV_TX_BUSY;
> +       }
> +
> +       return 0;
> +}
> +
> +static int ccmni_start_xmit(struct sk_buff *skb, struct net_device *dev)
> +{
> +       struct ccmni_instance *ccmni;
> +       struct ccmni_ctl_block *ctlb;
> +       enum txq_type txqt;
> +       int skb_len;
> +
> +       ccmni = wwan_netdev_drvpriv(dev);

Move assignment to the variable definition.

> +       ctlb = ccmni->ctlb;
> +       txqt = TXQ_NORMAL;
> +       skb_len = skb->len;
> +
> +       /* If MTU changed or there is no headroom, drop the packet */
> +       if (skb->len > dev->mtu || skb_headroom(skb) < sizeof(struct ccci_header)) {
> +               dev_kfree_skb(skb);
> +               dev->stats.tx_dropped++;
> +               return NETDEV_TX_OK;
> +       }
> +
> +       if (ctlb->capability & NIC_CAP_DATA_ACK_DVD)
> +               txqt = get_txq_type(skb);
> +
> +       if (ccmni_send_packet(ccmni, skb, txqt)) {
> +               if (!(ctlb->capability & NIC_CAP_TXBUSY_STOP)) {
> +                       if ((ccmni->tx_busy_cnt[txqt]++) % 100 == 0)
> +                               netdev_notice(dev, "[TX]CCMNI:%d busy:pkt=%ld(ack=%d) cnt=%ld\n",
> +                                             ccmni->index, dev->stats.tx_packets,
> +                                             txqt, ccmni->tx_busy_cnt[txqt]);

What is the purpose of this message?

> +               } else {
> +                       ccmni->tx_busy_cnt[txqt]++;
> +               }
> +
> +               return NETDEV_TX_BUSY;
> +       }
> +
> +       dev->stats.tx_packets++;
> +       dev->stats.tx_bytes += skb_len;
> +       if (ccmni->tx_busy_cnt[txqt] > 10) {
> +               netdev_notice(dev, "[TX]CCMNI:%d TX busy:tx_pkt=%ld(ack=%d) retries=%ld\n",
> +                             ccmni->index, dev->stats.tx_packets,
> +                             txqt, ccmni->tx_busy_cnt[txqt]);
> +       }
> +       ccmni->tx_busy_cnt[txqt] = 0;
> +
> +       return NETDEV_TX_OK;
> +}
> +
> +static int ccmni_change_mtu(struct net_device *dev, int new_mtu)
> +{
> +       if (new_mtu > CCMNI_MTU_MAX)
> +               return -EINVAL;
> +
> +       dev->mtu = new_mtu;
> +       return 0;
> +}

You do not need this function at all. You already specify the max_mtu
value in the ccmni_wwan_setup(), so the network core code will be
happy to check a user requested MTU against max_mtu for you.

> ...
> +static void ccmni_pre_stop(struct ccmni_ctl_block *ctlb)
> +{
> ...
> +}
> +
> +static void ccmni_pos_stop(struct ccmni_ctl_block *ctlb)

Please consider renaming this function to ccmni_post_stop(). It is
quite hard to figure out what position should be stopped on first code
reading.

> ...
> +static void ccmni_wwan_setup(struct net_device *dev)
> +{
> +       dev->header_ops = NULL;
> +       dev->hard_header_len += sizeof(struct ccci_header);
> +
> +       dev->mtu = WWAN_DEFAULT_MTU;
> +       dev->max_mtu = CCMNI_MTU_MAX;
> +       dev->tx_queue_len = CCMNI_TX_QUEUE;
> +       dev->watchdog_timeo = CCMNI_NETDEV_WDT_TO;
> +       /* ccmni is a pure IP device */
> +       dev->flags = (IFF_POINTOPOINT | IFF_NOARP)
> +                    & ~(IFF_BROADCAST | IFF_MULTICAST);

You do not need to reset flags on the initial assignment. Just

        dev->flags = IFF_POINTOPOINT | IFF_NOARP;

would be enough.

> +       /* not supporting VLAN */
> +       dev->features = NETIF_F_VLAN_CHALLENGED;
> +
> +       dev->features |= NETIF_F_SG;
> +       dev->hw_features |= NETIF_F_SG;
> +
> +       /* uplink checksum offload */
> +       dev->features |= NETIF_F_HW_CSUM;
> +       dev->hw_features |= NETIF_F_HW_CSUM;
> +
> +       /* downlink checksum offload */
> +       dev->features |= NETIF_F_RXCSUM;
> +       dev->hw_features |= NETIF_F_RXCSUM;
> +
> +       dev->addr_len = ETH_ALEN;

You do not need to configure HW address length as the modem is a pure
IP device. Just drop the above line or explicitly set address length
to zero.

> +       /* use kernel default free_netdev() function */
> +       dev->needs_free_netdev = true;
> +
> +       /* no need to free again because of free_netdev() */
> +       dev->priv_destructor = NULL;
> +       dev->type = ARPHRD_PPP;

Use ARPHRD_NONE here since the modem is a pure IP device. Or you could
use ARPHRD_RAWIP depending on how you would like to allocate the link
IPv6 address. If in doubt then ARPHRD_NONE is a good starting point.

> +       dev->netdev_ops = &ccmni_netdev_ops;
> +       eth_random_addr(dev->dev_addr);

You do not need this random address generation.

> +}
> ...
> +static void ccmni_recv_skb(struct mtk_pci_dev *mtk_dev, int netif_id, struct sk_buff *skb)
> +{
> ...
> +       pkt_type = skb->data[0] & SBD_PACKET_TYPE_MASK;
> +       ccmni_make_etherframe(dev, skb->data - ETH_HLEN, dev->dev_addr, pkt_type);

As I wrote above, you do not need to forge an Ethernet header for pure
IP devices.

> +       skb_set_mac_header(skb, -ETH_HLEN);
> +       skb_reset_network_header(skb);
> +       skb->dev = dev;
> +       if (pkt_type == IPV6_VERSION)
> +               skb->protocol = htons(ETH_P_IPV6);
> +       else
> +               skb->protocol = htons(ETH_P_IP);
> +
> +       skb_len = skb->len;
> +
> +       netif_rx_any_context(skb);

Did you consider using NAPI for the packet Rx path? This should
improve Rx performance.

> +       dev->stats.rx_packets++;
> +       dev->stats.rx_bytes += skb_len;
> +}

[skipped]

> diff --git a/drivers/net/wwan/t7xx/t7xx_netdev.h b/drivers/net/wwan/t7xx/t7xx_netdev.h
> ...
> +#define CCMNI_TX_QUEUE         1000

Is this a really carefully selected queue depth limit, or just an
arbitrary value? If the last one, then feel free to use  the
DEFAULT_TX_QUEUE_LEN macro.

> ..
> +#define IPV4_VERSION           0x40
> +#define IPV6_VERSION           0x60

Just curious why the _VERSION suffix? Why not, for example, PKT_TYPE_ prefix?

--
Sergey
