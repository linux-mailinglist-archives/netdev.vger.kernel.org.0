Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB72586070
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 20:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237640AbiGaSwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 14:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237564AbiGaSwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 14:52:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895B6DEC7
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 11:52:36 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oIE33-0004Iq-2x; Sun, 31 Jul 2022 20:52:21 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 9038CBEBC3;
        Sun, 31 Jul 2022 18:52:15 +0000 (UTC)
Date:   Sun, 31 Jul 2022 20:52:13 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Max Staudt <max@enpas.org>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] can: can327: Fix a broken link to Documentation
Message-ID: <20220731185213.gath5pgt4fcpttil@pengutronix.de>
References: <6a54aff884ea4f84b661527d75aabd6632140715.1659249135.git.christophe.jaillet@wanadoo.fr>
 <20220731104452.3bc2e76c.max@enpas.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="devh3drl6tdtjlei"
Content-Disposition: inline
In-Reply-To: <20220731104452.3bc2e76c.max@enpas.org>
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


--devh3drl6tdtjlei
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 31.07.2022 10:44:52, Max Staudt wrote:
> Thanks, Christophe!

If you think the patch is Ok, you can give an Acked-by: which is then
recorded in the patch while applying it to the kernel.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--devh3drl6tdtjlei
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLmz1gACgkQrX5LkNig
011XuAf/dJQV1xIfOUXfQGFEHQrYynqCpHfZ47rPqwtBdrgzlx7+aTaF3DQUdP/l
2ekPyU1mfWPxjkTwC9J/cF2rnWpouCgnOzO9jdkMdPUM3kn+6lRT2SSd1/bF5hqx
NBTJbl2Hc/y/0PKSFx0AMT9cOywA2IEv8pbjDC3OFrVDMZNyBJUqHzdf1/NPndYL
OOV+K00o8QnCzhlYTutwKhkvnyiUJawRRCgIysXQVNoKIcpI9N1xhfEN3u/Pnfb2
wjI1zb9U0ytfp26JVChHXk3L636luYHPv/G4tISck4ceV8PlCvsyw5kuIrBUV4WW
UiCw8cKohAvpxGqRSlZaLmDcPofxzQ==
=X7vm
-----END PGP SIGNATURE-----

--devh3drl6tdtjlei--
