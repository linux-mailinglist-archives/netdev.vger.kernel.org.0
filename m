Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1DB7600C5C
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 12:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiJQKZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 06:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiJQKZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 06:25:10 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56ACD543D8;
        Mon, 17 Oct 2022 03:25:06 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 054EA1C0016; Mon, 17 Oct 2022 12:25:04 +0200 (CEST)
Date:   Mon, 17 Oct 2022 12:25:03 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>,
        Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ndesaulniers@google.com,
        mkl@pengutronix.de, thomas.lendacky@amd.com, khalasa@piap.pl,
        wsa+renesas@sang-engineering.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.9 11/16] net: korina: Fix return type of
 korina_send_packet
Message-ID: <20221017102503.GA15612@duo.ucw.cz>
References: <20221009222713.1220394-1-sashal@kernel.org>
 <20221009222713.1220394-11-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <20221009222713.1220394-11-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Nathan Huckleberry <nhuck@google.com>
>=20
> [ Upstream commit 106c67ce46f3c82dd276e983668a91d6ed631173 ]
>=20
> The ndo_start_xmit field in net_device_ops is expected to be of type
> netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev=
).
>=20
> The mismatched return type breaks forward edge kCFI since the underlying
> function definition does not match the function hook definition.
>=20
> The return type of korina_send_packet should be changed from int to
> netdev_tx_t.

Patches 4-6, 9-11: I see this is nice cleanup for mainline, but ... do
we have CFI in 4.9 tree? This mismatch does not and can not cause any
problems there, right?

Best regards,
								Pavel
--
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany


--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY00tfwAKCRAw5/Bqldv6
8mtRAJ94X1njpj6/XfCoNQNa5Y6rpMWa7gCfemw2E8vG+r/YzUn0hGYsaq3HTqA=
=iw2O
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
