Return-Path: <netdev+bounces-2454-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C96EF702085
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 00:44:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 585B21C2098E
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 22:44:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3081C128;
	Sun, 14 May 2023 22:44:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E324F749C
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 22:44:43 +0000 (UTC)
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2CB10EA;
	Sun, 14 May 2023 15:44:40 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4QKHcg52YQz4x3n;
	Mon, 15 May 2023 08:44:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1684104275;
	bh=zCntv/gHs98BvbPwti3K9HEUfLJdbgGjZMzaNHbV8/Q=;
	h=Date:From:To:Cc:Subject:From;
	b=rDdPXverbK5H0EdoE9RauKpDhbONHiAaPm+wOxJLERZpNDgja9R99ct8nVvZ0HrJo
	 75JE+BCpvqGgw7OR2BTTRs+x/o5BM0+cH/qG2fmaSjvtSEzlcq4r2IWfYGzjU0sIpR
	 HO1ZoTIvfd2rMtvqCEJ/aiojipS00k2UnpHkvkOHwRX3UqcjvrCbwInaALpz8p3toQ
	 /y98boYcKNWKC2O0Woy2vDn6POiVXgr1svRs5g+gdB9vcdbsYWZhshMp8LoxllKfjc
	 zoJqEJYHn3eBU69AqM4KlEy8z3Wl34IY9qWRSNohDyYTARR31VoS7r7lkJFu1evKBB
	 XQIJTxe2vIlNw==
Date: Mon, 15 May 2023 08:44:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next
 Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the net tree
Message-ID: <20230515084418.409f81cb@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/XcdF3AyAd5.hT6=m+vPzRun";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/XcdF3AyAd5.hT6=m+vPzRun
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  01e8f6cd108b ("MAINTAINERS: don't CC docs@ for netlink spec changes")

is missing a Signed-off-by from its committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/XcdF3AyAd5.hT6=m+vPzRun
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmRhZEIACgkQAVBC80lX
0GyXYQf+N6LHTSUdHJCQe5gbL0o9O3F/u6TW2dzZDK6+1uA03wMT9Y5bjRt1GTwj
5X8Zu24YbgyYTN39nXojrlpc+Y8iBLzL8T56qJXIO3D3oVOAuy/Y5rOq/JsJ/TGM
SGaED+SQ7pskTcwe1XUWkJCKq34Yq+TxpNJsw+J4FUQKDVt44fmZ6v6yahzth4mQ
gtOXM1g44HqrEeV1f9fg00MFUCfjRqyWJlHfNDm+kL12DVuXgBCMv13MpzYnL6oR
pD2hFnVwYB8CbWMaMMzq2iOCa+9/nF7BBHzrC7aKQTErn5qVhhyXULB+5Qny+cLp
Qyp9azIUsE9MV8Z+nTo8hQuTnosJcQ==
=LZ1T
-----END PGP SIGNATURE-----

--Sig_/XcdF3AyAd5.hT6=m+vPzRun--

