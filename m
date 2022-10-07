Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 872975F74FC
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 09:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiJGH5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 03:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiJGH5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 03:57:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C471C107
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 00:57:01 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ogiDy-0008DF-0P; Fri, 07 Oct 2022 09:56:50 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 201DAF6BFB;
        Fri,  7 Oct 2022 07:56:48 +0000 (UTC)
Date:   Fri, 7 Oct 2022 09:56:47 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Kees Cook <keescook@chromium.org>
Cc:     Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] can: kvaser_usb: Remove -Warray-bounds exception
Message-ID: <20221007075647.3e2jm4g5qlytvqgo@pengutronix.de>
References: <20221006192035.1742912-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mdrwwnddiarwtxpo"
Content-Disposition: inline
In-Reply-To: <20221006192035.1742912-1-keescook@chromium.org>
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


--mdrwwnddiarwtxpo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 06.10.2022 12:20:35, Kees Cook wrote:
> GCC-12 emits false positive -Warray-bounds warnings with
> CONFIG_UBSAN_SHIFT (-fsanitize=3Dshift). This is fixed in GCC 13[1],
> and there is top-level Makefile logic to remove -Warray-bounds for
> known-bad GCC versions staring with commit f0be87c42cbd ("gcc-12: disable
> '-Warray-bounds' universally for now").
>=20
> Remove the local work-around.
>=20
> [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D105679
>=20
> Signed-off-by: Kees Cook <keescook@chromium.org>

Applied to linux-can-next/main.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--mdrwwnddiarwtxpo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmM/27wACgkQrX5LkNig
010vAQgAkL2nVGUp5uFl5m5LUQQDiBi5hflSPSP1u7B8UrI7yuPAwLF+mlzv80PO
eS+yMvKoAC6tiFPHS0p7tmBdxiJBZ4u8/64qOh73cx1qizqk6g9MTT3i8eOk0oY6
bSgrhhwyYZAK67O7xueEJogtxKI41caGhX9KUvqEU/1qb7bNvZqUCGb9k4GtGSFA
6ctpE/WJ158TWcgKOM8T6gM8e42Nnjt8C8JCODNmotLNMYtqZRaqa/56ECQ+oSVh
GbG+h7E0A2+hZc926FXqEfDPy3gJJxYvpKSPVvJxGchm5PCmbg0rytte6P0Mp7w3
9Un5ncNR6QnIXLGsNCG02X5lRz4B5A==
=3Lk2
-----END PGP SIGNATURE-----

--mdrwwnddiarwtxpo--
