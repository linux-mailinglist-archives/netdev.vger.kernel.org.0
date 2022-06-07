Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF19F53F6F2
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 09:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237541AbiFGHNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 03:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237554AbiFGHNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 03:13:14 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F6119C2B
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 00:13:13 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nyTOm-0002mw-8X; Tue, 07 Jun 2022 09:13:08 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 30BC38D77E;
        Tue,  7 Jun 2022 07:13:06 +0000 (UTC)
Date:   Tue, 7 Jun 2022 09:13:05 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can <linux-can@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Max Staudt <max@enpas.org>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 0/7] can: refactoring of can-dev module and of Kbuild
Message-ID: <20220607071305.olsrshjqtmkrp5et@pengutronix.de>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220604163000.211077-1-mailhol.vincent@wanadoo.fr>
 <2e8666f3-1bd9-8610-6b72-e56e669d3484@hartkopp.net>
 <CAMZ6RqKWUyf6dZmxG809-yvjg5wbLwPSLtEfv-MgPpJ5ra=iGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mgsbpo4n6776e7lh"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqKWUyf6dZmxG809-yvjg5wbLwPSLtEfv-MgPpJ5ra=iGQ@mail.gmail.com>
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


--mgsbpo4n6776e7lh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.06.2022 11:49:30, Vincent MAILHOL wrote:
[...]
> So I think that the diagram is correct. Maybe rephrasing the cover
> letter as below would address your concerns?

BTW: I got the OK from Jakub to send PR with merges.

If you think the cover letter needs rephrasing, send a new series and
I'm going to force push that over can-next/master. After that let's
consider can-next/master as fast-forward only.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--mgsbpo4n6776e7lh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKe+nwACgkQrX5LkNig
013wTwgAlcP3nZHN7Z1ztiCpNOZJjCinvwJafPOpjxyax+kE//w5nTQrKruBY+bh
h/J6u+8MQrmuPI+RunwoSIp5MDS7BjosH5PVmyE4KbjzPTzJk8Xm2u5rSTdrvGBo
oVt8y3DcjZuzpby4bpdV0YyjP0m7QyWMRXpPTZiumERcUGAT2rDDHP0Vi5c0D4MH
xF1K6C2OXnmJHCQk9ryDG7SEipCpXJbLMNug5mvNp936BR+SKh4j4JnbiuzT/WaG
sAt9mH0bxkKm2KwJm4KyD+o4tNEH/3B2grfAIXE5yDSS5pUk2uFmAo5NBZ1khM0H
jQuM1MwW/RNtcg97qjfJmvjluqlVWw==
=Bqqn
-----END PGP SIGNATURE-----

--mgsbpo4n6776e7lh--
