Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03C4468E27
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 00:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241256AbhLEX7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 18:59:01 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:57689 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhLEX7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 18:59:00 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4J6k2q1vj4z4xZ4;
        Mon,  6 Dec 2021 10:55:31 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1638748531;
        bh=DrJdXzY99aL2fHcFmJHSlP3TWIuV+frybA3ZFre4Xg8=;
        h=Date:From:To:Cc:Subject:From;
        b=ElO9+5MFva/yoDlMEdK0a1SrQJI4RohpbZfppNr66UfVfMbh5c1cxMDMJi5EPP11H
         /rJ1qyXPhQFz3otFZWNU67iuzI161j6scFewZxwm8JwOsWaPzVMQH3HgREBFYmLMG8
         /uGVbdahyeNzh5ETOh65hDtTCn7bOCpGLV1077QEGkDrgMlXRJjz47iQXJdDw46Fqp
         rsEIQWd1xFvbZvCl0i7UtpqWEUcLercpzk8uMPo60EjdnVdGOvF7Ksi3kPWcQrfqt7
         heG5XMKKRcyikdG9GunO234VNMeEP7vBjd/xQf6Kx+4p/Dnaub6My6WETd+4fthFje
         muAfgxAOFvZ0A==
Date:   Mon, 6 Dec 2021 10:55:30 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the bpf-next tree
Message-ID: <20211206105530.0cd0a147@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/2noK=m1j7E8R=JLz/_CEmtD";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/2noK=m1j7E8R=JLz/_CEmtD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the bpf-next tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

kernel/bpf/btf.c:6588:13: warning: 'purge_cand_cache' defined but not used =
[-Wunused-function]
 6588 | static void purge_cand_cache(struct btf *btf)
      |             ^~~~~~~~~~~~~~~~

Introduced by commit

  1e89106da253 ("bpf: Add bpf_core_add_cands() and wire it into bpf_core_ap=
ply_relo_insn().")

--=20
Cheers,
Stephen Rothwell

--Sig_/2noK=m1j7E8R=JLz/_CEmtD
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGtUXIACgkQAVBC80lX
0GxvuQgAgXMj3s8WiuWOPnalKzE/y7OdDSJxxK9W89LhGd3E2/L9BgIo/nNIj1bf
YSQPZAvsm0aTDO8jF7mO+T1Vwe/nNWHHEIKNEjgCGolNKStoyhr7zWR0SnSGzT2I
VgocPm2msOKZJ4sMMePV6nUGF74moOWyyZnTqOZYdm2/LhL2fFG6RwsnNtkB+SXC
4qKb6nAIqZzXOgWK26LhnL965MtoisUR1c4nvpqPxz2yATqE24DtVcJzxUO6GUFv
3LVfwAG4ZSVsBraCRWM+5Tq49sdMoDd4NNPa4//IcvC9H2YrQ2eFagaHBbWRdWgL
iqLcaY26keyMp7K1M7sEYqvOETBL1Q==
=AD1z
-----END PGP SIGNATURE-----

--Sig_/2noK=m1j7E8R=JLz/_CEmtD--
