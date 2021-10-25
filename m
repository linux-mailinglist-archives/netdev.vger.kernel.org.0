Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9550439EB5
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 20:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhJYSyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 14:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232653AbhJYSyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 14:54:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97631C061767
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 11:51:39 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mf53b-0008I3-JX; Mon, 25 Oct 2021 20:50:51 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-e094-d8e8-b5aa-4a00.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:e094:d8e8:b5aa:4a00])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 8048569DABA;
        Mon, 25 Oct 2021 18:50:41 +0000 (UTC)
Date:   Mon, 25 Oct 2021 20:50:40 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Guangbin Huang <huangguangbin2@huawei.com>, davem@davemloft.net,
        mkubecek@suse.cz, andrew@lunn.ch, amitc@mellanox.com,
        idosch@idosch.org, danieller@nvidia.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        netanel@amazon.com, akiyano@amazon.com, saeedb@amazon.com,
        chris.snook@gmail.com, ulli.kroll@googlemail.com,
        linus.walleij@linaro.org, jeroendb@google.com, csully@google.com,
        awogbemila@google.com, jdmason@kudzu.us, rain.1986.08.12@gmail.com,
        zyjzyj2000@gmail.com, kys@microsoft.com, haiyangz@microsoft.com,
        mst@redhat.com, jasowang@redhat.com, doshir@vmware.com,
        pv-drivers@vmware.com, jwi@linux.ibm.com, kgraul@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, johannes@sipsolutions.net,
        netdev@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH V4 net-next 4/6] ethtool: extend ringparam setting uAPI
 with rx_buf_len
Message-ID: <20211025185040.xj27ujo5wubirz6u@pengutronix.de>
References: <20211014113943.16231-1-huangguangbin2@huawei.com>
 <20211014113943.16231-5-huangguangbin2@huawei.com>
 <20211025131149.ya42sw64vkh7zrcr@pengutronix.de>
 <20211025132718.5wtos3oxjhzjhymr@pengutronix.de>
 <20211025104505.43461b53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zmvvm7jx7bbxbmoe"
Content-Disposition: inline
In-Reply-To: <20211025104505.43461b53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zmvvm7jx7bbxbmoe
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.10.2021 10:45:05, Jakub Kicinski wrote:
> On Mon, 25 Oct 2021 15:27:18 +0200 Marc Kleine-Budde wrote:
> > On 25.10.2021 15:11:49, Marc Kleine-Budde wrote:
> > > On 14.10.2021 19:39:41, Guangbin Huang wrote: =20
> > > > From: Hao Chen <chenhao288@hisilicon.com>
> > > >=20
> > > > Add two new parameters ringparam_ext and extack for
> > > > .get_ringparam and .set_ringparam to extend more ring params
> > > > through netlink.
> > > >=20
> > > > Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
> > > > Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com> =20
> > >=20
> > > While discussing a different ethtool ring param extension, =20
> >=20
> > Let me explain my requirements:
> >=20
> > There is a not Ethernet based bus system, called CAN (mainly used in the
> > automotive and industrial world). It comes in 2 different generations or
> > modes (CAN-2.0 and CAN-FD) and the 3rd one CAN-XL has already been
> > specified.
> >=20
> > Due to different frame sizes used in these CAN modes and HW limitations,
> > we need the possibility to set a RX/TX ring configuration for each of
> > these modes.
> >=20
> > The approach Andrew suggested is two-fold. First introduce a "struct
> > ethtool_kringparam" that's only used inside the kernel, as "struct
> > ethtool_ringparam" is ABI. Then extend "struct ethtool_kringparam" as
> > needed.
>=20
> Indeed, there are different ways to extend the API for drivers,
> I think it comes down to personal taste. I find the "inheritance"=20
> models in C (kstruct usually contains the old struct as some "base")
> awkward.
>=20
> I don't think we have agreed-on best practice in the area.

The set/get_coalesce as just extended, using a 3rd parameter for the new
values:

| 	int	(*set_coalesce)(struct net_device *,
| 				struct ethtool_coalesce *,
| 				struct kernel_ethtool_coalesce *,
| 				struct netlink_ext_ack *);

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=
=3Df3ccfda19319

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--zmvvm7jx7bbxbmoe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmF2/HsACgkQqclaivrt
76nIXggAnPumYY/CZI//RmCZL3I5ORqzeWWPSJ894gSIwmskhycjPlah1mvi+MUM
fOaahsRlvENVgBO1YHF9rHH54glllHP7r0p3boZsolOOXCwIJ+KVcgD3jfhPrRBu
dC7+4N6yiBXCZ0EwbJt3uxn2ooiSTZtbVrkB+rC1AX9SkJqOPHNc0OszYq3+54J0
zezwjT4rXCyabF5NBvxRwp0oVV+9oh7wMQsxVF/y/bUtOQBDDUkAJMU4KhRKwYjN
c1A0Fx5clY0FTw0PsLncWvcDNRpuLPKBxU1U+9j1EuZCXHy21UIP75+Fw4K7bL1P
qhgyZFlcwBXXCbjm5fPokysPou58yA==
=+ovD
-----END PGP SIGNATURE-----

--zmvvm7jx7bbxbmoe--
