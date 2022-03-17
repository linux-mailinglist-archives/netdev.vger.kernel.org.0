Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9934DC0B5
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 09:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiCQINX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 04:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiCQINU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 04:13:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85491C5919
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 01:12:01 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nUlEd-00049d-0F; Thu, 17 Mar 2022 09:11:51 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-5ff9-b2f4-7100-5120.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:5ff9:b2f4:7100:5120])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 30E074CFDE;
        Thu, 17 Mar 2022 08:11:49 +0000 (UTC)
Date:   Thu, 17 Mar 2022 09:11:48 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     rcsekar@samsung.com, wg@grandegger.com, davem@davemloft.net,
        kuba@kernel.org, linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: m_can: fix a possible use after free in
 m_can_tx_handler()
Message-ID: <20220317081148.rdnacm4bry76rny4@pengutronix.de>
References: <20220317030143.14668-1-hbh25y@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nbv2ga6m4oauj6bi"
Content-Disposition: inline
In-Reply-To: <20220317030143.14668-1-hbh25y@gmail.com>
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


--nbv2ga6m4oauj6bi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17.03.2022 11:01:43, Hangyu Hua wrote:
> can_put_echo_skb will clone skb then free the skb. It is better to avoid =
using
> skb after can_put_echo_skb.

Why not move the can_put_echo_skb() instead? I'll send a patch.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--nbv2ga6m4oauj6bi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIy7UIACgkQrX5LkNig
0126egf/eXMrD3xPjDnj4X60OnWYTRdu7/JjPrpV+l7EWntc/GElPXfB2IHoGhNJ
yHrEWYruDHUtmYug48mqvaysS+vvCtZ/U1pLyMqueKYEidkgQTmorSudgYUOZny/
y25MOIXTjNgl9p/BBwv5aezPXhUFZufPX/G1D+LB7CJGO9W8K9k/O4AKLtNPAlTf
ElnfT7sjXo/Cr+XPiSJXr0h4lAhXglR6+KhsxZwoP+41nzIM6G2z/f0nDQ7ShQGY
tGJN+icRxf8izwPanROz+74zIlOKEwn9uHPl5U35CcN8cyzk9A1PMm8DS+tdazh7
Gz5zi+xJChAkYuXXrPTuW3y39SfZGQ==
=5dNZ
-----END PGP SIGNATURE-----

--nbv2ga6m4oauj6bi--
