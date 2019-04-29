Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63CB3DA5C
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 03:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfD2ByO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Apr 2019 21:54:14 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:56107 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726681AbfD2ByO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Apr 2019 21:54:14 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44snl64JK2z9s55;
        Mon, 29 Apr 2019 11:54:10 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1556502851;
        bh=KN9J/W1T49rNawww/E2wIO3cDvFrVEihi+tUSgg7w3E=;
        h=Date:From:To:Cc:Subject:From;
        b=p/LRXjusuLEMvXEF+p48ei8s6Guxm10JgujSjp6jaM5wAHFXI73FoEGYfRreUWqzj
         VA3RMA6vxYUmIl5izcsVesHOiYs0hYYazDTTZRojgHk/6LA+eeFejxcd/zpiP0FU/d
         3fMFQ1LmfldrH9DKzsLdfnLIrR9oyWdtwzQjZk9LIH2gpT5FOhHlSBA0gRON5vq72a
         VhYqZmbCvK58KqSvkzZxRNsPyCSQoGyLf8MLv76eC1K+bOA/fgOTL+R+4awBuEVkWX
         1NcUnhjyWt6TYlEE+AtGGO8kSA9+WXrLgVJn2HiJomxQ7nzXyHgSc3fOu2DNcgjFE+
         NP4UC9wstr8WA==
Date:   Mon, 29 Apr 2019 11:54:02 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: linux-next: manual merge of the net-next tree with the
 wireless-drivers tree
Message-ID: <20190429115338.5decb50b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ouD1/C1Rf=a4YufAYVULo5g"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ouD1/C1Rf=a4YufAYVULo5g
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c

between commits:

  154d4899e411 ("iwlwifi: mvm: properly check debugfs dentry before using i=
t")
  d156e67d3f58 ("iwlwifi: mvm: fix merge damage in iwl_mvm_vif_dbgfs_regist=
er()")

from the wireless-drivers tree and commit:

  c9af7528c331 ("iwlwifi: mvm: no need to check return value of debugfs_cre=
ate functions")

from the net-next tree.

I fixed it up (the latter removed the code modified by the former, so I
just did that) and can carry the fix as necessary. This is now fixed as
far as linux-next is concerned, but any non trivial conflicts should be
mentioned to your upstream maintainer when your tree is submitted for
merging.  You may also want to consider cooperating with the maintainer
of the conflicting tree to minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/ouD1/C1Rf=a4YufAYVULo5g
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlzGWToACgkQAVBC80lX
0GyjqQf/WmQNjeOP1on2Gd80/wu5PBCMWR0vBySe2WZ8v1efY6dyhDSLHm1bLzu1
3ZYqkjy9od5BqotAHadOWbwNwv2SsYpYvWKuwYP82Fh509SWEwapxFk/hlv7b6MO
OXqPJxLVEQ9lBv9ErhkaEV50AkxApAkidiU5vZMbVLcA23dFjMGtpHOUEsEtR9Qc
xdEK1VHH14ZZAdRt06D3XK0lJwuh/JoMNlZXwmG3syMBwoggULzvqHvdL4KzpOz4
rDlbyPaOUXipocKkNaShf6EeKVPoOn7w0N8rsj2xGA1chlHQYNh53A1fg7adUIvp
bWD+K14cDKZGv5rPnaP63DGE8HrNlg==
=HV9G
-----END PGP SIGNATURE-----

--Sig_/ouD1/C1Rf=a4YufAYVULo5g--
