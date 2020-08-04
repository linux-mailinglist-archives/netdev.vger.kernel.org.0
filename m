Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352F423BAE5
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 15:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgHDNMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 09:12:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:38644 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727987AbgHDNMS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 09:12:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D4FDEB1AD;
        Tue,  4 Aug 2020 13:12:32 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id BD8696030D; Tue,  4 Aug 2020 15:12:16 +0200 (CEST)
Date:   Tue, 4 Aug 2020 15:12:16 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Roi Dayan <roid@mellanox.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool] ethtool.spec: Add bash completion script
Message-ID: <20200804131216.gn6qgwvniulsqjzd@lion.mk-sys.cz>
References: <20200803132338.221961-1-roid@mellanox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gd5lkx6ruobpvrvo"
Content-Disposition: inline
In-Reply-To: <20200803132338.221961-1-roid@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gd5lkx6ruobpvrvo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 03, 2020 at 04:23:38PM +0300, Roi Dayan wrote:
> After the additon of the bash completion script, packaging
> using the default spec file fails for installed but not packaged
> error. so package it.
>=20
> Fixes: 9b802643d7bd ("ethtool: Add bash-completion script")
> Signed-off-by: Roi Dayan <roid@mellanox.com>

Applied, thank you. We are using a heavily modified specfile in openSUSE
so I never noticed. Added rpmbuild to my check script now.

Michal

> ---
>  ethtool.spec.in | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/ethtool.spec.in b/ethtool.spec.in
> index 9c01b07abf2b..75f9be6aafa6 100644
> --- a/ethtool.spec.in
> +++ b/ethtool.spec.in
> @@ -34,6 +34,7 @@ make install DESTDIR=3D${RPM_BUILD_ROOT}
>  %defattr(-,root,root)
>  %{_sbindir}/ethtool
>  %{_mandir}/man8/ethtool.8*
> +%{_datadir}/bash-completion/completions/ethtool
>  %doc AUTHORS COPYING NEWS README
> =20
> =20
> --=20
> 2.8.4
>=20

--gd5lkx6ruobpvrvo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl8pXqsACgkQ538sG/LR
dpXw8gf/Xp9yU8pStItzLCwAs9R42r7WS3TQZcU+NyCwDZjPFLoAQyWM0F61HYWf
d1A2IADSFGubQ/GzisU5Vt4VHLzVn8cJdPmQp5b0vRO13ywD2kmUz7kosPIDtByN
78AsB7jhJUUV2ci1yC0euklbE2XNfiGejxV6fiSqeZoae/8jKjti1iWJiodoNNHC
d4K+SPJxeHaZ6JCaVuf6ENNAtxyxqYQB83kUHLErwta/2RIfBhDIp3QsWwHYVFc0
ePuxPm6QFn3jHpKDCmy7o1cv3nHXRJnhCPucJ6qeMzfLw03u3DRdwE71tH1TewjK
kJl1fVFxrrimq0JclWMSMQQXlfjezg==
=PvVV
-----END PGP SIGNATURE-----

--gd5lkx6ruobpvrvo--
