Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB099C73D
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 04:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729124AbfHZC1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 22:27:31 -0400
Received: from ozlabs.org ([203.11.71.1]:50045 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726248AbfHZC1a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Aug 2019 22:27:30 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46Gwrc1BGSz9s7T;
        Mon, 26 Aug 2019 12:27:27 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1566786448;
        bh=SkcK4GaxXaBhZShtVlHm+JpP+EHocs5ZVQOQqSb5eOo=;
        h=Date:From:To:Cc:Subject:From;
        b=Y3lG0eRUwbu/PKZwFHp1QKR2L/U1g+DBRaS4NnWpCGUgE2aDKJ8FXzy/DvHuoNU78
         w1gdwqzp8NRH2j4py30OCc6oKld08v9YchbxEl5iyiyO2jfv60TV77jhb00sDgSToD
         rTBC7yR6/asE36SHFDCYrpRsPsstzuCO/XQsA3FJGtOulr7+5phSK8EHL7Ic4wFhNd
         qlxDUOhWW38NGnMy+5dJfJBQq8ejkEg8rCPMIJHZl+lHECwK6YgC4jUA7MQz0t5kWE
         feYROcmF0VCcfNM4kGncMZ4apAE7wsFllFsfLGIrwvTnK85dPCUHTWosMjU6PutkPI
         0wX6qd7WOq2eg==
Date:   Mon, 26 Aug 2019 12:27:26 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20190826122726.145f538d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/KMHEud9KGq+l6RTA0YD1dE0";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/KMHEud9KGq+l6RTA0YD1dE0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/realtek/r8169_main.c

between commit:

  345b93265b3a ("Revert "r8169: remove not needed call to dma_sync_single_f=
or_device"")

from the net tree and commit:

  fcd4e60885af ("r8169: improve rtl_rx")
  d4ed7463d02a ("r8169: fix DMA issue on MIPS platform")

from the net-next tree.

I fixed it up (the latter seems to do the same as the net tree patch) and
can carry the fix as necessary. This is now fixed as far as linux-next
is concerned, but any non trivial conflicts should be mentioned to your
upstream maintainer when your tree is submitted for merging.  You may
also want to consider cooperating with the maintainer of the conflicting
tree to minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/KMHEud9KGq+l6RTA0YD1dE0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1jQ44ACgkQAVBC80lX
0Gy4QggAouAksoVmIVQKwYaVlaR1tpnVdLzoTIDHtr81rrgP7FsdFUnz4BB2g8Sa
50Wkp92CN8CGbg5pRb4d6eFN9DTQ3dEi13pQXDYIyWAZVUM2ibiGmDmqggcVhQ1G
l+Q1Z39U/GNTF/spuuquCx/y3k5G7CsnYr8YbRt00Flzus9QaNj4f2p1eFfd0wkd
miqpPih6QUIprrW0+xXR/UhVUPZ78a01BfVk3PVwDLhlI/utdTZv9vYSw4TD065u
YonV9nxKQQi5lvuqVoNyioRdLuL3BohqwfFxaXZZ16Gmuh4xlAZQGB21oSJPFMrL
sZjJbQWcyfbdSMCs04mhtIo0PAafeg==
=MxTe
-----END PGP SIGNATURE-----

--Sig_/KMHEud9KGq+l6RTA0YD1dE0--
