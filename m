Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79A5C16AB78
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 17:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgBXQaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 11:30:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:53536 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727426AbgBXQaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 11:30:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AB05CACE3;
        Mon, 24 Feb 2020 16:30:07 +0000 (UTC)
Message-ID: <074b4845119e1cdc500290922d4a43e8135acb7e.camel@suse.de>
Subject: Re: [PATCH] net: bcmgenet: Clear ID_MODE_DIS in EXT_RGMII_OOB_CTRL
 when not needed
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Wahren <wahrenst@gmx.net>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 24 Feb 2020 17:30:05 +0100
In-Reply-To: <20200224162804.GB4526@unreal>
References: <20200224153609.24948-1-nsaenzjulienne@suse.de>
         <20200224162804.GB4526@unreal>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-pKqKvFzgfdAwTnH1ApAy"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-pKqKvFzgfdAwTnH1ApAy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2020-02-24 at 18:28 +0200, Leon Romanovsky wrote:
> On Mon, Feb 24, 2020 at 04:36:09PM +0100, Nicolas Saenz Julienne wrote:
> > Outdated Raspberry Pi 4 firmware might configure the external PHY as
> > rgmii although the kernel currently sets it as rgmii-rxid. This makes
> > connections unreliable as ID_MODE_DIS is left enabled. To avoid this,
> > explicitly clear that bit whenever we don't need it.
> >=20
> > Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
> > Fixes: da38802211cc ("net: bcmgenet: Add RGMII_RXID support")
>=20
> The expectation is that Fixes line comes before SOB line.

Ouch, sorry for that.

I'll edit that on v2.

Regards,
Nicolas


--=-pKqKvFzgfdAwTnH1ApAy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEErOkkGDHCg2EbPcGjlfZmHno8x/4FAl5T+g0ACgkQlfZmHno8
x/5AawgAhxQzd1l2sjLbsOEIm4ht9sW2fOkbKnJXED3/nAZzT6C+oEvnqe4cEITd
FxHfxwbZ+jf6GTby+44Wk4xyIPNeew7z0cmgZbsWvag8KXnYgFEbO+fPMbXIglNW
f0ll63GKz0LS1FksO7qV7Wi6Jmj7FMRhrd04LWCJz6q5e8DB/5Ge0POkS5M+lEd9
c5a5mEqVqTfvupwptoXGEEmyuqG1vXvgNLdCyplNMUdzAzQDyb25zz5bn2iGMrtH
E/VuGQ9GrnoS/FJ7/ELMEjOb+YGs9aUJ3OM2lEl/rTiQRMMf8vJYrCLOAtKbHO4X
KNz/45NZ4fP6uI7ko7hA0Q0XuKGVgw==
=Dbex
-----END PGP SIGNATURE-----

--=-pKqKvFzgfdAwTnH1ApAy--

