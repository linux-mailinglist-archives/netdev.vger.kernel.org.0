Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A576EC9C4
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 12:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbjDXKGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 06:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjDXKGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 06:06:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C7D270B
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 03:06:50 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pqt5c-0004Gj-FR; Mon, 24 Apr 2023 12:06:32 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id BEF441B60C8;
        Mon, 24 Apr 2023 10:06:29 +0000 (UTC)
Date:   Mon, 24 Apr 2023 12:06:28 +0200
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
Subject: Re: [PATCH 4/4] can: bxcan: add support for single peripheral
 configuration
Message-ID: <20230424-fracture-going-5dcaf06a9e6c-mkl@pengutronix.de>
References: <20230423172528.1398158-1-dario.binacchi@amarulasolutions.com>
 <20230423172528.1398158-5-dario.binacchi@amarulasolutions.com>
 <20230423-surplus-spoon-4e8194434663-mkl@pengutronix.de>
 <CABGWkvqA2hwgfGvVWS08Qu-2ZUbwc82ynhvq8-FqFuhHoV-vhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nlfwcmgjkz5caxu3"
Content-Disposition: inline
In-Reply-To: <CABGWkvqA2hwgfGvVWS08Qu-2ZUbwc82ynhvq8-FqFuhHoV-vhw@mail.gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
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


--nlfwcmgjkz5caxu3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24.04.2023 08:56:03, Dario Binacchi wrote:
> > This probably works. Can we do better, i.e. without this additional cod=
e?
> >
> > If you add a syscon node for the single instance CAN, too, you don't
> > need a code change here, right?
>=20
> I think so.
>=20
> I have only one doubt about it. This implementation allows,
> implicitly, to distinguish if the peripheral is in single
> configuration (without handle to the gcan node) or in double
> configuration (with handle to the gcan node). For example, in single
> configuration the peripheral has 14 filter banks, while in double
> configuration there are 26 shared banks. Without code changes, this
> kind of information is lost. Is it better then, for future
> developments, to add a new boolean property to the can node of the dts
> (e.g. single-conf)?

The DT ist not yet mainline, so we can still change it. Another option
is to have "st,can-primary" and "st,can-secondary" for the shared
peripherals and nothing for the single instance.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--nlfwcmgjkz5caxu3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRGVKIACgkQvlAcSiqK
BOhkmwf/fVsu1OGCtagGs762m2UGMM/F1PtRokDn3Tcnq/TQBj4sCNJ6zYtz9sfX
kk1N7j3IpnOzDGeoR4UaeTzxg3Eu5dHoLsFGoka0mHd3RsOvbL4PO0UFAWAjv8lQ
ys32uN6DHtSPHCOWhCWbDxaO+7ebiEXoyCmf8NGYwYBMzOnTSDl13uPTKgo/l60t
2JJFQwbFbmhE9BBxkRKfWuN6VuyO5X0XdQl880tUiWZ8PkUQDwYrTnKYnNE8MIxC
xGoAmo1WKnPGCA8HB+878bgQ/Vf8/fMsUZJezFCN8sZ0QGGwo6HKq4MRSJ+Dse40
d/tLDEVGvEa0iVfBmaswhHr+jLd0lg==
=Ifbf
-----END PGP SIGNATURE-----

--nlfwcmgjkz5caxu3--
