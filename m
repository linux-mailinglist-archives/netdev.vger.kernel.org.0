Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535A34AEB70
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 08:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239437AbiBIHtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 02:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239669AbiBIHtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 02:49:42 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E17FC05CBA5
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 23:49:42 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nHhjK-0002UW-MQ; Wed, 09 Feb 2022 08:49:34 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A64A62EEE4;
        Wed,  9 Feb 2022 07:49:33 +0000 (UTC)
Date:   Wed, 9 Feb 2022 08:49:30 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Srinivas Neeli <srinivas.neeli@xilinx.com>
Cc:     wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        michal.simek@xilinx.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, appana.durga.rao@xilinx.com,
        sgoud@xilinx.com, git@xilinx.com
Subject: Re: [PATCH] can: xilinx_can: Add check for NAPI Poll function
Message-ID: <20220209074930.azbn26glrxukg4sr@pengutronix.de>
References: <20220208162053.39896-1-srinivas.neeli@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zar6w3gq6ud5tbfx"
Content-Disposition: inline
In-Reply-To: <20220208162053.39896-1-srinivas.neeli@xilinx.com>
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


--zar6w3gq6ud5tbfx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08.02.2022 21:50:53, Srinivas Neeli wrote:
> Add check for NAPI poll function to avoid enabling interrupts
> with out completing the NAPI call.

Thanks for the patch. Does this fix a bug? If so, please add a Fixes:
tag that lists the patch that introduced that bug.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--zar6w3gq6ud5tbfx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIDcgcACgkQrX5LkNig
0108nAf/ZasdLkXg7nYB6kH36IDS7QN92H98Mg4W97Tg3x0zfa1RZRKcd8frSZ5t
LXH59Nu5k675LeQp4jWyzignYO54QGcoz0AJ3UcaKInKN2wKUwvV3zlbILdjLb0O
nfPujAL5ubH6cTgc/uqZGYORumW2am4vfW9BqJL4zRM20ka0OCkx1Q3o92j7FoZz
bUBzEXBN6FV0evl+exdqszpOOdPenCE5i9TFCOMxYmJZoTBO7+NBCn/RZ79KCFfw
ewk77ZyUdf/hLUSEDV8/38KsvxEC0GQnnD4mk0JaIox6ZznSEGzvFdmwmkPo/5N7
2fopzMxuZHtjSqRl+6bgvjvXa5qaZw==
=6imx
-----END PGP SIGNATURE-----

--zar6w3gq6ud5tbfx--
