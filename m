Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9184B26182C
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732135AbgIHRtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:49:49 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51311 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732127AbgIHRtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 13:49:40 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200908174936euoutp02206dfe0dce1a3991cf7eaeaecc3b0ec0~y4D6A6Zt30693306933euoutp02g;
        Tue,  8 Sep 2020 17:49:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200908174936euoutp02206dfe0dce1a3991cf7eaeaecc3b0ec0~y4D6A6Zt30693306933euoutp02g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1599587376;
        bh=UWirAw/PFsj+9+rbZm46bA8bswKf6AzzRwj2qYkhOU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2ZXh2kM4yctoYdBrbTGpk+EOwiqX7UT4x/UXuP63HHU1u7BM8bn+IoLeDsLp8/Ox
         mMSF0SmQ5H+nrhJR0CbJtcKn8Th9MIzeLhLp9U/FIaKUtQcRwPJeEcRnolgoukCmoq
         a5q2dBLj1KHZA6PD2PN/5o6A4oe2GuT+iohIga/c=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200908174936eucas1p280614e16132f3bfe0a297668a274efde~y4D5sbu0f0137701377eucas1p2H;
        Tue,  8 Sep 2020 17:49:36 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id C7.6F.06456.034C75F5; Tue,  8
        Sep 2020 18:49:36 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200908174935eucas1p2f24d79b234152148b060c45863e3efeb~y4D5FtN6o0467204672eucas1p2k;
        Tue,  8 Sep 2020 17:49:35 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200908174935eusmtrp2a43233d918c3b59574a66b19ae4f2338~y4D5E6Q9p3114331143eusmtrp2Q;
        Tue,  8 Sep 2020 17:49:35 +0000 (GMT)
X-AuditID: cbfec7f2-7efff70000001938-d9-5f57c4306011
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 9C.71.06017.F24C75F5; Tue,  8
        Sep 2020 18:49:35 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200908174935eusmtip22473873d3cabdf8b41531b3623ab96a9~y4D42haRK0753307533eusmtip2L;
        Tue,  8 Sep 2020 17:49:35 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com
Subject: Re: [PATCH 1/3] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
Date:   Tue, 08 Sep 2020 19:49:20 +0200
In-Reply-To: <20200907181854.GD3254313@lunn.ch> (Andrew Lunn's message of
        "Mon, 7 Sep 2020 20:18:54 +0200")
Message-ID: <dleftj8sdkqhun.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02SaUwTURSF8zoznaFaMhTUazVIqsa4URHUh4pb/DEaE9eIGqVUHdFIC7ag
        YmJYBNwKSBEFQhSXKGIKWCsBtC4NQohKCwhqZDFgRAVXXICAyjg18d937z3nvnOTxxCKHkrJ
        7NHH8Aa9NlIllZFl1f11M2dVhWpmNdm8sbPVQeAbOSUUzncmk/h8VR2FMzq7Cex0ltLYVZZO
        YWtnM4UbK/OlOMd5V4Id2XaELVWtNK4uGI1T7FX0Ek+usbme4GzXXkg4a9FxKXfzcjxXUd4r
        4dJtRYjrtfquobfIFu7kI/fs5w3qReGy3S8TO4no1GUHh74MUgkoJ+gE8mCADYKupjbqBJIx
        CrYQQe09p0QsviEw5xYisehF8Kymgfxn6bDluAdXEQxmJpFi0YXg84MjwxOGkbL+YLFsEgw+
        rB+crh2kBCZYBwHttxcL7M2uh0tNjwmBSXYy2J+elAjsweqgPtWOBJaz88DqukULPIoNBtvb
        dlrse0Ft7mtS3KmDXGfP30DApjHQZ7qPxKTL4U3rD3dqb3hfY6NFHg+/K85LhJzAxkOWea7o
        NSEoy+9z6xdAS92AVOSl8PBumlTUe8LzD17iu55gLjtLiG05HEtViOpJUJxxx71FCWnvC5Eo
        4cDWHya0FWwSApdJfQr55f13TN5/x+QNOwh2KpRUqsX2dLhyoZsQOQSKiz+RBYgqQmP4WKMu
        gjcG6PkD/katzhirj/DfEaWzouF/9+hXzddy9L1huwOxDFKNlIenh2oUlHa/MU7nQJOGN3WU
        XnchJamP0vMqH/myJ4/CFPKd2rhDvCFKY4iN5I0ONI4hVWPkgRffbVOwEdoYfi/PR/OGf1MJ
        46FMQF4a/rVZ6ZqTePjcUGYy0JpIzRLa17L6UOBJ+ysm1NS9bkbwBsvDX/YP+zZjdX3PGSrL
        a6C8jzvWRE+YvXVlQ0rmG+Wqj+tX6NOD59ccdSjjLu8aV7A2oGt6ko8swzPCXNsWtzEkxvBz
        ir9pcbZfVMPExN8cHpFSvS2kA8e3HB6rIo27tQHTCINR+wcu8xO/fwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t/xe7r6R8LjDQ78UrE4f/cQs8XGGetZ
        Leacb2GxmH/kHKtF/+PXzBbnz29gt7iwrY/VYtPja6wWl3fNYbOYcX4fk8WhqXsZLdYeuctu
        cWyBmEXr3iPsDnwel69dZPbYsvImk8emVZ1sHpuX1Hvs3PGZyaNvyypGj8+b5ALYo/RsivJL
        S1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOtjEyV9O1sUlJzMstSi/TtEvQybjc+Zi5oc6r4
        +/EPawPjDJMuRk4OCQETiUdbZjB2MXJxCAksZZT4eKSVqYuRAyghJbFybjpEjbDEn2tdbBA1
        TxklZn/8zw5SwyagJ7F2bQRIjYiAgsSUk39YQWqYBbYxS3xdOYkJJCEsECjxYN4pdhBbCKj+
        /cVJjCA2i4CqxN4r3WA1nAK5Ehfb9oLFeQXMJTZd2ApWLypgKbHlxX12iLigxMmZT1hAbGaB
        bImvq58zT2AUmIUkNQtJahbQecwCmhLrd+lDhLUlli18zQxh20qsW/eeZQEj6ypGkdTS4tz0
        3GIjveLE3OLSvHS95PzcTYzAeN127OeWHYxd74IPMQpwMCrx8Cb0hccLsSaWFVfmHmJUARrz
        aMPqC4xSLHn5ealKIrxOZ0/HCfGmJFZWpRblxxeV5qQWH2I0BfpzIrOUaHI+MMXklcQbmhqa
        W1gamhubG5tZKInzdggcjBESSE8sSc1OTS1ILYLpY+LglGpgvPjoXWn/HBFeyRmrN+1/9V5C
        9kT3yYbNGjsKVRe+P/k9+327ydnlVzjYHde1py//EnxycbthR/ks9bCWZ5lnI8Uv7Q8NP5cb
        LbZ2w5Y3K5b+WTsh1MFoA6tHXpVrpOKKhRHiL6ZHZ+0oP7N0msu+xAfzEjb8TMlYGMHLv8H+
        p0ew6/UGlaQ5tUosxRmJhlrMRcWJAMgJ/b35AgAA
X-CMS-MailID: 20200908174935eucas1p2f24d79b234152148b060c45863e3efeb
X-Msg-Generator: CA
X-RootMTR: 20200908174935eucas1p2f24d79b234152148b060c45863e3efeb
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200908174935eucas1p2f24d79b234152148b060c45863e3efeb
References: <20200907181854.GD3254313@lunn.ch>
        <CGME20200908174935eucas1p2f24d79b234152148b060c45863e3efeb@eucas1p2.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-09-07 pon 20:18>, when Andrew Lunn wrote:
>> > On Tue, Aug 25, 2020 at 07:03:09PM +0200, =C5=81ukasz Stelmach wrote:
>> >> +++ b/drivers/net/ethernet/asix/ax88796c_ioctl.c
>> >
>> > This is an odd filename. The ioctl code is wrong anyway, but there is
>> > a lot more than ioctl in here. I suggest you give it a new name.
>> >
>>=20
>> Sure, any suggestions?
>
> Sorry, i have forgotten what is actually contained.=20

IOCTL handler (.ndo_do_ioctl), ethtool ops, and a bunch of hw control
functions.

> Does it even need to be a separate file?

It doesn't need, but I think it makes sense to keep ioctl and ethtool
stuff in a separate file. Some of the hw control function look like they
might change after using phylib.

>> >> +u8 ax88796c_check_power(struct ax88796c_device *ax_local)
>> >
>> > bool ?
>>=20
>> OK.
>>=20
>> It appears, however, that 0 means OK and 1 !OK. Do you think changing to
>> TRUE and FALSE (or FALSE and TRUE) is required?
>
> Or change the name, ax88796c_check_power_off()? I don't really care,
> so long as it is logical and not surprising.
>

Good idea, thanks.

>> >> +	AX_READ_STATUS(&ax_local->ax_spi, &ax_status);
>> >> +	if (!(ax_status.status & AX_STATUS_READY)) {
>> >> +
>> >> +		/* AX88796C in power saving mode */
>> >> +		AX_WAKEUP(&ax_local->ax_spi);
>> >> +
>> >> +		/* Check status */
>> >> +		start_time =3D jiffies;
>> >> +		do {
>> >> +			if (time_after(jiffies, start_time + HZ/2)) {
>> >> +				netdev_err(ax_local->ndev,
>> >> +					"timeout waiting for wakeup"
>> >> +					" from power saving\n");
>> >> +				break;
>> >> +			}
>> >> +
>> >> +			AX_READ_STATUS(&ax_local->ax_spi, &ax_status);
>> >> +
>> >> +		} while (!(ax_status.status & AX_STATUS_READY));
>> >
>> > include/linux/iopoll.h
>> >
>>=20
>> Done. The result seems only slightly more elegant since the generic
>> read_poll_timeout() needs to be employed.
>
> Often code like this has bugs in it, not correctly handling the
> scheduler sleeping longer than expected. That is why i point people at
> iopoll, no bugs, not elegance.
>
>> The manufacturer says
>>=20
>>     The AX88796C integrates on-chip Fast Ethernet MAC and PHY, [=E2=80=
=A6]
>>=20
>> There is a single integrated PHY in this chip and no possiblity to
>> connect external one. Do you think it makes sense in such case to
>> introduce the additional layer of abstraction?
>
> Yes it does, because it then uses all the standard phylib code to
> drive the PHY which many people understand, is well tested, etc. It
> will make the MAC driver smaller and probably less buggy.
>

Good point. I need to figure out how to do it. Can you point (from the
top fou your head) a driver which does it for a simmilarly integrated
device?

>> >> +static char *macaddr;
>> >> +module_param(macaddr, charp, 0);
>> >> +MODULE_PARM_DESC(macaddr, "MAC address");
>> >
>> > No Module parameters. You can get the MAC address from DT.
>>=20
>> What about systems without DT? Not every bootloader is sophisicated
>> enough to edit DT before starting kernel. AX88786C is a chip that can be
>> used in a variety of systems and I'd like to avoid too strong
>> assumptions.
>
> There is also a standardised way to read it from ACPI. And you can set
> it using ip link set. DaveM will likely NACK a module parameter.
>

I am not arguing to keep the parameter at any cost, but I would really
like to know if there is a viable alternative for DT and ACPI. This chip
is for smaller systems which not necessarily implement advanced
bootloaders (and DT).

>> >> +MODULE_AUTHOR("ASIX");
>> >
>> > Do you expect ASIX to support this?=20
>>=20
>> No.
>>=20
>> > You probably want to put your name here.
>>=20
>> I don't want to be considered as the only author and as far as I can
>> tell being mentioned as an author does not imply being a
>> maintainer. Do you think two MODULE_AUTHOR()s be OK?
>
> Can you have two? One with two names listed is O.K.
>

According to module.h

/*
 * Author(s), use "Name <email>" or just "Name", for multiple
 * authors use multiple MODULE_AUTHOR() statements/lines.
 */

>> >> +
>> >> +	phy_status =3D AX_READ(&ax_local->ax_spi, P0_PSCR);
>> >> +	if (phy_status & PSCR_PHYLINK) {
>> >> +
>> >> +		ax_local->w_state =3D ax_nop;
>> >> +		time_to_chk =3D 0;
>> >> +
>> >> +	} else if (!(phy_status & PSCR_PHYCOFF)) {
>> >> +		/* The ethernet cable has been plugged */
>> >> +		if (ax_local->w_state =3D=3D chk_cable) {
>> >> +			if (netif_msg_timer(ax_local))
>> >> +				netdev_info(ndev, "Cable connected\n");
>> >> +
>> >> +			ax_local->w_state =3D chk_link;
>> >> +			ax_local->w_ticks =3D 0;
>> >> +		} else {
>> >> +			if (netif_msg_timer(ax_local))
>> >> +				netdev_info(ndev, "Check media status\n");
>> >> +
>> >> +			if (++ax_local->w_ticks =3D=3D AX88796C_WATCHDOG_RESTART) {
>> >> +				if (netif_msg_timer(ax_local))
>> >> +					netdev_info(ndev, "Restart autoneg\n");
>> >> +				ax88796c_mdio_write(ndev,
>> >> +					ax_local->mii.phy_id, MII_BMCR,
>> >> +					(BMCR_SPEED100 | BMCR_ANENABLE |
>> >> +					BMCR_ANRESTART));
>> >> +
>> >> +				if (netif_msg_hw(ax_local))
>> >> +					ax88796c_dump_phy_regs(ax_local);
>> >> +				ax_local->w_ticks =3D 0;
>> >> +			}
>> >> +		}
>> >> +	} else {
>> >> +		if (netif_msg_timer(ax_local))
>> >> +			netdev_info(ndev, "Check cable status\n");
>> >> +
>> >> +		ax_local->w_state =3D chk_cable;
>> >> +	}
>> >> +
>> >> +	ax88796c_set_power_saving(ax_local, ax_local->ps_level);
>> >> +
>> >> +	if (time_to_chk)
>> >> +		mod_timer(&ax_local->watchdog, jiffies + time_to_chk);
>> >> +}
>> >
>> > This is not the normal use of a watchdog in network drivers. The
>> > normal case is the network stack as asked the driver to do something,
>> > normally a TX, and the driver has not reported the action has
>> > completed.  The state of the cable should not make any
>> > difference. This does not actually appear to do anything useful, like
>> > kick the hardware to bring it back to life.
>> >
>>=20
>> Maybe it's the naming that is a problem. Yes, it is not a watchdog, but
>> rather a periodic housekeeping and it kicks hw if it can't negotiate
>> the connection. The question is: should the settings be reset in such ca=
se.
>
> Let see what is left once you convert to phylib.
>

OK.

>> >> +	struct net_device *ndev =3D ax_local->ndev;
>> >> +	int status;
>> >> +
>> >> +	do {
>> >> +		if (!(ax_local->checksum & AX_RX_CHECKSUM))
>> >> +			break;
>> >> +
>> >> +		/* checksum error bit is set */
>> >> +		if ((rxhdr->flags & RX_HDR3_L3_ERR) ||
>> >> +		    (rxhdr->flags & RX_HDR3_L4_ERR))
>> >> +			break;
>> >> +
>> >> +		if ((rxhdr->flags & RX_HDR3_L4_TYPE_TCP) ||
>> >> +		    (rxhdr->flags & RX_HDR3_L4_TYPE_UDP)) {
>> >> +			skb->ip_summed =3D CHECKSUM_UNNECESSARY;
>> >> +		}
>> >> +	} while (0);
>> >
>> >
>> > ??
>> >
>>=20
>> if() break; Should I use goto?
>
> Sorry, i was too ambiguous. Why:
>
> do {
> } while (0);
>
> It is an odd construct.

As to "why" =E2=80=94 you have correctly spotted, this is a vendor driver I=
 am
porting. Although it's not like I am trying to avoid any changes, but
because this driver worked for us on older kernels (v3.10.9) I am trying
not to touch pieces which IMHO are good enough. Of course I don't mind
suggestions from more experienced developers.

To avoid using do{}while(0) it requires either goto (instead of breaks),
nesting those if()s in one another or a humongous single if(). Neither
looks pretty and the last one is even less readable than
do()while.

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl9XxCAACgkQsK4enJil
gBC1Vgf9EkeOUgjfBRAojgMgssc8oHafP7l3gHzfL0atRhxZmAlFtXfse8R+CNl1
dJqVKsRrEQRagmk/NUahcbGNhk9soWoV7GJ3w7cbzANgo8CPVXMjE8D5TkMc5+IZ
PKA2gwQatrOkDCB5VyWIUaLuKs+VUwvtYgFvhzElsk0W7l6ZMzD80ldMbE5zo8KK
b+/aUZTtGjEHnKrTy5p2XINVsjWMCj3Ymo/mZfrj97vKrsuM6O84v8UmCyjVvkNd
ebFKfw1Tt2ufPDjFOT6kzVGixBlzKmaDPRwMBJDtCpPhEgf6qnTMQDPAUZ+EP63Z
JfbNxAQMBBSY6U8jHGULU3fX4wg2XA==
=og4m
-----END PGP SIGNATURE-----
--=-=-=--
