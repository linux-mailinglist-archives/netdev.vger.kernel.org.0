Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123C54F7FDC
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 15:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245702AbiDGNDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 09:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245675AbiDGNDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 09:03:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D987E22FDBC
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 06:01:32 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ncRlI-0002Av-JA; Thu, 07 Apr 2022 15:01:20 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-b17e-6ba8-60fd-ca2d.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:b17e:6ba8:60fd:ca2d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id AAA2B5D40C;
        Thu,  7 Apr 2022 13:01:18 +0000 (UTC)
Date:   Thu, 7 Apr 2022 15:01:18 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     Brian Silverman <bsilver16384@gmail.com>,
        Brian Silverman <brian.silverman@bluerivertech.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Dan Murphy <dmurphy@ti.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:CAN NETWORK DRIVERS" <linux-can@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:TEGRA ARCHITECTURE SUPPORT" <linux-tegra@vger.kernel.org>
Subject: Re: [RFC PATCH] can: m_can: Add driver for M_CAN hardware in NVIDIA
 devices
Message-ID: <20220407130118.hp5szzhg4v6szmbq@pengutronix.de>
References: <20220106002514.24589-1-brian.silverman@bluerivertech.com>
 <Yk2vOj8wKi4FdPg2@orome>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="n7sqxwpygc2d6wn2"
Content-Disposition: inline
In-Reply-To: <Yk2vOj8wKi4FdPg2@orome>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--n7sqxwpygc2d6wn2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 06.04.2022 17:18:18, Thierry Reding wrote:
> On Wed, Jan 05, 2022 at 04:25:09PM -0800, Brian Silverman wrote:
> > It's a M_TTCAN with some NVIDIA-specific glue logic and clocks. The
> > existing m_can driver works with it after handling the glue logic.
> >=20
> > The code is a combination of pieces from m_can_platform and NVIDIA's
> > driver [1].
> >=20
> > [1] https://github.com/hartkopp/nvidia-t18x-can/blob/master/r32.2.1/nvi=
dia/drivers/net/can/mttcan/hal/m_ttcan.c
> >=20
> > Signed-off-by: Brian Silverman <brian.silverman@bluerivertech.com>
> > ---
> > I ran into bugs with the error handling in NVIDIA's m_ttcan driver, so I
> > switched to m_can which has been much better. I'm looking for feedback
> > on whether I should ensure rebasing hasn't broken anything, write up DT
> > documentation, and submit this patch for real. The driver works great,
> > but I've got some questions about submitting it.
> >=20
> > question: This has liberal copying of GPL code from NVIDIA's
> > non-upstreamed m_ttcan driver. Is that OK?
> >=20
> > corollary: I don't know what any of this glue logic does. I do know the
> > device doesn't work without it. I can't find any documentation of what
> > these addresses do.
> >=20
> > question: There is some duplication between this and m_can_platform. It
> > doesn't seem too bad to me, but is this the preferred way to do it or is
> > there another alternative?
> >=20
> > question: Do new DT bindings need to be in the YAML format, or is the
> > .txt one OK?
> >=20
> >  drivers/net/can/m_can/Kconfig       |  10 +
> >  drivers/net/can/m_can/Makefile      |   1 +
> >  drivers/net/can/m_can/m_can_tegra.c | 362 ++++++++++++++++++++++++++++
> >  3 files changed, 373 insertions(+)
> >  create mode 100644 drivers/net/can/m_can/m_can_tegra.c
>=20
> Sorry for the late reply, I completely missed this.

Brian Silverman left the company bluerivertech, I think there'll be no
progress on the tegra glue code. :/

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--n7sqxwpygc2d6wn2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJO4JsACgkQrX5LkNig
0118nQf/R+gaw3X7zD28Ee0fb5e4rcIIsxL2d1wmxWL6jkgQ/kbNmDx+nKY12dBx
pBsA69d5mP9I1RfXVOTaH6XFZd+iD2lcCrglXNaNyoo8O+p5y+nTKrVJr3yMEcHr
8asGp052fHln6FPSNTV8mvQYadWVYxBjEQVBrHJNp8nl5dZAn6uvW/V9AzWKMLWf
JOHv/Wu6229FlBnIcjHinPPHQFId5QaPS8sCZzGNefGZg3x1s9872bgvmBhqsQI+
/HxHDGtSCbrYcpKT7ykpcW5hkuYO+0+kqJZ7gMAzznxnDuKZ40hVXY9x+EVudwMn
dlYpGqn4jnFxYzDWJOr/tc1lKQF4JQ==
=wQkw
-----END PGP SIGNATURE-----

--n7sqxwpygc2d6wn2--
