Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1195C43978E
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 15:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhJYNae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 09:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbhJYNae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 09:30:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D743FC061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 06:28:11 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mf00d-00034N-5t; Mon, 25 Oct 2021 15:27:27 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-d7c8-7df6-a4ac-55f0.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:d7c8:7df6:a4ac:55f0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id F250369D6B4;
        Mon, 25 Oct 2021 13:27:18 +0000 (UTC)
Date:   Mon, 25 Oct 2021 15:27:18 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mkubecek@suse.cz,
        andrew@lunn.ch, amitc@mellanox.com, idosch@idosch.org,
        danieller@nvidia.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, jdike@addtoit.com, richard@nod.at,
        anton.ivanov@cambridgegreys.com, netanel@amazon.com,
        akiyano@amazon.com, saeedb@amazon.com, chris.snook@gmail.com,
        ulli.kroll@googlemail.com, linus.walleij@linaro.org,
        jeroendb@google.com, csully@google.com, awogbemila@google.com,
        jdmason@kudzu.us, rain.1986.08.12@gmail.com, zyjzyj2000@gmail.com,
        kys@microsoft.com, haiyangz@microsoft.com, mst@redhat.com,
        jasowang@redhat.com, doshir@vmware.com, pv-drivers@vmware.com,
        jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, johannes@sipsolutions.net,
        netdev@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH V4 net-next 4/6] ethtool: extend ringparam setting uAPI
 with rx_buf_len
Message-ID: <20211025132718.5wtos3oxjhzjhymr@pengutronix.de>
References: <20211014113943.16231-1-huangguangbin2@huawei.com>
 <20211014113943.16231-5-huangguangbin2@huawei.com>
 <20211025131149.ya42sw64vkh7zrcr@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="a5nxfjdi3kj6ctbj"
Content-Disposition: inline
In-Reply-To: <20211025131149.ya42sw64vkh7zrcr@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--a5nxfjdi3kj6ctbj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.10.2021 15:11:49, Marc Kleine-Budde wrote:
> On 14.10.2021 19:39:41, Guangbin Huang wrote:
> > From: Hao Chen <chenhao288@hisilicon.com>
> >=20
> > Add two new parameters ringparam_ext and extack for
> > .get_ringparam and .set_ringparam to extend more ring params
> > through netlink.
> >=20
> > Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
> > Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
>=20
> While discussing a different ethtool ring param extension,

Let me explain my requirements:

There is a not Ethernet based bus system, called CAN (mainly used in the
automotive and industrial world). It comes in 2 different generations or
modes (CAN-2.0 and CAN-FD) and the 3rd one CAN-XL has already been
specified.

Due to different frame sizes used in these CAN modes and HW limitations,
we need the possibility to set a RX/TX ring configuration for each of
these modes.

The approach Andrew suggested is two-fold. First introduce a "struct
ethtool_kringparam" that's only used inside the kernel, as "struct
ethtool_ringparam" is ABI. Then extend "struct ethtool_kringparam" as
needed.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--a5nxfjdi3kj6ctbj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmF2sLMACgkQqclaivrt
76mD4ggAiGfmXNdWCHSK3g0D5S8ey5SEX+qxEf7WBkQ0F6pQcZmaCT+cGJu8ZuN6
Kh1kk102/iRQnA+/kGBZfNbHyUcBN6yvAB4QrXLxWDKm6klE3VwcZXbIn06Xfy+5
Cuf63DbshxEcLLalTJW+a1ZX7SXHc3ErJ3Ve6P26wdYQT+Cn42y14se8odbTALBT
gevTE9B1jPFvaWBE3kD0E18H1S99iygpXWU+j83pGNslvXrNTxgv/wHkYkTAgk07
d/tG7LWD9cggcQPlzlLSeKg/C8SquOq6e01yIAJqdq2Kg+jRQHWbqsLth8FVvmrE
4h4DmYg0THrrekJ/gp2L8GwPjJTdGg==
=n9LB
-----END PGP SIGNATURE-----

--a5nxfjdi3kj6ctbj--
