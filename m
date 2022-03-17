Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 134CF4DC4C3
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 12:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbiCQLYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 07:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbiCQLYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 07:24:37 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FA4C4C;
        Thu, 17 Mar 2022 04:23:20 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 52C181C0B7F; Thu, 17 Mar 2022 12:23:19 +0100 (CET)
Date:   Thu, 17 Mar 2022 12:23:18 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>, Greg KH <greg@kroah.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S . Miller" <davem@davemloft.net>, rmody@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 19/20] bnx2: Fix an error message
Message-ID: <20220317112318.GC2237@amd>
References: <20220309162158.136467-1-sashal@kernel.org>
 <20220309162158.136467-19-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yLVHuoLXiP9kZBkt"
Content-Disposition: inline
In-Reply-To: <20220309162158.136467-19-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yLVHuoLXiP9kZBkt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>=20
> [ Upstream commit 8ccffe9ac3239e549beaa0a9d5e1a1eac94e866c ]
>=20
> Fix an error message and report the correct failing function.

This patch is not really fixing an important bug, it is just tweaking
an error message. I'm not sure why it is being queued for stable. I
believe AUTOSEL process should be more careful.

Second, at least for 5.10 and older, it is not _fixing_ bug, it is
_adding_ one, as old message is correct there.

Please drop.
								Pavel

> +++ b/drivers/net/ethernet/broadcom/bnx2.c
> @@ -8229,7 +8229,7 @@ bnx2_init_board(struct pci_dev *pdev, struct net_de=
vice *dev)
>  		rc =3D pci_set_consistent_dma_mask(pdev, persist_dma_mask);
>  		if (rc) {
>  			dev_err(&pdev->dev,
> -				"pci_set_consistent_dma_mask failed, aborting\n");
> +				"dma_set_coherent_mask failed, aborting\n");
>  			goto err_out_unmap;
>  		}
>  	} else if ((rc =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) !=3D 0) {

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--yLVHuoLXiP9kZBkt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmIzGiYACgkQMOfwapXb+vJ9KgCfX+8azpfDvw3Ye4Rar3Ct71xa
dVYAnjGPKbzHUhc5mhEqe8AzClP0mHOr
=W1eJ
-----END PGP SIGNATURE-----

--yLVHuoLXiP9kZBkt--
