Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449A829EC82
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 14:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgJ2NKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 09:10:25 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56813 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgJ2NKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 09:10:25 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201029131012euoutp025f5817b3d82340b7163eba3882ac70bc~CeJg9P3VV2725427254euoutp02i;
        Thu, 29 Oct 2020 13:10:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201029131012euoutp025f5817b3d82340b7163eba3882ac70bc~CeJg9P3VV2725427254euoutp02i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603977012;
        bh=GhdLDQRYReg/k6n/Wulo3NxMsdJbsZSIJ8BM7RMo+cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gEqdf0R8cCn+4HmvQW90clgioJS9yxol6tGKKNLn4vN9hG9gDCvQk7h/oG0cMo5Zs
         iWtu5h9p5NLwvTR4vQX3gh8Ohuf4Z4DBp5mE0M7qc4Cect74FiWLmaSOmmPjumzLD8
         RY4w44YYo1fY9WVJ6rxUoz9fjYoOHPZWylk5xi7s=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201029131012eucas1p280ec12a8754c91843acf1a110e0c4ca2~CeJggUuL32721827218eucas1p27;
        Thu, 29 Oct 2020 13:10:12 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 7E.94.05997.33FBA9F5; Thu, 29
        Oct 2020 13:10:11 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201029131011eucas1p1194c5614ca8f5d3835f888c8d1c09fa1~CeJf_A4m60958109581eucas1p1A;
        Thu, 29 Oct 2020 13:10:11 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201029131011eusmtrp14ffa1a08aa2502792f1e9970f0dba190~CeJf8qyEM2317423174eusmtrp1-;
        Thu, 29 Oct 2020 13:10:11 +0000 (GMT)
X-AuditID: cbfec7f4-677ff7000000176d-25-5f9abf331f16
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id C8.0D.06017.33FBA9F5; Thu, 29
        Oct 2020 13:10:11 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201029131011eusmtip2506d73c0f4bd00c0486ad70f93b75ade~CeJfuBJPa0532105321eusmtip2T;
        Thu, 29 Oct 2020 13:10:11 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     jim.cromie@gmail.com, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
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
Subject: Re: [PATCH v4 3/5] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Date:   Thu, 29 Oct 2020 14:09:57 +0100
In-Reply-To: <20201029003131.GF933237@lunn.ch> (Andrew Lunn's message of
        "Thu, 29 Oct 2020 01:31:31 +0100")
Message-ID: <dleftjwnz9uqje.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHe3fO2Y7S5LQuPqyIHPXBLl4y6jUrutIJAutLiWA282AXN2tH
        7UY3ZqFlFmo410JnlmZ4zYZamswxEWuzTKnUpNS0rZDSym6S81Xo2+//XP7P87y8LKX4yyjZ
        Q9pEQadVx6uk3rTF/tOxIuSJMTrIXhyGnT1WClcayhlscqbQOM/mYHDBsIHBnZ+7GXytz01h
        p7NChtssGQyu6utkcHudSYoNzgYJtt6oR7jU1iPD9vx5+GK9TbaR49s7n1N89b3XEr7W2CPj
        q0rSpPyDwnN8bc2IhM+oLkH8SNXCXWyk97pYIf5QsqAL3LDf+6CrvVlyVO9/orLBRJ1H9/wu
        Iy8WuFVwOy+FuYy8WQVXjMBWa6aJGEVg7yiWETGCoD61Szrd8iTdLCWJIgRfcx4hIgYR1Fm/
        TQiWlXIBUFoa4WmYwy2C7JY/jIcproOGbEush2dze8D25aHMwzS3BN7k6CcHeHEa6H1eI/Gw
        nFsDaaYvlIfncqFQPdQrI/FZ0JLbTxNPDeQ6P03uAJyZBUfWAEU23Qqmp1kM4dngaq6WEV4A
        rVnptGdP4M5BVuZq0puOwGIao0lNGHQ7fk1dvAluVt6UknofePV5FpnrA5mWHIqE5ZB6SUGq
        F0PZtcdTLkq46ipGhHn40T429boXEAw0WaXX0SLjf+cY/zvHOGFLcf5QXhdIwsvgrtlNEV4P
        ZWXDdD5iSpCvkCRq4gRxpVY4HiCqNWKSNi7gQIKmCk18xNbx5tEaVPcnxoo4Fqlmytu6cqMV
        jDpZPKmxosUTTu8r7rchJa1N0AqqOfLNz1r3KeSx6pOnBF1CtC4pXhCtaD5Lq3zlIQUfoxRc
        nDpROCIIRwXddFbCeinPo51j4fFn9cqow5XhY9nfQw0Fx7ab9f1XHkYGOQ7zo5u2dOEz+UVN
        2tV5P2bk789JaXzbs3bcfePYnVcfC07j/iuDig/BqPbFuwr71d9+A+tKtx3Zpk90vlmvbciO
        2TE0w2UI00dEUGLRrbbde2t8kvyCWwpbI5fva3RnDr/wDRoMf6mixYPq4KWUTlT/AyMvbViQ
        AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t/xe7rG+2fFG2x/JGpx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2qx6fE1VovLu+awWcw4v4/J
        4tDUvYwWa4/cZbc4tkDMonXvEXYHAY/L1y4ye2xZeZPJY+esu+wem1Z1snlsXlLvsXPHZyaP
        vi2rGD0+b5IL4IjSsynKLy1JVcjILy6xVYo2tDDSM7S00DMysdQzNDaPtTIyVdK3s0lJzcks
        Sy3St0vQy3h1+ThTQbNmxcZ9c5gbGFcqdjFyckgImEjs71nIBmILCSxllFjWUtTFyAEUl5JY
        OTcdokRY4s+1LqASLqCSp4wSd+7sZwGpYRPQk1i7NgKkRkRAQWLKyT+sIDXMAjdYJB5NWswM
        khAWCJFYdPAGI0i9kICuxKRWH5Awi4CqxK3pzWBrOQVyJda9388KYvMKmEt0zvkI1ioqYCmx
        5cV9doi4oMTJmU9YQGxmgWyJr6ufM09gFJiFJDULSWoW0DZmAU2J9bv0IcLaEssWvmaGsG0l
        1q17z7KAkXUVo0hqaXFuem6xkV5xYm5xaV66XnJ+7iZGYCRvO/Zzyw7GrnfBhxgFOBiVeHgv
        3J4ZL8SaWFZcmXuIUQVozKMNqy8wSrHk5eelKonwOp09HSfEm5JYWZValB9fVJqTWnyI0RTo
        z4nMUqLJ+cDkk1cSb2hqaG5haWhubG5sZqEkztshcDBGSCA9sSQ1OzW1ILUIpo+Jg1OqgXHq
        i7o9/c5TtJocHQK5rscuDvdoDZvE/2FSa57urDfdWjl1aRk2E3bkWUZunKm6SnB67Y/ZG0qv
        JwrM1XFSnNLrI1CaO+8Py5WY2DLPlpUKbq3tGplTf5QcUbXVnrLfTf6b/6rlEq7Np6clzix8
        qfl+0cwAebdZyqrlH7XNHl0/UrDRWPVxiBJLcUaioRZzUXEiAE7o2k8GAwAA
X-CMS-MailID: 20201029131011eucas1p1194c5614ca8f5d3835f888c8d1c09fa1
X-Msg-Generator: CA
X-RootMTR: 20201029131011eucas1p1194c5614ca8f5d3835f888c8d1c09fa1
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201029131011eucas1p1194c5614ca8f5d3835f888c8d1c09fa1
References: <20201029003131.GF933237@lunn.ch>
        <CGME20201029131011eucas1p1194c5614ca8f5d3835f888c8d1c09fa1@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-10-29 czw 01:31>, when Andrew Lunn wrote:
>> +static void
>> +ax88796c_get_regs(struct net_device *ndev, struct ethtool_regs *regs, v=
oid *_p)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	u16 *p =3D _p;
>> +	int offset, i;
>
> You missed a reverse christmass tree fix here.
>

Done.

>> +static int comp;
>> +static int msg_enable =3D NETIF_MSG_PROBE |
>> +			NETIF_MSG_LINK |
>> +			/* NETIF_MSG_TIMER | */
>> +			/* NETIF_MSG_IFDOWN | */
>> +			/* NETIF_MSG_IFUP | */
>> +			NETIF_MSG_RX_ERR |
>> +			NETIF_MSG_TX_ERR |
>> +			/* NETIF_MSG_TX_QUEUED | */
>> +			/* NETIF_MSG_INTR | */
>> +			/* NETIF_MSG_TX_DONE | */
>> +			/* NETIF_MSG_RX_STATUS | */
>> +			/* NETIF_MSG_PKTDATA | */
>> +			/* NETIF_MSG_HW | */
>> +			/* NETIF_MSG_WOL | */
>> +			0;
>
> You should probably delete anything which is commented out.
>

Done.

>> +
>> +static char *no_regs_list =3D "80018001,e1918001,8001a001,fc0d0000";
>> +unsigned long ax88796c_no_regs_mask[AX88796C_REGDUMP_LEN / (sizeof(unsi=
gned long) * 8)];
>> +
>> +module_param(comp, int, 0444);
>> +MODULE_PARM_DESC(comp, "0=3DNon-Compression Mode, 1=3DCompression Mode"=
);
>
> I think you need to find a different way to configure this. How much
> does compression bring you anyway?
>

Anything between almost 0 for large transfers, to 50 for tiniest. ~5%
for ~500 byte transfers. Considering the chip is rather for small
devices, that won't transfer large amounts of data, I'd rather keep some
way to control it.

>> +module_param(msg_enable, int, 0444);
>> +MODULE_PARM_DESC(msg_enable, "Message mask (see linux/netdevice.h for b=
itmap)");
>
> I know a lot of drivers have msg_enable, but DaveM is generally
> against module parameters. So i would remove this.
>

These two parameters have something in common: no(?) other way to pass
the information at the right time. Compression might be tuned in
runtime, if there is an interface (via ethtool?) for setting custom
knobs? Ther is such interface for msg_level level but it can be used
before a device is probed and userland is running. Hence, there is no
way to control msg_level during boot. I can remove those parameters, but
I really would like to be able to control these parameter, especially
msg_level during boot. If there is any other way, do let me know.

>> +static void ax88796c_set_hw_multicast(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	u16 rx_ctl =3D RXCR_AB;
>> +	int mc_count =3D netdev_mc_count(ndev);
>
> reverse christmass tree.
>

Done.

>> +static struct sk_buff *
>> +ax88796c_tx_fixup(struct net_device *ndev, struct sk_buff_head *q)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	struct sk_buff *skb, *tx_skb;
>> +	struct tx_pkt_info *info;
>> +	struct skb_data *entry;
>> +	int headroom;
>> +	int tailroom;
>> +	u8 need_pages;
>> +	u16 tol_len, pkt_len;
>> +	u8 padlen, seq_num;
>> +	u8 spi_len =3D ax_local->ax_spi.comp ? 1 : 4;
>
> reverse christmass tree.
>

Done.

>> +static int ax88796c_receive(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	struct sk_buff *skb;
>> +	struct skb_data *entry;
>> +	u16 w_count, pkt_len;
>> +	u8 pkt_cnt;
>
> Reverse christmass tree
>

Done.

>> +
>> +static int ax88796c_process_isr(struct ax88796c_device *ax_local)
>> +{
>> +	u16 isr;
>> +	u8 done =3D 0;
>> +	struct net_device *ndev =3D ax_local->ndev;
>
> ...
>

Done.

>> +static irqreturn_t ax88796c_interrupt(int irq, void *dev_instance)
>> +{
>> +	struct net_device *ndev =3D dev_instance;
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>
> ...
>

Done.

>> +static int
>> +ax88796c_open(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	int ret;
>> +	unsigned long irq_flag =3D IRQF_SHARED;
>> +	int fc =3D AX_FC_NONE;
>
> ...
>

Done.

>> +static int ax88796c_probe(struct spi_device *spi)
>> +{
>> +	struct net_device *ndev;
>> +	struct ax88796c_device *ax_local;
>> +	char phy_id[MII_BUS_ID_SIZE + 3];
>> +	int ret;
>> +	u16 temp;
>
> ...
>

Done.

> The mdio/phy/ethtool code looks O.K. now. I've not really looked at
> any of the frame transfer code, so i cannot comment on that.
>
>     Andrew
>
>

Thanks.

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl+avyYACgkQsK4enJil
gBCBMwf9FnD8E89ec3soQSzXByQAO6P8tm2DCbrdWpJDtt+llFnrA6h087U7EBmk
Qy/Wd/hPuhBjeNUYeX0BxJL3SHEFixlk2M18HFCJzTNbpBof7sYra9iB/q6NF/b9
Cs+ga5m/hfLpdSqVmQdsFiWwxCpjldB5htjBOzc7cnMnCkVPKJ+Cw4/KwYFlnGOR
F9TAPzugNnG2AH9JlOwBTZp/J6jTRlAp/naXssYWcWwJVSutidjyFJ472eElBkU/
2q13sSwY98lR6bYlvsGEV5XFIWFiSaLNJq3rUYelbojDR3E7ZO3opbzdogn0ROxY
MvqWStI2o5TBCDiHwp1RePhF6LdunA==
=n2/L
-----END PGP SIGNATURE-----
--=-=-=--
