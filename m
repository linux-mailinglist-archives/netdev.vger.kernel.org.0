Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44E9817F441
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 11:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgCJKBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 06:01:37 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:44877 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbgCJKBh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 06:01:37 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48c9bd3JKWz9sRN;
        Tue, 10 Mar 2020 21:01:31 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1583834493;
        bh=/cpwUTr/5C5bzvFRcsQ4FWvOJET1pc94+Z0oZc/XXCU=;
        h=Date:From:To:Cc:Subject:From;
        b=sr/xXATCs8zJRGQcCxQX26AzUiEgZ3YrXAiL5/pPJlCCny4oOk+OLG+BljFehsn9J
         eH/fVfDjlrT++7TA9ZCYiIxSoWdlAFbiCbyCKW2vTRUgFokVfS2wfTmGigAiCuz+Vz
         9WWDQ4ylm3Dyg5TO1HNKomkrXZy9xcDQKUOrwSoGnFlWEKtHeL2vVZUcrqAjIsGI5r
         8OWq63L+RY7MYF+92UAezUVqB5EARq6TxPs9KBsK3C4u8PiGrjWNn6gF4w9jm4cDLv
         7v5bglqkMgc/hAURfm8hhsjyj/j6b/136k1GLyZ3v4VmfgVBObGDfE2AI8TCGrA0Rm
         b43FnA/FVybwQ==
Date:   Tue, 10 Mar 2020 21:01:30 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: linux-next: Signed-off-by missing for commits in the net-next tree
Message-ID: <20200310210130.04bd5e2f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/7uVA0POWQkDBS8iRosZ5zD/";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/7uVA0POWQkDBS8iRosZ5zD/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commits

  b63293e759a1 ("net/mlx5e: Show/set Rx network flow classification rules o=
n ul rep")
  6783e8b29f63 ("net/mlx5e: Init ethtool steering for representors")
  01013ad355d6 ("net/mlx5e: Show/set Rx flow indir table and RSS hash key o=
n ul rep")

are missing a Signed-off-by from their committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/7uVA0POWQkDBS8iRosZ5zD/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5nZXoACgkQAVBC80lX
0Gxe5gf/aVyYgD2gVVHFqiorut6BoM8hNN9sb1dJ40+moPnzAu2hiCQlxOLT9m0i
ec2SNSXsRus/+KgTf4EtG03p4sKwWWI7hJz9Rny0ajXBUAEr+iEcHlKUurwBcKax
7z/nfZxRrnfZeniY9MwWwqMQnksLkL7Yojd5rLc2EcfH2jtT8SjCrrtIFjxEgLyZ
8ozipBGlDpD1ojl0N5Oi6tqL2zRAxMRz9+Vw0xF+EKwQIxpu3ak82TyPzuPyBuGs
Hdf9qLopH+xtWAisInDD/ooRGd5G+9mN486KCIhs66dPF9SlKMKN8h6/Hu6RaG1A
ifMBKEII0hcdfkImKPSN5YkpNFHOzQ==
=848x
-----END PGP SIGNATURE-----

--Sig_/7uVA0POWQkDBS8iRosZ5zD/--
