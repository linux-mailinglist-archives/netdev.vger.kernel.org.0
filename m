Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8A14684BE
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 13:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384917AbhLDMWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 07:22:15 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:59370 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384912AbhLDMWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 07:22:15 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D29791C0BB0; Sat,  4 Dec 2021 13:18:48 +0100 (CET)
Date:   Sat, 4 Dec 2021 13:18:47 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.4 8/9] net: ptp: add a definition for the UDP
 port for IEEE 1588 general messages
Message-ID: <20211204121847.GA15934@duo.ucw.cz>
References: <20211130145402.947049-1-sashal@kernel.org>
 <20211130145402.947049-8-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <20211130145402.947049-8-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit ec15baec3272bbec576f2ce7ce47765a8e9b7b1c ]
>=20
> As opposed to event messages (Sync, PdelayReq etc) which require
> timestamping, general messages (Announce, FollowUp etc) do not.
> In PTP they are part of different streams of data.
>=20
> IEEE 1588-2008 Annex D.2 "UDP port numbers" states that the UDP
> destination port assigned by IANA is 319 for event messages, and 320 for
> general messages. Yet the kernel seems to be missing the definition for
> general messages. This patch adds it.

This does not fix any bug in 4.4, right? We do not need it in stable.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYatcpwAKCRAw5/Bqldv6
8nNqAJ4th/eq5qbrpyI5Vf+tYwt3sW0y7QCgs6P2w9SCJGBpCPa2y5xg/0g2jPM=
=pwrG
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
