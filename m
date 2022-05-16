Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF4152921F
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 23:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348697AbiEPVEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 17:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349067AbiEPVE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 17:04:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970835C773
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 13:40:10 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nqhVa-0007jS-Ks; Mon, 16 May 2022 22:40:02 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 860AB7FBBC;
        Mon, 16 May 2022 20:40:01 +0000 (UTC)
Date:   Mon, 16 May 2022 22:40:00 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 1/4] can: slcan: use can_dropped_invalid_skb() instead
 of manual check
Message-ID: <20220516204000.t7yhhtp3jtekg7ar@pengutronix.de>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220514141650.1109542-1-mailhol.vincent@wanadoo.fr>
 <20220514141650.1109542-2-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qi7wwt46b6orgwpu"
Content-Disposition: inline
In-Reply-To: <20220514141650.1109542-2-mailhol.vincent@wanadoo.fr>
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


--qi7wwt46b6orgwpu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.05.2022 23:16:47, Vincent Mailhol wrote:
> slcan does a manual check in slc_xmit() to verify if the skb is
> valid. This check is incomplete, use instead
> can_dropped_invalid_skb().
>=20
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

I've taken this patch into the latest pull request to net-next.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--qi7wwt46b6orgwpu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKCtp4ACgkQrX5LkNig
0112AAf9EDMHiYNZoWtjw22NJonJySrZp/LhwR3Zxjqt8dzAScwqNu7By00++gid
y2c/5koi0tRHl3dEfYwT+JqmaS2ywuHCIaovOFR9/8XW6gz3risdRyWisdKL1QaV
ICgGVgWr0PdlmkKzacM2VAZjLfFQTrE4pjuTexPGNv+NGwdcoPQbvnlNVkFWFaCf
EcDZT4X7I140UPwlA+59MPQkOp0WphjudRS6PeYprC6Io3m4fvQ/LCCCt33q4b1n
JrkRLvNA5u0do0+4rq0ygbAYZUPLeJ8i6TWTDEagLQ8EFicGrOV57DifMrxGBHJu
0Ejnhezuqw8XE0FgkIFmfCI2cjLAWg==
=gWnZ
-----END PGP SIGNATURE-----

--qi7wwt46b6orgwpu--
