Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26297290C2B
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 21:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410671AbgJPTTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 15:19:25 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:48271 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393083AbgJPTTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 15:19:24 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201016191912euoutp0255ae5b1dc6af9cc42961c6a5415eb66c~_jy_fovJt0912809128euoutp02Q;
        Fri, 16 Oct 2020 19:19:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201016191912euoutp0255ae5b1dc6af9cc42961c6a5415eb66c~_jy_fovJt0912809128euoutp02Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1602875952;
        bh=79Ih4rNjifJnvzxSaVZe5NbN9xFlxjqnv7x4cIAYt6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YpGF5USubzsySPqgtY/SycVNhza9L5RK6dWA6KRdgbd1dkRlRS3XmgLsnJLjJpC06
         z7d3eP9T3vHzmkQT59qyIj988rUnC+9fv+IBnfHooV7HuWZmkDeESVBgjD5G8eCGET
         +8K+3ZD+bq1rd8vwmXxs27xmYpJAYYM1y6lmCWSo=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201016191906eucas1p18d3fbf7d9bd9b4e52522102784d4bf05~_jy5BL-ao1037210372eucas1p13;
        Fri, 16 Oct 2020 19:19:06 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 13.54.06456.A22F98F5; Fri, 16
        Oct 2020 20:19:06 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201016191905eucas1p235fb430a8f330a39e64f4fd6b81decb2~_jy4bzZVd3193331933eucas1p2t;
        Fri, 16 Oct 2020 19:19:05 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201016191905eusmtrp17d44d024354b88fd8091fee606766fc1~_jy4a-_rq1439014390eusmtrp13;
        Fri, 16 Oct 2020 19:19:05 +0000 (GMT)
X-AuditID: cbfec7f2-7efff70000001938-69-5f89f22ab066
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 96.9C.06017.922F98F5; Fri, 16
        Oct 2020 20:19:05 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201016191905eusmtip127e25dfb5fb7bda5cf6e854e3470ee53~_jy4QhrjU0978609786eusmtip1J;
        Fri, 16 Oct 2020 19:19:05 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, jim.cromie@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewi?= =?utf-8?Q?cz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2 2/4] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Date:   Fri, 16 Oct 2020 21:18:54 +0200
In-Reply-To: <20201016180100.GF139700@lunn.ch> (Andrew Lunn's message of
        "Fri, 16 Oct 2020 20:01:00 +0200")
Message-ID: <dleftj5z7a568x.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0hTYRjm2zlnOy5nx2X5siJkGKSlZY06kZlFxakfFUIRRemqg0Vuji0r
        ++OiLJ2bhmXpNDSblzSt5jK7WLFEM8nlFQ2li5GmmbQZbWHR1qfgv+d53ue9PB8fTUjdlIw+
        rj7Ja9XKJLlQTNY3exwR4c7M+JVTJjHrGLQT7P38uxRb5LhAssVN7RTbOz5AsTlDYwTrcNwT
        sW/rsynWOtRLsV2Pi4RsvuOZgLXnNSK2pmlQxDaXLGDTG5tEsXO5rt4OgrPd7hdwj8yDIs5a
        lSnk6ixp3KMGl4DLtlUhzmVdvJveL44+yicdP8VrV8QkiI8ZuiyEJl1xRj+o0aM7YQbkRwOj
        gOwXZoEBiWkpU4mguClTiMkkgqmWjyQmLgRvOpyimZYJ09i0qwJBRuEXApNhBH/+Wr0VmhYy
        kVBTs8/XEMSEwNXWKcrnIZg7JIx5agS+wjxmL3Rc6iN8mGSWgNOGdT9GBVkPyv7rEmYtdJe/
        +4/nM+vANvJehPVAaC34TPow4fUXOL4h3wJg8mjIqH6I8KlboMBeQmA8D0ZbbNMRFkHbFSPp
        OxSYNLiSuwb3GhHUF7lJ7FkPA+2/hRhvgqzuYgr7A6BvPBDvDYDc+usEliWQcVGK3aFQm/N0
        eooMTKOV09dw0DgxSeG3Oodg5EMfdRmFmGfFMc+KY/aOJZgwuPt4BZaXQfnNMQLjDVBbO0GW
        IKoKBfMpOlUir4tS86cjdUqVLkWdGHkkWWVF3j/Y9rfF2YB+dh62I4ZGcn8JXZYZL6WUp3Sp
        KjsK9U76dK/6LZKR6mQ1Lw+SbH7TdkgqOapMPctrk+O1KUm8zo4W0qQ8WLK69OtBKZOoPMmf
        4HkNr52pCmg/mR6te1UY7kHyS6olBy7uIgZQWKxou15p+Z60Ne28q3UjY4zgMl5Pdmo8/YeN
        DTmGxMB9ilFWE5FuebKz7YA9ffjDqq7nPe2ul3Ex42VX9+zQm0rdTq2kIsig8G8+f4Ooe2pK
        2P/r2vKYnXHbPqbwMvePCM+tnrSiqIYjkyNLo+cUykndMWVUOKHVKf8Bff/MQosDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t/xu7qanzrjDTZOVbA4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFtbd3WC36H79mtjh/fgO7xYVtfawWmx5fY7W4vGsOm8WM8/uYLA5N3cto
        sfbIXXaLYwvELFr3HmF34Pe4fO0is8eWlTeZPHbOusvusWlVJ5vH5iX1Hjt3fGby6NuyitHj
        8ya5AI4oPZui/NKSVIWM/OISW6VoQwsjPUNLCz0jE0s9Q2PzWCsjUyV9O5uU1JzMstQifbsE
        vYyuy0uYC1pNKhruFjQwrtHsYuTkkBAwkXjf+5qti5GLQ0hgKaPEo/MTmLoYOYASUhIr56ZD
        1AhL/LnWBVXzlFFi2qxvLCA1bAJ6EmvXRoDUiAgoSEw5+YcVxGYWWM8isXoSJ4gtLBAisbDv
        FBOILSSgK/H12TNmEJtFQFXi05a1YHFOgVyJz51XwOK8AuYSV5bdArNFBSwltry4zw4RF5Q4
        OfMJC8T8bImvq58zT2AUmIUkNQtJahbQdcwCmhLrd+lDhLUlli18zQxh20qsW/eeZQEj6ypG
        kdTS4tz03GIjveLE3OLSvHS95PzcTYzA+N127OeWHYxd74IPMQpwMCrx8G5Y1BkvxJpYVlyZ
        e4hRBWjMow2rLzBKseTl56UqifA6nT0dJ8SbklhZlVqUH19UmpNafIjRFOjPicxSosn5wJST
        VxJvaGpobmFpaG5sbmxmoSTO2yFwMEZIID2xJDU7NbUgtQimj4mDU6qB8ZgeO8u0K5q+L+dd
        WNboq8X/Xbfnlgbznid+PFlvk1VXLrn0kKv7UfFJTbbST8Hh8geVNpd937DvjseCKxyiE4Tq
        f7L4KRceF5HkNlP17Zpu/eVCzBcj7dup3JPU/jDFG0//n/5FYHtPz7p0qdBKU8erzfOnZwgt
        PbRMOeUhg9+JsKqGpkUHlViKMxINtZiLihMB7YU31AEDAAA=
X-CMS-MailID: 20201016191905eucas1p235fb430a8f330a39e64f4fd6b81decb2
X-Msg-Generator: CA
X-RootMTR: 20201016191905eucas1p235fb430a8f330a39e64f4fd6b81decb2
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201016191905eucas1p235fb430a8f330a39e64f4fd6b81decb2
References: <20201016180100.GF139700@lunn.ch>
        <CGME20201016191905eucas1p235fb430a8f330a39e64f4fd6b81decb2@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-10-16 pi=C4=85 20:01>, when Andrew Lunn wrote:
>> >> +static void
>> >> +ax88796c_get_regs(struct net_device *ndev, struct ethtool_regs *regs=
, void *_p)
>> >> +{
>> >> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> >> +	u16 *p =3D _p;
>> >> +	int offset, i;
>> >> +
>> >> +	memset(p, 0, AX88796C_REGDUMP_LEN);
>> >> +
>> >> +	for (offset =3D 0; offset < AX88796C_REGDUMP_LEN; offset +=3D 2) {
>> >> +		if (!test_bit(offset / 2, ax88796c_no_regs_mask))
>> >> +			*p =3D AX_READ(&ax_local->ax_spi, offset);
>> >> +		p++;
>> >> +	}
>> >> +
>> >> +	for (i =3D 0; i < AX88796C_PHY_REGDUMP_LEN / 2; i++) {
>> >> +		*p =3D phy_read(ax_local->phydev, i);
>> >> +		p++;
>> >
>> > Depending on the PHY, that can be dangerous.
>>=20
>> This is a built-in generic PHY. The chip has no lines to attach any
>> other external one.
>>=20
>> > phylib could be busy doing things with the PHY. It could be looking at
>>=20
>> How does phylib prevent concurrent access to a PHY?=20
>
> phydev->lock. All access to the PHY should go through the phylib,
> which will take the lock before calling into the driver.
>
>> > a different page for example.
>>=20
>> Different page?=20
>
> I was talking about the general case. A number of PHYs have more than
> 32 registers. So they implement pages to give access to more
> registers. For that to work, you need to ensure you don't have
> concurrent access.
>

It is not the case, this one has got only 7 and one only needs to make
sure the transaction in ax88796c_mdio_read() is not messed up.

>> > miitool(1) can give you the same functionally without the MAC driver
>> > doing anything, other than forwarding the IOCTL call on.
>>=20
>> No, I am afraid mii-tool is not able to dump registers.
>
> It should be able to.
>
> sudo mii-tool -vv eth0
> Using SIOCGMIIPHY=3D0x8947
> eth0: negotiated 1000baseT-FD flow-control, link ok
>   registers for MII PHY 0:=20
>     1040 79ed 001c c800 0de1 c5e1 006d 0000
>     0000 0200 0800 0000 0000 0000 0000 2000
>     0000 0000 ffff 0000 0000 0400 0f00 0f00
>     318b 0053 31ec 8012 bf1f 0000 0000 0000
>   product info: vendor 00:07:32, model 0 rev 0
>   basic mode:   autonegotiation enabled
>   basic status: autonegotiation complete, link ok
>   capabilities: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT=
-HD
>   advertising:  1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT=
-HD flow-control
>   link partner: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT=
-HD flow-control

Indeed. However, mii-tool(1) simply calls ioctl(SIOCGMIIREG) number of
times. Is looping in the userspace any better than in kernel? Anyway,
thanks for pointing out possible problems, I will make sure to avoid them.

>> >> +ax88796c_mdio_write(struct mii_bus *mdiobus, int phy_id, int loc, u1=
6 val)
>> >> +{
>> >> +	struct ax88796c_device *ax_local =3D mdiobus->priv;
>> >> +	int ret;
>> >> +
>> >> +	AX_WRITE(&ax_local->ax_spi, val, P2_MDIODR);
>> >> +
>> >> +	AX_WRITE(&ax_local->ax_spi,
>> >> +		 MDIOCR_RADDR(loc) | MDIOCR_FADDR(phy_id)
>> >> +		 | MDIOCR_WRITE, P2_MDIOCR);
>> >> +
>> >> +	ret =3D read_poll_timeout(AX_READ, ret,
>> >> +				((ret & MDIOCR_VALID) !=3D 0), 0,
>> >> +				jiffies_to_usecs(HZ / 100), false,
>> >> +				&ax_local->ax_spi, P2_MDIOCR);
>> >> +	if (ret)
>> >> +		return -EIO;
>> >> +
>> >> +	if (loc =3D=3D MII_ADVERTISE) {
>> >> +		AX_WRITE(&ax_local->ax_spi, (BMCR_FULLDPLX | BMCR_ANRESTART |
>> >> +			  BMCR_ANENABLE | BMCR_SPEED100), P2_MDIODR);
>> >> +		AX_WRITE(&ax_local->ax_spi, (MDIOCR_RADDR(MII_BMCR) |
>> >> +			  MDIOCR_FADDR(phy_id) | MDIOCR_WRITE),
>> >> +			  P2_MDIOCR);
>> >>
>> >
>> > What is this doing?
>> >
>>=20
>> Well=E2=80=A6 it turns autonegotiation when changing advertised link mod=
es. But
>> this is obvious. As to why this code is here, I will honestly say =E2=80=
=94 I am
>> not sure (Reminder: this is a vendor driver I am porting, I am more than
>> happy to receive any comments, thank you). Apparently it is not required
>> and I am willing to remove it.
>
> Please do remove it.
>

Done.

>> >> +
>> >> +	ret =3D devm_register_netdev(&spi->dev, ndev);
>> >> +	if (ret) {
>> >> +		dev_err(&spi->dev, "failed to register a network device\n");
>> >> +		destroy_workqueue(ax_local->ax_work_queue);
>> >> +		goto err;
>> >> +	}
>> >
>> > The device is not live. If this is being used for NFS root, the kernel
>> > will start using it. So what sort of mess will it get into, if there
>> > is no PHY yet? Nothing important should happen after register_netdev().
>> >
>>=20
>> But, with an unregistered network device ndev_owner in
>> phy_attach_direct() is NULL. Thus, phy_connect_direct() below fails.
>>=20
>> --8<---------------cut here---------------start------------->8---
>>    1332         if (dev)
>>    1333                 ndev_owner =3D dev->dev.parent->driver->owner;
>>    1334         if (ndev_owner !=3D bus->owner &&  !try_module_get(bus->=
owner)) {
>>    1335                 phydev_err(phydev, "failed to get the bus  modul=
e\n");
>>    1336                 return -EIO;
>>    1337         }
>> --8<---------------cut here---------------end--------------->8---
>
> Which is probably why most drivers actually attach the PHY in open()
> and detach it in close().
>
> It can be done in probe, just look around for a driver which does and
> copy it.
>

I will. Thanks for the info.

>> No problem. Do you have any recommendation how to express this
>>=20
>>  #define PSR_RESET  (0 << 15)
>>
>> I know it equals 0, but shows explicitly the bit number.
>
> Yes, that is useful for documentation. How about:
>
> #define PSR_NOT_RESET BIT(15)
>
> And then turn the logic around.

OK. This is an idea. I'll look around some more.

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl+J8h4ACgkQsK4enJil
gBD8qAf/eYt3jr44Y+Wjm/yUU1Myn0dZY7KbEcVSJo2oZEiYL3nKpTvcFeMPw9dH
o49vEFwADVrjiHXyy1w05jJTyUBv8RiAMEpCovbFL26nW6eyxqNCyUUwRRDgi7fk
uBnUyJWTcryPVGWH2bw84+ZtTvGh9UuHQpAWzhGf0X48kIym5GvgPK4+OaonqoPg
C+9oQxLxJ4b0/+JHBSRcqHA2YVdHVZYCsCXchxkpX8cRxoNeLc6Y0pNXzfGKFYCM
wLpJd+ZZ6bL4f4sEdIfpimB0nIcV19BxtmvbWFR6Bzur6+fTYxHY9sH8CrGS4rrJ
+6ZXm5UZSxjT6/dYpUKiatNQZXTxFg==
=JcIo
-----END PGP SIGNATURE-----
--=-=-=--
