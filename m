Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7070436A99C
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 23:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhDYVvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 17:51:33 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:52760 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbhDYVvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 17:51:33 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9DCAA1C0B77; Sun, 25 Apr 2021 23:50:51 +0200 (CEST)
Date:   Sun, 25 Apr 2021 23:50:51 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     "zhangjianhua (E)" <zhangjianhua18@huawei.com>
Cc:     "ath9k-devel@qca.qualcomm.com" <ath9k-devel@qca.qualcomm.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chenyi (Johnny)" <johnny.chenyi@huawei.com>
Subject: Re: [PATCH -next] drivers: net: CONFIG_ATH9K select LEDS_CLASS
Message-ID: <20210425215051.GI10996@amd>
References: <20210326081351.172048-1-zhangjianhua18@huawei.com>
 <20210327223811.GB2875@duo.ucw.cz>
 <9c6989a1-614e-23af-dc90-58663aa7d9a1@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CD/aTaZybdUisKIc"
Content-Disposition: inline
In-Reply-To: <9c6989a1-614e-23af-dc90-58663aa7d9a1@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--CD/aTaZybdUisKIc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> hello Pavel=EF=BC=8Cthanks for your reply.
>=20
> for=C2=A0 the a point, I don't know the led lists and cannot find it.
>=20
> for the b point, I look other configs who select LEDS_CLASS, almost all of
> them select NEW_LEDS=EF=BC=8Cmaybe you are right, CONFIG_ATH9K also need =
select
> NEW_LEDS too.

See MAINTAINERS file.
									Pavel
								=09
--=20
http://www.livejournal.com/~pavelmachek

--CD/aTaZybdUisKIc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmCF5DsACgkQMOfwapXb+vLXLACgmBdHu1pUnic51fdtugmdUPB1
W+QAoKep6Dq5DC85sYzCOlk0/69v2IO+
=OAIa
-----END PGP SIGNATURE-----

--CD/aTaZybdUisKIc--
