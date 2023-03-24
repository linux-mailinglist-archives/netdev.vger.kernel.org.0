Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3D26C809B
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 16:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbjCXPBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 11:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbjCXPBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 11:01:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86BEF199E3
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 08:01:02 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pfiuX-00033W-Ul; Fri, 24 Mar 2023 16:00:58 +0100
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 4F95A19B907;
        Fri, 24 Mar 2023 14:57:43 +0000 (UTC)
Date:   Fri, 24 Mar 2023 15:57:42 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v4 0/2] can: rcar_canfd: Add transceiver support
Message-ID: <20230324145742.j4ec237uxcehivsx@pengutronix.de>
References: <cover.1679414936.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5ikkmcmpcuvjoqhk"
Content-Disposition: inline
In-Reply-To: <cover.1679414936.git.geert+renesas@glider.be>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5ikkmcmpcuvjoqhk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21.03.2023 17:14:59, Geert Uytterhoeven wrote:
> 	Hi all,
>=20
> This patch series adds transceiver support to the Renesas R-Car CAN-FD
> driver, and improves the printing of error messages, as requested by
> Vincent.
>=20
> Originally, both patches were submitted separately, but as the latter
> depends on the former, I absorbed it within this series for the resend.

Thanks. Applied to can-next, I've replaced the colons by comma, as
Vincent suggested.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129  |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--5ikkmcmpcuvjoqhk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQdumIACgkQvlAcSiqK
BOgNPAgAhGtrMn4SrYmt4r929BMsV3fb4ZH2NvyjrIjebzSgwk8f73q8tZmCFtW9
ysA1Hzk2zcpDwMiIQgcfeiVPSB8vzMX35CVXMxYSt2iOmog+fwcGLGSJfXsYMSxF
4XtnIYrQJkf6fuse5/2EE77i5G4MO9a33yzJf9UMYuzw44Fz7GJPCxY+zR6nT70s
oa3N0v6TmpH1WtRVmo3xKW9fPrf6bOKkfWc6Bbx3KXUobn6lQcQ2Sn0rnQCWJx1Q
BxVlu9PmQQv4kN9qoLI+OhvDpVMkFt4kKnTgmdwr8/69jVt3L1EAMjuNih1cTsMa
kDwWLMXAxd7SVaTNpg/pPKbYVsd88A==
=MSlf
-----END PGP SIGNATURE-----

--5ikkmcmpcuvjoqhk--
