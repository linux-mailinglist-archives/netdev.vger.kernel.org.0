Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDBB75AE05F
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 08:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238354AbiIFG5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 02:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbiIFG5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 02:57:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD5872B70
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 23:57:37 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oVSWV-0001FF-8W; Tue, 06 Sep 2022 08:57:27 +0200
Received: from pengutronix.de (unknown [IPv6:2a0a:edc0:0:701:b512:8477:12a4:5bf])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 292CCDB5D0;
        Tue,  6 Sep 2022 06:57:25 +0000 (UTC)
Date:   Tue, 6 Sep 2022 08:57:24 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] docs: networking: device drivers: flexcan: fix invalid
 email
Message-ID: <20220906065724.m7tshei6d22vdm5z@pengutronix.de>
References: <20220828134442.794990-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="t6qnny6ibckwrep7"
Content-Disposition: inline
In-Reply-To: <20220828134442.794990-1-dario.binacchi@amarulasolutions.com>
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


--t6qnny6ibckwrep7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.08.2022 15:44:42, Dario Binacchi wrote:
> The Amarula contact info email address is wrong, so fix it up to use the
> correct one.
>=20
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

Applied to linux-can-next.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--t6qnny6ibckwrep7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMW71EACgkQrX5LkNig
011QMQf/dgqSh15X3sp3oGNXLRquTQW1q1TtBFpH6XFVstANsUEsT0ERt2xLLMcn
RJNnmRPBggIeqo0e6Sk0q5sniSruKNqbynvnPnGRTD0+UxM8teA7eCSgwrEL0lpK
ngkyOv4k+aiY9GyvkpylcUfyBwk2avNxYXS07U6A2S5CF4z0dEXjvfGzG9ZWLvxC
iG9w0fA0nYs7EvnS+962UNQCGbY3+NJQ9zMOoKDKCp5+SXFJ+2MDj2awTjhCR7wX
A2wYk/SeoCZ7QFIAfG8Ls25OPF/Aao2xdFhNpXliRDF6oKeThhDSI/r/cgPdCOei
rrXVWhPfhAxdTqwnhMFRNK8c/rI0ig==
=nOQG
-----END PGP SIGNATURE-----

--t6qnny6ibckwrep7--
