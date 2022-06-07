Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61D053F91F
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 11:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236240AbiFGJJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 05:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238998AbiFGJJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 05:09:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3F2B0D27
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 02:09:20 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nyVD2-0004Hy-Ni; Tue, 07 Jun 2022 11:09:08 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1A6408D96B;
        Tue,  7 Jun 2022 09:09:07 +0000 (UTC)
Date:   Tue, 7 Jun 2022 11:09:06 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Srinivas Neeli <srinivas.neeli@xilinx.com>
Cc:     wg@grandegger.com, davem@davemloft.net, edumazet@google.com,
        appana.durga.rao@xilinx.com, sgoud@xilinx.com,
        michal.simek@xilinx.com, kuba@kernel.org, pabeni@redhat.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        git@xilinx.com
Subject: Re: [PATCH V2 1/2] Revert "can: xilinx_can: Limit CANFD brp to 2"
Message-ID: <20220607090906.pdkvr2pcflcvzq2e@pengutronix.de>
References: <20220607085654.4178-1-srinivas.neeli@xilinx.com>
 <20220607085654.4178-2-srinivas.neeli@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wjnyn3zhqqn26n52"
Content-Disposition: inline
In-Reply-To: <20220607085654.4178-2-srinivas.neeli@xilinx.com>
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


--wjnyn3zhqqn26n52
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.06.2022 14:26:53, Srinivas Neeli wrote:
> This reverts commit 05ca14fdb6fe65614e0652d03e44b02748d25af7.
>=20
> On early silicon engineering samples observed
> bit shrinking issue when we use brp as 1.
> Hence updated brp_min as 2. As in production
> silicon this issue is fixed,so reverting the patch.
>=20
> Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>

Should this be applied to -stable?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--wjnyn3zhqqn26n52
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKfFa4ACgkQrX5LkNig
0122OAf/RurJH8hnAPHVTFf7YxHqOj7HUZ9X9ulYzwRbDkQyQaVX0YVYi7f640Gn
iEBUiIJcABRbR2cdMIltb8IkIDlh3l5jB+zFdAxOoM0dBSjh771mhr28lGNmazSe
br6iZ0WUkVRO60MG4Rjn/8WlG0zqw2OoW4494MBmNizfdLJztKgdihMUVLrm9t52
glqRdIrl4E/BY1fLzutyS9ZLsoaGk3iMg76XsrzUmOwlPldDiTdVv4pH5h2kmbf5
HApcjPFdHShIIKsDcFID9xMbbBfBq6P+Ud3SFZgE8FqvHnh4ID9u6jTfI58OGflx
6auGWgoyaHn+XxFq1/e4/x5Ue8gf2g==
=qzBd
-----END PGP SIGNATURE-----

--wjnyn3zhqqn26n52--
