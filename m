Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3346727B0FF
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 17:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgI1PgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 11:36:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:33368 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgI1PgO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 11:36:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2BEA5AD5F;
        Mon, 28 Sep 2020 15:36:13 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id C0815603A9; Mon, 28 Sep 2020 17:36:12 +0200 (CEST)
Date:   Mon, 28 Sep 2020 17:36:12 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        michael.chan@broadcom.com, edwin.peer@broadcom.com,
        andrew.gospodarek@broadcom.com, andrew@lunn.ch
Subject: Re: [PATCH v3 ethtool] bnxt: Add Broadcom driver support.
Message-ID: <20200928153612.dqpexr2c5drirdxv@lion.mk-sys.cz>
References: <1600769582-26467-1-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hnxvyhixeqjfwgqr"
Content-Disposition: inline
In-Reply-To: <1600769582-26467-1-git-send-email-vasundhara-v.volam@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hnxvyhixeqjfwgqr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 22, 2020 at 03:43:02PM +0530, Vasundhara Volam wrote:
> This patch adds the initial support for parsing registers dumped
> by the Broadcom driver. Currently, PXP and PCIe registers are
> parsed.
>=20
> Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
> Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
> Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> ---

Applied, thank you.

Michal

--hnxvyhixeqjfwgqr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl9yAuYACgkQ538sG/LR
dpVzuQgAnpFWMkbwI8dQmdkk9O1/D+90NZ2/COcHut8as+lmavQB+GK28NaEXTb0
vo5OTeFTeTBCB7ZY/MwjJPIeJDAI+P1Pwy+lrlCSrSPv0z7wxepC+Ke/Z27YX6Ng
s46c4WQ2jW8+jdhF5YD6OsL1eAOulUlDOyWgZeb1ljQb8DZK8452AM5SGRATClZQ
o5kKdCK9bUq06BhYcbRgGJ/hXLjNiz6emR/OiQwRDIX4PfudCek8/KmAi+ktlxOV
8T0w4yqqPWHIy2fke2i5zNYMp81J5XnecJyrcIQHPY5XNY+RZybX1E6QsqHO1Ojl
CarU60yc0PgPjHK+aMRu7RutL4W9bw==
=UiSy
-----END PGP SIGNATURE-----

--hnxvyhixeqjfwgqr--
