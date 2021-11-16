Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD4D452B6E
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 08:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhKPHTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 02:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbhKPHSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 02:18:46 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F110CC061766
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 23:15:49 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mmsgq-0000S2-Bh; Tue, 16 Nov 2021 08:15:36 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-a4ec-1e51-dfc5-35f4.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:a4ec:1e51:dfc5:35f4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 17C0A6ACF73;
        Tue, 16 Nov 2021 07:15:31 +0000 (UTC)
Date:   Tue, 16 Nov 2021 08:15:30 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Felipe Balbi (Intel)" <balbi@kernel.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/4] can: m_can: pci: fix incorrect reference clock
 rate
Message-ID: <20211116071530.k2qaccz5qixgt2jj@pengutronix.de>
References: <cover.1636967198.git.matthias.schiffer@ew.tq-group.com>
 <c9cf3995f45c363e432b3ae8eb1275e54f009fc8.1636967198.git.matthias.schiffer@ew.tq-group.com>
 <48d37d59-e7d1-e151-4201-1dcc151819fe@linux.intel.com>
 <0400022a-0515-db87-03cc-30b83c2aede2@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="c7fuwfwv5pgm7und"
Content-Disposition: inline
In-Reply-To: <0400022a-0515-db87-03cc-30b83c2aede2@linux.intel.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--c7fuwfwv5pgm7und
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.11.2021 09:11:40, Jarkko Nikula wrote:
> > ip link set can0 type can bitrate 1000000 dbitrate 2000000 fd on
>=20
> I got confirmation the clock to CAN controller is indeed changed from 100
> MHz to 200 MHz in release HW & firmware.
>=20
> I haven't upgraded the FW in a while on our HW so that perhaps explain
> why I was seeing expected rate :-)

Can we query the FW version in the driver and set the clock rate
accordingly?

> So which one is more appropriate:
>=20
> Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
> or
> Reviewed-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--c7fuwfwv5pgm7und
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmGTWo8ACgkQqclaivrt
76nKDAf/Xc7Mj3LR7IgGI1jF2bN0zLidqH9pHqlcRF2wiOkrK/VK7DWXqHwdpf3G
FtQK/Dz7A/mPPMTs6Z9Iqn4fv9vrL8oypftFlie62KIdB+c2v3P+uzt2EP9XoSTr
6LZbSSTPf5a2D8xaY/E++Pm2M3eSyDnksvc0hWRT3QEuQqxpnFaCkt2bkpnn9iED
REraCBzsyJqRvqkJPixrte23qN9vVju5q+Kz+fIvVTNzZ98A5jmA/vmGBgmwMUcL
nNp9I1hHeyxGd9Sc0daZ9FU4w6W3XhiOZeZknd6HWfcSAuGqD6FCcTjUAzdDl32x
ox9KSrotDqHU5UmpnZn5MoNhTGXl+Q==
=ShOs
-----END PGP SIGNATURE-----

--c7fuwfwv5pgm7und--
