Return-Path: <netdev+bounces-3073-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C55BC70555D
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:48:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FDD21C20F3A
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 17:48:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FBC21097C;
	Tue, 16 May 2023 17:48:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C4B101D5
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 17:48:52 +0000 (UTC)
Received: from bues.ch (bues.ch [IPv6:2a01:138:9005::1:4])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68A1A257;
	Tue, 16 May 2023 10:48:36 -0700 (PDT)
Received: by bues.ch with esmtpsa (Exim 4.94.2)
	(envelope-from <m@bues.ch>)
	id 1pyymf-000LJS-3V; Tue, 16 May 2023 19:48:24 +0200
Date: Tue, 16 May 2023 19:47:52 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Arnd Bergmann" <arnd@kernel.org>, "Kalle Valo" <kvalo@kernel.org>,
 "David S . Miller" <davem@davemloft.net>, "Eric Dumazet"
 <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo Abeni"
 <pabeni@redhat.com>, "Nathan Chancellor" <nathan@kernel.org>, "Nick
 Desaulniers" <ndesaulniers@google.com>, "Tom Rix" <trix@redhat.com>,
 linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org, Netdev
 <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev
Subject: Re: [PATCH] wifi: b43: fix incorrect __packed annotation
Message-ID: <20230516194752.50ae12db@barney>
In-Reply-To: <b53f3673-f6b1-4071-9bcf-9ae5815593eb@app.fastmail.com>
References: <20230516074554.1674536-1-arnd@kernel.org>
	<20230516191245.4149c51a@barney>
	<b53f3673-f6b1-4071-9bcf-9ae5815593eb@app.fastmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/LydMZaBgIzo3HKHo7_xf/iA";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/LydMZaBgIzo3HKHo7_xf/iA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 16 May 2023 19:45:16 +0200
"Arnd Bergmann" <arnd@arndb.de> wrote:

> Should I resend this as a combined patch for both drivers?

I think that would be fine, yes.
Thank you for checking.

--=20
Michael B=C3=BCsch
https://bues.ch/

--Sig_/LydMZaBgIzo3HKHo7_xf/iA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAmRjwcgACgkQ9TK+HZCN
iw5T+g/8DVJ2wyaO2Xg8k2CkNMDjP5bFJVvaUnLUQoYFT22CY2Rlkop53SsVpkgL
A7/SxrptKK4vPNgO0QjwN8+Nl8KbL320XH+YEFi+f64uJUBrpAusuVOmK5BZ13Il
V5ljNaJCWQyAVuYV7YlHFoe/EfSOZI5Ca/KVGzmJbcjCbt9vs9MiRIG8ClBdCS39
NHCDvWw+o7HzmExK9dfeO2puN9dHW54U6Np7sDQ9CBLrM3PDB6STBiIVSNnDvG1Q
b2M9mQEcK382pf53+6IJP6xuXppT94TDihTWTzeAmlRIQyMKAkDA7PgSYxr3T6+m
U4vPiCjq9mFZO1Mw8BZbLoVkG0JrX3ffO1LisjKqrLw7y6V4CischbnV4Ye6hTaH
dw8Fx2QPIsAIjb3kLgEY3BezcURQbRqLb3GPRdFHAS+pi8QbE9Hg5epbkxqW7iLS
ff9VDUXftth7fdv0+bMQ8YUuox5unQno/Dc0xaKXshxE4LpXowMlm1RIl+/CyUJ+
+eG1+cdd/NIt6Qw+ped8XxDOCEDeXfwWTrsjMK0WHMUnzItLKeFBJy6yDW9qj+6Y
RikXtPHZkrgJA3+Cfc8HWnuo8WFhIQvawGBjqenbVyI0FnuIFnzpys/ukNe/TiQd
g7yDBD5EJtNoyK0ez+/NJHOKt0lmcUKselAFpE7DZisStWWnLRs=
=syVX
-----END PGP SIGNATURE-----

--Sig_/LydMZaBgIzo3HKHo7_xf/iA--

