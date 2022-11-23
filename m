Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A78C63697B
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 20:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239182AbiKWTEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 14:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236590AbiKWTEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 14:04:39 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA68A13E19
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 11:04:36 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 280031C09FA; Wed, 23 Nov 2022 20:04:35 +0100 (CET)
Date:   Wed, 23 Nov 2022 20:04:34 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Shang XiaoJing <shangxiaojing@huawei.com>
Cc:     krzysztof.kozlowski@linaro.org, pavel@denx.de,
        u.kleine-koenig@pengutronix.de, kuba@kernel.org, michael@walle.cc,
        cuissard@marvell.com, sameo@linux.intel.com,
        clement.perrochaud@nxp.com, r.baldyga@samsung.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] nfc: Fix potential memory leak of skb
Message-ID: <Y35uwucYbEgadnsf@duo.ucw.cz>
References: <20221117113714.12776-1-shangxiaojing@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NpfljyPyERhwEkrb"
Content-Disposition: inline
In-Reply-To: <20221117113714.12776-1-shangxiaojing@huawei.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--NpfljyPyERhwEkrb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> There are still somewhere maybe leak the skb, fix the memleaks by adding
> fail path.

Thank you!

Reviewed-by: Pavel Machek <pavel@denx.de>

									Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--NpfljyPyERhwEkrb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY35uwgAKCRAw5/Bqldv6
8hayAJ9B1KRY/DMcFEGThpNJA3qHvSRHfwCfbykqWVRrLpdXXFTAZ2Tz8vAiCu8=
=ylPy
-----END PGP SIGNATURE-----

--NpfljyPyERhwEkrb--
