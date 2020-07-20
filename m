Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D49D227060
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 23:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgGTVbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 17:31:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:41752 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726730AbgGTVbe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 17:31:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 455A8B6D0;
        Mon, 20 Jul 2020 21:31:40 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id A0E986032A; Mon, 20 Jul 2020 23:31:33 +0200 (CEST)
Date:   Mon, 20 Jul 2020 23:31:33 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Chris Healy <cphealy@gmail.com>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v2] ethtool: dsa: mv88e6xxx: add pretty dump for 88E6352
 SERDES
Message-ID: <20200720213133.rlofhrmieedyzhj6@lion.mk-sys.cz>
References: <20200720185002.158693-1-cphealy@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7chpxhtbgjvbvoxg"
Content-Disposition: inline
In-Reply-To: <20200720185002.158693-1-cphealy@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7chpxhtbgjvbvoxg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 20, 2020 at 11:50:02AM -0700, Chris Healy wrote:
> From: Andrew Lunn <andrew@lunn.ch>
>=20
> In addition to the port registers, the device can provide the
> SERDES/PCS registers. Dump these, and for a few of the important
> SGMII/1000Base-X registers decode the bits.
>=20
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Chris Healy <cphealy@gmail.com>
> ---
> v2:
> - Add SERDES_OFFSET define
> - Improve readability of if statement
> - Fix inconsistency in dump handler code

Applied, thank you.

Michal

--7chpxhtbgjvbvoxg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl8WDTAACgkQ538sG/LR
dpXpOggAhTpO1DCvrTOSO4AxtwmolNJwPO2WusmzfqoImSsyFeMrTOrRgO1Zjzrs
Ntd+TWjNX10sGTcC8uqQPfNjOSWwGyBOuDsL6n4aWDmbi8KooK79Q52zeevqqW1e
H+3aoDSwj1aBbXMZv2HIp2XZ5bVyRijoMnoosaPpjv8F7pAvAgvClPo8ULPz02xN
2JIK+IoUe2m6xuL4VABVoqrk+RJ4u4lVQdL9qjH2/NlPeLEpO4QVxuV+mAwReeLw
CD2dY6cP26xVGjKX2oeS3iI/iuuUqoSMzj/FfrZlvXTP0i+CHTqPfeD/6unhK1bw
Tu3MKEVxK3XGOQaSJGXJsVJ4z8F45Q==
=uHrp
-----END PGP SIGNATURE-----

--7chpxhtbgjvbvoxg--
