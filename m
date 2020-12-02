Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825362CBAED
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 11:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729538AbgLBKrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 05:47:40 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:38748 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729412AbgLBKrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 05:47:39 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201202104646euoutp02f16d7a136bd79de66091c4600c4b2201~M4H-iwpfB3095630956euoutp02R;
        Wed,  2 Dec 2020 10:46:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201202104646euoutp02f16d7a136bd79de66091c4600c4b2201~M4H-iwpfB3095630956euoutp02R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1606906006;
        bh=TeKWjQ2OAMOu2A59mJW7atRFhrOO69NwcJ90k863xGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i2gw6wcTGue5b+E/McXoSCMm9TsJGWaAY2P0cZVEOAafFZtm0wOZPeZymotXtdG1P
         reRpgzjqcK5+A1V//Dos+vaCbX0IRmIMOam+eZTrjAqVn6uZoH62iy3WCYjQvZ/TzN
         NQGUvg9NteF0QKciFZLh5jUi59IBZR2tELzFWYho=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201202104646eucas1p1884aa5a33e80b7b52712e9e13bcd1517~M4H-FnQUn2629126291eucas1p13;
        Wed,  2 Dec 2020 10:46:46 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 66.7E.45488.69077CF5; Wed,  2
        Dec 2020 10:46:46 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201202104645eucas1p25335c0b07b106f932006f2a5bce88b6e~M4H_gdJYy2857528575eucas1p22;
        Wed,  2 Dec 2020 10:46:45 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201202104645eusmtrp1592dde863c8588d91afba1c5915be88f~M4H_fh0KZ0723107231eusmtrp1u;
        Wed,  2 Dec 2020 10:46:45 +0000 (GMT)
X-AuditID: cbfec7f5-c5fff7000000b1b0-90-5fc770969b66
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id FF.1B.21957.59077CF5; Wed,  2
        Dec 2020 10:46:45 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201202104645eusmtip18ee36f7913c027a205fb6acbadd4d4ac~M4H_RaVgr2574125741eusmtip1L;
        Wed,  2 Dec 2020 10:46:45 +0000 (GMT)
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
Subject: Re: [PATCH v7 3/3] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Date:   Wed, 02 Dec 2020 11:46:28 +0100
In-Reply-To: <20201125132621.628ac98b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Wed, 25 Nov 2020 13:26:21 -0800")
Message-ID: <dleftj8sageb97.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sf1CTdRjnu/fHXnZuvU7Ih0WcLeg0T4jDkxf7cXRhvpYWl4he14VL3hgn
        jLWxYJ4X3EWoKGwym9skwTTC4X64ESdDPG8tFz9i/AhOO0jTOmlGCKuT6LKYL17+93mez+fz
        PJ/ne18Kk84RMqpYVc5pVIoSOSnCO6/8FVpnVgcLnqs+LGVCk36MOW9xEUxTqAZnmgODBPP5
        jIVgxqcnCMZw6w7GhEJuITPU2UAwnlvjBDPqayIZS+iSgPF/2oMYR2BSyFxpeZz5pCcgzKbZ
        0fFhjO04e03AdtkmhazHfohkvWeq2K4LEQHb0GFHbMSTlEu9LXqhkCsp/pDTpL20W6Q0eI9i
        6vmEymstfUQ1csbXoVgK6PUw5XWQdUhESek2BO0TLUK++APBebNZwBcRBGH3oOChxeqdQTzx
        JYKBH9qW/LcRuK3WRRVFkXQqOBy7ooY4OhlqvFY8qsHoYRxchyN4lFhB50PjgoOIYpxOgdPd
        f2NRUSxtRjDWasGihJjOhHt9YRTF8XQWdExdF/L95dBr/fnBIIwuBWvotweRgB6JhWaPl+Cz
        5sCp+n8Rj1dAONgh5HEi9JuO4NGkQFeBqXED7z2CoLNpHuc1z8PE4ALJ45ch4uwmeL0Erk4v
        5/dKoLHzOMa3xXCwVsqrk8FpuLg0RQb14balBCz4+r/+/+Xq/N8iI1ple+Qc2yPn2BbHYvQa
        cPnS+PZaaD11B+Pxi+B0zuAtiLCjlZxOW1rEaTNUXEWqVlGq1amKUveUlXrQ4lfsvx/88wJq
        C8+m+pGAQn6UvGi+6W4fQjJcVabi5HFi/H6gQCouVOj3cZqyAo2uhNP60RMULl8p9n11rkBK
        FynKub0cp+Y0D1kBFSurFkCKU+qY3rzs5LFzrqt64+7ijLlLwzvf1HnfgTeeHDCdHCYzXX37
        g/qAOqE+0vWTZofbH7lcWbE+uzBhY63cMpc7G2luLXt3dmSD6bOknLE81e3tyoWtMb8a0j9m
        2+MSjR+9VXRRnXnAYzimP0TOP/bq8UxHxZBf8sV7NsOPa74bNOZ/H3Pj7lqdaHW2WPqBr7w3
        I/fonom04N60mB2v3z3DdOv3x8uWQc2+9CzJbNYUs803smn1U5dvyJ75Z+CXxN7fnZvyfO+n
        vLL9Hmmu2tKg/GbhQGH7nPn66YOvGc/ukqprsS2j6+ZzSEkcUbgq/+kTkxnFPTn2PLto58ab
        28ZMyqRKOa5VKtKfxTRaxX+EMyoGBQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t/xu7pTC47HG/yYqWNx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2qx6fE1VovLu+awWcw4v4/J
        4tDUvYwWa4/cZbc4tkDMonXvEXYHAY/L1y4ye2xZeZPJY+esu+wem1Z1snlsXlLvsXPHZyaP
        vi2rGD0+b5IL4IjSsynKLy1JVcjILy6xVYo2tDDSM7S00DMysdQzNDaPtTIyVdK3s0lJzcks
        Sy3St0vQy+jfPJG54Idkxc0Fp1gbGNeJdjFyckgImEjM3PyesYuRi0NIYCmjxIMJs4EcDqCE
        lMTKuekQNcISf651sUHUPGWUeNTwnh2khk1AT2Lt2giQGhEBFYmWzTNZQGqYBa6wSKz62MIK
        khAWCJHY0NjOCGILCQRLNO2YzQZiswioSize/ZsZpIFTYBqjxNVlM5hBErwC5hLfT70CaxAV
        sJTY8uI+O0RcUOLkzCcsIDazQLbE19XPmScwCsxCkpqFJDUL6D5mAU2J9bv0IcLaEssWvmaG
        sG0l1q17z7KAkXUVo0hqaXFuem6xoV5xYm5xaV66XnJ+7iZGYDxvO/Zz8w7Gea8+6h1iZOJg
        PMSoAtT5aMPqC4xSLHn5ealKIrws/47EC/GmJFZWpRblxxeV5qQWH2I0BfptIrOUaHI+MNHk
        lcQbmhmYGpqYWRqYWpoZK4nzbp27Jl5IID2xJDU7NbUgtQimj4mDU6qBKcPxSWjFZ2F5r20c
        026cmMk19RjHkivupdovjjfsOL3/S/fZE/YhjxbrWPqcmhfzUK9XKK08YcXM1BD/yJK65O2H
        zx7bePP5uWnZr6897Knf2dEWu0pj8crMLV5bly16dGLny5/7rzZbqKkvvqqbUavpna223X3x
        /m/RJ/su7U3R3LbRtyTU+v9izsjGbA0ZE8ae0zedHl4JdDL7cvPR39m3n8YVbNbsPm69s1ZJ
        IYz7w4uFPV+UPSTXmu2R7nnKvGatoNbKJSHGi/LaPguyiB+SaOjIa+h8autoVuyVc6Gi+wR7
        bsk7n8AOuzSRF57LzdiP/PFsDdP5xx/eJ9LevnvdiRkLrVYH/uiRnuLwT4mlOCPRUIu5qDgR
        AN7AxN18AwAA
X-CMS-MailID: 20201202104645eucas1p25335c0b07b106f932006f2a5bce88b6e
X-Msg-Generator: CA
X-RootMTR: 20201202104645eucas1p25335c0b07b106f932006f2a5bce88b6e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201202104645eucas1p25335c0b07b106f932006f2a5bce88b6e
References: <20201125132621.628ac98b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CGME20201202104645eucas1p25335c0b07b106f932006f2a5bce88b6e@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-11-25 =C5=9Bro 13:26>, when Jakub Kicinski wrote:
> On Tue, 24 Nov 2020 13:03:30 +0100 =C5=81ukasz Stelmach wrote:
>> +static int
>> +ax88796c_start_xmit(struct sk_buff *skb, struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +
>> +	skb_queue_tail(&ax_local->tx_wait_q, skb);
>> +	if (skb_queue_len(&ax_local->tx_wait_q) > TX_QUEUE_HIGH_WATER) {
>> +		netif_err(ax_local, tx_queued, ndev,
>> +			  "Too many TX packets in queue %d\n",
>> +			  skb_queue_len(&ax_local->tx_wait_q));
>
> This will probably happen under heavy traffic. No need to print errors,
> it's normal to back pressure.
>

Removed.

>> +		netif_stop_queue(ndev);
>> +	}
>> +
>> +	set_bit(EVENT_TX, &ax_local->flags);
>> +	schedule_work(&ax_local->ax_work);
>> +
>> +	return NETDEV_TX_OK;
>> +}
>> +
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
>> +	skb->protocol =3D eth_type_trans(skb, ax_local->ndev);
>> +
>> +	netif_info(ax_local, rx_status, ndev, "< rx, len %zu, type 0x%x\n",
>> +		   skb->len + sizeof(struct ethhdr), skb->protocol);
>> +
>> +	status =3D netif_rx(skb);
>
> If I'm reading things right this is in process context, so netif_rx_ni()
>

Is it? The stack looks as follows

    ax88796c_skb_return()
    ax88796c_rx_fixup()
    ax88796c_receive()
    ax88796c_process_isr()
    ax88796c_work()

and ax88796c_work() is a scheduled in the system_wq.

>> +	if (status !=3D NET_RX_SUCCESS)
>> +		netif_info(ax_local, rx_err, ndev,
>> +			   "netif_rx status %d\n", status);
>
> Again, it's inadvisable to put per packet prints without any rate
> limiting in the data path.

Even if limmited by the msglvl flag, which is off by default?

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl/HcIQACgkQsK4enJil
gBBN7wgAlX2fLw6725RegHggjpDKRYFPk5jJKKk6hw+qlGwk1G3sIOQ+hInxHpb+
zT49SxB8Br71+x7xK+kX3lwAMUORG3KglYPzR1zoYHsnBEW/wfBYpnvswn/eLzW6
/xGA/p/J4ekcGlowceuxawfABxUbuhIMaoogZzRtibQ/NB0jW1fhpp1XwWYTDhHp
0tWG0qbY+849vDJt35PphNbumIWMSBItRJwGJeH7+xQL3AzSLWO41OnyETV6aCFs
yOB2NwBD2xX5jRhFty+Sxa1D13OWg1WVQ+TkzIijVTRm4Uzn8NQoqS37QLpepuJC
R01E2mSsLBdYk4lgfVbH5Z/edpKjSw==
=n65j
-----END PGP SIGNATURE-----
--=-=-=--
