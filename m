Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1026C5AD72B
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 18:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiIEQLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 12:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiIEQLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 12:11:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD35F53D24
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 09:11:43 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oVEhB-00076t-Ex; Mon, 05 Sep 2022 18:11:33 +0200
Received: from pengutronix.de (unknown [IPv6:2a0a:edc0:0:701:b4c0:a600:5e68:1e31])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 66CD0DAE54;
        Mon,  5 Sep 2022 16:11:29 +0000 (UTC)
Date:   Mon, 5 Sep 2022 18:11:28 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     cgel.zte@gmail.com
Cc:     wg@grandegger.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] can: kvaser_pciefd: remove redundant variable
 ret
Message-ID: <20220905161128.yc5fhxu3pgkb5mz3@pengutronix.de>
References: <20220831150805.305106-1-cui.jinpeng2@zte.com.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ci2d37bmzgc5snda"
Content-Disposition: inline
In-Reply-To: <20220831150805.305106-1-cui.jinpeng2@zte.com.cn>
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


--ci2d37bmzgc5snda
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 31.08.2022 15:08:05, cgel.zte@gmail.com wrote:
> From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
>=20
> Return value directly from readl_poll_timeout() instead of
> getting value from redundant variable ret.
>=20
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>

Applied to linux-can-next.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ci2d37bmzgc5snda
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMWH64ACgkQrX5LkNig
012EsAgAkSDmtW8hKyXjEHpeh73VZtefjXXO+NhAV/z+QWmy5Oup05eNQj8ndolo
mcUZkvY4MNYB3EzNXusMnNd0MxeX5W2cbE5Fik5U4vlsVEtPLaM26jBbQ9nDxmSV
Y6oamSi7Pk4r0mzHhtIdg/WuGmAJEAHuwhE4OcRkeB92JNVYPgPqbK+/v7G3Gdig
BJBD0Z5zrYLcJDh3w1r9A52pFn3VLUtkF2WUvAwnEky12B4NrVlRocI7F7G9YTUF
OM67dx86xmCQyYlf86IeE9fsOGINY2947u+j5iB2oOP/ZEG6mqoG51a9vj1d2GKy
qz3brjilt7U5bYakYv7fHdgAj3vPZQ==
=DrOa
-----END PGP SIGNATURE-----

--ci2d37bmzgc5snda--
