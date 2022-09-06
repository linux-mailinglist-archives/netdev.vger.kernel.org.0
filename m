Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E771B5ADFCC
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 08:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238260AbiIFGbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 02:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238085AbiIFGbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 02:31:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE74D56B8C
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 23:31:41 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oVS7M-0006t6-OD; Tue, 06 Sep 2022 08:31:28 +0200
Received: from pengutronix.de (unknown [IPv6:2a0a:edc0:0:701:a3ba:d49d:1749:550])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A6CA1DB575;
        Tue,  6 Sep 2022 06:31:27 +0000 (UTC)
Date:   Tue, 6 Sep 2022 08:31:25 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: can: nxp,sja1000: drop ref from
 reg-io-width
Message-ID: <20220906063125.pgv3j3i4ugkxlubq@pengutronix.de>
References: <20220823101011.386970-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lsl5szbglsrv6lm6"
Content-Disposition: inline
In-Reply-To: <20220823101011.386970-1-krzysztof.kozlowski@linaro.org>
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


--lsl5szbglsrv6lm6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 23.08.2022 13:10:11, Krzysztof Kozlowski wrote:
> reg-io-width is a standard property, so no need for defining its type
>=20
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Applied to linux-can-next.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--lsl5szbglsrv6lm6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMW6TsACgkQrX5LkNig
013fawf/c4s2V6wfXL6c4iE/QdZf/iopJwlkYqM7pckagIuvQSOS+kP09wxmZNE5
IekY6tNx4kDVC7ZohH89YnCGs5eiVv6iprt7mS4FZDa9HKiFw/338U6Y294HvANm
MONUHbOJ255OHFLGKwGRYCaLOAAGMZeCJGkOsLf5uStH3q+/6pR7bNoSXSeM4n2G
HVz1mvY5wNSEwjQzv5/BiHp8qJnqqLdStNdWo3jC+tFVZodriCb3wYDRU0hwRJKr
nh8RVCWKfEjANY7ilGpH/QugdJV0wP3mlawiKgHazLJIQxUPBe9J/+ajfQinhXY5
umdlkFB3p7I3TA6bBN3P7EwX6sWNiA==
=0by4
-----END PGP SIGNATURE-----

--lsl5szbglsrv6lm6--
