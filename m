Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9C15879E9
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 11:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235536AbiHBJeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 05:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbiHBJep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 05:34:45 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711DD402C4
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 02:34:44 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oIoIA-0005wN-Ok; Tue, 02 Aug 2022 11:34:22 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 705CFC130C;
        Tue,  2 Aug 2022 07:06:31 +0000 (UTC)
Date:   Tue, 2 Aug 2022 09:06:30 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Matej Vasilevski <matej.vasilevski@seznam.cz>
Cc:     Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 0/3] can: ctucanfd: hardware rx timestamps reporting
Message-ID: <20220802070630.7g5dyn732bh724az@pengutronix.de>
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="w4uynht36msvyibp"
Content-Disposition: inline
In-Reply-To: <20220801184656.702930-1-matej.vasilevski@seznam.cz>
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


--w4uynht36msvyibp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 01.08.2022 20:46:53, Matej Vasilevski wrote:
> Hello,
>=20
> this is the v2 patch for CTU CAN FD hardware timestamps reporting.
>=20
> This patch series is based on the latest net-next, as I need the patch
> - 9e7c9b8eb719 can: ctucanfd: Update CTU CAN FD IP core registers to matc=
h version 3.x.
> and the patch below to avoid git conflict (both this and my patch
> introduce ethtool_ops)
> - 409c188c57cd can: tree-wide: advertise software timestamping capabiliti=
es
>=20
> Changes in v2: (compared to the RFC I've sent in May)

Please add a link to the RFC here:
https://lore.kernel.org/all/20220512232706.24575-1-matej.vasilevski@seznam.=
cz

> - Removed kconfig option to enable/disable timestamps.
> - Removed dt parameters ts-frequency and ts-used-bits. Now the user
>   only needs to add the timestamping clock phandle to clocks, and even
>   that is optional.
> - Added SIOCSHWTSTAMP ioctl to enable/disable timestamps.
> - Adressed comments from the RFC review.
>=20
> Matej Vasilevski (3):
>   can: ctucanfd: add HW timestamps to RX and error CAN frames
>   dt-bindings: can: ctucanfd: add another clock for HW timestamping
>   doc: ctucanfd: RX frames timestamping for platform devices

Please reorder your patches so that the dt-bindings update comes first.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--w4uynht36msvyibp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLozPMACgkQrX5LkNig
01091Af+OFXdTcBJ8SC+XtUpGidcGMP3j/04HaOYtByP8I5TVp+WdTPZAJaPbVmj
N556yRn6xx+cbMZVYQQ0cRr0uDBMWiv0jKfP95EI6X9zQtv/eiACjoTI+81QRoPz
+bfPfCiDnPNZKGUhGRNdJiFRbbFBG998Ihim6RVsqZcTo3aQVzzKIK7yVOpx+vKH
e+d6wgTX0X6+iyqx5kKlONJk9vhxW9waSQEQDlu5f+M4K7djBEHg+cZkpgPI0W5P
5yFAmPQZJCi0RoySSKXxYcQQAFXkPeTTv3eS/6sAI5EkHe+eDwcaNm8jgt3syFh+
KAEvVRaI8HEqEXM/eVE9m9UXMac8OA==
=/wYk
-----END PGP SIGNATURE-----

--w4uynht36msvyibp--
