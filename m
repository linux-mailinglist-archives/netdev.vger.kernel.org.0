Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44CC2254D6
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 02:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgGTAKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 20:10:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:38096 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726553AbgGTAKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 20:10:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5F651AF5B;
        Mon, 20 Jul 2020 00:10:53 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 046B960743; Mon, 20 Jul 2020 02:10:47 +0200 (CEST)
Date:   Mon, 20 Jul 2020 02:10:46 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andre Guedes <andre.guedes@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH ethtool 0/4] Add support for IGC driver
Message-ID: <20200720001046.g7y3p7wrua5qz6i2@lion.mk-sys.cz>
References: <20200707234800.39119-1-andre.guedes@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ej7tdyo6eki5dxpl"
Content-Disposition: inline
In-Reply-To: <20200707234800.39119-1-andre.guedes@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ej7tdyo6eki5dxpl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 07, 2020 at 04:47:56PM -0700, Andre Guedes wrote:
> Hi all,
>=20
> This patch series adds support for parsing registers dumped by the IGC dr=
iver.
> For now, the following registers are parsed:
>=20
> 	* Receive Address Low (RAL)
> 	* Receive Address High (RAH)
> 	* Receive Control (RCTL)
> 	* VLAN Priority Queue Filter (VLANPQF)
> 	* EType Queue Filter (ETQF)
>=20
> More registers should be parsed as we need/enable them.
>=20
> Cheers,
> Andre

Series merged. But please consider making the output consistent with
other Intel drivers which use lowercase keywords for values (e.g.
"enabled") and "yes"/"no" for bool values (rather than "True" / "False").

Michal

>=20
> Andre Guedes (4):
>   Add IGC driver support
>   igc: Parse RCTL register fields
>   igc: Parse VLANPQF register fields
>   igc: Parse ETQF registers
>=20
>  Makefile.am |   3 +-
>  ethtool.c   |   1 +
>  igc.c       | 283 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  internal.h  |   3 +
>  4 files changed, 289 insertions(+), 1 deletion(-)
>  create mode 100644 igc.c
>=20
> --=20
> 2.26.2
>=20

--ej7tdyo6eki5dxpl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl8U4PsACgkQ538sG/LR
dpXm9QgAq72fYscACYbNgLvt5loeQmo308467Y/f74rgitTYOHpomU6d+mK2ipkt
dO8k6vbPnFJSQET6VhS/HSP/FyYcvvhLe36yoai9CKdPrFxoe5SIDA6N347b5vaD
CHzOr48YgA+Ja63JQ7GtNQ1XouElw0htGLHrqTp6VFTq7vUx5TgcitoOzO9bZN4m
v1TiHVqw/rexWVn8EEWMUpNTviVmAyiAsktume3iW81JncrPiZNgyH//gsFLAd0u
g73Wg3hsP9uhkuXrcXeQWGZp8DZaT47PfYajbtsQYrba43nL3t2Yi5giYAHvZgUC
oWOaGXiNylF3ZsvYDi0rDIUqsXwNBQ==
=tfbV
-----END PGP SIGNATURE-----

--ej7tdyo6eki5dxpl--
