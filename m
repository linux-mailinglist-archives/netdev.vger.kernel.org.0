Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFFA5EC48B
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 15:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbiI0Ndp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 09:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbiI0NdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 09:33:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E412857EF
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 06:31:58 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1odAgT-0004Qu-4S; Tue, 27 Sep 2022 15:31:37 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 98235EE174;
        Tue, 27 Sep 2022 13:31:34 +0000 (UTC)
Date:   Tue, 27 Sep 2022 15:31:32 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, kvalo@kernel.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, linux-can@vger.kernel.org
Subject: Re: [PATCH net-next] net: drop the weight argument from
 netif_napi_add
Message-ID: <20220927133132.ze3wx54shojraa5a@pengutronix.de>
References: <20220927132753.750069-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sn3iwhk4ctenflmz"
Content-Disposition: inline
In-Reply-To: <20220927132753.750069-1-kuba@kernel.org>
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


--sn3iwhk4ctenflmz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27.09.2022 06:27:53, Jakub Kicinski wrote:
> We tell driver developers to always pass NAPI_POLL_WEIGHT
> as the weight to netif_napi_add(). This may be confusing
> to newcomers, drop the weight argument, those who really
> need to tweak the weight can use netif_napi_add_weight().
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/can/ctucanfd/ctucanfd_base.c      |  2 +-
>  drivers/net/can/ifi_canfd/ifi_canfd.c         |  2 +-
>  drivers/net/can/m_can/m_can.c                 |  3 +--

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de> # for CAN

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--sn3iwhk4ctenflmz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMy+zEACgkQrX5LkNig
013DrQgAnSKMI/Gmp2TfD4MpcjCCFFzRyLlfs/viJiu7YHBCsRclZMTAAjTAnyD1
/t5maqlOkdRi0wZCqcu/kF7vgnbmNYuFfEw4RlAWGZl9AXXgo6jPXxz8qEpnlr5B
5lQuaVneytM0+ky5WLWl3uqB6JG++Ra+L3jDESRAcwXiJNJPg92n2IglPENuBNxT
s6CrSuetrV0OAvEaU8IJAtIYIIFjMy7P3itZY535ngx65mhiEomQ9Er3ohkRvCzi
teo7zO/iutWshQQK1WKjNQ1P/L+aDvtAvGlnx5Sf5Ap4cYauwiywsqRjzlzdPVou
EQLAVrG9cy8yPUyKXWpmvifg3osHlQ==
=pEGT
-----END PGP SIGNATURE-----

--sn3iwhk4ctenflmz--
