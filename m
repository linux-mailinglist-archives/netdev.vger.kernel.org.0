Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34681B4FD7
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 00:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgDVWGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 18:06:30 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:49263 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbgDVWG3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 18:06:29 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 496vfB4JL4z9sSX;
        Thu, 23 Apr 2020 08:06:26 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1587593187;
        bh=TTMSDBNA5O6jYEnVeviUPfJ9u2dsDfKsDa6deGWFYR0=;
        h=Date:From:To:Cc:Subject:From;
        b=rtbMvXXebPH2tMr/YFqsl7l2zCmNMnInQl7L7KPWJHilOgHNBAcku3CNiKco1OEji
         Nc6PxrdWSTRCRdHtDS86ulEjJ2aR6F9zShHHyqyXy/+fKtdbC9+0yvA/cib5VPU2mB
         43nYCAGFWbdiZpNO+iMSRzXJgmEH4QZPl+JIiPkaLot2ODpzIHS6SIlkyLHgdtmdWw
         wW1Jsbv75QCvsiKJ6gKK57yprBOF7cKOusAGg5GAlOVXIeFjOFkzOWcZaDH3RDwC/U
         N9C7cCG9QzMbJVFACqlyBAXqJglwQw8ryWjCq/Re8kNF+2AQqnVox3bvV+2RxbtAQt
         th/TA1DHuji0w==
Date:   Thu, 23 Apr 2020 08:06:25 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20200423080625.76785b93@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/JoqlmvAVm_f6Uo7Ko+H7kbL";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/JoqlmvAVm_f6Uo7Ko+H7kbL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  63edbcceef61 ("net: phy: microchip_t1: add lan87xx_phy_init to initialize=
 the lan87xx phy.")

Fixes tag

  Fixes: 3e50d2da5850 ("Add driver for Microchip LAN87XX T1 PHYs")

has these problem(s):

  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

--=20
Cheers,
Stephen Rothwell

--Sig_/JoqlmvAVm_f6Uo7Ko+H7kbL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6gv+EACgkQAVBC80lX
0GxWYAgAm6OibxfSfdLHoyAfb1dF9U6I94T/gSoj5e1gqNdau0pdD7JwBK9YOmDg
j2f8H64jhlepjxg+xnx2cDnj0coy2AYbVkQ3kfZWVnZmdNOStT/o8OwcDUrV0MtV
EOoXUgYvKLw92k+Fwls5UcXqFkY8RlKvj+P4odCmqbtPOELxetlMqojHSVqaAq/g
AcCNY1uXiexNRI8iOxM+9Wdp+FAusK4bJzpyyK6m91I2faTsgnJ1qel60S7N2yTS
YPHAaIethx1NHXABe0lUiXU9iW/7lZwKE5ul8D5zxtid2S+UgEFt46PUCA35aMrf
orq9hnVGtcRfAgY1KmzhkzhohP48YA==
=o+g7
-----END PGP SIGNATURE-----

--Sig_/JoqlmvAVm_f6Uo7Ko+H7kbL--
