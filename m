Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2023819CC2C
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 22:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389177AbgDBU70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 16:59:26 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:48407 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730837AbgDBU70 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Apr 2020 16:59:26 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48tb632pHjz9sQt;
        Fri,  3 Apr 2020 07:59:22 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1585861163;
        bh=A+oR9hYrpAXID36arZmYI+S3QzlBOfIt8pl4DJ3lP4U=;
        h=Date:From:To:Cc:Subject:From;
        b=SnFcrmj+5pd5Hyt6BS/oNj+TCs0yxTLASySQvrxSnkVoAFpp6cDsZFStHRchslABa
         POutgJVVkAs0OdDenWV0qV1KfiV3Jkrvn8rwOat0hz0fJuTcfjZ6Nfzvo38CHLom1M
         enAlcAGI228yRzlzibtjVbmtde6f8h1teAs6Ec3pR2zvfqjHoVZnr9Rxq1h0tZ3oNw
         0rfZcYVgpJvHVjHP90MbTjUFGbDVAvqlzaGhohJlbPNH33iY1wM0nrcy7Wc8yhEACF
         40xd9x3iTnmwtAGEVK3FnasJQS0GUm5htIJ1m/okV1GqGY8WMh/AT5zAgj5TzCaXYo
         SbgM1zYc6frzw==
Date:   Fri, 3 Apr 2020 07:59:19 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kbuild test robot <lkp@intel.com>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20200403075919.7b3cf1f5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/QE6o/a/tjzDPwQm.l780GoM";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/QE6o/a/tjzDPwQm.l780GoM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

n commit

  bf88dc327de8 ("net: dsa: dsa_bridge_mtu_normalization() can be static")

Fixes tag

  Fixes: f41071407c85 ("net: dsa: implement auto-normalization of MTU for b=
ridge hardware datapath")

has these problem(s):

  - Target SHA1 does not exist

Maybe you meant

Fixes: bff33f7e2ae2 ("net: dsa: implement auto-normalization of MTU for bri=
dge hardware datapath")

--=20
Cheers,
Stephen Rothwell

--Sig_/QE6o/a/tjzDPwQm.l780GoM
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6GUicACgkQAVBC80lX
0GwsCQf/Q7YOGrhBDlI/W8UNAc1AwmOx/m/7SyCaD6X31sCd3wcRnSyS1cLAJhGa
hZX6IQRSurA+uofJsZHMGpKqsbaHxkLdFbOX1k1JkW5CuOaECJY6eV3KQLsmqjet
ol+aT4JCYzj36qYUB5MA7NZdFR0GLgdgwEVvuY6ILConclGGgyqZyroQcdoSJ9yu
ucWWq7alm1V0YxuJ96MVONdh8mrGYba0xQVACX5qnF1s0oVisPUVxvHGK0A2Yt3/
CzcSpbOXqhZkIeWAirGuqpEkJ+eonVhB1IT4BBmr3O4CDhL6ao5ji3B6TFtSUO3b
3BXkklCMUh87eObTuGoB035+jwx8bA==
=zimE
-----END PGP SIGNATURE-----

--Sig_/QE6o/a/tjzDPwQm.l780GoM--
