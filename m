Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89DB769115C
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 20:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjBITai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 14:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjBITae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 14:30:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8397F6A720
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 11:30:32 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pQCck-0002Gj-6v; Thu, 09 Feb 2023 20:30:26 +0100
Received: from pengutronix.de (hardanger-9.fritz.box [IPv6:2a03:f580:87bc:d400:3254:7f93:f3b2:3e1b])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B9C4E174D02;
        Thu,  9 Feb 2023 19:30:23 +0000 (UTC)
Date:   Thu, 9 Feb 2023 20:30:23 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Frank Jungclaus <Frank.Jungclaus@esd.eu>
Cc:     Stefan =?utf-8?B?TcOkdGpl?= <Stefan.Maetje@esd.eu>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mailhol.vincent@wanadoo.fr" <mailhol.vincent@wanadoo.fr>
Subject: Re: [PATCH 2/3] can: esd_usb: Improved behavior on esd CAN_ERROR_EXT
 event (2)
Message-ID: <20230209193023.uyb2isvrrjguhtbc@pengutronix.de>
References: <20221219212717.1298282-1-frank.jungclaus@esd.eu>
 <CAMZ6RqKAmrgQUKLehUZx+hiSk3jD+o44uGtzrRFk+RBk8Bt81A@mail.gmail.com>
 <a1d253bacdf296947a45fb069a0fd64eabb7e117.camel@esd.eu>
 <CAMZ6RqLeHNzZyKdCmqXDDtd5GZC8KZ0Y1hESYyPaaMbFe=ryYQ@mail.gmail.com>
 <786db8fae65a2ed415b5dd0c3001b4dfc8c7112b.camel@esd.eu>
 <20230202152256.kc5xh4e4m6panumw@pengutronix.de>
 <da0551556e42fd67c0b743d6d066fb09702571ef.camel@esd.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ls46os5cfnvtd7aa"
Content-Disposition: inline
In-Reply-To: <da0551556e42fd67c0b743d6d066fb09702571ef.camel@esd.eu>
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


--ls46os5cfnvtd7aa
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.02.2023 19:00:54, Frank Jungclaus wrote:
> > Not taking this series, waiting for the reworked version.
> >=20
> > Marc
> >=20
> Marc, can I just send a reworked patch of [PATCH 2/3], let's say
> with subject [PATCH v2 2/3] as a reply to this thread or should I
> better resend the complete patch series as [PATCH v2 0/3] up to
> [PATCH v2 3/3]?

Just re-post the whole series. Complete series are easier to handle.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ls46os5cfnvtd7aa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmPlScsACgkQvlAcSiqK
BOgN3gf5AXwvdYF1Okk+KgXGxwMVb1X/CBxO0Xes1mA6DzRZZRUxdw3UU1wDwTc5
K+5wR3iWcm7bt/PzgDk1kukyQZ7+uVh69IUCGtzP6GgZtOPJjfbP6/lifkJSn7Qc
ujH1Ay+7Pq/AD9Z4pcSo7CxG/QvCOLL1XaA0eIXqkuPA7jqoSkgqr6rvHz2dFjoZ
Fd2MJFSPTtYK8qJwTuoYadp070vvRSUajVcT6G+lWQM3m42b9Be+URY345P07PFO
qY2Dh0B49owZvZ5m4fe/VFwFvkAYyNlwB7p2X8alUwa3is/SzIYCfb1XyTQLYlck
5EqnUmol4RBRgCgkIYiEPEBdb98qOA==
=P+AW
-----END PGP SIGNATURE-----

--ls46os5cfnvtd7aa--
