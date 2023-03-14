Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5776BA35D
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 00:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjCNXJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 19:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCNXJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 19:09:24 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 916EF11E8E;
        Tue, 14 Mar 2023 16:09:20 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Pbq3H3qsPz4x7s;
        Wed, 15 Mar 2023 10:09:14 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1678835355;
        bh=zp1vOq3Z4RzomtovnhpPk+i4gmtfN2epGEyTUY+WVy4=;
        h=Date:From:To:Cc:Subject:From;
        b=MG/5NmOosdQ685cX0QuNcO7oVGU90dHSIUvdzAHP4Pe5t/nCvpOwVDSJYZpKs9T1X
         RT4r0Qo5K34XZq3YLAxNSoASjRhSkrHBOPSvxIdgqGhle5tqrVAvHQB/ADTcH1lhbY
         dJvsiBOMYNicXZTqwbWXtzsLBiUXKQ2TRHDqmHiij7hBxy4oZXU92IPeTpFuMFVAYF
         ymZtN7pVi77zJjmbRqPq6BM6pniLVEYuQqcR/cLZKGUwQusIvvw8/S3JecH1apdV/2
         NGDb/phi9BM/gg3F28CDakTkvEVaqOhcvZq0Nl+vKNlRvS4tPbe0fMiEnckzKsnovT
         JYnOXQXSr83RQ==
Date:   Wed, 15 Mar 2023 10:09:14 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Kristian Overskeid <koverskeid@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20230315100914.53fc1760@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/XpQnpy+q6oC7lPpKvksrlVx";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/XpQnpy+q6oC7lPpKvksrlVx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/hsr/hsr_framereg.c

between commit:

  28e8cabe80f3 ("net: hsr: Don't log netdev_err message on unknown prp dst =
node")

from the net tree and commit:

  4821c186b9c3 ("net: hsr: Don't log netdev_err message on unknown prp dst =
node")

from the net-next tree.

I fixed it up (I just used the latter version) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/XpQnpy+q6oC7lPpKvksrlVx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmQQ/poACgkQAVBC80lX
0GyG/Qf/V5F0eZwQKjj1YA4px9e+pxaINh1a1x8V+dRn5kNq/9r2Up5Tkc6F/9m8
bqTzJAouBoTtZ5UNajXuU5/aOlLrOBN0hw1T/FaApRH6VpwgQqZXXuTe+d1kOZEh
s2ehRCyo7jGNvwzlGJ4jCvl/vMlaIu9Z49HAYKOWZv5N+ukGFh0NFvkMnvA8SwGf
gud/BhanG4EYXctlks1vveiHzyv0MfxUsG+uQNJ2jXxRzzO7/6fZ7DYO4Cw+LgAa
x2URfhgRrc2ufCs2kRkY5stViNfdXlyKL+HLCz2SMmatrarAcdv1GfRGpK3dIfA4
FJ6FxgRm5RwrLHP8uHiaK5wKTdmjPQ==
=k10F
-----END PGP SIGNATURE-----

--Sig_/XpQnpy+q6oC7lPpKvksrlVx--
