Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C856C21E584
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 04:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgGNCQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 22:16:14 -0400
Received: from ozlabs.org ([203.11.71.1]:56949 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgGNCQO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 22:16:14 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4B5PJW4g67z9sQt;
        Tue, 14 Jul 2020 12:16:11 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1594692971;
        bh=rVAGOXUcYkSUFm/QOqX+mwpG4sJ8hnCIMzWRUosxu6Q=;
        h=Date:From:To:Cc:Subject:From;
        b=JKgEpVOF+gKsWfQndZKY3N6lwAcMLd0Spe1XkYa0/Jcl8cRwp0H+4fBGQM0tCny8E
         lF0rm1X6JqN0dcrorkYPpu7u6a8ZPZH0vTTxN/rawOBxCYB6bKcDTA9Qfmsyq4fk3S
         X+nIG0wZ3G3D+i0qJxPBxudbPEhVvUlPqOICvrAgnqz/RtAwrzjJTaACZz6VFj03mD
         cUTOp3/GrKpFP2hfefLsa3rfXS8uGJEfywtvHaV8TImPy7EkMPf4XlQXYg2Y8RbTSq
         ADNsN8aeH0+9ZvHhJJ4+xQHr1t6WIRBcTmSfCZTAhPt1hVmZfMrMLlUEOyDwGRMg3s
         BJ7OYKtWK1GcQ==
Date:   Tue, 14 Jul 2020 12:16:08 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: linux-next: build warning after merge of the bpf-next tree
Message-ID: <20200714121608.58962d66@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/FQM8yWfyiMO+aHkZLyky8.7";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/FQM8yWfyiMO+aHkZLyky8.7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the bpf-next tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

ld: warning: orphan section `.BTF_ids' from `kernel/trace/bpf_trace.o' bein=
g placed in section `.BTF_ids'
ld: warning: orphan section `.BTF_ids' from `kernel/bpf/btf.o' being placed=
 in section `.BTF_ids'
ld: warning: orphan section `.BTF_ids' from `kernel/bpf/stackmap.o' being p=
laced in section `.BTF_ids'
ld: warning: orphan section `.BTF_ids' from `net/core/filter.o' being place=
d in section `.BTF_ids'
ld: warning: orphan section `.BTF_ids' from `kernel/trace/bpf_trace.o' bein=
g placed in section `.BTF_ids'
ld: warning: orphan section `.BTF_ids' from `kernel/bpf/btf.o' being placed=
 in section `.BTF_ids'
ld: warning: orphan section `.BTF_ids' from `kernel/bpf/stackmap.o' being p=
laced in section `.BTF_ids'
ld: warning: orphan section `.BTF_ids' from `net/core/filter.o' being place=
d in section `.BTF_ids'
ld: warning: orphan section `.BTF_ids' from `kernel/trace/bpf_trace.o' bein=
g placed in section `.BTF_ids'
ld: warning: orphan section `.BTF_ids' from `kernel/bpf/btf.o' being placed=
 in section `.BTF_ids'
ld: warning: orphan section `.BTF_ids' from `kernel/bpf/stackmap.o' being p=
laced in section `.BTF_ids'
ld: warning: orphan section `.BTF_ids' from `net/core/filter.o' being place=
d in section `.BTF_ids'

Presumably ntroduced by the merge of the resolve_btfids branch.

--=20
Cheers,
Stephen Rothwell

--Sig_/FQM8yWfyiMO+aHkZLyky8.7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8NFWgACgkQAVBC80lX
0Gy6+wgAoyJUbC/DVCPWdvLTBOUJoTlVg1/wYhG6hi7HsA3tnFCh0C1vrWRF6gbn
QTvlEo5rfeEbcy4N8ksQDk2B00ED5iuInvkGGQp5fZXkq6hsTAyDItjnxxAh6Js0
QtxhGGwP3LShrZg8pyOSmjqU/rfML22986kQsJ8cL6cn9Xsl6z099qv9U1mEgBoy
muGwkgchg6PGfW3iVAW54zPt+ltLXNcuWKrPhPZ9ur44Vo0Dxt9j/T5AOV+Qo+R4
dt3f3yrtJa+6VBI9bZDHcDBzDP9vOL0iQ5UKVDX5re8ivTH1bweRTRShImpM+sj3
0JTXbJtZvut7+BLGIbB882ed6/tG8A==
=0atY
-----END PGP SIGNATURE-----

--Sig_/FQM8yWfyiMO+aHkZLyky8.7--
