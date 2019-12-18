Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 346F51256C7
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 23:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfLRWca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 17:32:30 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:55527 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbfLRWca (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 17:32:30 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47dVBL3pzLz9sNH;
        Thu, 19 Dec 2019 09:32:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1576708347;
        bh=FGnzLAbggJk4K5oNheKXf8Yw8oOCRUFvVWzB4jYqwSA=;
        h=Date:From:To:Cc:Subject:From;
        b=Vu3EZ3xEAuvetUK+DhSdcIH5ocx2WuktadrhCIQfGi8lQFvJrf5AO5jnUVsW8vBfz
         /Zeu9dRQG0+lhbsEEyfu0Wn4J6C+3XSVatKmmxClt/rXwOz1V87MtG5pVxwBPbyNY0
         dpA1f8Y+gIZyfVnOl26hZZ3W2L/XXQtHOQMafEFsSGkK4MeMMp43+6N3vtpkeCq8vh
         PJyJU2iwZdLhWwYFTs5nrCdQN+mVChQVuHv4EO4nIW5wkYE+hrOj+XbhkbpjeUTXlc
         FYKCm0wCA38y+NgdDghBNNDrh0OMLuiVA87gQRiqls57FQlM8BX3Ppnj0y+ntQCqVX
         Hyk3KkU841Tpg==
Date:   Thu, 19 Dec 2019 09:32:18 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20191219093218.1c1d06f2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/L03AUYJ7v_h6KH65+iT+3ss";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/L03AUYJ7v_h6KH65+iT+3ss
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

arm-linux-gnueabi-ld: drivers/net/ethernet/stmicro/stmmac/stmmac_tc.o: in f=
unction `tc_setup_taprio':
stmmac_tc.c:(.text+0x4e8): undefined reference to `__aeabi_uldivmod'
arm-linux-gnueabi-ld: stmmac_tc.c:(.text+0x508): undefined reference to `__=
aeabi_uldivmod'

Caused by commit

  b60189e0392f ("net: stmmac: Integrate EST with TAPRIO scheduler API")

I have used the net-nest tree from next-20191218 for today.
--=20
Cheers,
Stephen Rothwell

--Sig_/L03AUYJ7v_h6KH65+iT+3ss
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl36qPIACgkQAVBC80lX
0GzURAf/fpRbnxSSolJBIez5KLl5OecRQH9u8F+k3NfRupCbU16/BlgyfQU3cWJI
m6lcN+XHqjqOgCKpEEqeL+FBl60aaZerlDXl8bHFfnRMm5mv5QjXjscHUioKuAu3
V7ZCaboZoPMqgSvMT3nCJUpatHE6mXEyA6rJ5T3ekpL2XQoM7gA1jQ3L1mbjX5mv
6gI2VSyWrktWvMHpVNxIVNSVEZuEwqsz9stZanRG/QKyQQAUM2H4ZaOkhFNy09gp
dFdPAB4C6KNjnFnj5S+Cx5rLDqMrjBW/9m1SH28QiN3xVFKQK97IrU5PF+sP3U6t
AAUTbZZ7ssGz2xMGnSVN7W4wug1j/w==
=Wfjr
-----END PGP SIGNATURE-----

--Sig_/L03AUYJ7v_h6KH65+iT+3ss--
