Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D213898C6
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 23:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhESVr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 17:47:29 -0400
Received: from ozlabs.org ([203.11.71.1]:53409 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229518AbhESVr2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 17:47:28 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Flmdp1zKHz9sV5;
        Thu, 20 May 2021 07:46:05 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1621460766;
        bh=vLXgbsvq1neic6r4wdYfFQqTu3DlG0QmV2Q7vJ9TVD8=;
        h=Date:From:To:Cc:Subject:From;
        b=GqAGgpv7llaZkAVDC/lZyZJaEp4DqhoyjCSVL7XZkkg1E4yARHNI84eCSCn2lrH6P
         ui09O2/lJHuCa1t+BdqQ84WU3Id2dv9ILelvxAjtrXUK1tj1MMc3zY3Id381KSNBQm
         ejaTiCn171e/ApXdwBxcStknUO43W7LqFibsv7NCq2oFatAaGilM07MtVwO0YmIlfX
         RxeTutv2e6e6ZfsB1eel4tWFUBvb/godifgQh1AbNcw5jPatd/LJRxMizsrVaPMS5P
         6Faa5ir2wSQLAQMp8AFh0bOrfOJdCj8PpmRJnEGjzi6bMh4djoOFe4ypAjQOV60z47
         9p3h+QWFnSmFA==
Date:   Thu, 20 May 2021 07:46:03 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the net tree
Message-ID: <20210520074603.410d6bc3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/dB5==j0kkZ4K4Y3=1B/pQNK";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/dB5==j0kkZ4K4Y3=1B/pQNK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  6ff51ab8aa8f ("net/mlx5: Set term table as an unmanaged flow table")

is missing a Signed-off-by from its committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/dB5==j0kkZ4K4Y3=1B/pQNK
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmClhxsACgkQAVBC80lX
0Gy3pQf/Yo7BSBkVQLWcgaqqgv+kAWhM1oQ+ji043I4vF/eEiQ+3dzYnC0pwci09
VM3J5sOKHqvX8lcKOV9dr1Z2cxMN0iFWtLxYizbUYMiweV+N4FD+Nhjxf/TEWvwm
LVOJlszGswSkcJxgWrFa80/3QLS+K9LaSewGn+Z6gTF4mh09XmhuQr7OmclEQ4/b
i839Fcwzt8Hf928ayAzwOkneS1pAEyCFHUHE3SLSPUoUBSMgfSbqcVULTpV6gIqT
n/kPsX5bm6Z+fOkYAoFIgdVSJu1eT679dT+JDXggf7QKwCmsor6jxYmoi7LqzekC
C0YAYfZsUIl1TCP3kjsn2b7WflIEIQ==
=ZqtW
-----END PGP SIGNATURE-----

--Sig_/dB5==j0kkZ4K4Y3=1B/pQNK--
