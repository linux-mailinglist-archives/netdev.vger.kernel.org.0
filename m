Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58DDD41590D
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 09:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239620AbhIWHfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 03:35:21 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:34214 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbhIWHfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 03:35:20 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C07511C0B76; Thu, 23 Sep 2021 09:33:47 +0200 (CEST)
Date:   Thu, 23 Sep 2021 09:33:47 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>, drt@linux.ibm.com,
        mpe@ellerman.id.au, kuba@kernel.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH AUTOSEL 5.10 01/26] ibmvnic: check failover_pending in
 login response
Message-ID: <20210923073347.GA2056@amd>
References: <20210923033839.1421034-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <20210923033839.1421034-1-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Something went wrong with this series. I only see first 7 patches. I
thought it might be local problem, but I only see 7 patches on lore...

https://lore.kernel.org/lkml/20210923033839.1421034-1-sashal@kernel.org/

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmFMLdsACgkQMOfwapXb+vIztACfabE4FauOyH3Yr2+Y08OExQCK
aM0AoJJSuzwuAh4dFup0H3fXpIyX3kWD
=r9X5
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
