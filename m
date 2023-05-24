Return-Path: <netdev+bounces-4958-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8402170F5E5
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:06:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B911628129C
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:06:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C15E017ADE;
	Wed, 24 May 2023 12:06:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF18917ABE
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:06:51 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4D195;
	Wed, 24 May 2023 05:06:48 -0700 (PDT)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: lukma@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 2247A8472F;
	Wed, 24 May 2023 14:06:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1684930006;
	bh=2iFlhX4vNF+xS15redxx4hHKGfUKI/07uv78N8i0kRo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=eCgnimGs9r6jIHikZdKRLsQPHC8HOpMZBXlz8LPw7qA8hXq+HRvutd+IA2rBfpNQO
	 zHh79uhH46qrjrN89Zu4ttrar/TYjmie4R3q+F7NDahFZJg9TyXEVJwmoBgxn1COlF
	 ORarW4Gcvbi78lrd4NTWO+jT7VQ7iSQgQt78PLhXWwg3GzdnKw0T5lOhDz7+ksR/qV
	 jRB3wEkTGepE1cJRfBsM7o/2WfQ99k7dGg5RWfld2BlHhHkT+7296/Ld5UnS87U8QM
	 3evPeZP0+zDz0DSpWQNiNH1MA79Z/V5h7j6SDbQISnDl2kLR0laL7KrmLkyi3qIKme
	 2zeWFDOaApJew==
Date: Wed, 24 May 2023 14:06:36 +0200
From: Lukasz Majewski <lukma@denx.de>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>, Eric
 Dumazet <edumazet@google.com>, Florian Fainelli <f.fainelli@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Alexander Duyck
 <alexander.duyck@gmail.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/3] dsa: marvell: Define .set_max_frame_size()
 function for mv88e6250 SoC family
Message-ID: <20230524140636.0cd31b13@wsk>
In-Reply-To: <ZGzRE48DchoclbBl@shell.armlinux.org.uk>
References: <20230523142912.2086985-1-lukma@denx.de>
	<20230523142912.2086985-2-lukma@denx.de>
	<ZGzRE48DchoclbBl@shell.armlinux.org.uk>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/MSbrG7CxauOY+Z1b8Ypc4Ka";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/MSbrG7CxauOY+Z1b8Ypc4Ka
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Russell,

> Also, subject line should be "net: dsa: ..."
>=20

Ok, I will correct that subject line.


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/MSbrG7CxauOY+Z1b8Ypc4Ka
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmRt/cwACgkQAR8vZIA0
zr3hfwf+Je/DzQMi+GgW2qUv0ousX731gyC5TBznkPGI4IC2MnaIYHlFcUSN3c81
sdg4EF9jVlTzofoYV1nRrXw0gxx7CV4ooxXLemBqvzgui2AZWvZzFH5Iy7XUn/nJ
WpA1Xh2N81J2cyKyiTObqv+6i2BtW1yXbIyz/1EsXQ4FXsaL0QfOscEnJ7CZyUWA
Ll9vaZvFEB2kalOAwSsMPXRpClILHiKHYpUyl40x8LecEO6y9clH9Jmygxx5O/w1
W9qGATsrhFk+zWSspNJ7jkte7nPf79PLndCm/d/QqjJY5ePexiLSz1bG8Eztiqo+
DBh6KYpPuQKh+b9RAd3OIo4fwbiRyA==
=BFPP
-----END PGP SIGNATURE-----

--Sig_/MSbrG7CxauOY+Z1b8Ypc4Ka--

