Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 346CD529FC2
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 12:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344825AbiEQKtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 06:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344838AbiEQKsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 06:48:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7650848E7A
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 03:48:09 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nqukH-0000lW-37; Tue, 17 May 2022 12:48:05 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 588EC80430;
        Tue, 17 May 2022 10:45:46 +0000 (UTC)
Date:   Tue, 17 May 2022 12:45:45 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/4] can: skb:: move can_dropped_invalid_skb and
 can_skb_headroom_valid to skb.c
Message-ID: <20220517104545.eslountqjppvcnz2@pengutronix.de>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220514141650.1109542-1-mailhol.vincent@wanadoo.fr>
 <20220514141650.1109542-4-mailhol.vincent@wanadoo.fr>
 <7b1644ad-c117-881e-a64f-35b8d8b40ef7@hartkopp.net>
 <CAMZ6RqKZMHXB7rQ70GrXcVE7x7kytAAGfE+MOpSgWgWgp0gD2g@mail.gmail.com>
 <20220517060821.akuqbqxro34tj7x6@pengutronix.de>
 <CAMZ6RqJ3sXYUOpw7hEfDzj14H-vXK_i+eYojBk2Lq=h=7cm7Jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dy5lya2n3tvgocui"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqJ3sXYUOpw7hEfDzj14H-vXK_i+eYojBk2Lq=h=7cm7Jg@mail.gmail.com>
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


--dy5lya2n3tvgocui
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17.05.2022 16:04:53, Vincent MAILHOL wrote:
> So slcan, v(x)can and can-dev will select can-skb, and some of the
> hardware drivers (still have to figure out the list) will select
> can-rx-offload (other dependencies will stay as it is today).

For rx-offload that's flexcan, ti_hecc and mcp251xfd

> I think that splitting the current can-dev into can-skb + can-dev +
> can-rx-offload is enough. Please let me know if you see a need for
> more.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--dy5lya2n3tvgocui
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKDfNcACgkQrX5LkNig
011riwf+MG2N6WIbcv9M35tGFR/qSkQ4Bn10GPfSr+mjOjaWam9XZnsHy0E8gB0+
Cx1npRDb54aEkQ8zeVZMCl4GQQiiwgr3qlBaOwTz4N8i02D8mIDDZwTIfGpqprey
5PAcI7Xz+xM5Pc889OHbGq3F0qIx0VEnzBLAyzW/RscpbrFrIW3gpYJHA6Qz34zD
5kc8lW8wYb7ev2wIevJ2aDQaqGhzh0sWVHv8IDrB1hBvAy9m/uS1jhfzboVGdZ0+
oVR+COehpBdVkcQZaKjgrO6MEdmB7Uoir0AqBOTGB4huRR5jJzawnp9vP55/A0CU
upqO2ta1qwcIzFGw+CbtAsCjYaU06Q==
=NtJl
-----END PGP SIGNATURE-----

--dy5lya2n3tvgocui--
