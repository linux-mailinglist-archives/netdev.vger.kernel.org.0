Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D65E53F6FF
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 09:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237555AbiFGHPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 03:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237544AbiFGHPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 03:15:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7586B8A30F
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 00:15:46 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nyTQy-0002zY-S2; Tue, 07 Jun 2022 09:15:24 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C17DC8D788;
        Tue,  7 Jun 2022 07:15:20 +0000 (UTC)
Date:   Tue, 7 Jun 2022 09:15:19 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Conor Dooley <conor.dooley@microchip.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Daire McNamara <daire.mcnamara@microchip.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: Re: [PATCH net-next 0/2] Document PolarFire SoC can controller
Message-ID: <20220607071519.6m6swnl55na3vgwm@pengutronix.de>
References: <20220607065459.2035746-1-conor.dooley@microchip.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wmxu3eossejojdgn"
Content-Disposition: inline
In-Reply-To: <20220607065459.2035746-1-conor.dooley@microchip.com>
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


--wmxu3eossejojdgn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.06.2022 07:54:58, Conor Dooley wrote:
> When adding the dts for PolarFire SoC, the can controllers were
                                             ^^^
> omitted, so here they are...

Nitpick:
Consider writing "CAN" in capital letters to avoid confusion for the not
informed reader.

Is the documentation for the CAN controller openly available? Is there a
driver somewhere?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--wmxu3eossejojdgn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKe+wUACgkQrX5LkNig
010mGwgAsk4h1zagYu60b6rZjltdh82vMaUZuWWlhOtLWxaZXbgHboLYurlj7gq3
dXxVDkrAByE6WcaAkKCRdUSGV66X+amInYdrRsvG9wfESbX001Lj3XdwyL97XI8g
WGs4T0e0dhR/EjU0Ap8YZh3KyIs9vyfLzACRVWyRJhLQXz2KLtWMTa/QGzAd9hQJ
j4vT0fIesQFuh1qxqZw2eYUxpYN5o6aysm4/qfXJTIVIn9Y03jwPcRVWFWt+GiQl
xirOrt/V5cw72EE02V0IWnmKT7fylD3HgTrwgyAInguTharRV9WZYhXttUwQc+Kc
SFIA5n4bQb3DdGldoJGkkCUDJPAT9A==
=epBJ
-----END PGP SIGNATURE-----

--wmxu3eossejojdgn--
