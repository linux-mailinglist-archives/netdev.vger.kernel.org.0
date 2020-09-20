Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5AE2717A6
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 21:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgITTux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 15:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgITTux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 15:50:53 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E44C061755;
        Sun, 20 Sep 2020 12:50:52 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BvdTy1Mjtz9sPB;
        Mon, 21 Sep 2020 05:50:45 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1600631448;
        bh=HQf/RXqYVq3pbKPnLfIJFUdCN2pwtECNpw8IKj+aNM4=;
        h=Date:From:To:Cc:Subject:From;
        b=Z36mwUw/PzEyUSfNrdZmulVN2Oln6ygSsdjO50FzokceF+Jwc5xdW89vHSrHXoeBh
         KJZ+5fU1rzOiqL7duH3TVBOhgB5lhGoxhJpKl84ciq9w2SjuhG87eUXk3Jqa35B2de
         Wg2PMrC1ROgZro6MQoPPDjMeNj5kGS+Spr+g6CI8nLh4tH323mpnB5dfLsbz0b8zhn
         Ry8j+rE3UY39aLfqAcduRsfLV1bTrFSBs89a7L3LxMoir4GsszUjaCkF+CdgiUUq1i
         zmm7Jfymn423FO86JMPBO+4LA6dgC1wgFcb9ezmWpNub9HwtmZqyZOC8IWSPdQoVRi
         AFRTwJrCXmDBw==
Date:   Mon, 21 Sep 2020 05:50:43 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>,
        Linus =?UTF-8?B?TMO8c3Npbmc=?= <ll@simonwunderlich.de>
Subject: linux-next: Signed-off-by missing for commit in the net tree
Message-ID: <20200921055043.5f52aa79@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Ld4NWdjbI6ioROyc9nXFFOA";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Ld4NWdjbI6ioROyc9nXFFOA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  097930e85f90 ("batman-adv: bla: fix type misuse for backbone_gw hash inde=
xing")

is missing a Signed-off-by from its committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/Ld4NWdjbI6ioROyc9nXFFOA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9nspMACgkQAVBC80lX
0GyiLAf9FuRIeDUoy4XWxMOx5xL5lNWWPLzhUiLF+E7TM9pOFVsulGkCKEIjN2Cf
9mLO207rY0E9QPHPAMNrlh/iQpkelvQh2Zt/EUUiXN75Mrbs7nFfGKraIK6aY0hq
q7sQuWUG3HO8gokTwk/rjIlkaONiJdByEeyh40RCZ2UXYVnc+9Fjt96SUQaiNlG0
TOdUsG/6WFPxZP85He+EKdYT7PSMZWC45bamlkN2yGG1bqEzmWUVZlNkiS5Kn5bC
cn1AdyKeb8w2Rh9yhtLUwfG/k2nvSj2fj9Nohpp27Edbmc73YreytaFm8mcsri9R
d2ZDsE40IrBUO37lrbW/tws04tnGiA==
=MF0y
-----END PGP SIGNATURE-----

--Sig_/Ld4NWdjbI6ioROyc9nXFFOA--
