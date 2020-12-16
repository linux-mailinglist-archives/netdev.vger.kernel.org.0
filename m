Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11712DB7DF
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 01:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgLPAnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 19:43:55 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:51091 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgLPAnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 19:43:49 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201216004257euoutp01536f6e787d2b71d7f411501c21386620~RC6xz4T5N0168001680euoutp01g;
        Wed, 16 Dec 2020 00:42:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201216004257euoutp01536f6e787d2b71d7f411501c21386620~RC6xz4T5N0168001680euoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608079377;
        bh=yeTtaeAq8C2K2prFKVmlIL0aSrCLj/T9pEpwOZNgAGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Az+cAuuGzCOM5TPD55urJPWwX/2GJWMD/mQ+PY0DGIx85UWF8giEU5kkatvM37XgM
         iXhXgS3F1N/Cl1St1pddWhq6pZ/Y8AhQnb2AsoFLAESkpKfrGI7VVlckYCsq4ynIeq
         OHkfj4zoODhvgVj9gxXCXi1mHiBlKnLeZGHhaIaI=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201216004251eucas1p2375b635e6f1c3e692c325498ae5399c3~RC6s0ncUN1767117671eucas1p2O;
        Wed, 16 Dec 2020 00:42:51 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 00.F6.45488.B0859DF5; Wed, 16
        Dec 2020 00:42:51 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201216004251eucas1p17b212b74d7382f4dbc0eb9a1955404e7~RC6sXTP022445524455eucas1p1Y;
        Wed, 16 Dec 2020 00:42:51 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201216004251eusmtrp2df12cd82fb94efc715f95a06195b1de2~RC6sWjnOu2060220602eusmtrp2X;
        Wed, 16 Dec 2020 00:42:51 +0000 (GMT)
X-AuditID: cbfec7f5-c77ff7000000b1b0-cc-5fd9580b64d6
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 51.3D.16282.B0859DF5; Wed, 16
        Dec 2020 00:42:51 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201216004251eusmtip2dcb6d4ba5fcc00eb514ba41cef943095~RC6sELH7L2538025380eusmtip2e;
        Wed, 16 Dec 2020 00:42:51 +0000 (GMT)
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
Subject: Re: [PATCH v8 3/3] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Date:   Wed, 16 Dec 2020 01:42:03 +0100
In-Reply-To: <20201204193702.1e4b0427@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        (Jakub Kicinski's message of "Fri, 4 Dec 2020 19:37:02 -0800")
Message-ID: <dleftjr1nq8tus.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA01SfUxTVxTffR/to67kWaheC6GkwS1iVjToeOhmNCPxLS5xiYYoBmsHb0As
        hbQw5nSjWdyUgjBFXNuR4ZCNwkbBtlRaQUwlIHG2KFtDXRnDutUAlWkdG8LoKK8u/vc7v49z
        zzm5BCp4gouIImUZo1LKFRIOD7MNzrteW3XAK9vk/ymNco87UeqyrhOnGt0nMappwIVTzbM6
        nPIEfThV559GKbe7i0uN2Gpxyuz34NSoo5FD6dzXEMrZ0AeojoFxLjV4cQ31Wd8AdydJj3ru
        oLS1zYvQdsM4lza3V3FoS0slbe8JIXSttR3QIXPSu0QO7418RlH0AaNK23GEVzjSfBkpfXT8
        w8kFHVcDLuRpQQwByS3QfNrI1QIeISCNAA5XDUWLpwAuXJnksEUIwMVfLoHnkW/NZ3FWaAXw
        nv5+1BUA8InlJqYFBMEhpbCj40AkEE+mwJMWPRbxoOQdDHZWh7CIEEdmw/o2MxLBGLkeBia6
        VkwxZAOAv7m7VwQ+mQG1DTfwCBaSmdD6cILL8qvhsP7BSiOULIZ69wyIhCF5NwZa61swdtYs
        eCMwg7A4Dk4NWbksToRhexMSmRSSlbD+3OtstgZAW+M/0ex26HM947B4F/SEwlzWHwvHgqvZ
        d2PhOduXKEvz4enPBaw7BZrqeqNdRPDMlDF6ORpWt/7B+f9yj8PPkC9AsuGFdQwvrGNYbouS
        G2CnI42lN8LvvplGWfwmNJlmsYsAbwdrmXJ1cQGjTlcyFVK1vFhdriyQ5pUUm8HyV7y1NPRX
        DzBOPZY6AUIAJ0hZDt/v+n4EiDBliZKRxPMXg2MyAT9ffuwjRlUiU5UrGLUTJBCYZC3f0f2D
        TEAWyMuYowxTyqieqwgRI9Ig1ft8Pdm1whPir4WLjoT+OaTEkxiXffxm0fRu210Dcn5fjYGR
        n5/l77zyft2k+EyiaE5OV9b1vm15dGw00fS39+nPPpdJWhOCSblZlq2btg2tc4bHNDNX0y89
        oBPems9ZCuIHtcmF6S6h2GarSpBtGe3xvjT/6al11yaCW3m3gcXXbUqayGyrOHRYfKL7q+ut
        eh+2Pqeqffst3m3d7/eSP96gLtyz6k8Fcqr2neZXKvZn5BmG98bmpu7PWgg8bBK+592BhO27
        OXbOUiDjekuqv6/z6NXU3F7x4MCPlWe7dqVlKvL7NS/LS//1Hyzb1qLsl+QcmXN8YnTEa4wb
        X/11z14Jpi6Ub05FVWr5fwEe49AFBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t/xe7rcETfjDXY08lmcv3uI2WLjjPWs
        FnPOt7BYzD9yjtVi0fsZrBbX3t5hteh//JrZ4vz5DewWF7b1sVpsenyN1eLyrjlsFjPO72Oy
        ODR1L6PF2iN32S2OLRCzaN17hN1BwOPytYvMHltW3mTy2DnrLrvHplWdbB6bl9R77Nzxmcmj
        b8sqRo/Pm+QCOKL0bIryS0tSFTLyi0tslaINLYz0DC0t9IxMLPUMjc1jrYxMlfTtbFJSczLL
        Uov07RL0Mi4s2shU8K664uHvGewNjNOSuxg5OSQETCSWbprI2sXIxSEksJRR4s2+RpYuRg6g
        hJTEyrnpEDXCEn+udbFB1DxllFi2YQJYDZuAnsTatREgNSICKhItm2eygNQwC1xhkVj1sYUV
        JCEsECLR/PsDI4gtJBAsce7+LGYQm0VAVeL5/Q1gDZwCUxklHpzfygSS4BUwl+iaehisWVTA
        UmLLi/vsEHFBiZMzn7CA2MwC2RJfVz9nnsAoMAtJahaS1Cyg+5gFNCXW79KHCGtLLFv4mhnC
        tpVYt+49ywJG1lWMIqmlxbnpucVGesWJucWleel6yfm5mxiB8bzt2M8tOxhXvvqod4iRiYPx
        EKMKUOejDasvMEqx5OXnpSqJ8P55eyNeiDclsbIqtSg/vqg0J7X4EKMp0G8TmaVEk/OBiSav
        JN7QzMDU0MTM0sDU0sxYSZzX5MiaeCGB9MSS1OzU1ILUIpg+Jg5OqQYm12N7OTxtJ/nucbNu
        8Tq+sWO2pduDkh2eCsZHQ8V4q5K81Ke2vD2lc7qx7+zN/AvV+UbHdjM+572358S+9YIep9Vu
        cnOcNxfxKn3fr/1Z/l1+91yOS7OZODQvWr7kUfkezaY1UyKY7btk4qPU818rGDf3Ga/Y/uoc
        X8HLR/9q/K5KZy5nyZSovJyiN6VE6pFzbKLSHMFnJa2Pnx4XtD7iwllboV7VFRufkx6jXlFQ
        ohbc+ztKtzFv3/oTNu5d7BH8008X7io8UjRD7+htd31B5aqONcEFcV/mBn5NXXmR686dpfcT
        V7xK+sJ7UkShj/vUmktz8iINxKbM7ZhhFjHlxxzDxPht+6KNzuhVFSixFGckGmoxFxUnAgCY
        Qpg0fAMAAA==
X-CMS-MailID: 20201216004251eucas1p17b212b74d7382f4dbc0eb9a1955404e7
X-Msg-Generator: CA
X-RootMTR: 20201216004251eucas1p17b212b74d7382f4dbc0eb9a1955404e7
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201216004251eucas1p17b212b74d7382f4dbc0eb9a1955404e7
References: <20201204193702.1e4b0427@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <CGME20201216004251eucas1p17b212b74d7382f4dbc0eb9a1955404e7@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-12-04 pi=C4=85 19:37>, when Jakub Kicinski wrote:
> On Wed,  2 Dec 2020 22:47:09 +0100 =C5=81ukasz Stelmach wrote:
>> ASIX AX88796[1] is a versatile ethernet adapter chip, that can be
>> connected to a CPU with a 8/16-bit bus or with an SPI. This driver
>> supports SPI connection.
>>=20

Before we begin let me emphisize the following sentence

>> The driver has been ported from the vendor kernel for ARTIK5[2]
>> boards.

This means, that there may be parts I am not very confident about. I am
not saying I don't take responsibility for them, far from that. But I am
more then happy, when someone points at them saying they make no
sense. When you ask - Why? And I say - I don't know. That means -
Please, be so kind and help me improve it. OK?

>> Several changes were made to adapt it to the current kernel which
>> include:
>>=20
>> + updated DT configuration,
>> + clock configuration moved to DT,
>> + new timer, ethtool and gpio APIs,
>> + dev_* instead of pr_* and custom printk() wrappers,
>> + removed awkward vendor power managemtn.
>> + introduced ethtool tunable to control SPI compression
>>=20
>> [1]
>> https://protect2.fireeye.com/v1/url?k=3D676ddfd4-38f6e6cb-676c549b-000ba=
bdfecba-4b1c0ca737b1deaa&q=3D1&e=3D0b28bac6-bda4-4cf1-8d38-c5c264b64aca&u=
=3Dhttps%3A%2F%2Fwww.asix.com.tw%2Fproducts.php%3Fop%3DpItemdetail%26PItemI=
D%3D104%3B65%3B86%26PLine%3D65
>> [2]
>> https://protect2.fireeye.com/v1/url?k=3D4148effe-1ed3d6e1-414964b1-000ba=
bdfecba-a257ebdf6f0e18f5&q=3D1&e=3D0b28bac6-bda4-4cf1-8d38-c5c264b64aca&u=
=3Dhttps%3A%2F%2Fgit.tizen.org%2Fcgit%2Fprofile%2Fcommon%2Fplatform%2Fkerne=
l%2Flinux-3.10-artik%2F
>>=20
>> The other ax88796 driver is for NE2000 compatible AX88796L chip. These
>> chips are not compatible. Hence, two separate drivers are required.
>>=20
>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>
>> +	case ETHTOOL_SPI_COMPRESSION:
>> +		if (netif_running(ndev))
>> +			return -EBUSY;
>> +		if ((*(u32 *)data) !=3D 1)
>> +			return -EINVAL;
>> +		ax_local->capabilities &=3D ~AX_CAP_COMP;
>> +		ax_local->capabilities |=3D (*(u32 *)data) =3D=3D 1 ? AX_CAP_COMP : 0;
>
> Since you're just using a single bit of information please use=20
> a private driver flag.
>

Done.

>> +	headroom =3D skb_headroom(skb);
>> +	tailroom =3D skb_tailroom(skb);
>> +	padlen =3D ((pkt_len + 3) & 0x7FC) - pkt_len;
>
> 	round_up(pkt_len, 4) - pkt_len;
>
>> +	tol_len =3D ((pkt_len + 3) & 0x7FC) +
>> +			TX_OVERHEAD + TX_EOP_SIZE + spi_len;
>
> Ditto
>

Done.

>> +	seq_num =3D ++ax_local->seq_num & 0x1F;
>> +
>> +	info =3D (struct tx_pkt_info *)skb->cb;
>> +	info->pkt_len =3D pkt_len;
>> +
>> +	if ((!skb_cloned(skb)) &&
>> +	    (headroom >=3D (TX_OVERHEAD + spi_len)) &&
>> +	    (tailroom >=3D (padlen + TX_EOP_SIZE))) {
>
>> +	} else {
>
> I think you can just use pskb_expand_head() instead of all this
>

Under construction.

>> +		tx_skb =3D alloc_skb(tol_len, GFP_KERNEL);
>> +		if (!tx_skb)
>> +			return NULL;
>> +
>> +		/* Write SPI TXQ header */
>> +		memcpy(skb_put(tx_skb, spi_len), ax88796c_tx_cmd_buf, spi_len);
>> +
>> +		info->seq_num =3D seq_num;
>> +		ax88796c_proc_tx_hdr(info, skb->ip_summed);
>> +
>> +		/* SOP and SEG header */
>> +		memcpy(skb_put(tx_skb, TX_OVERHEAD),
>> +		       &info->sop, TX_OVERHEAD);
>> +
>> +		/* Packet */
>> +		memcpy(skb_put(tx_skb, ((pkt_len + 3) & 0xFFFC)),
>> +		       skb->data, pkt_len);
>> +
>> +		/* EOP header */
>> +		memcpy(skb_put(tx_skb, TX_EOP_SIZE),
>> +		       &info->eop, TX_EOP_SIZE);
>> +
>> +		skb_unlink(skb, q);
>> +		dev_kfree_skb(skb);
>> +	}
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
>> +	skb->truesize =3D skb->len + sizeof(struct sk_buff);
>
> Why do you modify truesize?
>

I don't know. Although uncommon, this appears in a few usb drivers, so I
didn't think much about it when I ported this code.

>> +	skb->protocol =3D eth_type_trans(skb, ax_local->ndev);
>> +
>> +	netif_info(ax_local, rx_status, ndev, "< rx, len %zu, type 0x%x\n",
>> +		   skb->len + sizeof(struct ethhdr), skb->protocol);
>> +
>> +	status =3D netif_rx_ni(skb);
>> +	if (status !=3D NET_RX_SUCCESS)
>> +		netif_info(ax_local, rx_err, ndev,
>> +			   "netif_rx status %d\n", status);
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
>> +	if ((((short)rxhdr->flags_len) & RX_HDR1_PKT_LEN) !=3D
>> +			 (~((short)rxhdr->seq_lenbar) & 0x7FF)) {
>
> Why do you cast these values to signed types?
> Is the casting necessary at all?
>

It is not. Done.

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
>> +	__pskb_trim(rx_skb, len);
>
> Why __pskb_trim? skb_trim() should do.
>

Done.

>> +	return ax88796c_skb_return(ax_local, rx_skb, rxhdr);
>
> please drop the "return", both caller and callee are void.
>

Done.

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
>> +
>> +	skb =3D alloc_skb((w_count * 2), GFP_ATOMIC);
>
> netdev_alloc_skb()
>

Done.

>> +	if (!skb) {
>> +		AX_WRITE(&ax_local->ax_spi, RXBCR1_RXB_DISCARD, P0_RXBCR1);
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
>
>> +static irqreturn_t ax88796c_interrupt(int irq, void *dev_instance)
>> +{
>> +	struct ax88796c_device *ax_local;
>> +	struct net_device *ndev;
>> +
>> +	ndev =3D dev_instance;
>> +	if (!ndev) {
>> +		pr_err("irq %d for unknown device.\n", irq);
>> +		return IRQ_RETVAL(0);
>> +	}
>> +	ax_local =3D to_ax88796c_device(ndev);
>> +
>> +	disable_irq_nosync(irq);
>> +
>> +	netif_dbg(ax_local, intr, ndev, "Interrupt occurred\n");
>> +
>> +	set_bit(EVENT_INTR, &ax_local->flags);
>> +	schedule_work(&ax_local->ax_work);
>> +
>> +	return IRQ_HANDLED;
>> +}
>
> Since you always punt to a workqueue did you consider just using
> threaded interrupts instead?=20

Yes, and I have decided to stay with the workqueue. Interrupt
processing is not the only task performed in the workqueue. There is
also trasmission to the hardware, which may be quite slow (remember, it
is SPI), so it's better decoupled from syscalls

> Also you're not checking if this is actually your devices IRQ that
> triggered. You can't set IRQF_SHARED.

Fixed.

>> +static int
>> +ax88796c_open(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	unsigned long irq_flag =3D IRQF_SHARED;
>> +	int fc =3D AX_FC_NONE;
>> +	int ret;
>> +
>> +	ret =3D request_irq(ndev->irq, ax88796c_interrupt,
>> +			  irq_flag, ndev->name, ndev);
>> +	if (ret) {
>> +		netdev_err(ndev, "unable to get IRQ %d (errno=3D%d).\n",
>> +			   ndev->irq, ret);
>> +		return ret;
>> +	}
>> +
>> +	mutex_lock(&ax_local->spi_lock);
>> +
>> +	ret =3D ax88796c_soft_reset(ax_local);
>> +	if (ret < 0) {
>> +		mutex_unlock(&ax_local->spi_lock);
>> +		return ret;
>
> What frees the IRQ?
>

Fixed.

>> +	}
>> +	ax_local->seq_num =3D 0x1f;
>> +
>> +	ax88796c_set_mac_addr(ndev);
>> +	ax88796c_set_csums(ax_local);
>> +
>> +	/* Disable stuffing packet */
>> +	AX_WRITE(&ax_local->ax_spi,
>> +		 AX_READ(&ax_local->ax_spi, P1_RXBSPCR)
>> +		 & ~RXBSPCR_STUF_ENABLE, P1_RXBSPCR);
>
> Please use a temporary variable or create a RMW helper.
>
>> +	/* Enable RX packet process */
>> +	AX_WRITE(&ax_local->ax_spi, RPPER_RXEN, P1_RPPER);
>> +
>> +	AX_WRITE(&ax_local->ax_spi, AX_READ(&ax_local->ax_spi, P0_FER)
>> +		 | FER_RXEN | FER_TXEN | FER_BSWAP | FER_IRQ_PULL, P0_FER);
>
> Ditto. etc.
>

Done x2.

>> +	ndev =3D devm_alloc_etherdev(&spi->dev, sizeof(*ax_local));
>> +	if (!ndev)
>> +		return -ENOMEM;
>> +
>> +	SET_NETDEV_DEV(ndev, &spi->dev);
>> +
>> +	ax_local =3D to_ax88796c_device(ndev);
>> +	memset(ax_local, 0, sizeof(*ax_local));
>
> No need to zero out netdev priv, it's zalloced.
>

Fixed.

>> +	mutex_lock(&ax_local->spi_lock);
>> +
>> +	/* ax88796c gpio reset */
>> +	ax88796c_hard_reset(ax_local);
>> +
>> +	/* Reset AX88796C */
>> +	ret =3D ax88796c_soft_reset(ax_local);
>> +	if (ret < 0) {
>> +		ret =3D -ENODEV;
>> +		goto err;
>> +	}
>> +	/* Check board revision */
>> +	temp =3D AX_READ(&ax_local->ax_spi, P2_CRIR);
>> +	if ((temp & 0xF) !=3D 0x0) {
>> +		dev_err(&spi->dev, "spi read failed: %d\n", temp);
>> +		ret =3D -ENODEV;
>> +		goto err;
>> +	}
>
> These jump out without releasing the lock.
>

Fixed.

>> +	/* Disable power saving */
>> +	AX_WRITE(&ax_local->ax_spi, (AX_READ(&ax_local->ax_spi, P0_PSCR)
>> +				     & PSCR_PS_MASK) | PSCR_PS_D0, P0_PSCR);
>
> This is asking for a temporary variable or a RMW helper.
>
>> +	u8			plat_endian;
>> +		#define PLAT_LITTLE_ENDIAN	0
>> +		#define PLAT_BIG_ENDIAN		1
>
> Why do you store this little nugget of information?
>

I don't know*. The hardware enables endianness detection by providing a
constant value (0x1234) in one of its registers. Unfortunately I don't
have a big-endian board with this chip to check if it is necessary to
alter AX_READ/AX_WRITE in any way.

>> +/* Tx headers structure */
>> +struct tx_sop_header {
>> +	/* bit 15-11: flags, bit 10-0: packet length */
>> +	u16 flags_len;
>> +	/* bit 15-11: sequence number, bit 11-0: packet length bar */
>> +	u16 seq_lenbar;
>> +} __packed;
>> +
>> +struct tx_segment_header {
>> +	/* bit 15-14: flags, bit 13-11: segment number */
>> +	/* bit 10-0: segment length */
>> +	u16 flags_seqnum_seglen;
>> +	/* bit 15-14: end offset, bit 13-11: start offset */
>> +	/* bit 10-0: segment length bar */
>> +	u16 eo_so_seglenbar;
>> +} __packed;
>> +
>> +struct tx_eop_header {
>> +	/* bit 15-11: sequence number, bit 10-0: packet length */
>> +	u16 seq_len;
>> +	/* bit 15-11: sequence number bar, bit 10-0: packet length bar */
>> +	u16 seqbar_lenbar;
>> +} __packed;
>> +
>> +struct tx_pkt_info {
>> +	struct tx_sop_header sop;
>> +	struct tx_segment_header seg;
>> +	struct tx_eop_header eop;
>> +	u16 pkt_len;
>> +	u16 seq_num;
>> +} __packed;
>> +
>> +/* Rx headers structure */
>> +struct rx_header {
>> +	u16 flags_len;
>> +	u16 seq_lenbar;
>> +	u16 flags;
>> +} __packed;
>
> These all look like multiple of 2 bytes. Why do they need to be packed?
>

These are structures sent to and returned from the hardware. They are
prepended and appended to the network packets. I think it is good to
keep them packed, so compilers won't try any tricks.

>> +u16 axspi_read_reg(struct axspi_data *ax_spi, u8 reg)
>> +{
>> +	int ret;
>> +	int len =3D ax_spi->comp ? 3 : 4;
>> +
>> +	ax_spi->cmd_buf[0] =3D 0x03;	/* OP code read register */
>> +	ax_spi->cmd_buf[1] =3D reg;	/* register address */
>> +	ax_spi->cmd_buf[2] =3D 0xFF;	/* dumy cycle */
>> +	ax_spi->cmd_buf[3] =3D 0xFF;	/* dumy cycle */
>> +	ret =3D spi_write_then_read(ax_spi->spi,
>> +				  ax_spi->cmd_buf, len,
>> +				  ax_spi->rx_buf, 2);
>> +	if (ret)
>> +		dev_err(&ax_spi->spi->dev, "%s() failed: ret =3D %d\n", __func__, ret=
);
>> +	else
>> +		le16_to_cpus(ax_spi->rx_buf);
>> +
>> +	return *(u16 *)ax_spi->rx_buf;
>
> No need to return some specific pattern on failure? Like 0xffff?
>

All registers are 16 bit wide. I am afraid it isn't safe to assume that
there is a 16 bit value we could use. Chances that SPI goes south are
pretty slim. And if it does, there isn't much more than reporting an
error we can do about it anyway.

One thing I can think of is to change axspi_* to (s32), return -1,
somehow (how?) shutdown the device in AX_*.

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl/ZV9sACgkQsK4enJil
gBCzBwgAlsDgnbsx0xY+ke1qQyJO0TDcs6Q8YBh3LUJtd4nrrOKHpcj/OV/LFTvD
vD2w5BpfPeHEJUuDEZ9AjyWGEvd5KYejvIQ/WqZN+tzr/Ilp/PzC9JOGkIhIKktz
W2FmppkiNRXYtQB4/YMlX3IrFOQZr3QBotdy7VqHgvX8Qk0l21O1uC5l7QvnKkPL
qVgiBUdyh+BsK1PEU4a5WP6dNDvDKVgPmXbEQBRNP0RibttmIWhKO5rEDn8Z1lqf
5mfXzJudkIFNzLz6MyFkNF54PnApoKUWf8Rpf2F+IMdOathTEGpB9HZW01MJRICz
dDTtjU+ClFyyTUHuteoTcLKKLYVGNw==
=ypF7
-----END PGP SIGNATURE-----
--=-=-=--
