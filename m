Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A437E522C85
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 08:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242286AbiEKGpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 02:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240707AbiEKGpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 02:45:13 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8170478FEE
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 23:45:12 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nog5d-0005UM-PD; Wed, 11 May 2022 08:44:53 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 13FD27B124;
        Wed, 11 May 2022 06:44:51 +0000 (UTC)
Date:   Wed, 11 May 2022 08:44:50 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Bernard Zhao <zhaojunkui2008@126.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bernard@vivo.com
Subject: Re: [PATCH] usb/peak_usb: cleanup code
Message-ID: <20220511064450.phisxc7ztcc3qkpj@pengutronix.de>
References: <20220511063850.649012-1-zhaojunkui2008@126.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dq7m2atvmyrifx54"
Content-Disposition: inline
In-Reply-To: <20220511063850.649012-1-zhaojunkui2008@126.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--dq7m2atvmyrifx54
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10.05.2022 23:38:38, Bernard Zhao wrote:
> The variable fi and bi only used in branch if (!dev->prev_siblings)
> , fi & bi not kmalloc in else branch, so move kfree into branch
> if (!dev->prev_siblings),this change is to cleanup the code a bit.

Please move the variable declaration into that scope, too. Adjust the
error handling accordingly.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--dq7m2atvmyrifx54
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJ7W18ACgkQrX5LkNig
013BNgf+P67Oin0cXNemqeEdYw4/XZiAPTSqYELYFmJ+aSFuL+/0bT98LwE+3Age
wuaDlSZrLAYnB8FiOyISV6Hgmqubw46mukSn7KRZUrEyug4ca2U4SbKXU8IyZP9z
c07Ufpyk3lDSMOunJoyaNt37gF/JiCz7+adtnh3ipvGUy2/VwRdmmundl9U6cC02
3YawFRwA3Qju7VTYB0oEdA4EnxJ2y5OpnZvnBD1oOu8btEHW1pvptR324KW+NNlm
hO4/wFzPH37GICxmgUm9kHbBdqA3bZA3PnmbaZHaSSq8jEsgkb2pc9I5+FF8r6cb
OD0zhBSE5km2+JCEtKQNFBYoFtfOhw==
=tSaC
-----END PGP SIGNATURE-----

--dq7m2atvmyrifx54--
