Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3EB2430C10
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 22:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344594AbhJQUqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 16:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344585AbhJQUql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 16:46:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8753C06161C
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 13:44:31 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mcD0y-0007C8-H2; Sun, 17 Oct 2021 22:44:16 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-c215-888e-54eb-c2bc.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:c215:888e:54eb:c2bc])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 50031695E9B;
        Sun, 17 Oct 2021 20:44:13 +0000 (UTC)
Date:   Sun, 17 Oct 2021 22:44:12 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Aswath Govindraju <a-govindraju@ti.com>
Cc:     Lokesh Vutla <lokeshvutla@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matt Kline <matt@bitbashing.io>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: m_can: m_can_platform: Fix iomap_read_fifo() and
 iomap_write_fifo()
Message-ID: <20211017204412.2jvp24tgaibvmcz3@pengutronix.de>
References: <20210920123344.2320-1-a-govindraju@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vyrpaejnfoakxj4h"
Content-Disposition: inline
In-Reply-To: <20210920123344.2320-1-a-govindraju@ti.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vyrpaejnfoakxj4h
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 20.09.2021 18:03:43, Aswath Govindraju wrote:
> The read and writes from the fifo are from a buffer, with various fields
> and data at predefined offsets. So, they should not be done to the same
> address(or port) in case of val_count greater than 1. Therefore, fix this
> by using iowrite32/ioread32 instead of ioread32_rep/iowrite32_rep.
>=20
> Also, the write into fifo must be performed with an offset from the messa=
ge
> ram base address. Therefore, fix the base address to mram_base.
>=20
> Fixes: e39381770ec9 ("can: m_can: Disable IRQs on FIFO bus errors")
> Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>

Applied to linux-can/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--vyrpaejnfoakxj4h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmFsixkACgkQqclaivrt
76nANAf8CPQsL+cF95xUlCMoxS4E7BgIb7HAWVRKEdE0wYn5DOWOhHSQ/Ct2OzNy
PwglN9CFRcSlMR4N2vmtpuu76UZ2ifmm2oiGHGCXQ6tgwUIFAIEWjm4dA91FdTQV
Gj/hWgb5HOJa3vC+Yre01EhElbGDOCwNRJo/eFKTRIF5DO9UaBiC7ut+S4zPsL/i
+BkMkvAg5v2ePo2gvJSqZinSshcWWTyX3oxDoB6cuXZq0MDedy5Lv4WfGWRqh5kO
UbvlS2/UXAjHagMQaBzPz/4wxMz7Dqu0n9k3X6Dz1ZnbfV2A4kthJ+tAGVmRkiVz
nkxcH8wyiizCaPTGO5qtfkKibial/w==
=7CHm
-----END PGP SIGNATURE-----

--vyrpaejnfoakxj4h--
