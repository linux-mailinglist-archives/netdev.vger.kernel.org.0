Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A66523434
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 15:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238687AbiEKNYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 09:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242899AbiEKNYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 09:24:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2027B5B3D5
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 06:24:30 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nomKF-0000rv-1n; Wed, 11 May 2022 15:24:23 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B199D7BD22;
        Wed, 11 May 2022 13:24:21 +0000 (UTC)
Date:   Wed, 11 May 2022 15:24:21 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Devid Antonio Filoni <devid.filoni@egluetechnologies.com>,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: Re: [PATCH 1/1] can: skb: add and set local_origin flag
Message-ID: <20220511132421.7o5a3po32l3w2wcr@pengutronix.de>
References: <20220511121913.2696181-1-o.rempel@pengutronix.de>
 <b631b022-72d5-9160-fd13-f33c80dbbe59@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="regs3wlmb3rwqwth"
Content-Disposition: inline
In-Reply-To: <b631b022-72d5-9160-fd13-f33c80dbbe59@hartkopp.net>
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


--regs3wlmb3rwqwth
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11.05.2022 14:38:32, Oliver Hartkopp wrote:
> IMO this patch does not work as intended.
>=20
> You probably need to revisit every place where can_skb_reserve() is used,
> e.g. in raw_sendmsg().

And the loopback for devices that don't support IFF_ECHO:

| https://elixir.bootlin.com/linux/latest/source/net/can/af_can.c#L257

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--regs3wlmb3rwqwth
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJ7uQIACgkQrX5LkNig
0112+Af+Pp84b/2x9pkUckJd7BiXaSSo95W2yPRSjLaA3r1A6jbGBVrogvYl49Xg
MnKDo6z/Av30GwwOaKLXnMSdtL1Q73PabyGKD+ILzKQLxpAp3kXMVcz9M2jZliMF
BqR6VjklD+9TrA6PBQ8YMqU1hROnr3Fb5shQtjhsa099Y1eG4riDSutyQ7AWUO9h
luo3MTyzvY6Lml/yxm82qzzpJLOd7tvmN1OpFS/DV1Eyu5lr9sXp3cYvlqpc6MK5
3Hc1tnbZ2Gss1drs9kKY5A6Fmx/YYklnsBzHVTAfiVBvqJ+Mgq9qw9SKIijG2nVa
zHwaaZf/y6fiuSXfiHYkmTnNq1FjWA==
=qnXD
-----END PGP SIGNATURE-----

--regs3wlmb3rwqwth--
