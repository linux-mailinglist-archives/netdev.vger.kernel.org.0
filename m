Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6224EDDC5
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 17:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237054AbiCaPsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 11:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239807AbiCaPs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 11:48:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67433D1DD
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 08:45:57 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nZwzf-0001Ux-9S; Thu, 31 Mar 2022 17:45:51 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-ffcf-bd2e-518f-8dbf.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:ffcf:bd2e:518f:8dbf])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id CF03B57E4B;
        Thu, 31 Mar 2022 15:45:49 +0000 (UTC)
Date:   Thu, 31 Mar 2022 17:45:49 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH net 0/n] pull-request: can 2022-03-31
Message-ID: <20220331154549.wqtxsepujwwap5wg@pengutronix.de>
References: <20220331084634.869744-1-mkl@pengutronix.de>
 <20220331084223.5d145b23@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rf447r2yt5hqkosf"
Content-Disposition: inline
In-Reply-To: <20220331084223.5d145b23@kernel.org>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rf447r2yt5hqkosf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 31.03.2022 08:42:23, Jakub Kicinski wrote:
> On Thu, 31 Mar 2022 10:46:26 +0200 Marc Kleine-Budde wrote:
> > The first patch is by Oliver Hartkopp and fixes MSG_PEEK feature in
> > the CAN ISOTP protocol (broken in net-next for v5.18 only).
> >=20
> > Tom Rix's patch for the mcp251xfd driver fixes the propagation of an
> > error value in case of an error.
> >=20
> > A patch by me for the m_can driver fixes a use-after-free in the xmit
> > handler for m_can IP cores v3.0.x.
> >=20
> > Hangyu Hua contributes 3 patches fixing the same double free in the
> > error path of the xmit handler in the ems_usb, usb_8dev and mcba_usb
> > USB CAN driver.
> >=20
> > Pavel Skripkin contributes a patch for the mcba_usb driver to properly
> > check the endpoint type.
> >=20
> > The last patch is by me and fixes a mem leak in the gs_usb, which was
> > introduced in net-next for v5.18.
>=20
> I think patchwork did not like the "0/n" in the subject :(

Should I resend (with a fixed subject)?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--rf447r2yt5hqkosf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJFzKkACgkQrX5LkNig
0112pwgAo79AkuTCJ7ZI9GalcPMXwaJx2Ko7iSVABcuHaL2V4I/4UX7JFAJBLmDr
9T4/L5JqP5ow83hg3HRcozC7HPmMwyjbvZltBqOZ4jwVvZPVa2rzqgZTbXjLwKhg
rKUq4+wYVszsOzV0M9pj0sqw/eiNpsjAfOIPLCtC3uBZaOO+3QgO7CDvSJaj9ynZ
nnytNLqf396zYN6DdQYfKHZ/e+0+SwdFAXkB8QrajNUUVpvMOziYrr/k4imICERm
Oe8R+F1uDPp20FbTuk8WRh3/+qglNIUVsEeHeFsQA3woYb7CorTwHJz01uAwDStQ
NHoOBLlngXrZemMYkXxhx60iB2QzlQ==
=Izfj
-----END PGP SIGNATURE-----

--rf447r2yt5hqkosf--
