Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4931E6D07
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 23:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407466AbgE1VBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 17:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407395AbgE1VA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 17:00:56 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7FAC08C5C6;
        Thu, 28 May 2020 14:00:56 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49Y0Tx4jpCz9sSn;
        Fri, 29 May 2020 07:00:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1590699654;
        bh=wLYHzL/mcZeb8818+XIZiJAx0cHJCqrE8aFQSWPnBgA=;
        h=Date:From:To:Cc:Subject:From;
        b=Yb3ihQC6DmxJ9V/ZY5NfHiOnqZRMowr6290IF6aMk5k0T74nMCVh/HFRod15qKxWw
         5kHbS035yfCXJpqJ5QCKB45uCJgcNRF2XZXRl1ccU9Atql5egWvCzyQ6f3UE3kHvEC
         70C+jrwrq2euyvzV+tHoNDLX8YNGjrhV58XgthienCPEpvpeohTZVEizsawLWKlHGu
         0lg7APeBY3dNf7DEdelBul4DmaFJNHCJnPSTXtcJdyD0MNGGjTjM7NbVV3/Gqlm+RB
         hhwdq8/4jcXLcgw0hF53CZFTZJyEL/yHK5CbD4MrxLbtC+0H16R1MkbbKLOB5uxCXl
         tydt7HhJnqYxQ==
Date:   Fri, 29 May 2020 07:00:52 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: linux-next: Signed-off-by missing for commit in the net-next tree
Message-ID: <20200529070052.2c171fd3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/yV9Kli2BjNSFa9uZ1NGtJGa";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/yV9Kli2BjNSFa9uZ1NGtJGa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  07bab9502641 ("net/mlx5: E-Switch, Refactor eswitch ingress acl codes")

is missing a Signed-off-by from its committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/yV9Kli2BjNSFa9uZ1NGtJGa
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7QJoQACgkQAVBC80lX
0Gzb/wf+IQy0vyjWMHkRQTtl7Yd75nQbRY30Y5Z1fIA5S0t8r2NxXDjkcZzd13Zo
wRLm6Ne7Pby5kuxRyVe9xfXkCzOACloLiAaocPyPKFP2n4O67bAdPZUaBYyDbYhu
FWNqJnhZwNw0YiMxC0czhlxq3iX0ef+8Grl5FDDqU58YOddZKyy6iTVaobBW+b46
JMdWZg9j4asx4d3DNm1OyFma4vw2iKpvwVAiDi/ftHFj7PvaZkrpu3qEKRngiiBc
DU5TD183U4lrYgrGIHwvfhcJB26XKrOU0JT3+idYZvcz434bbzty7svXuobbpBmp
g1lSdcCP2WvojhIvSvcuFCeedk2Zvg==
=fbfH
-----END PGP SIGNATURE-----

--Sig_/yV9Kli2BjNSFa9uZ1NGtJGa--
