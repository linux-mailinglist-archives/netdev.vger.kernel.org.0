Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727E11EB88F
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 11:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgFBJay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 05:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgFBJay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 05:30:54 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECF2C061A0E;
        Tue,  2 Jun 2020 02:30:53 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49bmxQ1HgNz9sPF;
        Tue,  2 Jun 2020 19:30:50 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1591090251;
        bh=AQe/VUiGG3MYATjhx0CdnC6wc5yX+zATfOS9ULtPrH8=;
        h=Date:From:To:Cc:Subject:From;
        b=cV6oh/I7C8r+fP9m8u6TEC5o7gHHQ50b2Hps4YsNmalulok+FpvNfx6AowJy4j0Ew
         8gBHfdtWSDszWNiuSaAtYTEEXdgyRMc4PU1OajZjBVgqE2MqL3Na0hS+rp9O3+U+6h
         j01W/bZVmJc2tUVtK4JCHyUdGcg0vI+9t2SjPpMtnu5LnasO7vIFoECUWldFn51oKo
         y2BvYhDpANTNgTlvymYxT58HzRRl5HN7TJ2wC+nVIESkFvSxow43KQ4HNjW41ZQ58P
         8GHmTAk6ggDAzSJsd4Sd19PHDY0KE83bTbXeT4EZX0SEo9SX+nIV9fMwhYCrtHxLnm
         9hzw/jIuDw60g==
Date:   Tue, 2 Jun 2020 19:30:48 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>
Subject: linux-next: manual merge of the akpm tree with the net-next tree
Message-ID: <20200602193048.6ab63e72@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/CCBnNGpy6kpy/I7QlBCJzIU";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/CCBnNGpy6kpy/I7QlBCJzIU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the akpm tree got a conflict in:

  kernel/trace/bpf_trace.c

between commit:

  b36e62eb8521 ("bpf: Use strncpy_from_unsafe_strict() in bpf_seq_printf() =
helper")

from the net-next tree and patch:

  "bpf:bpf_seq_printf(): handle potentially unsafe format string better"

from the akpm tree.

I fixed it up (I just dropped the akpm tree patch (and its fix) for now)
and can carry the fix as necessary. This is now fixed as far as linux-next
is concerned, but any non trivial conflicts should be mentioned to your
upstream maintainer when your tree is submitted for merging.  You may
also want to consider cooperating with the maintainer of the conflicting
tree to minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/CCBnNGpy6kpy/I7QlBCJzIU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7WHEgACgkQAVBC80lX
0GzaFAf/cQHv6SkHPmkCK9lsZ37Eb2X0OhGy6aK3r7CfiDrKIME/QTIPQAi37Ej5
w028QbX1s3Lrr6WxNYa9tQSv8mya5yVqE/HS42hAexGDViLRg617Z2ybbljqBS9s
JBkl8n56KJv+0ZYA1dG4jlkt9tYSSqUSbKjOJb3CzcwUNUqWjba52tpitRiYrwWz
g4khpa9UEYm+MfWlmh26irXy+4oKK+7xEy28BtAhN99zf51mwK50pEPUlkjC4AaC
Zq13+gUDIEEL7uhaeEFOkWtwb9AOnOhor0OWeNj+hubnlcSZeORs+tsdTO8BcCKn
A4wgg6cAZADqlNRLYeG9jsyIuDUmhw==
=ZwTb
-----END PGP SIGNATURE-----

--Sig_/CCBnNGpy6kpy/I7QlBCJzIU--
