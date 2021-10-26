Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2BF743AEEC
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234710AbhJZJXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbhJZJXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 05:23:08 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230A3C061745;
        Tue, 26 Oct 2021 02:20:45 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HdmWr1XHDz4xZ0;
        Tue, 26 Oct 2021 20:20:39 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1635240042;
        bh=m1Rb45uoxjErkJwXWtmqdgMe+iimlHg0wtGe3WiYk1c=;
        h=Date:From:To:Cc:Subject:From;
        b=fGPE/Y6o4s79/77fvkOlUfY25WgD2qGeN14ZriZcJpVTEuP/2cZQ/9osx+NUXfSMA
         YvrzTeccjk2vdjMIAvzgbOqfvo7S7YA+52TsygUzpTum94lKLZdtqSQZp5mIA/8Nzf
         dG3o8yiEczt5rG6HtGX4rl5sQDDAfO4ASVV5i0xopFTzurbiEJENnR9kSmk/pVT16p
         13iU4pBpjSnp/ULgnC0IFSFnbdKhuzI+W1spemez78pm9BOCkcZmtZ049lvhbv5maD
         RnW4fxb5oXbXGEH6ViV7tV0NsKlIu/b64ajCtzzKMxJrrTI/TwGxCKqqTdT/BgTgxB
         aFYM7L/vyGu8A==
Date:   Tue, 26 Oct 2021 20:20:36 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Luo Jie <luoj@codeaurora.org>, Andrew Lunn <andrew@lunn.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20211026202036.1b8f5c31@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/QUqSzUnd/dg5WRO02XIRbtF";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/QUqSzUnd/dg5WRO02XIRbtF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced this warning:

drivers/net/phy/phy-c45.c:624: warning: Function parameter or member 'enabl=
e' not described in 'genphy_c45_fast_retrain'

Introduced by commit

  63c67f526db8 ("net: phy: add genphy_c45_fast_retrain")

--=20
Cheers,
Stephen Rothwell

--Sig_/QUqSzUnd/dg5WRO02XIRbtF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmF3yGQACgkQAVBC80lX
0GyAFwgAjhZGGVMQs7w88t3HNqeHLtHNZOx3PSZg3eRF8GJu5Y4SjGuPex4UBPx4
/OjVg2bf0IG8mGS5iqbC0yQ5gPNL36Fe3WXHVrmbDtF5j6L3fxeshbskl2P/NzDC
qtrHaNJzRzLcD8a4vcvPHhzrzzMowaRAGUPUS7SjiUIAmxmt51TSerjG8x8NVzPt
POcjgLew8cVaxhexR3En8ZA1PtxLB1UpBj277UK7tqFiQ1zgWs5EjdRPf7f7/HZo
1szss/d74yh4yGF6VYoq9nN28qyW5e1Lp6lJTMXr0DguFUmHmk1T2P9CWyw3XZiP
yX79pTE9f7RgoaY2q7mQ9PflYkhZmA==
=vs3I
-----END PGP SIGNATURE-----

--Sig_/QUqSzUnd/dg5WRO02XIRbtF--
