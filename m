Return-Path: <netdev+bounces-3057-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC3EA7054C7
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:14:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 962982811E6
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 17:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C0C8101D7;
	Tue, 16 May 2023 17:14:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706E5847F
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 17:14:06 +0000 (UTC)
Received: from bues.ch (bues.ch [IPv6:2a01:138:9005::1:4])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6C47EC0;
	Tue, 16 May 2023 10:13:57 -0700 (PDT)
Received: by bues.ch with esmtpsa (Exim 4.94.2)
	(envelope-from <m@bues.ch>)
	id 1pyyEo-000LBs-4Q; Tue, 16 May 2023 19:13:25 +0200
Date: Tue, 16 May 2023 19:12:45 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Kalle Valo <kvalo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Nathan
 Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>,
 Tom Rix <trix@redhat.com>, linux-wireless@vger.kernel.org,
 b43-dev@lists.infradead.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] wifi: b43: fix incorrect __packed annotation
Message-ID: <20230516191245.4149c51a@barney>
In-Reply-To: <20230516074554.1674536-1-arnd@kernel.org>
References: <20230516074554.1674536-1-arnd@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/h3eF.NMb8zN_PF_aekVVTvG";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/h3eF.NMb8zN_PF_aekVVTvG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 16 May 2023 09:45:42 +0200
Arnd Bergmann <arnd@kernel.org> wrote:

> b43_iv { union {
>  		__be16 d16;
>  		__be32 d32;
> -	} data __packed;
> +	} __packed data;
>  } __packed;
> =20
> =20

Oh, interesting. This has probably been there forever.
Did you check if the b43legacy driver has the same issue?

Acked-by: Michael B=C3=BCsch <m@bues.ch>

--=20
Michael B=C3=BCsch
https://bues.ch/

--Sig_/h3eF.NMb8zN_PF_aekVVTvG
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAmRjuY4ACgkQ9TK+HZCN
iw45gw//YtREyc0Ll9Z5mUYuRQuRvClsfk1NDerPQUm2m7byxHpwFBpMxNxvp234
ywnZHxD5RDFM2XjhYW1SpU1ewr2z8ElvbNMERX5ZoXDLwo5sxuYDz6bAEwd4Ka69
VdQ3aXYm2xexI+s68fhZQuKKMSLI0zd6/IPs0pJidFnPM+Q4xhtkGlEr3gXQwbfL
cPnvN1plCaxsndV0gkaulfKdfRgO7i6H7jfLpqgQx1PLrgDLsdycW4AXURTn7N1K
XZbgXBdR62fJxxKhGddYOd+bVBIkQ0al2GPHQZ+YSYf+N9XR7tUxCnfRU7inQlDE
d9cH949KJBeoUz/Fz9ulnAadtvh10+81Kdtc00X3OL+NWtU24NFUmqdiOM9PfDBT
j30mny47L6o1GlwaY3/narr4nNHGuHnHEljFDsMJa4RC8gmRpOR2x6FemD7CU5+Y
ZYcgShzbYVmfsIE5XGO9LNBOciIZpyzaMlPIaOSb2hnrvwKZRQSYlj7I+tRsdvnE
OEZxEzM8PE5M1jaw5YR+3dxbXbjLBRMm/F5IaEjoxWPymMt0V1AWGtkA2bPw06sz
WUDMN3c4UecHrOUBFiU7GdVO8M9pjIWuZVOyv2dTCXCqpALusWSie3AcOLrrw+kS
TGPi0uYmKg/Td+5vTwRVuqZ8Z5Z11VqZXxI79xVUR3wV0WSXUPI=
=kQU1
-----END PGP SIGNATURE-----

--Sig_/h3eF.NMb8zN_PF_aekVVTvG--

