Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 564114FF78
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 04:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbfFXCh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 22:37:26 -0400
Received: from ozlabs.org ([203.11.71.1]:60631 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbfFXChZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jun 2019 22:37:25 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45X5cV0C1qz9s5c;
        Mon, 24 Jun 2019 07:47:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1561326442;
        bh=VkBXuv7fVGNt+d2zUDjCDYOwbWse739pBe2u/5BhT/4=;
        h=Date:From:To:Cc:Subject:From;
        b=VkG2AWeCHJlfrD5pp+YEYXrGqA7/v/xmsgATu72h5xaqQdgJ/iUXbBPZd6S1YGfJT
         qRqtd4D0SiIbj4xWVNtv3GLjbpLMXkZmtZ5p/JzOnuvh8pzsDpF2bRO8lWi8vXjHP5
         J6Zqg+ibI4jg/eKcrSTlNYsupL2zY6I5DBoE3irMgX4IAZHcc0zoi86paQPCcrX3Bu
         k1Sw4WSv5ih2H8eSXQvh/lC27+/cMfYoXFx7JLalWp0Axd6eA4ixhPv2Xk6cF9cNcl
         fs/nRMwCfxmuD7jcjzJm+jvOrqmkdEN6t+tJtQFVqZB3G+4k8tXKiQxHh3kO2Md2Sd
         EKOUh9aUUnAjQ==
Date:   Mon, 24 Jun 2019 07:47:16 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roland Hii <roland.king.guan.hii@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20190624074716.44b749d3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Na9+/O=gek0KognWqCqb/n3"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Na9+/O=gek0KognWqCqb/n3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  d0bb82fd6018 ("net: stmmac: set IC bit when transmitting frames with HW t=
imestamp")

Fixes tag

  Fixes: f748be531d70 ("net: stmmac: Rework coalesce timer and fix multi-qu=
eue races")

has these problem(s):

  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

Fixes: f748be531d70 ("stmmac: support new GMAC4")

or did you mean

Fixes: 8fce33317023 ("net: stmmac: Rework coalesce timer and fix multi-queu=
e races")

--=20
Cheers,
Stephen Rothwell

--Sig_/Na9+/O=gek0KognWqCqb/n3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0P82QACgkQAVBC80lX
0GzOpAf9F/VT4UgXO75BenZ0s4eht/5MSb6+HByvDuP5GyXkYOi+yl4lteWBrUFg
tiBQvw3cq/j7aHcPs+x7NHhNHiMuFovU2g11GMGkG11hEAPAJ5CfQLmqJK2NiOwm
Eala+LJs+CjbgBpWVQeqdJQZMQEe438y0LTyJG1YtRzSxP8/pmbOpJSEN7kP4h2X
MPUCGd+dlAfHsilXpcg18Kg4svDD9SWk0y/j5rYS9XLcLGL8sPjsiEUZIxoDaOIU
dukVL/9BtN75lseVL6Y87EMPS4Cuv2ahsEdaTRYpqSGcPkRN7DsNXygLITyno++A
cjs07J5aKrvC8ejQ6GUoEvSnbBw5FA==
=ygt7
-----END PGP SIGNATURE-----

--Sig_/Na9+/O=gek0KognWqCqb/n3--
