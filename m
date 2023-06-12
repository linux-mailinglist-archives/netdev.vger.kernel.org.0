Return-Path: <netdev+bounces-10263-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C48972D4A7
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 00:45:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BA3E2811E0
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 22:45:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90A1EC8DE;
	Mon, 12 Jun 2023 22:45:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FEFBE66
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 22:45:39 +0000 (UTC)
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FAC11B;
	Mon, 12 Jun 2023 15:45:37 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4Qg6GN1T8Mz4xFn;
	Tue, 13 Jun 2023 08:45:31 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1686609932;
	bh=Q9gUMGKZiF/GmkEjStXgBf+odj1jwLyhIMrBLGi7+QY=;
	h=Date:From:To:Cc:Subject:From;
	b=GEUMAPwAVftsI046YzsO00i3BMHHe6YkXSZrmwD1IxdWI9o0mBTpzRauo0tDluetr
	 UgIv5w+iZrAwE4jRN/7XFsuMpo0tCp98bOR+iHF/s69LtltmwPfQNARPBBCHszStJe
	 XwP3CAT00qeAgvxXRaMzf3Lny8XtdIwxObj7n1I/T8PLuYzGEyPIati2rPy+wQWCkb
	 866qoYC7AmCAcdwG5lAhMI3cHg2zJ+g6Ge1sOvpUgVBuwhH5HUYlnwZt3pMfXV8ZO8
	 Mrj2XkF0pu5QowT1TjZ84T9Bn3UKC+hOqyHsL1C8T4SbjaSefsmRipM8jJwTT7nwAG
	 bCHcIN2KUUHIw==
Date: Tue, 13 Jun 2023 08:45:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: Max Tottenham <mtottenh@akamai.com>, Networking
 <netdev@vger.kernel.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20230613084529.6b655b51@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/n1tbFaLxDzRBxDKlwFO.cVA";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/n1tbFaLxDzRBxDKlwFO.cVA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  6c02568fd1ae ("net/sched: act_pedit: Parse L3 Header for L4 offset")

Fixes tag

  Fixes: 71d0ed7079df ("net/act_pedit: Support using offset relative to

has these problem(s):

  - Subject has leading but no trailing parentheses
  - Subject has leading but no trailing quotes

Please do not split Fixes tags over more than one line.

--=20
Cheers,
Stephen Rothwell

--Sig_/n1tbFaLxDzRBxDKlwFO.cVA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmSHoAkACgkQAVBC80lX
0GxyeAf+IT+eLTPi5kMIrzQI/aDkDPe/OCoGjVzZsSEUa5gYrvz64LjGzsBqJscY
HQifo/jv3qw7uOeLq29VxE87yOYjEKRJvrYZcyOvbvwnCFl5ykcx9Xo6QgMVDSJD
QHNbfNibkiWYQfQGAIwvVph2Cl7stm4UogRxyhIU4OcKoPVCXUzEuow0UNJk2jch
Bx0bXTqh9mapawtn4kw4B8ndMSyEt+ZGHp5kcpa/jl87tfw0mgZLtEsC4E3sjf2a
ZRtLC7Aqrgs7kdeqoN5hp4rnwidgrOQDQeNCNTr4uzuTxWWt8iZNMMNHP0WEz2ux
i2iQLK0dE30L8xCVCGzFryTppGwf4A==
=pHEh
-----END PGP SIGNATURE-----

--Sig_/n1tbFaLxDzRBxDKlwFO.cVA--

