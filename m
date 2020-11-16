Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB192B4A3E
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 17:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731635AbgKPQDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 11:03:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:48812 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728858AbgKPQDD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 11:03:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DCE1EABF4;
        Mon, 16 Nov 2020 16:03:02 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 9DAC7604F6; Mon, 16 Nov 2020 17:03:02 +0100 (CET)
Date:   Mon, 16 Nov 2020 17:03:02 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Antonio Cardace <acardace@redhat.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v3 2/4] netdevsim: support ethtool ring and
 coalesce settings
Message-ID: <20201116160302.mieama6ylp2srjlj@lion.mk-sys.cz>
References: <20201113231655.139948-1-acardace@redhat.com>
 <20201113231655.139948-2-acardace@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vhamiml5qxa6dik7"
Content-Disposition: inline
In-Reply-To: <20201113231655.139948-2-acardace@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vhamiml5qxa6dik7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 14, 2020 at 12:16:53AM +0100, Antonio Cardace wrote:
> Add ethtool ring and coalesce settings support for testing.
>=20
> Signed-off-by: Antonio Cardace <acardace@redhat.com>

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

--vhamiml5qxa6dik7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl+yorEACgkQ538sG/LR
dpXLGQf9GRZ4XFdlfaMfmnqFaW3zKE5Gu8RmZxMJhwzQOvZ7E71Ayt+16ZuCOYg3
554YNzYhA/j2NpucqqKwg5a+tvO386s1Q656MHt/XXKRl1QTAGckqFekzaGh5shY
Ul1k2KJKbIrjKG0lIbyq1Bs4dmic6ETugKxl38ZpI8H+b3ehExSgLx8D5vEmDfdx
IJJQsOH1bwgMtzr+WPp5ygavtGhGqwDWPuSiBUMIOHjTdWC45J2JCOO99yvEzpya
Ft5BOfkVaI1V+4WgnNX9qdjU3K+SElegSTdJfamKWREOE6d/lNqjb0edDkEg9pG7
pVyYP26PeKa2ObLLpvEJAfohmM1xkA==
=1DcC
-----END PGP SIGNATURE-----

--vhamiml5qxa6dik7--
