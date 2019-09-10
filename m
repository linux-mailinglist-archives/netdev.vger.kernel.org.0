Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6635BAED72
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 16:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393262AbfIJOmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 10:42:09 -0400
Received: from ozlabs.org ([203.11.71.1]:38637 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393023AbfIJOmG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 10:42:06 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46SSQY2r3lz9s4Y;
        Wed, 11 Sep 2019 00:41:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1568126523;
        bh=OgL1E3Bn836EI/U9TfNLgjcy9EiqKvLZ4vknVwwsPfE=;
        h=Date:From:To:Cc:Subject:From;
        b=QJtFt4FJe9ZV89RhMLsPUEIccr+G9wrvlU5ZTHMDm9G/iJg50qjvIS/SAF+2F8d7G
         qYnIhgShhNf07dQNvuFku8heFGfZ7gh7tZsJxvzMhdtqusRMaulcw8MyOU5KLEjQgb
         0S607N0fz3QwuumuwUl3YfwgVcmtsU8IRXAmTN0oxq2nFBNYCOt2JPf2Ee5RertKLn
         4wI79U0DuEmJzLmAw31DBljOo57JxH0AVgeBdISYMZa2+UPVLNL+Wx0woNzd7yLDVV
         j8g3J73gCLk4NHGCmQDkAbe2NTCW/SGjQzVR8JS3+cbmVqYi0ytTys6vc14Cg5O3q8
         YOU7JR+ReQFMw==
Date:   Wed, 11 Sep 2019 00:41:03 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        The j1939 authors <linux-can@vger.kernel.org>,
        Bastian Stender <bst@pengutronix.de>,
        Elenita Hinds <ecathinds@gmail.com>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        kbuild test robot <lkp@intel.com>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: linux-next: Signed-off-by missing for commit in the net-next tree
Message-ID: <20190911004103.3480fa40@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/9Jn59mgO98rup=kQiyX7Z.U";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/9Jn59mgO98rup=kQiyX7Z.U
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  9d71dd0c7009 ("can: add support of SAE J1939 protocol")

is missing a Signed-off-by from its author.

[Not sure if I should complain about this one ...]

--=20
Cheers,
Stephen Rothwell

--Sig_/9Jn59mgO98rup=kQiyX7Z.U
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl13tf8ACgkQAVBC80lX
0Gz1XQgAghJMDzpTB959LAyRnZ2BTcdjC1I1Ql+yI07GFjjckCpckq6nNv+XJQ8V
8v0zFk21GxHe4iiFr5TENfSfALy1o8hw1lqjfilqQk9q8E6RjkNrVE+j6rnEVG95
iLE41mafTnm/T6b2sUBdLPQ8hkir6ToIcLeEQp8k3naw1cEqa7dG1D07nRiOFDoU
OzQREKHCUpFGmbne150OlvNIBzM5tQmicoRALm6dAwGckksLMeGwtES07coQsSqZ
dMydcYHuHSfMLzrail0URBEN2Llw75EZxKc+Y6XJhNhQLYhuKiERhZ0ZtWykz82i
cvM+OQfoJINzEz+OyEne3/nLz1azEg==
=F1hC
-----END PGP SIGNATURE-----

--Sig_/9Jn59mgO98rup=kQiyX7Z.U--
