Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A6A2FD9B4
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 20:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436468AbhATTb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 14:31:57 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:51686 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392621AbhATTbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 14:31:17 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210120193033euoutp01e65e29bf2475d4329d79ebd7a78b86bd~cB4SsFAam1801918019euoutp01I;
        Wed, 20 Jan 2021 19:30:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210120193033euoutp01e65e29bf2475d4329d79ebd7a78b86bd~cB4SsFAam1801918019euoutp01I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611171033;
        bh=4bO2Uv41jxTdypYH99Kab4MDziT6hJeuR4pBCj47XVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SOlMempSeXP83T+K5b2erwcR9NPzcoa40mnEu1M7jv7jJw17+uEIK0LgZ2QXSAbzk
         ileNVRyzI3iE7tMGbDV/sLLiYRnKN05DPjwH0sg1SdDm30eSAF9saZA2DJx/k+FjNM
         V/brRU4YXaJXdocgDfZu5kID1pUCeLYQOB7CZElU=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210120193032eucas1p187c35551e2b3c73497d4bc8ec0643992~cB4SUkGpu0586305863eucas1p1y;
        Wed, 20 Jan 2021 19:30:32 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 1D.14.27958.8D488006; Wed, 20
        Jan 2021 19:30:32 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210120193032eucas1p26566e957da7a75bc0818fe08e055bec8~cB4R4PWYL2968929689eucas1p2f;
        Wed, 20 Jan 2021 19:30:32 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210120193032eusmtrp2215c04d7abe4ef58683b64d239bde90e~cB4R3eUa_2659326593eusmtrp2j;
        Wed, 20 Jan 2021 19:30:32 +0000 (GMT)
X-AuditID: cbfec7f2-efdff70000006d36-7b-600884d8152c
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id FA.67.21957.7D488006; Wed, 20
        Jan 2021 19:30:32 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210120193031eusmtip2e12112576bb2bdae78673bc9a80a8508~cB4RkjPco2938929389eusmtip2n;
        Wed, 20 Jan 2021 19:30:31 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolni?= =?utf-8?Q?erkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v10 3/3] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Date:   Wed, 20 Jan 2021 20:30:14 +0100
In-Reply-To: <20210115172722.516468bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Fri, 15 Jan 2021 17:27:22 -0800")
Message-ID: <dleftj8s8nwgmx.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsWy7djPc7o3WjgSDN68kbM4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7XY9Pgaq8XlXXPYLGac38dk
        cWjqXkaLtUfuslscWyBm0br3CLuDgMflaxeZPbasvMnksXPWXXaPTas62Tw2L6n32LnjM5NH
        35ZVjB6fN8kFcERx2aSk5mSWpRbp2yVwZew8M5O5YGk3Y8XnrqmsDYxP8roYOTgkBEwkFlx2
        62Lk4hASWMEosft8EyOE84VR4vyke+xdjJxAzmdGiWs71WAaGvewQNQsZ5RYdPkFO4TznFHi
        asc0JpAiNgE9ibVrI0B6RQRUJFo2zwRrYBa4yCKxvvszC0hCWCBcYmbvKyYQm0VAVeJM+z0m
        kCJOgWmMEu+PLWQDSfAKmEvsOrwPrEhUwFJiy4v77BBxQYmTM5+ADWIWyJWYef4N2NkSApc4
        JR6dOcQKcaqLxILWUJAaCQFhiVfHt7BD2DIS/3fOZ4IoqZeYPMkMorWHUWLbnB8sEDXWEnfO
        /WKDsB0lnjdvghrJJ3HjrSDEWj6JSdumM0OEeSU62oQgqlUk1vXvgZoiJdH7agUjhO0hcf/V
        b0Z4wG1vf8U8gVFhFpJvZiH5ZhbQWGYBTYn1u/QhwtoSyxa+ZoawbSXWrXvPsoCRdRWjeGpp
        cW56arFhXmq5XnFibnFpXrpecn7uJkZgOjz97/inHYxzX33UO8TIxMF4iFEFqPnRhtUXGKVY
        8vLzUpVEeB9ZciQI8aYkVlalFuXHF5XmpBYfYpTmYFES5101e028kEB6YklqdmpqQWoRTJaJ
        g1OqgcnkaNwhCVf7PcsntCtcFK5/cZZ54rxHhVK3kizKZb6ufZCk8zPGocD798XAnTrl1ee4
        3/kFfuKbeG/lhV8PGsoS1b+/Fo8JfMwcHBchl/tJJZJdkGfS2vjSkzdeHfK+Y8if/aLk9QV3
        3+63927f27tb6qrpI537Kvu6XN5+9u2cIau16f39exrud/vPmPtt77zxIX2Ga8m3lWrX1ggn
        8vZ/DFr3YfLzvZvnGP439oqJkT996v+jFwdt/XweHrc4p/wy7v/Lbb6RLREp5vdWBGnseyJ8
        +Fpb6tXWrAUV8Vfsiytn8Ki82O3lvUns8I4Dr56+FSv1MLhYV7+Bc8XDM4vavr5JK5plLrJ8
        n++PZFsmJZbijERDLeai4kQAxLn1FQIEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t/xe7o3WjgSDA5eYrI4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7XY9Pgaq8XlXXPYLGac38dk
        cWjqXkaLtUfuslscWyBm0br3CLuDgMflaxeZPbasvMnksXPWXXaPTas62Tw2L6n32LnjM5NH
        35ZVjB6fN8kFcETp2RTll5akKmTkF5fYKkUbWhjpGVpa6BmZWOoZGpvHWhmZKunb2aSk5mSW
        pRbp2yXoZew8M5O5YGk3Y8XnrqmsDYxP8roYOTgkBEwkGvewdDFycQgJLGWUmDnpPStEXEpi
        5dz0LkZOIFNY4s+1LjaImqeMElPfzWIGqWET0JNYuzYCpEZEQEWiZfNMsDnMAldYJFZ9bGEF
        SQgLhEp8/jGdEcQWEgiW2LOjmx3EZhFQlTjTfo8JpIFTYBqjxPtjC9lAErwC5hK7Du9jArFF
        BSwltry4zw4RF5Q4OfMJC4jNLJAt8XX1c+YJjAKzkKRmIUnNArqPWUBTYv0ufYiwtsSyha+Z
        IWxbiXXr3rMsYGRdxSiSWlqcm55bbKhXnJhbXJqXrpecn7uJERjP24793LyDcd6rj3qHGJk4
        GA8xqgB1Ptqw+gKjFEtefl6qkgjvI0uOBCHelMTKqtSi/Pii0pzU4kOMpkC/TWSWEk3OByaa
        vJJ4QzMDU0MTM0sDU0szYyVx3q1z18QLCaQnlqRmp6YWpBbB9DFxcEo1MLk7n1q04eKJZ40d
        nV5GC9Re5FRUs76aH39FjzPskp7aRv60k9UyXe2LNGZ+aHHVT/1mktzVuKnlhJSvcAb73Rrx
        /H0PF36zPbs3VyF3XmDmhemdF2xbQ/+6nE3tmDGLhf/23adtjulzp88/lXBWRuLd5BC9pe5F
        3z5nPisuV5iQw5GrpHg4S1H4WV7FTb63zyYyfHzYL/u8/4pL9dPkB2vWVOw0mrd7aXGI4y+F
        Mild/3uTcs6le6gaOxZYeh2/2VEy3XFVU/q0WpPVuQ+arlr9DVB8FSMlaVk/7/ad+6m/L+z2
        lbktrFu221LU4OCnr1mXdawnle5cEvDd9P6nEqM3N17MnHZsf/pJedbPtkosxRmJhlrMRcWJ
        AGMNGW58AwAA
X-CMS-MailID: 20210120193032eucas1p26566e957da7a75bc0818fe08e055bec8
X-Msg-Generator: CA
X-RootMTR: 20210120193032eucas1p26566e957da7a75bc0818fe08e055bec8
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210120193032eucas1p26566e957da7a75bc0818fe08e055bec8
References: <20210115172722.516468bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CGME20210120193032eucas1p26566e957da7a75bc0818fe08e055bec8@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2021-01-15 pi=C4=85 17:27>, when Jakub Kicinski wrote:
> On Wed, 13 Jan 2021 19:40:28 +0100 =C5=81ukasz Stelmach wrote:
>> ASIX AX88796[1] is a versatile ethernet adapter chip, that can be
>> connected to a CPU with a 8/16-bit bus or with an SPI. This driver
>> supports SPI connection.
>>=20
>> The driver has been ported from the vendor kernel for ARTIK5[2]
>> boards. Several changes were made to adapt it to the current kernel
>> which include:
>>=20
>> + updated DT configuration,
>> + clock configuration moved to DT,
>> + new timer, ethtool and gpio APIs,
>> + dev_* instead of pr_* and custom printk() wrappers,
>> + removed awkward vendor power managemtn.
>> + introduced ethtool tunable to control SPI compression
>>=20

[...]

>>=20
>> The other ax88796 driver is for NE2000 compatible AX88796L chip. These
>> chips are not compatible. Hence, two separate drivers are required.
>>=20
>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>
>> +static u32 ax88796c_get_priv_flags(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +
>> +        return ax_local->priv_flags;
>
> stray indent
>
>> +}

Done.

>> +#define MAX(x,y) ((x) > (y) ? (x) : (y))
>
> Please use the standard linux max / max_t macros.

Done.

>> +static struct sk_buff *
>> +ax88796c_tx_fixup(struct net_device *ndev, struct sk_buff_head *q)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	u8 spi_len =3D ax_local->ax_spi.comp ? 1 : 4;
>> +	struct sk_buff *skb;
>> +	struct tx_pkt_info *info;
>> +	struct skb_data *entry;
>> +	u16 pkt_len;
>> +	u8 padlen, seq_num;
>> +	u8 need_pages;
>> +	int headroom;
>> +	int tailroom;
>> +
>> +	if (skb_queue_empty(q))
>> +		return NULL;
>> +
>> +	skb =3D skb_peek(q);
>> +	pkt_len =3D skb->len;
>> +	need_pages =3D (pkt_len + TX_OVERHEAD + 127) >> 7;
>> +	if (ax88796c_check_free_pages(ax_local, need_pages) !=3D 0)
>> +		return NULL;
>> +
>> +	headroom =3D skb_headroom(skb);
>> +	tailroom =3D skb_tailroom(skb);
>> +	padlen =3D round_up(pkt_len, 4) - pkt_len;
>> +	seq_num =3D ++ax_local->seq_num & 0x1F;
>> +
>> +	info =3D (struct tx_pkt_info *)skb->cb;
>> +	info->pkt_len =3D pkt_len;
>> +
>> +	if (skb_cloned(skb) ||
>> +	    (headroom < (TX_OVERHEAD + spi_len)) ||
>> +	    (tailroom < (padlen + TX_EOP_SIZE))) {
>> +		size_t h =3D MAX((TX_OVERHEAD + spi_len) - headroom,0);
>> +		size_t t =3D MAX((padlen + TX_EOP_SIZE) - tailroom,0);
>> +
>> +		if (pskb_expand_head(skb, h, t, GFP_KERNEL))
>> +			return NULL;
>> +	}
>> +
>> +	info->seq_num =3D seq_num;
>> +	ax88796c_proc_tx_hdr(info, skb->ip_summed);
>> +
>> +	/* SOP and SEG header */
>> +	memcpy(skb_push(skb, TX_OVERHEAD), &info->sop, TX_OVERHEAD);
>
> why use skb->cb to store info? why not declare it on the stack?
>

Done.

>> +	/* Write SPI TXQ header */
>> +	memcpy(skb_push(skb, spi_len), ax88796c_tx_cmd_buf, spi_len);
>> +
>> +	/* Make 32-bit alignment */
>> +	skb_put(skb, padlen);
>> +
>> +	/* EOP header */
>> +	memcpy(skb_put(skb, TX_EOP_SIZE), &info->eop, TX_EOP_SIZE);
>> +
>> +	skb_unlink(skb, q);
>> +
>> +	entry =3D (struct skb_data *)skb->cb;
>> +	memset(entry, 0, sizeof(*entry));
>> +	entry->len =3D pkt_len;
>> +
>> +	if (netif_msg_pktdata(ax_local)) {
>> +		char pfx[IFNAMSIZ + 7];
>> +
>> +		snprintf(pfx, sizeof(pfx), "%s:     ", ndev->name);
>> +
>> +		netdev_info(ndev, "TX packet len %d, total len %d, seq %d\n",
>> +			    pkt_len, skb->len, seq_num);
>> +
>> +		netdev_info(ndev, "  SPI Header:\n");
>> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
>> +			       skb->data, 4, 0);
>> +
>> +		netdev_info(ndev, "  TX SOP:\n");
>> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
>> +			       skb->data + 4, TX_OVERHEAD, 0);
>> +
>> +		netdev_info(ndev, "  TX packet:\n");
>> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
>> +			       skb->data + 4 + TX_OVERHEAD,
>> +			       skb->len - TX_EOP_SIZE - 4 - TX_OVERHEAD, 0);
>> +
>> +		netdev_info(ndev, "  TX EOP:\n");
>> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
>> +			       skb->data + skb->len - 4, 4, 0);
>> +	}
>> +
>> +	return skb;
>> +}
>> +
>> +static int ax88796c_hard_xmit(struct ax88796c_device *ax_local)
>> +{
>> +	struct sk_buff *tx_skb;
>> +	struct skb_data *entry;
>> +
>> +	WARN_ON(!mutex_is_locked(&ax_local->spi_lock));
>> +
>> +	tx_skb =3D ax88796c_tx_fixup(ax_local->ndev, &ax_local->tx_wait_q);
>> +
>> +	if (!tx_skb)
>> +		return 0;
>
> tx_dropped++ ?
>

Done.

>> +	entry =3D (struct skb_data *)tx_skb->cb;
>> +
>> +	AX_WRITE(&ax_local->ax_spi,
>> +		 (TSNR_TXB_START | TSNR_PKT_CNT(1)), P0_TSNR);
>> +
>> +	axspi_write_txq(&ax_local->ax_spi, tx_skb->data, tx_skb->len);
>> +
>> +	if (((AX_READ(&ax_local->ax_spi, P0_TSNR) & TXNR_TXB_IDLE) =3D=3D 0) ||
>> +	    ((ISR_TXERR & AX_READ(&ax_local->ax_spi, P0_ISR)) !=3D 0)) {
>> +		/* Ack tx error int */
>> +		AX_WRITE(&ax_local->ax_spi, ISR_TXERR, P0_ISR);
>> +
>> +		ax_local->stats.tx_dropped++;
>> +
>> +		netif_err(ax_local, tx_err, ax_local->ndev,
>> +			  "TX FIFO error, re-initialize the TX bridge\n");
>
> rate limit
>

Done.

>> +		/* Reinitial tx bridge */
>> +		AX_WRITE(&ax_local->ax_spi, TXNR_TXB_REINIT |
>> +			AX_READ(&ax_local->ax_spi, P0_TSNR), P0_TSNR);
>> +		ax_local->seq_num =3D 0;
>> +	} else {
>> +		ax_local->stats.tx_packets++;
>> +		ax_local->stats.tx_bytes +=3D entry->len;
>> +	}
>> +
>> +	entry->state =3D tx_done;
>> +	dev_kfree_skb(tx_skb);
>
> dev_consume_skb() is better in cases the xmission was correct.
> kfree_skb() shows up in packet drop monitor.
>

This one is OK as it is because

1. dev_kfree_skb() is consume_skb()

    include/linux/skbuff.h:#define dev_kfree_skb(a) consume_skb(a)

2. dev_consume_skb() does not exist. There are dev_consume_skb_irq() and
dev_consume_skb_any(). The former can be used in IRQs, the latter
anywher and de facto calls the former if in IRQ. If not, it calls
dev_kfree_skb() (see above)

3. Last but not least. kfree_skb() and consume_skb() become the same
without CONFIG_TRACEPOINTS (commit be769db2f958).

>> +
>> +	return 1;
>> +}
>
>> +static void
>> +ax88796c_skb_return(struct ax88796c_device *ax_local, struct sk_buff *s=
kb,
>> +		    struct rx_header *rxhdr)
>> +{
>> +	struct net_device *ndev =3D ax_local->ndev;
>> +	int status;
>> +
>> +	do {
>> +		if (!(ndev->features & NETIF_F_RXCSUM))
>> +			break;
>> +
>> +		/* checksum error bit is set */
>> +		if ((rxhdr->flags & RX_HDR3_L3_ERR) ||
>> +		    (rxhdr->flags & RX_HDR3_L4_ERR))
>> +			break;
>> +
>> +		/* Other types may be indicated by more than one bit. */
>> +		if ((rxhdr->flags & RX_HDR3_L4_TYPE_TCP) ||
>> +		    (rxhdr->flags & RX_HDR3_L4_TYPE_UDP))
>> +			skb->ip_summed =3D CHECKSUM_UNNECESSARY;
>> +	} while (0);
>> +
>> +	ax_local->stats.rx_packets++;
>> +	ax_local->stats.rx_bytes +=3D skb->len;
>> +	skb->dev =3D ndev;
>> +
>> +	skb->protocol =3D eth_type_trans(skb, ax_local->ndev);
>> +
>> +	netif_info(ax_local, rx_status, ndev, "< rx, len %zu, type 0x%x\n",
>> +		   skb->len + sizeof(struct ethhdr), skb->protocol);
>> +
>> +	status =3D netif_rx_ni(skb);
>> +	if (status !=3D NET_RX_SUCCESS)
>> +		netif_info(ax_local, rx_err, ndev,
>> +			   "netif_rx status %d\n", status);
>
> rate limit
>

Done.

>> +}
>> +
>> +static void
>> +ax88796c_rx_fixup(struct ax88796c_device *ax_local, struct sk_buff *rx_=
skb)
>> +{
>> +	struct rx_header *rxhdr =3D (struct rx_header *)rx_skb->data;
>> +	struct net_device *ndev =3D ax_local->ndev;
>> +	u16 len;
>> +
>> +	be16_to_cpus(&rxhdr->flags_len);
>> +	be16_to_cpus(&rxhdr->seq_lenbar);
>> +	be16_to_cpus(&rxhdr->flags);
>> +
>> +	if (((rxhdr->flags_len) & RX_HDR1_PKT_LEN) !=3D
>> +			 (~(rxhdr->seq_lenbar) & 0x7FF)) {
>
> Lots of unnecessary parenthesis.
>

Done.

>> +		netif_err(ax_local, rx_err, ndev, "Header error\n");
>> +
>> +		ax_local->stats.rx_frame_errors++;
>> +		kfree_skb(rx_skb);
>> +		return;
>> +	}
>> +
>> +	if ((rxhdr->flags_len & RX_HDR1_MII_ERR) ||
>> +	    (rxhdr->flags_len & RX_HDR1_CRC_ERR)) {
>> +		netif_err(ax_local, rx_err, ndev, "CRC or MII error\n");
>> +
>> +		ax_local->stats.rx_crc_errors++;
>> +		kfree_skb(rx_skb);
>> +		return;
>> +	}
>> +
>> +	len =3D rxhdr->flags_len & RX_HDR1_PKT_LEN;
>> +	if (netif_msg_pktdata(ax_local)) {
>> +		char pfx[IFNAMSIZ + 7];
>> +
>> +		snprintf(pfx, sizeof(pfx), "%s:     ", ndev->name);
>> +		netdev_info(ndev, "RX data, total len %d, packet len %d\n",
>> +			    rx_skb->len, len);
>> +
>> +		netdev_info(ndev, "  Dump RX packet header:");
>> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
>> +			       rx_skb->data, sizeof(*rxhdr), 0);
>> +
>> +		netdev_info(ndev, "  Dump RX packet:");
>> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
>> +			       rx_skb->data + sizeof(*rxhdr), len, 0);
>> +	}
>> +
>> +	skb_pull(rx_skb, sizeof(*rxhdr));
>> +	pskb_trim(rx_skb, len);
>> +
>> +	ax88796c_skb_return(ax_local, rx_skb, rxhdr);
>> +}
>> +
>> +static int ax88796c_receive(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	struct skb_data *entry;
>> +	u16 w_count, pkt_len;
>> +	struct sk_buff *skb;
>> +	u8 pkt_cnt;
>> +
>> +	WARN_ON(!mutex_is_locked(&ax_local->spi_lock));
>> +
>> +	/* check rx packet and total word count */
>> +	AX_WRITE(&ax_local->ax_spi, AX_READ(&ax_local->ax_spi, P0_RTWCR)
>> +		  | RTWCR_RX_LATCH, P0_RTWCR);
>> +
>> +	pkt_cnt =3D AX_READ(&ax_local->ax_spi, P0_RXBCR2) & RXBCR2_PKT_MASK;
>> +	if (!pkt_cnt)
>> +		return 0;
>> +
>> +	pkt_len =3D AX_READ(&ax_local->ax_spi, P0_RCPHR) & 0x7FF;
>> +
>> +	w_count =3D ((pkt_len + 6 + 3) & 0xFFFC) >> 1;
>
> w_count =3D round_up(pkt_len + 6, 4) >> 1;
>

Done.

>> +	skb =3D netdev_alloc_skb(ndev, (w_count * 2));
>
> parenthesis unnecessary
>

Done.

>> +	if (!skb) {
>> +		AX_WRITE(&ax_local->ax_spi, RXBCR1_RXB_DISCARD, P0_RXBCR1);
>
> Increment rx_dropped counter here?
>

Done.

>> +		return 0;
>> +	}
>> +	entry =3D (struct skb_data *)skb->cb;
>> +
>> +	AX_WRITE(&ax_local->ax_spi, RXBCR1_RXB_START | w_count, P0_RXBCR1);
>> +
>> +	axspi_read_rxq(&ax_local->ax_spi,
>> +		       skb_put(skb, w_count * 2), skb->len);
>> +
>> +	/* Check if rx bridge is idle */
>> +	if ((AX_READ(&ax_local->ax_spi, P0_RXBCR2) & RXBCR2_RXB_IDLE) =3D=3D 0=
) {
>> +		netif_err(ax_local, rx_err, ndev,
>> +			  "Rx Bridge is not idle\n");
>
> rate limit?
>

Ok.

>> +		AX_WRITE(&ax_local->ax_spi, RXBCR2_RXB_REINIT, P0_RXBCR2);
>> +
>> +		entry->state =3D rx_err;
>> +	} else {
>> +		entry->state =3D rx_done;
>> +	}
>> +
>> +	AX_WRITE(&ax_local->ax_spi, ISR_RXPKT, P0_ISR);
>> +
>> +	ax88796c_rx_fixup(ax_local, skb);
>> +
>> +	return 1;
>> +}
>> +
>> +static int ax88796c_process_isr(struct ax88796c_device *ax_local)
>> +{
>> +	struct net_device *ndev =3D ax_local->ndev;
>> +	u8 done =3D 0;
>
> The logic associated with this variable is "is there more to do" rather
> than "done", no?
>

ax88796c_receive() returns 1, if there may be something more to do. So
yes, let's rename it to todo.

>> +	u16 isr;
>> +
>> +	WARN_ON(!mutex_is_locked(&ax_local->spi_lock));
>> +
>> +	isr =3D AX_READ(&ax_local->ax_spi, P0_ISR);
>> +	AX_WRITE(&ax_local->ax_spi, isr, P0_ISR);
>> +
>> +	netif_dbg(ax_local, intr, ndev, "  ISR 0x%04x\n", isr);
>> +
>> +	if (isr & ISR_TXERR) {
>> +		netif_dbg(ax_local, intr, ndev, "  TXERR interrupt\n");
>> +		AX_WRITE(&ax_local->ax_spi, TXNR_TXB_REINIT, P0_TSNR);
>> +		ax_local->seq_num =3D 0x1f;
>> +	}
>> +
>> +	if (isr & ISR_TXPAGES) {
>> +		netif_dbg(ax_local, intr, ndev, "  TXPAGES interrupt\n");
>> +		set_bit(EVENT_TX, &ax_local->flags);
>> +	}
>> +
>> +	if (isr & ISR_LINK) {
>> +		netif_dbg(ax_local, intr, ndev, "  Link change interrupt\n");
>> +		phy_mac_interrupt(ax_local->ndev->phydev);
>> +	}
>> +
>> +	if (isr & ISR_RXPKT) {
>> +		netif_dbg(ax_local, intr, ndev, "  RX interrupt\n");
>> +		done =3D ax88796c_receive(ax_local->ndev);
>> +	}
>> +
>> +	return done;
>> +}
>
>> +static void ax88796c_work(struct work_struct *work)
>> +{
>> +	struct ax88796c_device *ax_local =3D
>> +			container_of(work, struct ax88796c_device, ax_work);
>> +
>> +	mutex_lock(&ax_local->spi_lock);
>> +
>> +	if (test_bit(EVENT_SET_MULTI, &ax_local->flags)) {
>> +		ax88796c_set_hw_multicast(ax_local->ndev);
>> +		clear_bit(EVENT_SET_MULTI, &ax_local->flags);
>> +	}
>> +
>> +	if (test_bit(EVENT_INTR, &ax_local->flags)) {
>> +		AX_WRITE(&ax_local->ax_spi, IMR_MASKALL, P0_IMR);
>> +
>> +		while (1) {
>> +			if (!ax88796c_process_isr(ax_local))
>> +				break;
>
> while (ax88796c_process_isr(ax_local))
> 	/* nothing */;
> ?
>

Ok.

>> +		}
>> +
>> +		clear_bit(EVENT_INTR, &ax_local->flags);
>> +
>> +		AX_WRITE(&ax_local->ax_spi, IMR_DEFAULT, P0_IMR);
>> +
>> +		enable_irq(ax_local->ndev->irq);
>> +	}
>> +
>> +	if (test_bit(EVENT_TX, &ax_local->flags)) {
>> +		while (skb_queue_len(&ax_local->tx_wait_q)) {
>> +			if (!ax88796c_hard_xmit(ax_local))
>> +				break;
>> +		}
>> +
>> +		clear_bit(EVENT_TX, &ax_local->flags);
>> +
>> +		if (netif_queue_stopped(ax_local->ndev) &&
>> +		    (skb_queue_len(&ax_local->tx_wait_q) < TX_QUEUE_LOW_WATER))
>> +			netif_wake_queue(ax_local->ndev);
>> +	}
>> +
>> +	mutex_unlock(&ax_local->spi_lock);
>> +}
>
>> +static void ax88796c_set_csums(struct ax88796c_device *ax_local)
>> +{
>> +	struct net_device *ndev =3D ax_local->ndev;
>> +
>> +	WARN_ON(!mutex_is_locked(&ax_local->spi_lock));
>
> lockdep_assert_held() in all those cases
>

Done.

>> +static void ax88796c_free_skb_queue(struct sk_buff_head *q)
>> +{
>> +	struct sk_buff *skb;
>> +
>> +	while (q->qlen) {
>> +		skb =3D skb_dequeue(q);
>> +		kfree_skb(skb);
>> +	}
>
> __skb_queue_purge()
>

Done.

>> +}
>> +
>> +static int
>> +ax88796c_close(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +
>> +	netif_stop_queue(ndev);
>> +	phy_stop(ndev->phydev);
>> +
>> +	mutex_lock(&ax_local->spi_lock);
>> +
>> +	/* Disable MAC interrupts */
>> +	AX_WRITE(&ax_local->ax_spi, IMR_MASKALL, P0_IMR);
>> +	ax88796c_free_skb_queue(&ax_local->tx_wait_q);
>> +	ax88796c_soft_reset(ax_local);
>> +
>> +	mutex_unlock(&ax_local->spi_lock);
>> +
>> +	free_irq(ndev->irq, ndev);
>> +
>> +	return 0;
>> +}
>
>> +struct ax88796c_device {
>> +	struct spi_device	*spi;
>> +	struct net_device	*ndev;
>> +	struct net_device_stats	stats;
>
> You need to use 64 bit stats, like struct rtnl_link_stats64.
> On a 32bit system at 100Mbps ulong can wrap in minutes.
>

Let me see. At first glance

git grep -l ndo_get_stats\\\> drivers/net/ethernet/  | xargs grep -li SPEED=
_100\\\>

quite a number of Fast Ethernet drivers use net_device_stats. Let me
calculate.

=2D bytes
  100Mbps is ~10MiB/s
  sending 4GiB at 10MiB/s takes 27 minutes

=2D packets
  minimum frame size is 84 bytes (840 bits on the wire) on 100Mbps means
  119048 pps at this speed it takse 10 hours to transmit 2^32 packets

Anyway, I switched to rtnl_link_stats64. Tell me, is it OK to just
memcpy() in .ndo_get_stats64?

>> +	struct work_struct	ax_work;
>
> I don't see you ever canceling / flushing this work.
> You should do that at least on driver remove if not close.

Done.

Does it mean most drivers do it wrong?

    git grep INIT_WORK drivers/net/ethernet/ | \
    sed -e 's/\(^[^:]*\):[^>]*->\([^,]*\),.*/\1        \2/' | \
    while read file var; do \
        grep -H $var $file;
    done | grep INIT_WORK\\\|cancel_work


>> +	struct mutex		spi_lock; /* device access */
>> +
>> +	struct sk_buff_head	tx_wait_q;
>> +
>> +	struct axspi_data	ax_spi;
>> +
>> +	struct mii_bus		*mdiobus;
>> +	struct phy_device	*phydev;
>> +
>> +	int			msg_enable;
>> +
>> +	u16			seq_num;
>> +
>> +	u8			multi_filter[AX_MCAST_FILTER_SIZE];
>> +
>> +	int			link;
>> +	int			speed;
>> +	int			duplex;
>> +	int			pause;
>> +	int			asym_pause;
>> +	int			flowctrl;
>> +		#define AX_FC_NONE		0
>> +		#define AX_FC_RX		BIT(0)
>> +		#define AX_FC_TX		BIT(1)
>> +		#define AX_FC_ANEG		BIT(2)
>> +
>> +	u32			priv_flags;
>> +		#define AX_CAP_COMP		BIT(0)
>> +		#define AX_PRIV_FLAGS_MASK	(AX_CAP_COMP)
>> +
>> +	unsigned long		flags;
>> +		#define EVENT_INTR		BIT(0)
>> +		#define EVENT_TX		BIT(1)
>> +		#define EVENT_SET_MULTI		BIT(2)
>> +
>> +};
>
>> +struct skb_data {
>> +	enum skb_state state;
>> +	struct net_device *ndev;
>> +	struct sk_buff *skb;
>
> Don't think you ever use the skb or ndev from this structure.
>

Done.

>> +	size_t len;
>> +};
>
>

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmAIhMYACgkQsK4enJil
gBA+igf/WmLwPP/YvB2r5ISNO4wKlK6jaURjg+CE+s44XESsOQ/l26jFH6Zd6OGo
WW3sjbWX057H/K8BgRujSVxf5Vn7I26PhF4gzHvaBaNX8EnL2y1znZMZHwf0g2M1
hcbsv1lCF+MBwvKfoyIep7NyhKAQ9jdSccDFsKF6Fva1ViH1svKw+Nytk5iU47NO
6MGedk6greVLsN2rZZeMWK7zKwRP1QOBvOcuuahaUumaAJFRA0TCP4Lw1VgkhUPL
N0zhIUdvyB07UUNDK0Rg9BIiNHd9Btn7jlJ8Ppz4cJaX3ObXwe2xyiFHKvSFq3Vx
zkvlmAHntJnkWGVtQVNc9aJxx6V9VQ==
=pHve
-----END PGP SIGNATURE-----
--=-=-=--
