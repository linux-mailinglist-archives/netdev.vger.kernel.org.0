Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A424D13D7
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 10:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345432AbiCHJvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 04:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbiCHJvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 04:51:38 -0500
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19EF73F32D
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 01:50:41 -0800 (PST)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20220308095037euoutp02fe6332df10c1ac0ff725740ad50b5c9e~aXvj69POc1116811168euoutp02j;
        Tue,  8 Mar 2022 09:50:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20220308095037euoutp02fe6332df10c1ac0ff725740ad50b5c9e~aXvj69POc1116811168euoutp02j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1646733037;
        bh=aqx1X+BDK0O/qlbb/rlZ0HjLO2mQ2qpMTMJUWCNvoh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dkh8y6c9b2Zi6ChhYnUIAX9TXRM7rEL4DLB9aw6sknpuf1/wN7nlO+YFhTjX8QlJl
         Fne/9N4ciSEDpxFZJ2RhNHskX2SaCCPgmAhcvbd5lQ0u5yIYfV44ShaU60SnjmYrbb
         3ovIghhFVqtH3G2LzNjgHjocKpXM+aFULD8YZyOQ=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220308095036eucas1p22600cdf278fbf20c31b033496030390f~aXvjlPP8a0193801938eucas1p2S;
        Tue,  8 Mar 2022 09:50:36 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 58.73.09887.CE627226; Tue,  8
        Mar 2022 09:50:36 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20220308095036eucas1p1a300da96466f8a5363daa998f66ddd47~aXvjKPO9I1960319603eucas1p1c;
        Tue,  8 Mar 2022 09:50:36 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220308095036eusmtrp292fc3fa86eef30c23567f568eb62b56c~aXvjJgrsA0046900469eusmtrp2x;
        Tue,  8 Mar 2022 09:50:36 +0000 (GMT)
X-AuditID: cbfec7f4-471ff7000000269f-5b-622726ec8087
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id B3.65.09404.CE627226; Tue,  8
        Mar 2022 09:50:36 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220308095036eusmtip1fd65761ac9a70cde10bd3e9130832a6e~aXvi9CVr62362123621eusmtip1X;
        Tue,  8 Mar 2022 09:50:36 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 6/9] net: ethernet: Use netif_rx().
Date:   Tue, 08 Mar 2022 10:50:24 +0100
In-Reply-To: <20220303171505.1604775-7-bigeasy@linutronix.de> (Sebastian
        Andrzej Siewior's message of "Thu, 3 Mar 2022 18:15:02 +0100")
Message-ID: <dleftjk0d4pycf.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsWy7djPc7pv1NSTDPo+6FtMuziJ2WLO+RYW
        i/d/hSwubOtjtTi2QMxi86apzBa/J15kc2D32LLyJpPHplWdbB7vzp1j97jzYymjx+dNcgGs
        UVw2Kak5mWWpRfp2CVwZXx89ZinotqjY+fcRYwPjfP0uRg4OCQETicl9dV2MXBxCAisYJT4e
        nsbexcgJ5HxhlGh/wgGR+MwocWfHARaQBEjDmj//mSGKljNK7LjMA1H0nFHi5vYeVpCpbAJ6
        EmvXRoDUiAiYSjRePMQCUsMscJ9R4uzUI2wgNcICDhKfXxiD1LAIqEo8mroMrIZToJNRYt/6
        iawgCV4Bc4nPU36DLRYVsJT48+wjO0RcUOLkzCdgcWaBXImZ598wQhz3hUPi5vJkCNtFYm3j
        IWYIW1ji1fEt7BC2jMT/nfOZIL6vl5g8yQxkr4RAD6PEtjk/oJ60lrhz7hcbRI2jxMUVLBAm
        n8SNt4IQW/kkJm2bzgwR5pXoaBOCaFSRWNe/B2qIlETvqxVQh3lIHJi+lQ0SUhOAofDuNesE
        RoVZSJ6ZheSZWUBjmQU0Jdbv0ocIa0ssW/iaGcK2lVi37j3LAkbWVYziqaXFuempxUZ5qeV6
        xYm5xaV56XrJ+bmbGIEJ6fS/4192MC5/9VHvECMTB+MhRhWg5kcbVl9glGLJy89LVRLhvX9e
        JUmINyWxsiq1KD++qDQntfgQozQHi5I4b3LmhkQhgfTEktTs1NSC1CKYLBMHp1QDk8Js9s0y
        P0Wq7mi1BGyzy4k7ua/lqOO8JfcdfvVH2B01uLctQ6qwWXtK49tltxb2q+wMLf64iXf/m7dT
        XdLiZ1zQYg3aIzXr7fbpAan1b41mJbb5+Xz8e+iNfumeF9I/FjjIJVzMKJJZ+nXTpStan9dM
        6ayavrzP773lOtf22APzzk3/GaJxafFXIwPvfTlrbHuWLxNqcD75QWjueb413+P67GXKg5s1
        BaKbsoOersvyUvK6tnVlUenlODt/WRcffrdjxq92N+/JUGk4q6F/WMJv7fd0rgSxYk2G18oT
        v559vP7l6bdijzw62QSaj6wUnGY6seseL49w8OtpX6+Kdk2+7tSr4PH+kkNag0SRhBJLcUai
        oRZzUXEiAPN8E0vDAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t/xu7pv1NSTDBq7hSymXZzEbDHnfAuL
        xfu/QhYXtvWxWhxbIGaxedNUZovfEy+yObB7bFl5k8lj06pONo93586xe9z5sZTR4/MmuQDW
        KD2bovzSklSFjPziElulaEMLIz1DSws9IxNLPUNj81grI1MlfTublNSczLLUIn27BL2Mr48e
        sxR0W1Ts/PuIsYFxvn4XIyeHhICJxJo//5lBbCGBpYwSr2aEdTFyAMWlJFbOTYcoEZb4c62L
        rYuRC6jkKaPE3Lef2UBq2AT0JNaujQCpEREwlWi8eIgFpIZZ4DGjxN8TDxlBaoQFHCQ+vzCG
        GG8j8e3PWzYQm0VAVeLR1GVg9ZwCnYwS+9ZPZAVJ8AqYS3ye8psFxBYVsJT48+wjO0RcUOLk
        zCdgcWaBbImvq58zT2AUmIUkNQtJahbQamYBTYn1u/QhwtoSyxa+ZoawbSXWrXvPsoCRdRWj
        SGppcW56brGRXnFibnFpXrpecn7uJkZgTG079nPLDsaVrz7qHWJk4mA8xKgC1Plow+oLjFIs
        efl5qUoivPfPqyQJ8aYkVlalFuXHF5XmpBYfYjQF+m0is5Rocj4w2vNK4g3NDEwNTcwsDUwt
        zYyVxHk9CzoShQTSE0tSs1NTC1KLYPqYODilGpgY/ba+nXUq7P9OvsmrjNt5GWKPm+0K2HOv
        cUWGG3uU557CsEqjlb4hK+etdvru4bV3b+r8Oqn2vr9ZR3OfvIyetPxJ4OGOsK8S+wsrNEoS
        Xq+ts5LY2ObQkvDs2vniiRNeMKo7prsLZoZN9rZW8d3hxb/g+0ymxw+e3mczuLVyfh9LNgfn
        rnsbX7k171o3l/fZLSbzi348GwrYzdxPC0z34L9YK15w1vauXXOIb2fiYft19xvdHN13rMjk
        Dth/U6h+n1OzTazNW+cq9inzNrxUfpd6uFtKJTs88funGZc3MyUraHj3XZ27+5vIQwbvpZ+S
        HCWeBqxcl/0p52a70aX5+/oPdYZMcAqrcy4q0lRiKc5INNRiLipOBAD0U+4qPgMAAA==
X-CMS-MailID: 20220308095036eucas1p1a300da96466f8a5363daa998f66ddd47
X-Msg-Generator: CA
X-RootMTR: 20220308095036eucas1p1a300da96466f8a5363daa998f66ddd47
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220308095036eucas1p1a300da96466f8a5363daa998f66ddd47
References: <20220303171505.1604775-7-bigeasy@linutronix.de>
        <CGME20220308095036eucas1p1a300da96466f8a5363daa998f66ddd47@eucas1p1.samsung.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2022-03-03 czw 18:15>, when Sebastian Andrzej Siewior wrote:
> Since commit
>    baebdf48c3600 ("net: dev: Makes sure netif_rx() can be invoked in any =
context.")
>
> the function netif_rx() can be used in preemptible/thread context as
> well as in interrupt context.
>
> Use netif_rx().
>
> Cc: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
> Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
> Cc: UNGLinuxDriver@microchip.com
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/net/ethernet/asix/ax88796c_main.c             | 2 +-
>  drivers/net/ethernet/davicom/dm9051.c                 | 2 +-
>  drivers/net/ethernet/micrel/ks8851_spi.c              | 2 +-
>  drivers/net/ethernet/microchip/enc28j60.c             | 2 +-
>  drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 2 +-
>  drivers/net/ethernet/qualcomm/qca_spi.c               | 2 +-
>  drivers/net/ethernet/qualcomm/qca_uart.c              | 2 +-
>  drivers/net/ethernet/vertexcom/mse102x.c              | 2 +-
>  drivers/net/ethernet/wiznet/w5100.c                   | 2 +-
>  9 files changed, 9 insertions(+), 9 deletions(-)
>

Acked-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>

> diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethe=
rnet/asix/ax88796c_main.c
> index bf70481bb1cad..6ba5b024a7be7 100644
> --- a/drivers/net/ethernet/asix/ax88796c_main.c
> +++ b/drivers/net/ethernet/asix/ax88796c_main.c
> @@ -433,7 +433,7 @@ ax88796c_skb_return(struct ax88796c_device *ax_local,
>  	netif_info(ax_local, rx_status, ndev, "< rx, len %zu, type 0x%x\n",
>  		   skb->len + sizeof(struct ethhdr), skb->protocol);
>=20=20
> -	status =3D netif_rx_ni(skb);
> +	status =3D netif_rx(skb);
>  	if (status !=3D NET_RX_SUCCESS && net_ratelimit())
>  		netif_info(ax_local, rx_err, ndev,
>  			   "netif_rx status %d\n", status);
> diff --git a/drivers/net/ethernet/davicom/dm9051.c b/drivers/net/ethernet=
/davicom/dm9051.c
> index 8ebcb35bbc0e1..a523ddda76093 100644
> --- a/drivers/net/ethernet/davicom/dm9051.c
> +++ b/drivers/net/ethernet/davicom/dm9051.c
> @@ -804,7 +804,7 @@ static int dm9051_loop_rx(struct board_info *db)
>  		skb->protocol =3D eth_type_trans(skb, db->ndev);
>  		if (db->ndev->features & NETIF_F_RXCSUM)
>  			skb_checksum_none_assert(skb);
> -		netif_rx_ni(skb);
> +		netif_rx(skb);
>  		db->ndev->stats.rx_bytes +=3D rxlen;
>  		db->ndev->stats.rx_packets++;
>  		scanrr++;
> diff --git a/drivers/net/ethernet/micrel/ks8851_spi.c b/drivers/net/ether=
net/micrel/ks8851_spi.c
> index d167d93e4c12f..82d55fc27edc6 100644
> --- a/drivers/net/ethernet/micrel/ks8851_spi.c
> +++ b/drivers/net/ethernet/micrel/ks8851_spi.c
> @@ -293,7 +293,7 @@ static void ks8851_wrfifo_spi(struct ks8851_net *ks, =
struct sk_buff *txp,
>   */
>  static void ks8851_rx_skb_spi(struct ks8851_net *ks, struct sk_buff *skb)
>  {
> -	netif_rx_ni(skb);
> +	netif_rx(skb);
>  }
>=20=20
>  /**
> diff --git a/drivers/net/ethernet/microchip/enc28j60.c b/drivers/net/ethe=
rnet/microchip/enc28j60.c
> index db5a3edb4c3c0..559ad94a44d03 100644
> --- a/drivers/net/ethernet/microchip/enc28j60.c
> +++ b/drivers/net/ethernet/microchip/enc28j60.c
> @@ -975,7 +975,7 @@ static void enc28j60_hw_rx(struct net_device *ndev)
>  			/* update statistics */
>  			ndev->stats.rx_packets++;
>  			ndev->stats.rx_bytes +=3D len;
> -			netif_rx_ni(skb);
> +			netif_rx(skb);
>  		}
>  	}
>  	/*
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/driv=
ers/net/ethernet/microchip/lan966x/lan966x_main.c
> index 4e877d9859bff..ad310c95bf5c9 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> @@ -600,7 +600,7 @@ static irqreturn_t lan966x_xtr_irq_handler(int irq, v=
oid *args)
>  				skb->offload_fwd_mark =3D 0;
>  		}
>=20=20
> -		netif_rx_ni(skb);
> +		netif_rx(skb);
>  		dev->stats.rx_bytes +=3D len;
>  		dev->stats.rx_packets++;
>=20=20
> diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethern=
et/qualcomm/qca_spi.c
> index 3c5494afd3c04..c865a4be05eec 100644
> --- a/drivers/net/ethernet/qualcomm/qca_spi.c
> +++ b/drivers/net/ethernet/qualcomm/qca_spi.c
> @@ -435,7 +435,7 @@ qcaspi_receive(struct qcaspi *qca)
>  				qca->rx_skb->protocol =3D eth_type_trans(
>  					qca->rx_skb, qca->rx_skb->dev);
>  				skb_checksum_none_assert(qca->rx_skb);
> -				netif_rx_ni(qca->rx_skb);
> +				netif_rx(qca->rx_skb);
>  				qca->rx_skb =3D netdev_alloc_skb_ip_align(net_dev,
>  					net_dev->mtu + VLAN_ETH_HLEN);
>  				if (!qca->rx_skb) {
> diff --git a/drivers/net/ethernet/qualcomm/qca_uart.c b/drivers/net/ether=
net/qualcomm/qca_uart.c
> index 27c4f43176aaa..26646cb6a20a6 100644
> --- a/drivers/net/ethernet/qualcomm/qca_uart.c
> +++ b/drivers/net/ethernet/qualcomm/qca_uart.c
> @@ -108,7 +108,7 @@ qca_tty_receive(struct serdev_device *serdev, const u=
nsigned char *data,
>  			qca->rx_skb->protocol =3D eth_type_trans(
>  						qca->rx_skb, qca->rx_skb->dev);
>  			skb_checksum_none_assert(qca->rx_skb);
> -			netif_rx_ni(qca->rx_skb);
> +			netif_rx(qca->rx_skb);
>  			qca->rx_skb =3D netdev_alloc_skb_ip_align(netdev,
>  								netdev->mtu +
>  								VLAN_ETH_HLEN);
> diff --git a/drivers/net/ethernet/vertexcom/mse102x.c b/drivers/net/ether=
net/vertexcom/mse102x.c
> index 25739b182ac7b..eb39a45de0121 100644
> --- a/drivers/net/ethernet/vertexcom/mse102x.c
> +++ b/drivers/net/ethernet/vertexcom/mse102x.c
> @@ -362,7 +362,7 @@ static void mse102x_rx_pkt_spi(struct mse102x_net *ms=
e)
>  		mse102x_dump_packet(__func__, skb->len, skb->data);
>=20=20
>  	skb->protocol =3D eth_type_trans(skb, mse->ndev);
> -	netif_rx_ni(skb);
> +	netif_rx(skb);
>=20=20
>  	mse->ndev->stats.rx_packets++;
>  	mse->ndev->stats.rx_bytes +=3D rxlen;
> diff --git a/drivers/net/ethernet/wiznet/w5100.c b/drivers/net/ethernet/w=
iznet/w5100.c
> index ae24d6b868031..4fd7c39e11233 100644
> --- a/drivers/net/ethernet/wiznet/w5100.c
> +++ b/drivers/net/ethernet/wiznet/w5100.c
> @@ -883,7 +883,7 @@ static void w5100_rx_work(struct work_struct *work)
>  	struct sk_buff *skb;
>=20=20
>  	while ((skb =3D w5100_rx_skb(priv->ndev)))
> -		netif_rx_ni(skb);
> +		netif_rx(skb);
>=20=20
>  	w5100_enable_intr(priv);
>  }

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmInJuAACgkQsK4enJil
gBDhigf+IJQO6/lFqQLtT3c+iS7GEkU2denJCR/NL6gliFi7K7BCLgBjhPKr6L4k
8QurQzq5Zo262dV4fVJdXM9Oxc8MBrq0pWQLx+X1OMbR9Z0C4wuxhpD7OljAy6Py
xjyjShxTHBa0HBPMbaNqoKBVFFXxgQryvcMppsoQvi9VnWZtpLtAYzXfUCJlP39K
7WFfQvIPMEjPbbspjP4gbhzrxbw7DLQ+jG9rkWScZhfcYZxzK3c4AkjdG8qRc/Eg
NDaZbtB9SHva+ObV57qkS9uqOrXquvkT636i3Og3BXhIGb0x0hLSyS4KQbGaE6IF
DDnysJre/X1zi1Sos3g6LDoZQbpD5A==
=8nj7
-----END PGP SIGNATURE-----
--=-=-=--
