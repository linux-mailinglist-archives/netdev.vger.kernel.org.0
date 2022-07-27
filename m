Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5FC58256C
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 13:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbiG0LbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 07:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbiG0LbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 07:31:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9341BEB9
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 04:31:11 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oGfFk-0003VQ-Px; Wed, 27 Jul 2022 13:31:00 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id ACA2ABC135;
        Wed, 27 Jul 2022 11:30:57 +0000 (UTC)
Date:   Wed, 27 Jul 2022 13:30:54 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH v3 8/9] can: slcan: add support to set bit time
 register (btr)
Message-ID: <20220727113054.ffcckzlcipcxer2c@pengutronix.de>
References: <20220726210217.3368497-1-dario.binacchi@amarulasolutions.com>
 <20220726210217.3368497-9-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wo6f23lv67r22v2k"
Content-Disposition: inline
In-Reply-To: <20220726210217.3368497-9-dario.binacchi@amarulasolutions.com>
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


--wo6f23lv67r22v2k
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26.07.2022 23:02:16, Dario Binacchi wrote:
> It allows to set the bit time register with tunable values.
> The setting can only be changed if the interface is down:
>=20
> ip link set dev can0 down
> ethtool --set-tunable can0 can-btr 0x31c
> ip link set dev can0 up

As far as I understand, setting the btr is an alternative way to set the
bitrate, right? I don't like the idea of poking arbitrary values into a
hardware from user space.

Do you have a use case for this?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--wo6f23lv67r22v2k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLhIesACgkQrX5LkNig
013QcAgAki/APZw2NZdx7MYizFEMgcZs7wph/ASDUdNrNRR41Q+qDqxCS3MMn+Sx
mbORSwe2pNt1z1CrjnOMqHLNWCZ86ejIHa52iGlWOGhc88oC9U5wKk2kTP97C8tf
Pd+vsu1J/cA53Z2dmDfIrl58+xRJOdqfRzvh4J/nL0AfXfTjvXCVFGIBN/Dv8JXp
6caqLbi3HRCp0gJ87lWk8TnLvJ2rlLXHVYHxwe6+tZ3CJn7/HaB69mBVDPEGE1sg
6laYbxsGKk9qiD+Is8lvHzWUT3Bq8Gniu+vpp8GV6cnxeBSCLDUIChPK+kLhbYkz
bpo+kfyfBJgF2W6pVbapeLD4BiFhVA==
=bFCW
-----END PGP SIGNATURE-----

--wo6f23lv67r22v2k--
