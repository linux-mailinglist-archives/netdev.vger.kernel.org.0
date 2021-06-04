Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A3739AFA1
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 03:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhFDB0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 21:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhFDB0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 21:26:00 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4E9C06174A;
        Thu,  3 Jun 2021 18:24:15 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Fx4mX1GKbz9sRf;
        Fri,  4 Jun 2021 11:24:11 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1622769852;
        bh=Y8Pk2CsU/n3nllqNiul95HyVmnP/XFvbdpZTTymVslw=;
        h=Date:From:To:Cc:Subject:From;
        b=HaZJ5rSg+rZWGtXrU6S4+ntP6BGLgCCuLRjN+pSe7+G71+zJOKA+bskoj4fxs2Clc
         r41uGq9HKXR1cCKwD/m/vUA9P0x3oNIO8EcTadAduia6365ZOXAYhcYhS7kYz9twmJ
         ZKrpDQmeAcAZzzYNAEzbhZkGHa6eSzZh55/TF2U6alEx1nZlCG6LGZ/oaBFQgefl3Q
         VbsAs22CNFSbi84KVWt4jTDV168ZjR9JOemML7Lo+GGwTXXj66yHQJt25vxJ5EZfr7
         MT9LkHCvP4BQTleZiv+NyHh6Em50Ux52HkW4n+91Na/RLnyEyKmoJlYrLFZSu6DtLp
         H33J9jlhRMHwQ==
Date:   Fri, 4 Jun 2021 11:24:09 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Andre Guedes <andre.guedes@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Vedang Patel <vedang.patel@intel.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210604112409.75d2cb91@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/=0fNk_KV8Im1axbCS.FRT0Q";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/=0fNk_KV8Im1axbCS.FRT0Q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/intel/igc/igc_main.c

between commit:

  45ce08594ec3 ("igc: add correct exception tracing for XDP")

from the net tree and commit:

  73a6e3721261 ("igc: Refactor __igc_xdp_run_prog()")

from the net-next tree.

I fixed it up (I am not sure, but I just used the latter version) and
can carry the fix as necessary. This is now fixed as far as linux-next
is concerned, but any non trivial conflicts should be mentioned to your
upstream maintainer when your tree is submitted for merging.  You may
also want to consider cooperating with the maintainer of the conflicting
tree to minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/=0fNk_KV8Im1axbCS.FRT0Q
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmC5gLkACgkQAVBC80lX
0GzLEAf+I2BlUmezOaUzkHxqsyiJdtrkOuKSYduYfBXCu4IP/6nw7MHy0aA1uwr7
xzjguGkrpnh8Am5yHeGyzfx8/nzv5FRyqc/vzBXi8ayfh7yyOQsyjEpcyyu2bHZR
W8zO1SCzvM9SUMOkkhesAh1G+MdnmYLzc2GCmiOl5MPqoaQT9ASpQ7ioCw1Zjk2b
sKwgc50GcL7M3s7e0xcmNeIqR8VmP/9nhB6jXDHkITyVDhDkIFqESf52cawA49Lb
00VkXSAOZqnkTXR+43+ZNCFXgbawZjIt/q43ZJvzHIB3pu6/MmVlkiFbxcGc7tH4
D7hvTZjuWqB/6vZHxDca9p3W36OlSw==
=NlEW
-----END PGP SIGNATURE-----

--Sig_/=0fNk_KV8Im1axbCS.FRT0Q--
