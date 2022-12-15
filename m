Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF7064D9F6
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 12:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiLOLCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 06:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiLOLBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 06:01:18 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500552E6B1;
        Thu, 15 Dec 2022 02:59:58 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 075EA1C09F8; Thu, 15 Dec 2022 11:59:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1671101996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cicz6QwKPaJpoU/+63lqnUWauHKV+OTx7aD6itZoggk=;
        b=ZFvZRZEUyjDPDHUjNrUACJS7UnyFW/HOkmW8Xa5OGtccrxWTRpO1LqIPoVOfZf1y+j1LYh
        LZMvACYlDTMavOkpUS3omrKDwEtYObOeJI2KxqyuWm0+rmYILqmhfokBplrpG9UxVIjgee
        UZgWUHHud82xYgQ41hYQCEDA6Fatyjo=
Date:   Thu, 15 Dec 2022 11:59:55 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "David S . Miller" <davem@davemloft.net>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.9 2/2] net: loopback: use NET_NAME_PREDICTABLE
 for name_assign_type
Message-ID: <Y5r+KyWmREm7dKbr@duo.ucw.cz>
References: <20221212103704.300692-1-sashal@kernel.org>
 <20221212103704.300692-2-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gJ/hiWhg9YU5w1jA"
Content-Disposition: inline
In-Reply-To: <20221212103704.300692-2-sashal@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gJ/hiWhg9YU5w1jA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>=20
> [ Upstream commit 31d929de5a112ee1b977a89c57de74710894bbbf ]
>=20
> When the name_assign_type attribute was introduced (commit
> 685343fc3ba6, "net: add name_assign_type netdev attribute"), the
> loopback device was explicitly mentioned as one which would make use
> of NET_NAME_PREDICTABLE:
>=20
>     The name_assign_type attribute gives hints where the interface name o=
f a
>     given net-device comes from. These values are currently defined:
> ...
>       NET_NAME_PREDICTABLE:
>         The ifname has been assigned by the kernel in a predictable way
>         that is guaranteed to avoid reuse and always be the same for a
>         given device. Examples include statically created devices like
>         the loopback device [...]
>=20
> Switch to that so that reading /sys/class/net/lo/name_assign_type
> produces something sensible instead of returning -EINVAL.

This was already part of the previous autosel:

Date: Tue,  6 Dec 2022 04:51:42 -0500
=46rom: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 3/3] net: loopback: use NET_NAME_PREDICTABLE fo=
r name_assign_type
X-Mailer: git-send-email 2.35.1

=46rom: Rasmus Villemoes <linux@rasmusvillemoes.dk>

[ Upstream commit 31d929de5a112ee1b977a89c57de74710894bbbf ]

Best regards,

								Pavel
--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--gJ/hiWhg9YU5w1jA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY5r+KwAKCRAw5/Bqldv6
8j44AKDAn7gzcTwuiqd0i2uC4+kcxNxABgCfdp0D1TIZI6/BvMb3JYOiuJa7ZZo=
=U9eW
-----END PGP SIGNATURE-----

--gJ/hiWhg9YU5w1jA--
