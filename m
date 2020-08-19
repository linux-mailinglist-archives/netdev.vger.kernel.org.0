Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F69249228
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 03:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgHSBJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 21:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbgHSBJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 21:09:24 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB53C061389;
        Tue, 18 Aug 2020 18:09:23 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BWV6m2Zsvz9sPC;
        Wed, 19 Aug 2020 11:09:19 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1597799360;
        bh=PZ4f53VeW+am97M+os2kN5bTE89KqaSC9EwrF9k3KBU=;
        h=Date:From:To:Cc:Subject:From;
        b=j95hiToEKFsL0BphmgilDDXrzZyUj/guPGnrsc0NyvYWAekP3Fc/8I9io8yEFko1t
         /ztJl4Viyy8XOITgLCUX7GtcPSXQx4P6KG/Nwwq3T9OFhc1BlKemCfLNrNsW31k5ts
         KSAdWQD4pF2/QM+ALwmNhY61zPpefLtvaHNpvF2wH/lzEnWdoLstlRJzUMI4mDviKB
         mhrOZdojm8/euvz35xXg8QPc3By9SolpC8xBYMfY6MjnE2Zb0b0vqqaWXSjjMqwrqj
         gnALmInD3UB/rNU2MdRmxAE5fkcCRkuUK50NAnU/tvPOmBFvc6kebwrMIPolAC9tD0
         HZWZRtgmzzmIQ==
Date:   Wed, 19 Aug 2020 11:09:18 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: linux-next: manual merge of the net-next tree with the kspp-gustavo
 tree
Message-ID: <20200819110918.43a7397d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/LzT7RpsEKCeHL6WWia16gBO";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/LzT7RpsEKCeHL6WWia16gBO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  lib/nlattr.c

between commit:

  58e813cceabd ("treewide: Use fallthrough pseudo-keyword")

from the kspp-gustavo tree and commit:

  8aa26c575fb3 ("netlink: make NLA_BINARY validation more flexible")

from the net-next tree.

I fixed it up (the latter removed some of the code updated by the former)
and can carry the fix as necessary. This is now fixed as far as linux-next
is concerned, but any non trivial conflicts should be mentioned to your
upstream maintainer when your tree is submitted for merging.  You may
also want to consider cooperating with the maintainer of the conflicting
tree to minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/LzT7RpsEKCeHL6WWia16gBO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl88e74ACgkQAVBC80lX
0GwzEAf/cmJ58ZsosxZvX25OxpXOzuUPtkOtCilLc9vtKYKk0eZpP5F80LPhuTPO
fluq9y4BpfeCMj2D3WnRwE+Fj7e5oG7aOziMU0L1X097eM8gn4afWhoEcr11BwyP
y4G+Q1zOhsyB38K7Oo2RhEByc2p9fDtNk8x+kTKSFSzX4OxFWrcN8bZcVoolCYoW
mSa2Z4mzFKZehDC2hjFa6+OutLuwOMoq0IvJwibpWLXeQzP2lS4waRGxRGFsQD42
VcZFCsPjFdZkqTHXipXI8sF3mtebnzFCAIqqUGBoWwi+E4EdHUTZwAGeH74eyLBi
/iz0GK8gJ4+D8yTyPWRz1rOwOzoMAQ==
=0c+y
-----END PGP SIGNATURE-----

--Sig_/LzT7RpsEKCeHL6WWia16gBO--
