Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABAE544495
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 09:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237469AbiFIHQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 03:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238900AbiFIHQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 03:16:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6052428D4
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 00:16:51 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nzCPH-0004ve-Ff; Thu, 09 Jun 2022 09:16:39 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1D9A78FC8B;
        Thu,  9 Jun 2022 07:16:37 +0000 (UTC)
Date:   Thu, 9 Jun 2022 09:16:36 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 06/13] can: slcan: allow to send commands to the
 adapter
Message-ID: <20220609071636.6tbspftu3yclip55@pengutronix.de>
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
 <20220607094752.1029295-7-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7stl6ydzt5xshu4k"
Content-Disposition: inline
In-Reply-To: <20220607094752.1029295-7-dario.binacchi@amarulasolutions.com>
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


--7stl6ydzt5xshu4k
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.06.2022 11:47:45, Dario Binacchi wrote:
> This is a preparation patch for the upcoming support to change the
> bitrate via ip tool, reset the adapter error states via the ethtool API
> and, more generally, send commands to the adapter.
>=20
> Since some commands (e. g. setting the bitrate) will be sent before
> calling the open_candev(), the netif_running() will return false and so
> a new flag bit (i. e. SLF_XCMD) for serial transmission has to be added.
>=20
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

I think this patch can be dropped, let me explain:

You don't have to implement the do_set_bittiming callback. It's
perfectly OK to set the bitrate during the ndo_open callback after
open_candev().

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--7stl6ydzt5xshu4k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKhnlEACgkQrX5LkNig
011KPAf+MP0nAePFTpQQJOwpxv468csZ37atHCgPNOWmGIw4u0n3zvQnLJzPOzY3
G5hckJvFCJblep4Dxm3k2XU0zYo8cK/nQ5lLJ1jYQ1rh1RZzlET/7bV2nu/yCFzm
aiRzEksO6SZMDLCy6BwMB6lwXEtMYdwpDrS2fOcn5Rcv17NJez2bJH5C3kIa5Wrp
XPzVcgUYeD8Z+ARdkOsUvbwWnl1bHmGZaLrZWWtEbmqQ5w/Kq0z4zwvwUKo14mNx
4d3KUwFcbJMtuwpz65qc5De9YjESWawuCqJfLw19InkhJElsxNQAUuWIEt+SE8jR
UZJRpgRPRue7e1aXyRiGPwmuGwTgEQ==
=jCQx
-----END PGP SIGNATURE-----

--7stl6ydzt5xshu4k--
