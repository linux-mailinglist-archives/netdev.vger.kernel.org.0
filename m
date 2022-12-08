Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D93D646BB2
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 10:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiLHJOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 04:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbiLHJN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 04:13:58 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EF973F6F
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 01:12:59 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p3Cx3-0006oc-8k; Thu, 08 Dec 2022 10:12:21 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:92e:b9fb:f0e7:2adf])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 76E921394C2;
        Thu,  8 Dec 2022 09:12:19 +0000 (UTC)
Date:   Thu, 8 Dec 2022 10:12:11 +0100
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
Subject: Re: [Patch v4 1/2] can: m_can: Call the RAM init directly from
 m_can_chip_config
Message-ID: <20221208091211.622jm5raebedxboa@pengutronix.de>
References: <20221207100632.96200-1-vivek.2311@samsung.com>
 <CGME20221207100650epcas5p408d280e0e2d2d6acfb5e252e37f504b2@epcas5p4.samsung.com>
 <20221207100632.96200-2-vivek.2311@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qo5ntlmugze2qlne"
Content-Disposition: inline
In-Reply-To: <20221207100632.96200-2-vivek.2311@samsung.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qo5ntlmugze2qlne
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.12.2022 15:36:31, Vivek Yadav wrote:
> When we try to access the mcan message ram addresses during the probe,
> hclk is gated by any other drivers or disabled, because of that probe
> gets failed.
>=20
> Move the mram init functionality to mcan chip config called by
> m_can_start from mcan open function, by that time clocks are
> enabled.
>=20
> Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>

Applied to linux-can-next.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--qo5ntlmugze2qlne
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmORqmkACgkQrX5LkNig
013EGAgAqIsT8Spgs5YSH/Ia25bQG5vb66rPRb4TpsVjmLjycBzY26fgnsXhMqnD
EJ0x3PhYxpZS3/XI8IiRXPgewekGZBl9DkZWk7BreOLS7MbKR+jnW/82FOrYoDvm
JleZrFmHQB65YiJTZwzmNmcuEgiQ/KJBfnvVWFbN2KZu8zyEJT6OIRpjDCztetuA
a/lPfdZJybyh4fTrHJo98KTKie/xuzHGcWtu0YXdI6u3R3O7Z8PBr2jhvuzsvFh/
7ZrrKY55DAp4TfYI472mR3V4IJpM+Xhs0CJhxPBzqjWw6XxckjrJSTk5k1ZLRymX
Nf3Bm8cceg345Bu4LOi1AiI+AjxzOw==
=aA7E
-----END PGP SIGNATURE-----

--qo5ntlmugze2qlne--
