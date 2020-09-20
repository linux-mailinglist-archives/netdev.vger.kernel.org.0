Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE7912717BE
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 21:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgITT7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 15:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgITT7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 15:59:23 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247A3C061755;
        Sun, 20 Sep 2020 12:59:23 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Bvdgr1vNsz9sSn;
        Mon, 21 Sep 2020 05:59:20 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1600631960;
        bh=K9EwikCZOZe93VOpyvhvMl2J14PPghHc7s8jzz7I4bo=;
        h=Date:From:To:Cc:Subject:From;
        b=NZK+b0Ei2b5/kQwV2qigyePE+9JmHoERxQ7TkdHq33IdiocdUD7Jki0dVsCnrMa9C
         w5tEhjICiCKTw+Qtedx1a6J+yvRW8H3G7B9ZXA3oFknp9V46jK39TynsUxBrFuhC9H
         jQyMr/o9nIZTsLJHtJqxNBgL9R7IcHMZiqeTU8L+gLy5xNqA0R33g1ZTcR2MRoCFIO
         3+xawo7rNevd236sbSH3S0NzDHd3LbxVFO/fc99lXkjJww5NkPMKzfpkCqR50PFy9q
         2ylgReTpeoxqckBYjpDu1J3NEPwDVYDq1/Ac7Bbg6VL4Y4HXETRlp85AGQnK1M1amE
         rMP9EerV5nB1w==
Date:   Mon, 21 Sep 2020 05:59:19 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus =?UTF-8?B?TMO8c3Npbmc=?= <linus.luessing@c0d3.blue>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20200921055919.5bf70643@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/3zBD.H+RxUu5w60cb04Omgo";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/3zBD.H+RxUu5w60cb04Omgo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  2369e8270469 ("batman-adv: mcast: fix duplicate mcast packets from BLA ba=
ckbone to mesh")

Fixes tag

  Fixes: 279e89b2281a ("batman-adv: add broadcast duplicate check")

has these problem(s):

  - Subject does not match target commit subject

Did you mean:

Fixes: 279e89b2281a ("batman-adv: bla: use netif_rx_ni when not in interrup=
t context")

or

Fixes: fe2da6ff27c7 ("batman-adv: add broadcast duplicate check")


In commit

  74c09b727512 ("batman-adv: mcast: fix duplicate mcast packets in BLA back=
bone from mesh")

Fixes tag

  Fixes: fe2da6ff27c7 ("batman-adv: check incoming packet type for bla")

has these problem(s):

  - Subject does not match target commit subject

Did you mean

Fixes: fe2da6ff27c7 ("batman-adv: add broadcast duplicate check")

or

Fixes 2d3f6ccc4ea5 ("batman-adv: check incoming packet type for bla")


In commit

  3236d215ad38 ("batman-adv: mcast: fix duplicate mcast packets in BLA back=
bone from LAN")

Fixes tag

  Fixes: 2d3f6ccc4ea5 ("batman-adv: Modified forwarding behaviour for multi=
cast packets")

has these problem(s):

  - Subject does not match target commit subject

Did you mean

Fixes 2d3f6ccc4ea5 ("batman-adv: check incoming packet type for bla")
(I could find no commit with subject "batman-adv: Modified forwarding
behaviour for multicast packets".)
--=20
Cheers,
Stephen Rothwell

--Sig_/3zBD.H+RxUu5w60cb04Omgo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9ntJcACgkQAVBC80lX
0GzOwwf/dHL8KMvsPVKLBC6BGQmHNRzPzlvbjtewXdD2wtVcM4asRzmziElIZR64
pmLD1+LgtQv+2YNdKA8Do2pinHvaIh1bAbNq7hm9QEN1z5nAOzpHrbJ84USadtoA
zipWk+U0PVFOIZWwYKDujXpNBz6NOK9ugRUpQ+FHYRetJTBK9Dsm4sUhu3lJloPz
PRkzx7p0VhcKC9EPJvjFoRMD7uDLuGxF1HCQGLPkTYQO1gAqMq8C04rETiqa9xk1
ANYTOWETAgoVyD1QI1jjLtVfv4HVeFY6J9I6UbvMRi3B6rEoJmJAP0cqqURVLMgk
1MY/Q73YJv3O7NFp5KXQmipSrrUdcg==
=QBMA
-----END PGP SIGNATURE-----

--Sig_/3zBD.H+RxUu5w60cb04Omgo--
