Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C722B40757B
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 09:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbhIKHpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 03:45:01 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:40212 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbhIKHpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Sep 2021 03:45:00 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id BEB611C0B7A; Sat, 11 Sep 2021 09:43:36 +0200 (CEST)
Date:   Sat, 11 Sep 2021 09:43:35 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Pavel Machek <pavel@denx.de>, Aya Levin <ayal@nvidia.com>
Subject: Re: [net 4/7] net/mlx5: FWTrace, cancel work on alloc pd error flow
Message-ID: <20210911074335.GA27612@amd>
References: <20210907212420.28529-1-saeed@kernel.org>
 <20210907212420.28529-5-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <20210907212420.28529-5-saeed@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2021-09-07 14:24:17, Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
>=20
> Handle error flow on mlx5_core_alloc_pd() failure,
> read_fw_strings_work must be canceled.
>=20
> Fixes: c71ad41ccb0c ("net/mlx5: FW tracer, events handling")

Reviewed-by: Pavel Machek (CIP) <pavel@denx.de>

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmE8XicACgkQMOfwapXb+vJ67gCeMQC0K/Xplu9yYC6HdydFPF/N
dVUAn0vsbGRkNH5In0Ke99DAzKyVC8j3
=6xzz
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
