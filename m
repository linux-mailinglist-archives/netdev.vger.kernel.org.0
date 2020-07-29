Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C17E231807
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 05:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgG2DU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 23:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbgG2DU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 23:20:58 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD50C061794;
        Tue, 28 Jul 2020 20:20:58 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BGf2F2DGWz9sSd;
        Wed, 29 Jul 2020 13:20:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1595992855;
        bh=FQfpmxCdFZ8cS6nJ/IIH9W5dOQ4bTbHg21bsMtTdKQU=;
        h=Date:From:To:Cc:Subject:From;
        b=kNKkuZCSB/1cjnGKIvUbpELOPWY91GQC01onRDI72UXmjECLOx1xHBTC/r0Gt7w+w
         g+OX4Xf1hzVKS6IsOh92BWB6BBDI7QEJC5n02UGzHfOQmkz67029v4fBCzXK1HN4gS
         Ck3QppYN8ixBOz5HXwYZREZfPRGeGIoa54EAWoQrlbUnIK2/UZvO2UJ5ARTSqEyJDF
         vqC1y+JWefdIfcHxRgsJwCYx0tvT5TW0X5qePGNItmvYqmq4Jef9Qz44C87Uqhsku3
         W2ybIp9w7euAl4hbqdB8b7KERKAmb2kCsojUMkDFEPgwR2pidsxBlaQg2LTVXZ+VJa
         bHXvwFZacJEeA==
Date:   Wed, 29 Jul 2020 13:20:50 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul@pwsan.com>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: linux-next: manual merge of the net-next tree with the risc-v tree
Message-ID: <20200729132050.10527ff1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/rKGAqN4rJ0Sxexkd60vKQYf";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/rKGAqN4rJ0Sxexkd60vKQYf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  lib/Kconfig

between commit:

  1a479f783857 ("lib: Add a generic version of devmem_is_allowed()")

from the risc-v tree and commit:

  b8265621f488 ("Add pldmfw library for PLDM firmware update")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc lib/Kconfig
index 610c16ecbb7c,3ffbca6998e5..000000000000
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@@ -677,5 -677,6 +677,9 @@@ config GENERIC_LIB_CMPDI
  config GENERIC_LIB_UCMPDI2
  	bool
 =20
 +config GENERIC_LIB_DEVMEM_IS_ALLOWED
 +	bool
++
+ config PLDMFW
+ 	bool
+ 	default n

--Sig_/rKGAqN4rJ0Sxexkd60vKQYf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8g6xIACgkQAVBC80lX
0GwumwgAgaM1oRM4ovApS9tbdCpmmk2laMWFWvSV2XbYF4B78o8pUdMRNkFwh/eA
1KHu//ycq1O56W1APnv4XeQGoH+qdB43aJSddvCerdpEFLrCgkhPdaoq5s9ROkop
s/hWBVw8oqV1xtYdnK4vg0j6++uhHSpoPYMGqqxi++yP+jih1c3cE3kj+hXEGc8s
OiLAqUM9g+L0ZQnRahWiqHjNwNhy8ESWdH3LKmOD2inIoYoInF4a6oOUU+H/t/gE
9YvtqSgRQc3ugmKjeJGmVc5aRhYH47TPwaB2b13TS2ZbXSFsK88IznQIl5tSxZrG
9Md6SnDc1uXL4yO2fDNG3tlQfW0izg==
=bvmC
-----END PGP SIGNATURE-----

--Sig_/rKGAqN4rJ0Sxexkd60vKQYf--
