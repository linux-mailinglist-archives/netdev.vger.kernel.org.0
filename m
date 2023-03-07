Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B045D6AD397
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 01:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjCGA7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 19:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjCGA7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 19:59:33 -0500
X-Greylist: delayed 392 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 06 Mar 2023 16:59:29 PST
Received: from gimli.rothwell.id.au (unknown [IPv6:2404:9400:2:0:216:3eff:fee1:997a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F04731E1C
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 16:59:29 -0800 (PST)
Received: from authenticated.rothwell.id.au (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.rothwell.id.au (Postfix) with ESMTPSA id 4PVxkY60MSzykW;
        Tue,  7 Mar 2023 11:52:53 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rothwell.id.au;
        s=201702; t=1678150375;
        bh=OTQcyoWW8W+dsJF+tizzSxsNTDpMqcgj3C/Jk1CfLyw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kBv0M9YGt+4BkOhekgqRUvPeP9jfVDVtj2jcj/Xe3rr8uCXkSetjywfAFyeTOPaJ8
         sctjdqoGJrhG+lQR74xx1NMCPpyCgdRsFEjf1SKIGh0vO8c8GJGN9l6UTdJ813TjZw
         rmqzNKb7uoSTu61eqe72w7I9OWjUgKPrw9/OFxY6/UXLiDM6Yfu0rsLYYl5NBk6Ns5
         9zmbEz4caKV/9l3He1o/JjhSNbpwv57SzicIC7+6b4W5j0oJstR51izSbBCDffLESZ
         1T+DxFZt6PYBwxRAayymjsOhPbU8UJmJylQoucrkC03utRQxazKkPGzV9NXd1ACxR+
         tP5w3MXZlqvOg==
Date:   Tue, 7 Mar 2023 11:52:52 +1100
From:   Stephen Rothwell <sfr@rothwell.id.au>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: Signed-off-by missing for commit in the net tree
Message-ID: <20230307115252.2b23c4f5@oak.ozlabs.ibm.com>
In-Reply-To: <d5b3d530-e050-1891-e5c0-8c98e136b744@gmail.com>
References: <20230307083703.558634a9@canb.auug.org.au>
        <d5b3d530-e050-1891-e5c0-8c98e136b744@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/QZfzygOe5M27vvB.wvaVLQK";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/QZfzygOe5M27vvB.wvaVLQK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Heiner,

On Mon, 6 Mar 2023 23:16:09 +0100 Heiner Kallweit <hkallweit1@gmail.com> wr=
ote:
>
> On 06.03.2023 22:37, Stephen Rothwell wrote:
> >=20
> > Commit
> >=20
> >   58aac3a2ef41 ("net: phy: smsc: fix link up detection in forced irq mo=
de")
> >=20
> > is missing a Signed-off-by from its committer.
>=20
> Seems to be ok, false positive?
>=20
> net: phy: smsc: fix link up detection in forced irq mode
> Currently link up can't be detected in forced mode if polling
> isn't used. Only link up interrupt source we have is aneg
> complete which isn't applicable in forced mode. Therefore we
> have to use energy-on as link up indicator.
>=20
> Fixes: 7365494550f6 ("net: phy: smsc: skip ENERGYON interrupt if disabled=
")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>

It was committed by Jakub Kicinski <kuba@kernel.org>

$ git show --pretty=3Draw 58aac3a2ef41
commit 58aac3a2ef414fea6d7fdf823ea177744a087d13
tree 26bf9b3b866bd43baa1b8055d42536ac7ce3b3cf
parent 89b59a84cb166f1ab5b6de9830e61324937c661e
author Heiner Kallweit <hkallweit1@gmail.com> 1677927164 +0100
committer Jakub Kicinski <kuba@kernel.org> 1678137790 -0800

--=20
Cheers,
Stephen Rothwell

--Sig_/QZfzygOe5M27vvB.wvaVLQK
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmQGiuQACgkQAVBC80lX
0GyXywf+N2S0korooYAI10TLOcpdf2nsSWuCLwlezBTU/cqR4cC69Bgzi7i+4vf1
clTfhbWTVBd5aYcIvq4wOWoTuQRoHHcPIVdKPAl+grip7wdPdKHLyngeF7xrTiqJ
DKtDq8cjPMeE6Dhr9bsx9WR18ROAQmRELyU5ZA+hTPKd/KgvXzKrRpFuyz8UBxTc
v1GHZdb5sgTJxISPNWlW3XefsUc4H42ZBHmUy34/fDrW2aTXHGeMmHN8u7R+/L2W
oie70dPm3+KovnnC9lWadkg0/jqH49aW4xDDres3NbRexY+WMT67Dm8gutU78qLm
4D779FSb1NMVRkjhem4H5mAsxPxA2g==
=BX3z
-----END PGP SIGNATURE-----

--Sig_/QZfzygOe5M27vvB.wvaVLQK--
