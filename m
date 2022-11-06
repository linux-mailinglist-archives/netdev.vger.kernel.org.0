Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A945661E7BF
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 00:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiKFX51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 18:57:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiKFX50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 18:57:26 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB511B850;
        Sun,  6 Nov 2022 15:57:24 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4N5B9s28bfz4x2c;
        Mon,  7 Nov 2022 10:57:20 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1667779042;
        bh=WKbbjhmoX+PLZSWp9Hz42z8ZXQ+/shw87aV6Bdak6r0=;
        h=Date:From:To:Cc:Subject:From;
        b=L97Xiyi4DK6DrWR11l6SCXngWW9fNb4IBTGBg64UnRvbVTDToj2mS/AGSW1Jq3MWe
         gXw8L3Ea+dtbldHxRlDPT/sKIbAz7Qt6yq37442CCDl5G/WaEmon+rtZdVNnDWgGl0
         MvpzUXDDVm5xp6pZPYEjCdzJpkzNa7DMWeHNuiIYCygD/QIPRWoIF9yPA3Yqkga4fd
         I2GMg4ik/PBgd3Zli9c4dbwCJCaTl0alr2UC2WfH+TDu45m0RK6aWU3Ukx/L8d+ot+
         UJ57Z1Z8stp+1AEtxLfwKoNttp0onNh3BtaKQ2EamUmHE24EGGGbXLJHSukoJBl38P
         Gj1DhD8OCxzTg==
Date:   Mon, 7 Nov 2022 10:57:19 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the tip tree with the bpf tree
Message-ID: <20221107105719.56060308@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/gJYGAaOCvgcCYzE_mMaE4Ro";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/gJYGAaOCvgcCYzE_mMaE4Ro
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in:

  include/linux/bpf.h

between commit:

  18acb7fac22f ("bpf: Revert ("Fix dispatcher patchable function entry to 5=
 bytes nop")")

from the bpf tree and commits:

  bea75b33895f ("x86/Kconfig: Introduce function padding")
  931ab63664f0 ("x86/ibt: Implement FineIBT")

from the tip tree.

I fixed it up (the former removed the lines modified by the latter) and
can carry the fix as necessary. This is now fixed as far as linux-next
is concerned, but any non trivial conflicts should be mentioned to your
upstream maintainer when your tree is submitted for merging.  You may
also want to consider cooperating with the maintainer of the conflicting
tree to minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/gJYGAaOCvgcCYzE_mMaE4Ro
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmNoSd8ACgkQAVBC80lX
0GyAMAf/V33zgHqmbl8MAluSFFtMw8oVynfJE7uit0GOeoMPT3bMLydOMRiTvLbS
JkER/+HO6ioj6Om/7y54QsmcWcplH85EsD3h+v1uKVPDzrfkWSv2OIDkYZxIjjuT
oLwKAX0bj62AgQbRig1z8K0hLt67O0gxeNATVeJZFt6WHfUZKbfkhd4xiEGiP+8I
TlDbQLXP6mgFr31BFD69MMQuZXtJtiEsOBf/kC/1zCjUi7VLOzRbtUA+0tF5gP4K
jVpb2Nc1HM8DYZux/BiDdKbF5JbNqv18JwpDV0kmrbLt6kOMnaCWQjKlJYabfdL2
idgg+/wJAGfe2nQJweDuJS7PKPBCJA==
=ur6H
-----END PGP SIGNATURE-----

--Sig_/gJYGAaOCvgcCYzE_mMaE4Ro--
