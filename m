Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781AB60C531
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 09:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbiJYHcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 03:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbiJYHcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 03:32:08 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5C027FE5
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 00:32:06 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1onEPX-0008Ls-40; Tue, 25 Oct 2022 09:31:43 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 72FB71092BD;
        Tue, 25 Oct 2022 07:31:40 +0000 (UTC)
Date:   Tue, 25 Oct 2022 09:31:36 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vivek Yadav <vivek.2311@samsung.com>
Cc:     rcsekar@samsung.com, wg@grandegger.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        pankaj.dubey@samsung.com, ravi.patel@samsung.com,
        alim.akhtar@samsung.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] dt-bindings: can: mcan: Add ECC functionality to
 message ram
Message-ID: <87k04oxsvb.fsf@hardanger.blackshift.org>
References: <20221021095833.62406-1-vivek.2311@samsung.com>
 <CGME20221021102625epcas5p4e1c5900b9425e41909e82072f2c1713d@epcas5p4.samsung.com>
 <20221021095833.62406-3-vivek.2311@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rbxgeu56cnkotd7p"
Content-Disposition: inline
In-Reply-To: <20221021095833.62406-3-vivek.2311@samsung.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rbxgeu56cnkotd7p
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

You should add the DT people on Cc:
- devicetree@vger.kernel.org
- Rob Herring <robh+dt@kernel.org>

On 21.10.2022 15:28:28, Vivek Yadav wrote:
> Whenever the data is transferred or stored on message ram, there are
> inherent risks of it being lost or corruption known as single-bit errors.
>=20
> ECC constantly scans data as it is processed to the message ram, using a
> method known as parity checking and raise the error signals for corruptio=
n.
>=20
> Add error correction code config property to enable/disable the
> error correction code (ECC) functionality for Message RAM used to create
> valid ECC checksums.
>=20
> Signed-off-by: Chandrasekar R <rcsekar@samsung.com>
> Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
> ---
>  Documentation/devicetree/bindings/net/can/bosch,m_can.yaml | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b=
/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> index 26aa0830eea1..0ba3691863d7 100644
> --- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> +++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> @@ -50,6 +50,10 @@ properties:
>        - const: hclk
>        - const: cclk
> =20
> +  mram-ecc-cfg:

This probably needs a prefix and a "$ref: /schemas/types.yaml#/definitions/=
phandle".

> +    items:
> +      - description: M_CAN ecc registers map with configuration register=
 offset
> +
>    bosch,mram-cfg:
>      description: |
>        Message RAM configuration data.
> --=20
> 2.17.1
>=20
>=20

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--rbxgeu56cnkotd7p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNXkNYACgkQrX5LkNig
0116ngf/WerB6eiZ4KhIIl2sbpwVomHHx1fa+rLxMF67iim61XShfYMP/KvselYd
7/99GeCXldUZwP/2LBZYERfyx/RLW0h74ZUKw2MaNh/qPPwjDmvCi87JAyB/9Y86
mPw4UHSvHLL7Fgrj4TN35IK2fyVuFCsVudb2XsjqyYz6BkuqCRG6C+8mJRP4SH8/
4Uoz+mAe+7QYWAYYzkoe3hCW1ASgPN1cOIQnaNit536Y0+B1bE3B1F8kCFbHvLlw
0inK2J70etcqQzTQRV9it2eCEBqJyOGW1fOVvQq4+V9nsnwOAKVtlJjh3C2DK9Wt
0WBI2HWUAx9bqgZLk7KnKkE84Lua+A==
=DWe4
-----END PGP SIGNATURE-----

--rbxgeu56cnkotd7p--
