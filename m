Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771AC365133
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 06:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbhDTEP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 00:15:29 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:34649 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhDTEP2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 00:15:28 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FPVhH3s0Wz9sWQ;
        Tue, 20 Apr 2021 14:14:54 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1618892096;
        bh=k8eWH1sA7VLjuI++AbBGBSJj1IIJmkdbesJARKjNeak=;
        h=Date:From:To:Cc:Subject:From;
        b=fxNSa1l/hirfA/YKhI2SA2K8JZPUQXyKDul4uAOHGopwFCLySKKrWta1L58KY/3cA
         91rhbBndjIQ19DJtTtYKJZ4tZcbL39KTyFRCdpZ8mgi0bjeXieOEIeVD3QaBp74E1/
         6gDAUkPvjieDVqm380bTppA2eu17iRBpZ8T6LiBixK3O+p1Lq/jXAHRaLBXnGJf62c
         +KmLYZuUMpIQgalEYX/QGhS9nCscz5dOJYZ6sI1SOsBCwTl0yUBxIlgGdedmW+GK9P
         MsNufXFpfBHhiY0xmlBtlrjqIrKCgWJU1ZzBVKrOIZPJ7d7GhyLz9aJn4BNiptok0A
         zlrA+QsBx/PXQ==
Date:   Tue, 20 Apr 2021 14:14:52 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Florent Revest <revest@chromium.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the ftrace tree with the bpf-next tree
Message-ID: <20210420141452.6e6658b4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Pn4+GfZIM8NDSkabrm3_m.H";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Pn4+GfZIM8NDSkabrm3_m.H
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the ftrace tree got a conflict in:

  kernel/trace/bpf_trace.c

between commit:

  d9c9e4db186a ("bpf: Factorize bpf_trace_printk and bpf_seq_printf")

from the bpf-next tree and commit:

  f2cc020d7876 ("tracing: Fix various typos in comments")

from the ftrace tree.

I fixed it up (the former removed the comment updated by the latter) and
can carry the fix as necessary. This is now fixed as far as linux-next
is concerned, but any non trivial conflicts should be mentioned to your
upstream maintainer when your tree is submitted for merging.  You may
also want to consider cooperating with the maintainer of the conflicting
tree to minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/Pn4+GfZIM8NDSkabrm3_m.H
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmB+VTwACgkQAVBC80lX
0GxElQf/alTe2DZf/ChTMHfnV1VSdfcVegaoDGQ7iGSKaTFtxdVSrK/Xz2ve2OaQ
iE0/TFXGRFzCTZKlXNTOyoUzifvsDE83BcDSoNxhJKnRxN+6Vvt/r9zGdEZ4VAVH
lIDQsSVv0pun4QbDg4H8mzmHkHWo9h/P2X2jVMC4XDylYQsC3lqEcpkC3Y1n0tBj
yyrqlpAQHZ+I75sX3e4+CViKUTXvgSA+D++KZv6SLPfKQWrbY6zlJTrBFSEdhOmy
AA03BJ+zJP3wnn8WrT9QoQurTAdCCk7cc8PMCy0FOBIyGySwWPsG7/Vp/Nzhwybj
qbmeNBt78drbzL65BwM95NoGUvTwTw==
=wa+B
-----END PGP SIGNATURE-----

--Sig_/Pn4+GfZIM8NDSkabrm3_m.H--
