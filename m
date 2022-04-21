Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65DDF5099D4
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 09:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385961AbiDUHob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 03:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386070AbiDUHnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 03:43:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3081A3A7
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 00:40:20 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nhRQ0-0000ar-Le; Thu, 21 Apr 2022 09:40:00 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-6754-95df-0276-ee1b.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:6754:95df:276:ee1b])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D488767FF4;
        Thu, 21 Apr 2022 07:39:56 +0000 (UTC)
Date:   Thu, 21 Apr 2022 09:39:56 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Martin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the net-next tree
Message-ID: <20220421073956.uin74ejmt6okxly7@pengutronix.de>
References: <20220421170749.1c0b56db@canb.auug.org.au>
 <202204210929.46477.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sak2e7zagjnn2h7n"
Content-Disposition: inline
In-Reply-To: <202204210929.46477.pisa@cmp.felk.cvut.cz>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--sak2e7zagjnn2h7n
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21.04.2022 09:29:46, Pavel Pisa wrote:
> On Thursday 21 of April 2022 09:07:49 Stephen Rothwell wrote:
> > After merging the net-next tree, today's linux-next build (htmldocs)
> > produced this warning:
> >
> > Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst:
> > WARNING: document isn't included in any toctree
> >
> > Introduced by commit
> >
> >   c3a0addefbde ("docs: ctucanfd: CTU CAN FD open-source IP core
> > documentation.")
>=20
> I would be happy for suggestion for reference location.
>=20
> Is the next file right location=20
>=20
>   Documentation/networking/device_drivers/can/index.rst
>=20
> for reference to
>=20
>   Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst

Feel free to send a patch. I'm happy to take it.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--sak2e7zagjnn2h7n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJhCkkACgkQrX5LkNig
010qMwf/dypxeuTZEC6vQRlb1ngYhbb7US1donTW/CjSBuCOs1px084X/jcKr5aO
Dbgr6dMvcou4OV6OIrYmd0kWBBv4bjh1lZbm2eJEVZJPVlA2MzAs5D/xZNtQRKcf
bo3v49Yi57f+99IBHKcOA1NazqBxBHe38U1cUFufxLgvKvCjN396aeKIKtPzngCW
aOXx/+4oOiGqbAabsIG7CXGhayE+/474OA21JuMRzjV7HJJonG0a2xc9rU16tmyi
79muP/gdkXYf26ECB5U2rfYuv6D5Q3i0/B18Prr1/xJqmWKUuTDsWa0z5Acbbvm8
w62k0M/zuKO98p03bs3nQMT2FgFOYw==
=5rUs
-----END PGP SIGNATURE-----

--sak2e7zagjnn2h7n--
