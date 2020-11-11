Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65EEE2AE539
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 02:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732383AbgKKBB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 20:01:29 -0500
Received: from ozlabs.org ([203.11.71.1]:55233 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730254AbgKKBB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 20:01:28 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CW5yt0nHSz9s0b;
        Wed, 11 Nov 2020 12:01:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1605056486;
        bh=7DC7gvem1UbPgT/VXbxWA0rCkpEa56uVYGIexoT6kak=;
        h=Date:From:To:Cc:Subject:From;
        b=H909i5lWwpVJUX9wq2KDJR0RufBYulpnoNwdHthVAiXdYZIpCdhYLI8C4FLamZHUh
         oejqYzcZlprmDs8eamgE/gPv/EneDyeBzEmN/q6CfUGOIV4xDfoXwMUWALNaL5KKr3
         g72MkXeM63D5C1Z45pGLj8Zag//OcBWhJoInFUGGAjdmIpcENTAuIiE3qBtP5JJtIh
         2a6qD7lRqv1DBkIQwMr5AEc7usBuJxoDqcZXt7R2K/r4rfxhPrb9xJsjlLJu7Xt64A
         q0ptpalb5cTmlh4KYMK7p16u5F9bhe40tyJzw4dzjdnTKumajrdWZ5vRhnPbWmMUAY
         iOln+boIL1RLA==
Date:   Wed, 11 Nov 2020 12:01:21 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the bpf-next tree
Message-ID: <20201111120121.48dd970d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/iWrle19D3CsoDrjSZK2THjN";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/iWrle19D3CsoDrjSZK2THjN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the bpf-next tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

kernel/bpf/btf.c:4481:20: warning: 'btf_parse_module' defined but not used =
[-Wunused-function]
 4481 | static struct btf *btf_parse_module(const char *module_name, const =
void *data, unsigned int data_size)
      |                    ^~~~~~~~~~~~~~~~

Introduced by commit

  36e68442d1af ("bpf: Load and verify kernel module BTFs")

--=20
Cheers,
Stephen Rothwell

--Sig_/iWrle19D3CsoDrjSZK2THjN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl+rN+EACgkQAVBC80lX
0GwTJgf9E5nzW5y0jLn6+pQ2LZm6udyxCY0aMfYH7akZ56tOVDNC5xtWNAOjmDQV
HTv1Zk1rQeBD8/2R7WASNHkM2INiDhjmt00Lz3pHHEy0/o59K57I/P2wZE+ZkViZ
EH80eFkVlQHBp8EuUIvQTxHjBBBJHGijMulYTO6yrEEWFvirT8k0yncC0bHNVeA0
DLk4E/o7u0qbDgLbtw/k0xEVXqkQCCeiJmK9aBrkpoMmQ2BeTvepLspmEmvLmAVn
xzHkzb6+xIGHjuafLXTmLOu7sNRb7aoXfjBXnMVCo23lBee3RqUsAqGoWeLJ6/8o
7Z5RE5jDzMJsgRHFv0ZPdwYohjeNew==
=0CGt
-----END PGP SIGNATURE-----

--Sig_/iWrle19D3CsoDrjSZK2THjN--
