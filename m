Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C9B32CAC6
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 04:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhCDDUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 22:20:30 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:36533 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232178AbhCDDUZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 22:20:25 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DrbhG6z4pz9sPf;
        Thu,  4 Mar 2021 14:19:42 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1614827983;
        bh=yUkzJf99TcD5TX12wKNcaiACzxJSdmXLK2gpDaBbZhI=;
        h=Date:From:To:Cc:Subject:From;
        b=FV4AcKCdoaGCUO+vKlCQ/2tB704S0nzFLZvML2lwENeoqnyEnQFjqRGzFAra7gzll
         0QzW9piRI/JEtQY4bIAP0nzOq+hzMhxT3gCKX77M/obS11VlfjOcRqqbFqedtWAkts
         +9wIumNlTDklrwHU1tSzC07V6m6BbkpMd9wgvrjdY/p7mOKktv1YZMYKgzSpJz2NsH
         AAprIzTVeFZcqt33mqxS++1+C/9nbZwuQ4MINuPywK0Nl1iZlkkEw8p2tmDn5p+c2e
         3ks3j+/qWq5alGTXpuMMUK+yqBQEDMZ3iCeMTO0ZMVFW49lXqp2FoVmokMRjN/pLk4
         dMF2CnG7IbYlA==
Date:   Thu, 4 Mar 2021 14:19:41 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Atish Patra <atish.patra@wdc.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20210304141941.07a98dce@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/wU2AgWcWDdeg6qn7qB.XbBL";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/wU2AgWcWDdeg6qn7qB.XbBL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  b12422362ce9 ("net: macb: Add default usrio config to default gem config")

Fixes tag

  Fixes: edac63861db7 ("add userio bits as platform configuration")

has these problem(s):

  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

Maybe you meant

Fixes: edac63861db7 ("net: macb: add userio bits as platform configuration")

--=20
Cheers,
Stephen Rothwell

--Sig_/wU2AgWcWDdeg6qn7qB.XbBL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBAUc0ACgkQAVBC80lX
0Gw1fwf9F7Y5sU4xzvEKW1pXpJfBH2YSRn1fXrC3/EaZ4GGzyqjYVItGMSltU1nf
m75rdMR+IAsszf7SNmcwEA3QHi6SJyva9EmcGxvM31n7yP0CSkPT3yNFPuQIL29y
uKeOpjMeXtTayZDl4FVulZloFg749ejNSt1TyqcS1+83It/2tVrsSpEN0/kyNXNR
Yv49wbOh6ROGJ8zflFVMqIMOwGpfYhC3YKsKImMN7AZZW3XhtJwiWVoHxkwrA453
OElm58qAQpFGxt3IgiSROglqB8P0TB6n05o/NHdYhL0hzEAWquBvb6w3w20OPriw
pEwLQasKjfgPubg+eUppJ48Ou//FtQ==
=lD/B
-----END PGP SIGNATURE-----

--Sig_/wU2AgWcWDdeg6qn7qB.XbBL--
