Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A5D39691B
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 22:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbhEaUso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 16:48:44 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:53560 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbhEaUsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 16:48:42 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id F3A611C0B76; Mon, 31 May 2021 22:47:00 +0200 (CEST)
Date:   Mon, 31 May 2021 22:47:00 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Kangjie Lu <kjlu@umn.edu>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.4 07/16] ath6kl: return error code in
 ath6kl_wmi_set_roam_lrssi_cmd()
Message-ID: <20210531204700.GA19694@amd>
References: <20210524145130.2499829-1-sashal@kernel.org>
 <20210524145130.2499829-7-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <20210524145130.2499829-7-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Anirudh Rayabharam <mail@anirudhrb.com>
>=20
> [ Upstream commit fc6a6521556c8250e356ddc6a3f2391aa62dc976 ]
>=20
> ath6kl_wmi_cmd_send could fail, so let's return its error code
> upstream.

Something went very wrong here.

Content is okay, but "upstream commit" label is wrong, pointing to
incomplete fix that was reverted (with different content and different
author).

commit fc6a6521556c8250e356ddc6a3f2391aa62dc976
Author: Kangjie Lu <kjlu@umn.edu>
Date:   Wed Dec 26 00:43:28 2018 -0600

    ath6kl: return error code in ath6kl_wmi_set_roam_lrssi_cmd()

    ath6kl_wmi_cmd_send could fail, so let's return its error code
        upstream.

    Signed-off-by: Kangjie Lu <kjlu@umn.edu>
        Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Best regards,
							Pavel
						=09
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmC1S0QACgkQMOfwapXb+vIeoACfSepaPc6dfkU2aKXHkCAHXiqg
bAAAoK/3j/SpCoKfqGlIDdZZmjO8GoW7
=AhPf
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
