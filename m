Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A377C5A0575
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 03:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiHYBAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 21:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiHYBAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 21:00:46 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E44474F7;
        Wed, 24 Aug 2022 18:00:43 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MCl550YM9z4x1G;
        Thu, 25 Aug 2022 11:00:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1661389241;
        bh=AYiOBWb08mU0nHDWsMSihOkyrHhYlKh5jSDYiWjyYpE=;
        h=Date:From:To:Cc:Subject:From;
        b=cN+Bcij5a+N9U2JxmpAfvldFOTjMSr8xHhqr8CrWbCM0DPb8ZgwOobDJV7PFCQGZS
         UCMrnDPz6OpnBGaFRCS90JZwA9grTYcd2xhT+87rrsNvFESv4SsAd+VjShkXd3SbV3
         AXAMegUdn8i4MTaHnoLCB3HKzXoi6fHKObPbsdxNWa6M+fCLS/RYtGg29vULxs77wQ
         w4cDz1xRUc3JWQmn9ck03tC8wA8ZWMvy2MD1yWmPy/gNwcGUBH4Y4+hHYkhsT4lb49
         TQ9Ct4ntshL0bUE2rAeUgo2jHjHXy/WOvKxFNC+BAZwdzXzgahwq+E5WxsbxqJo2XL
         Yk5vzxvBH8/gA==
Date:   Thu, 25 Aug 2022 11:00:39 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Subject: linux-next: manual merge of the bpf-next tree with the net tree
Message-ID: <20220825110039.2e398527@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/JS48schjlrZViXtwXqiHQaS";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/JS48schjlrZViXtwXqiHQaS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  net/core/filter.c

between commit:

  1227c1771dd2 ("net: Fix data-races around sysctl_[rw]mem_(max|default).")

from the net tree and commit:

  29003875bd5b ("bpf: Change bpf_setsockopt(SOL_SOCKET) to reuse sk_setsock=
opt()")

from the bpf-next tree.

I fixed it up (I dropped the former patches changes to this file) and
can carry the fix as necessary. This is now fixed as far as linux-next
is concerned, but any non trivial conflicts should be mentioned to your
upstream maintainer when your tree is submitted for merging.  You may
also want to consider cooperating with the maintainer of the conflicting
tree to minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/JS48schjlrZViXtwXqiHQaS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMGybcACgkQAVBC80lX
0GyJ+wf8DqH1iGWmAN71OauMREBYz5Y8LhdWk43zTRiKqchRo/tVBHFJpXWxK6qJ
zFkq+ZBMccgyZ676JBTMrm+nIdL90nwYrwfLVacY0f7yWiDy1RM0tG2IunHWvVHa
Dsmm6hRVjJh6qqxrV3oan0PYlghpMzYeTDbR2kI23sU0jJ5RVAgfvN66jcfns8XJ
+CTZTBvcd+1ZLYt3+YgwtlfstvJuYvdSp12/GXG3ybUerFilyWBHXJNpayyN7BsE
sEwtMGkGPzTvQL5mlIxvOZs2QDDzzih3KlWucxdyt3SzSk2uNJ+JWx0u8kaS8r0K
G0bFUJebIaVa7IvS2KKQalOJQYEMzQ==
=GXmx
-----END PGP SIGNATURE-----

--Sig_/JS48schjlrZViXtwXqiHQaS--
