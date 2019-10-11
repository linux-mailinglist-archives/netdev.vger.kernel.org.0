Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0A0DD383D
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 06:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfJKELW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 00:11:22 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:42701 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfJKELW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 00:11:22 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46qDzC0cbcz9sDB;
        Fri, 11 Oct 2019 15:11:18 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1570767079;
        bh=olz6hcZobQUy1HClWoP+pa/+V7FHl/Qj/3t7OM/lK/U=;
        h=Date:From:To:Cc:Subject:From;
        b=Mnzi4nkXSqL+XgCSg4e4gNccg8MFMuS0aLo0WrdLvKduAS27EqILbsUHvsearpCPj
         ZlrkRSTQJOia7O71jO/ggZLzK4yu5BjmTy79YqCQVkW6TA2rpdKe1xOE55KZ4BYA5n
         wl9uMTpGnb/DUZ1IqAE0CUI6OWaNyfOv2GdQ8w+bRTYVo36YJ7q0eGbGm4MGt4F514
         GWX2C3MmcTOkGVAWNGextdBBcUjTnqXk22lVk1vUf5R3+mZqzeWRb/RbIXIF9fDyRQ
         8NhxqcIpZ+GF+m/gu86BrkVlnsbNliMEtsE+781kNGixrzSz1jqDm+R6EZu6oNyuqX
         h4O78cPCL9toQ==
Date:   Fri, 11 Oct 2019 15:11:17 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20191011151117.46bc6981@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/73SMEYNtzZwoB3.O7YpHvQ=";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/73SMEYNtzZwoB3.O7YpHvQ=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  2168da459404 ("net: update net_dim documentation after rename")

Fixes tag

  Fixes: 8960b38932be ("linux/dim: Rename externally used net_dim members",=
 2019-06-25)

has these problem(s):

  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

Fixes tag

  Fixes: c002bd529d71 ("linux/dim: Rename externally exposed macros", 2019-=
06-25)

has these problem(s):

  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

--=20
Cheers,
Stephen Rothwell

--Sig_/73SMEYNtzZwoB3.O7YpHvQ=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl2gAOUACgkQAVBC80lX
0GzYFgf8C4SW8gztXaeZIL4/2zevoCZLKTxSesy2CE1ZIOQou0JhWkchYGX2f1cp
DjBqFHvYo/EBP9b4YkRVoK8iQaKh4j1mNMTG7K6sRZJPYJ4yHOV/xq5IrlSCkCm5
CA+hT+ugfw84PjS9Gi4ATJwFHBi+MeiADoHLw4LffERQW3h+jJohYah2YJbLbqp/
zRtFFu0CkA6Pjpn0bOsjo067UHZ0W7UHcuD3fkCF2r060GMf7i7DcVLvdRdTc7zC
0g3vZXPm5KeMaDbjDhJl+tkcsP4sQVXi+hM3ayV9b8YXGeXuXuObq1JxgjsK49tu
C0xfV+zow1uEZC6CfPToUhUbAXJsNQ==
=LWUR
-----END PGP SIGNATURE-----

--Sig_/73SMEYNtzZwoB3.O7YpHvQ=--
