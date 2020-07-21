Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC96227C0D
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 11:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgGUJrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 05:47:47 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:46813 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbgGUJrq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 05:47:46 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4B9v0H0PkZz9sQt;
        Tue, 21 Jul 2020 19:47:42 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1595324864;
        bh=ugY4o/TZYhklh1+/uO59si7dSoFL542+vS5fIOihoSw=;
        h=Date:From:To:Cc:Subject:From;
        b=UN6GnqvpHWu0JQIISvWXo7EigZbtVIkhyu/7+pOeJUXG7aRHer5pxEHFbzUi+nRFN
         Aei4sL4Pg61DpCfLfzAMGp6A+fHRUaN4q86pclDHss4A4betb/uF+wqfhLh9nasV4u
         ch+oPMhZVnqD4qfHeKv7Gi5VjtcDgR7+HYxcPe1PklrtUTwyZBqJ+wKybkx7pj/gNP
         nK84I1saGtScToy6+2xqVLji/Fyc3mcPBbXITlCxiNvVBhzB77Z5pSoM5QUy5Iql4u
         KYHLJOLt+3vQqCEvIpkVkr26K/wqGCuL6yPV3W8XZGTWDUkA+J5hJIsE1NHcsQ1oLT
         bxoQ3hwSA58rw==
Date:   Tue, 21 Jul 2020 19:47:39 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Waiman Long <longman@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: linux-next: manual merge of the akpm-current tree with the net-next
 tree
Message-ID: <20200721194739.4cac3da4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/RVB4UNz+Uam9DImdewNfFT_";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/RVB4UNz+Uam9DImdewNfFT_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the akpm-current tree got a conflict in:

  net/sctp/socket.c

between commits:

  89fae01eef8b ("sctp: switch sctp_setsockopt_auth_key to use memzero_expli=
cit")
  534d13d07e77 ("sctp: pass a kernel pointer to sctp_setsockopt_auth_key")

from the net-next tree and commit:

  f08cd4915bb1 ("mm, treewide: rename kzfree() to kfree_sensitive()")

from the akpm-current tree.

I fixed it up (I just used the net-next tree version) and can carry the
fix as necessary. This is now fixed as far as linux-next is concerned,
but any non trivial conflicts should be mentioned to your upstream
maintainer when your tree is submitted for merging.  You may also want
to consider cooperating with the maintainer of the conflicting tree to
minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/RVB4UNz+Uam9DImdewNfFT_
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8WubsACgkQAVBC80lX
0GxwtQf8Cz8gQtOTJ7wQZDKywCfaD5gW6et5FPlqKA36rEZWcXr1FjqiQrbdywfR
6OfbfvxTaORjclstKwAs3y7jRxdd/q5FoIVnj3xQ88ZU/M3aINZpThpr4AIJyTcB
zO/8eR27/8nItHqnrpA6pEUSnz8qwZKS/XeYi99BtlPpQlv9lRqujBMRYvmtI7Wy
6aN4bYho8Xk5DSOHIK1RfrZGWcoJHdFISEgW7imvQlzhrM/YJ8j3jHDbshT+txmA
7jXYaA/QmPM6TJyYg4U3C+RYoY4bIT8BoqMOetxULPujQVBGCq1Z61Z7lOUgzMqJ
mvCw9HniybLU1+t11uTew6cr5Vghsg==
=tydt
-----END PGP SIGNATURE-----

--Sig_/RVB4UNz+Uam9DImdewNfFT_--
