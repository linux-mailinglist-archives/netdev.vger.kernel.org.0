Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A067431970
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhJRMle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbhJRMle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 08:41:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E04C06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 05:39:22 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mcRv8-00023Q-2m; Mon, 18 Oct 2021 14:39:14 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-c2ef-28ab-e0cd-e8fd.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:c2ef:28ab:e0cd:e8fd])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id ED709696744;
        Mon, 18 Oct 2021 12:39:11 +0000 (UTC)
Date:   Mon, 18 Oct 2021 14:39:11 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Michal Simek <michal.simek@xilinx.com>
Cc:     linux-kernel@vger.kernel.org, monstr@monstr.eu, git@xilinx.com,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] can: xilinx_can: Remove repeated work the from kernel-doc
Message-ID: <20211018123911.5ri2gbodsolhcvg2@pengutronix.de>
References: <267c11097c90debbb5b1efebbeabc98161177def.1632306843.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2nbomcsbxyvypu7o"
Content-Disposition: inline
In-Reply-To: <267c11097c90debbb5b1efebbeabc98161177def.1632306843.git.michal.simek@xilinx.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2nbomcsbxyvypu7o
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 22.09.2021 12:34:04, Michal Simek wrote:
> Trivial patch. Issue is reported by checkpatch.
>=20
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

I've fixed the subject to:

| Subject: can: xilinx_can: remove repeated word from the kernel-doc

Applied to linux-can-next/testing

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--2nbomcsbxyvypu7o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmFtauwACgkQqclaivrt
76ki0Af/dCW7j9/75sw2c0gE5wOTQGQLi5pCx+4Pz0emj1DQog24UGEnwhwTOcIP
g44O7ZNeUw2YnMkIc2CZMvdd+ACOnjlrGaEwxJ5mioW9tqZTh+HIil3wd1cPW3sR
zclscn05AS2S2d6jfUB5N2BgDYhHbALe7p9HM70BlKUAcjOsaM5mmpVaA5wI/VVD
ZsdDzRbpMY2cgAP2VbdAJqO5azoSnHFN1uOfh40hChwlonwKhZPbBkNS7FeHMRN9
SvAi8G7wqojz5Wmx1JZKAKrfF0ZrokKFoVVj/GjuE2X8lLT5bI2u5wsDRw5tfvuW
d20wWVcVm4sgONltlD315fiQuZVLog==
=ULN4
-----END PGP SIGNATURE-----

--2nbomcsbxyvypu7o--
