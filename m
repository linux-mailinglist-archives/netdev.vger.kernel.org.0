Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9A51CAA59
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 14:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgEHMLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 08:11:18 -0400
Received: from 12.mo4.mail-out.ovh.net ([178.33.104.253]:41091 "EHLO
        12.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgEHMLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 08:11:17 -0400
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 May 2020 08:11:17 EDT
Received: from player759.ha.ovh.net (unknown [10.110.115.139])
        by mo4.mail-out.ovh.net (Postfix) with ESMTP id A82C1234F0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 14:02:21 +0200 (CEST)
Received: from sk2.org (82-65-25-201.subs.proxad.net [82.65.25.201])
        (Authenticated sender: steve@sk2.org)
        by player759.ha.ovh.net (Postfix) with ESMTPSA id 67DAC122E88D1;
        Fri,  8 May 2020 12:02:15 +0000 (UTC)
Date:   Fri, 8 May 2020 14:02:09 +0200
From:   Stephen Kitt <steve@sk2.org>
To:     David Miller <davem@davemloft.net>
Cc:     joe@perches.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Protect INET_ADDR_COOKIE on 32-bit architectures
Message-ID: <20200508140209.1715118b@heffalump.sk2.org>
In-Reply-To: <20200428.140746.1017253285576997409.davem@davemloft.net>
References: <20200428075231.29687-1-steve@sk2.org>
        <20200428.140746.1017253285576997409.davem@davemloft.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/xHlR1d_w3iJ7g1yK24Z3KUu"; protocol="application/pgp-signature"
X-Ovh-Tracer-Id: 5353935535833173284
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedrkedvgdegjecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvuffkjghfofggtgesghdtreerredtjeenucfhrhhomhepufhtvghphhgvnhcumfhithhtuceoshhtvghvvgesshhkvddrohhrgheqnecuggftrfgrthhtvghrnhepveelvdeufedvieevffdtueegkeevteehffdtffetleehjeekjeejudffieduteeknecukfhppedtrddtrddtrddtpdekvddrieehrddvhedrvddtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejheelrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepshhtvghvvgesshhkvddrohhrghdprhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/xHlR1d_w3iJ7g1yK24Z3KUu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Apr 2020 14:07:46 -0700 (PDT), David Miller <davem@davemloft.net>
wrote:
> From: Stephen Kitt <steve@sk2.org>
> Date: Tue, 28 Apr 2020 09:52:31 +0200
>=20
> > This patch changes INET_ADDR_COOKIE to declare a dummy typedef (so it
> > makes checkpatch.pl complain, sorry...) =20
>=20
> This is trading one problem for another, so in the end doesn't really
> move us forward.

Right, a dummy struct is probably better, I=E2=80=99ll send a v2.

Regards,

Stephen

--Sig_/xHlR1d_w3iJ7g1yK24Z3KUu
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEnPVX/hPLkMoq7x0ggNMC9Yhtg5wFAl61SkEACgkQgNMC9Yht
g5yl5w/7BpAaC5GwH0nuOn9v2IpC5+KFuvHWeXxyxEoa3VQxUkYVWlf8UvK8mBqw
XXglO4/qf95b0HVTeXVHDw8gl0JcwsGwd4cGxO2PubUQM/M1GHUBDqiLMVdlXW6Z
x41Vx2KWe6dPxwnUj4UpfiB/a3a9ti+R+ykz8IjSRHc/ge3lvx34bC9Bn9pBsBLw
bE6zcbrxCAndyI4G0hOo+5vDGbCziXSN8fnLt93KnFlWnRvFGAjb/uwNrESUgRC+
2rulU3Ne16tvXfwRPvs/hWi2eeAKlPvxr6/tkBtkle+OwWCZSO5IR9R+EDVZi4Uz
pnQlEbTynOfBtC+j529C/JXeVLoEjrXewAPbTx0AUV7kGEF3er9X0vega6c4jJpp
WQ2MeV2JNcFqtCNbi8ThXZt8uEQG/F70dOvvCym3FwdhHCMIYoAxz1QGDlhCKq0M
rWs35DPU1tBA88vuFK1e7N9rVrXWkXEJ7embgFyBXLcHkmBU0xCfD2/QjeiV89kc
uR+ssqiGtwZoCY/Nh4sgt05S0PsVhgW7B+GLPbJpStPtkeHXCNKd3DbEXQf83yuA
JmiY5PsICo4NCDgiyN1FbX1X0JVhonxjHpm11AexA51SQfwu12DdlFvc5xvF89+0
SvEyLDOpANYJsamkkTcCez1WOcpVcK7geUK9grjgmDDc7YnwfHw=
=eQ/h
-----END PGP SIGNATURE-----

--Sig_/xHlR1d_w3iJ7g1yK24Z3KUu--
