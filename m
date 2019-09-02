Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B909A4CD1
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 02:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbfIBAbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 20:31:42 -0400
Received: from ozlabs.org ([203.11.71.1]:51059 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729098AbfIBAbm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Sep 2019 20:31:42 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46M9xl1h88z9s7T;
        Mon,  2 Sep 2019 10:31:39 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1567384299;
        bh=3UK8Ztozs7xxNmcWzuV44WDq2E9dwhhyHjl2lEEbEkU=;
        h=Date:From:To:Cc:Subject:From;
        b=aXPkA3t9zkmY1opkoyhblLlGZRlDM/u6uPUCR8DeSf2NqcyNRlwgyCtyvMcuezdvI
         qPx153lpd1OYhvRv/NBcqWtKyCRH+o/XiGnWUPDoPJ5rKplcMEw2TIn4SdogeE00vz
         iGRv5jNhDnABlCxEL/00b+NxsQJSQA/uXqh2gCxLoiu9400n59HKifSnpENRUXvIRf
         mCIzgASsGisgOxMLo4IWYMDQnHrlOKeqonngHFkzGOUrmXkN/CBepOxK0NQOPMSydm
         RzrPPbm5n6Fhe98VneDEePF8fYkubeEDjk+Qt984RMwSqN+/7V3qi1O1L4YBs1LooY
         J3Gtuy4sYdI9g==
Date:   Mon, 2 Sep 2019 10:31:37 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Howells <dhowells@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: manual merge of the afs tree with the net tree
Message-ID: <20190902103137.4c676df4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/l8KMogUmRNMDxS9Y+qQ/mQ0";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/l8KMogUmRNMDxS9Y+qQ/mQ0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the afs tree got conflicts in:

  include/trace/events/rxrpc.h
  net/rxrpc/ar-internal.h
  net/rxrpc/call_object.c
  net/rxrpc/conn_client.c
  net/rxrpc/input.c
  net/rxrpc/recvmsg.c
  net/rxrpc/skbuff.c

between various commits from the net tree and similar commits from the
afs tree.

I fixed it up (I just dropped the afs tree for today) and can carry the
fix as necessary. This is now fixed as far as linux-next is concerned,
but any non trivial conflicts should be mentioned to your upstream
maintainer when your tree is submitted for merging.  You may also want
to consider cooperating with the maintainer of the conflicting tree to
minimise any particularly complex conflicts.

It looks like the afs tree has older versions fo some commits in the
net tree ... plus some more.

--=20
Cheers,
Stephen Rothwell

--Sig_/l8KMogUmRNMDxS9Y+qQ/mQ0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1sYuoACgkQAVBC80lX
0GzQjgf+It47t1OqGXjGJJ0BgTasfwU/KZJBYN9SaQjkJ/MAOPb/a9ogS+/9fQbh
EuOI5F61Is/Re9fZovrd8OA+WurolTPxW6CNiyDeqTVIx00g6rU7eyE3FKfHrEyE
1ZEZcZT/I68yo/WHcMR5KFfOwFCUeRK9JgaaEuY4oPcRsVhpEcI/WvcOniAMZIO9
y2aqNq63V9u1kzMr8IncTlp54XkPcAo+J1prB3up0Ex0uXc1Hwb9fIGPgEyajDlZ
novm9Zhed14fdrffY5LBAk7bFuUlZS9YTaH89Sormhpbg36crX2N2qhPzP8EGvbP
VLNo2m7l54k5NKETBg6xFAIwqYduUg==
=Jhmu
-----END PGP SIGNATURE-----

--Sig_/l8KMogUmRNMDxS9Y+qQ/mQ0--
