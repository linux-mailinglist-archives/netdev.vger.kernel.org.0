Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48761636D69
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 23:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiKWWmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 17:42:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiKWWmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 17:42:23 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CEC93CDD
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 14:42:23 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oxyRE-00020Y-Hi; Wed, 23 Nov 2022 23:41:52 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:2e2e:9f36:4c74:dde5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 994ED127BF5;
        Wed, 23 Nov 2022 22:41:48 +0000 (UTC)
Date:   Wed, 23 Nov 2022 23:41:46 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vivek Yadav <vivek.2311@samsung.com>
Cc:     rcsekar@samsung.com, krzysztof.kozlowski+dt@linaro.org,
        wg@grandegger.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, pankaj.dubey@samsung.com,
        ravi.patel@samsung.com, alim.akhtar@samsung.com,
        linux-fsd@tesla.com, robh+dt@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        aswani.reddy@samsung.com, sriranjani.p@samsung.com
Subject: Re: [PATCH v3 1/2] can: m_can: Move mram init to mcan device setup
Message-ID: <20221123224146.iic52cuhhnwqk2te@pengutronix.de>
References: <20221122105455.39294-1-vivek.2311@samsung.com>
 <CGME20221122105022epcas5p3f5db1c5790b605bac8d319fe06ad915b@epcas5p3.samsung.com>
 <20221122105455.39294-2-vivek.2311@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cil7nudg4royyvqc"
Content-Disposition: inline
In-Reply-To: <20221122105455.39294-2-vivek.2311@samsung.com>
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


--cil7nudg4royyvqc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 22.11.2022 16:24:54, Vivek Yadav wrote:
> When we try to access the mcan message ram addresses, hclk is
> gated by any other drivers or disabled, because of that probe gets
> failed.
>=20
> Move the mram init functionality to mcan device setup called by
> mcan class register from mcan probe function, by that time clocks
> are enabled.

Why not call the RAM init directly from m_can_chip_config()?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--cil7nudg4royyvqc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmN+oagACgkQrX5LkNig
011CiQf/e32bdb0BoAliyr1ZRwrW/c5KZqmDEeb4gpGTrA+uk73UwZje2Z7ONoUG
i/N5b0FpZTka1LfBi+XANlo77wmwTrvRut5OdXSw++JobVghAqqJOOLGZLJ5k4xz
glFz35NhXTNlY6VMs5l8Mg0X/lBNcTQ0WkjUUZylqF63c8szMbZcIxG2avMB00dS
BPIsmfMwSjwQqle7i2VXnjH8cW7A2jrDytYx0Azai4a6NrZ8ZxK47aAiyuMfvUsA
t2kJZHqp1IfSnhZ99QHvAPMOsYVO26bqvN0EDdd0ZVo9kij/moh2aqOh3XwCoqQF
OA1iycEnvVQh1ytL69snZMIEm1GkEw==
=geD9
-----END PGP SIGNATURE-----

--cil7nudg4royyvqc--
