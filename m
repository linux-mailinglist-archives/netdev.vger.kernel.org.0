Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD57CEF2FA
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 02:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbfKEBpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 20:45:44 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:47361 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730037AbfKEBpo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 20:45:44 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 476XYc0bVqz9sP6;
        Tue,  5 Nov 2019 12:45:39 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1572918340;
        bh=8XWY64SJKqZIyzn9EFs+RU2Chz3MCXPcnBcxJoBUTjk=;
        h=Date:From:To:Cc:Subject:From;
        b=Q6/KyacKQpBRHV8jj5Jw5hgo3C1+HrIIAJ8sDBq5IoA5utI8IFEpe470MH/rPNA11
         TrUTSAIc36ZbxC/xq4HoHZOxfygmlC/cDCF1jlfIw+eh6Vdz/y0htXqQQeObU+YMKQ
         F7ZzVD/JKgbaZagdNsX05ohUSMmG7h9zJsmMPhR9MsSMYVo2oCqyWUonAV71EVTK1o
         BhL477oZuWG/whAp54Dfy9Y83WpjipUrQMl90kqsE8+g0bKtw8oqDotg3kWWteYeLr
         jgCyHSGWzN55nbeQ+z+kqfCjnvNe7Ksw/9+EHmUGKLJfslG2M4/SR7Zk04OY0ChXiF
         C9/aUdxdWKhxQ==
Date:   Tue, 5 Nov 2019 12:45:39 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Venkat Duvvuru <venkatkumar.duvvuru@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: linux-next: build warnings after merge of the net-next tree
Message-ID: <20191105124539.7566b922@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_//jQT+NOl0NGJ4he.TSA94Wo";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_//jQT+NOl0NGJ4he.TSA94Wo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64
allmodconfig) produced these warnings:

drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c: In function 'bnxt_tc_parse_fl=
ow':
drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c:532:8: warning: array subscrip=
t [12, 17] is outside array bounds of 'u16[6]' {aka 'short unsigned int[6]'=
} [-Warray-bounds]
  532 |   if (p[i] !=3D 0)
      |       ~^~~
drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c:293:6: note: while referencing=
 'eth_addr'
  293 |  u16 eth_addr[ETH_ALEN] =3D { 0 };
      |      ^~~~~~~~
drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c:532:8: warning: array subscrip=
t [12, 17] is outside array bounds of 'u16[6]' {aka 'short unsigned int[6]'=
} [-Warray-bounds]
  532 |   if (p[i] !=3D 0)
      |       ~^~~
drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c:288:6: note: while referencing=
 'eth_addr_mask'
  288 |  u16 eth_addr_mask[ETH_ALEN] =3D { 0 };
      |      ^~~~~~~~~~~~~
drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c:532:8: warning: array subscrip=
t [12, 17] is outside array bounds of 'u16[6]' {aka 'short unsigned int[6]'=
} [-Warray-bounds]
  532 |   if (p[i] !=3D 0)
      |       ~^~~
drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c:288:6: note: while referencing=
 'eth_addr_mask'
  288 |  u16 eth_addr_mask[ETH_ALEN] =3D { 0 };
      |      ^~~~~~~~~~~~~
drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c:544:8: warning: array subscrip=
t [12, 17] is outside array bounds of 'u16[6]' {aka 'short unsigned int[6]'=
} [-Warray-bounds]
  544 |   if (p[i] !=3D 0xff)
      |       ~^~~
drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c:288:6: note: while referencing=
 'eth_addr_mask'
  288 |  u16 eth_addr_mask[ETH_ALEN] =3D { 0 };
      |      ^~~~~~~~~~~~~

Introduced (I think) by commit

  90f906243bf6 ("bnxt_en: Add support for L2 rewrite")

--=20
Cheers,
Stephen Rothwell

--Sig_//jQT+NOl0NGJ4he.TSA94Wo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3A1EMACgkQAVBC80lX
0Gzd4wf/TsGM+bQOSLVWyrPF2ARyzpDjjPpRR90fKowk0enDFlijABIgcj8JuZfF
ePx0Ws5wxaSFdi5ncNfqk6kzmS9ixm1HfaBO5NgtjrU+tdOJiuJDeCsl79Za4SGR
c3aF57AuRyhIsz4h6DpLCBsaVPWHiMDekZ4nHbwF8tc/49j8T6vwTBYy89AqcS3J
aPXLbUzPlI8Hr1hDdwYo7ke41JG5FMZ8mS4hB2w06BJyh8BU1qPosW76ip06jwl1
3f68tU+u1EPio5yc+HddhFAhBYhVFns5VMPih/jzWyIWpQTLMSlS4kPBCXfSJvo5
GVDADCiGTQpz35WhmdFWDWVvKvRrDw==
=nRKU
-----END PGP SIGNATURE-----

--Sig_//jQT+NOl0NGJ4he.TSA94Wo--
