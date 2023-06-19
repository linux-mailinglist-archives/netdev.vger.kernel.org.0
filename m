Return-Path: <netdev+bounces-11825-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C7C1734B24
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 06:40:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 170F9280FB9
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 04:40:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6F961C37;
	Mon, 19 Jun 2023 04:40:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC53915A0
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 04:40:14 +0000 (UTC)
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A22DE49;
	Sun, 18 Jun 2023 21:40:13 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4Qkxrr0FL6z4x0B;
	Mon, 19 Jun 2023 14:40:11 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1687149612;
	bh=UedWqHzVwDEeEU3XVUENw1rGNCIT4MDygwvxGOtjV4Q=;
	h=Date:From:To:Cc:Subject:From;
	b=lv6KUU7MzLZsaq57H0W/MCBh9PHDP5zfUu7XkQmKMCUEchLfyw/Bs8cVz9BUbxsRR
	 KqY+U2+Y5siXer+fF15/CSDFd9eFvRJqYA5l7PkuDLfZGhxY/FjrkleY3sEO1VcttS
	 40zFww7OjAGudIoxxKY0CyrUiZiRxfSIDQIeVkpfv5n4SxACPg5Kfjdkb4gAQLsDik
	 k81r1/Oma2OzMYTQWOHe0F7H9uWWqACDP7aLap/5mIgSNdJpwLN8H/SvYzf8oqpRLs
	 54iUGZfddV04KhxhyKlFx2XnPEHXrtQpoYuHB0jjgPuQNKS1FSDoKICdx+OtjCd8WE
	 3zM+wvCF1aTYQ==
Date: Mon, 19 Jun 2023 14:40:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: Networking <netdev@vger.kernel.org>, Arthur Kiyanovski
 <akiyano@amazon.com>, David Arinzon <darinzon@amazon.com>, Jakub Kicinski
 <kuba@kernel.org>, Shay Agroskin <shayagr@amazon.com>, Linux Kernel Mailing
 List <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20230619144010.6a767b46@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/lDYUkVU35896U5Vv60GJ7Bt";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/lDYUkVU35896U5Vv60GJ7Bt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced this warning:

Documentation/networking/device_drivers/ethernet/amazon/ena.rst:209: WARNIN=
G: Explicit markup ends without a blank line; unexpected unindent.

Introduced by commit

  f7d625adeb7b ("net: ena: Add dynamic recycling mechanism for rx buffers")

--=20
Cheers,
Stephen Rothwell

--Sig_/lDYUkVU35896U5Vv60GJ7Bt
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmSP3CoACgkQAVBC80lX
0Gwr7Af/aV9NkukPjtGkeDgM8B6F2s1ZLByeaCR0aU1Ae3vOdTLNMwWJgUwVG50a
KY698rjpHwDiQfcxmomX1GDz/OjeSOgUEZEwktGwyAjRcjAgfacbuwdmdw2CZqEx
yKyD8s9AaPgOWhBixFeXauxX3hoQ+5nWcOLt/mZ73+SUJEaQfej9ay6eCbkxhOTk
2bgt7UOx+bA07nB/aVQkus4vvFcpV+IeDXrFy1ndbpL8l9etuWJyr83LoccoeRfz
0RtYztDPC8JjEGszLCa568YxD7SLhxPHaSWylLQKr6FisJTbYM/MeWgXrB7W2mxI
Bkr1XPB2R3/kfKw3vY47Ao4ONdKVjg==
=xEIE
-----END PGP SIGNATURE-----

--Sig_/lDYUkVU35896U5Vv60GJ7Bt--

