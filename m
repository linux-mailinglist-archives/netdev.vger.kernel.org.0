Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3473527B103
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 17:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgI1Phl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 11:37:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:34428 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbgI1Phl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 11:37:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 87A37ADF2;
        Mon, 28 Sep 2020 15:37:40 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 4F954603A9; Mon, 28 Sep 2020 17:37:40 +0200 (CEST)
Date:   Mon, 28 Sep 2020 17:37:40 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 1/2] fix memory leaks in do_sfeatures()
Message-ID: <20200928153740.a7kr6m3r2hrl77qk@lion.mk-sys.cz>
References: <20200925070527.1001190-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="p6ovsykcgs7mamvg"
Content-Disposition: inline
In-Reply-To: <20200925070527.1001190-1-ivecera@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--p6ovsykcgs7mamvg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 25, 2020 at 09:05:26AM +0200, Ivan Vecera wrote:
> Memory blocks referenced by new_state and old_state are never freed.
> For efeatures there is no need to check pointer as free() can be called
> with NULL parameter.
>=20
> Fixes: 6042804cf6ec ("Change -k/-K options to use ETHTOOL_{G,S}FEATURES")
>=20
> Cc: Michal Kubecek <mkubecek@suse.cz>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---

Applied, thank you.

Michal

--p6ovsykcgs7mamvg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl9yAz4ACgkQ538sG/LR
dpXZJggApd31utLt4Bg2acyTB26fV4NnJqVPr9rUe2Lqzys0g3v6Eyz0zboqWkXe
ks4ZEL+lTQaP/0dTDYckU1gyXIKrjAoMi6XNgOKCoix4FBMz1dmSILdD+CismRXh
gX8SCBrSf0bHuZkwU2RZ21a813uxyWvDj5PnpHbZua/Ci9J64XFCZT6eA+Rz3D/I
gQv1ZbzaFHNw1+6XkKRY/LIu06VanndVQGXVzvNx9MNapxjWUt6vap0/0AG+UgY+
lR/oNjK2Wi5TLt8O0WDj+l69+8og7TfpXJiJlH8B/YFufJiYh1sU/FcbGZWGzoQh
C8LaZTnf+XiPVWIBL8y8Q+G7l+DR6A==
=6vjN
-----END PGP SIGNATURE-----

--p6ovsykcgs7mamvg--
