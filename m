Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5462C22E1F5
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 20:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgGZSZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 14:25:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgGZSY7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jul 2020 14:24:59 -0400
Received: from localhost (p5486c93f.dip0.t-ipconnect.de [84.134.201.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A35892065F;
        Sun, 26 Jul 2020 18:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595787899;
        bh=X0SsSOPPqzDtDa3Lf0g5uMtwodCKBTDzAaWYJ2uyP8A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=reBlES1WaGLzbye+naXlGRq1uc2tWBe1Fwz0X4EXX7pTlwpzlDmbcy2ZTA7wYaGnG
         CwIGIz1pof9w0QC9+SFkADwZaj3E5b5eQZauZ2DMDtMJMK1J7Ej2vY/7nbR22I4GD+
         tTRWy15wVrnB1nVzKV8btwPjClhNsuZVSovAOLhU=
Date:   Sun, 26 Jul 2020 20:24:53 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] iwlwifi: yoyo: don't print failure if debug firmware
 is missing
Message-ID: <20200726182453.GA1996@kunai>
References: <20200625165210.14904-1-wsa@kernel.org>
 <20200726152642.GA913@ninjato>
 <87y2n6404y.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <87y2n6404y.fsf@codeaurora.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 26, 2020 at 09:11:25PM +0300, Kalle Valo wrote:
> Wolfram Sang <wsa@kernel.org> writes:
>=20
> > On Thu, Jun 25, 2020 at 06:52:10PM +0200, Wolfram Sang wrote:
> >> Missing this firmware is not fatal, my wifi card still works. Even mor=
e,
> >> I couldn't find any documentation what it is or where to get it. So, I
> >> don't think the users should be notified if it is missing. If you brow=
se
> >> the net, you see the message is present is in quite some logs. Better
> >> remove it.
> >>=20
> >> Signed-off-by: Wolfram Sang <wsa@kernel.org>
> >> ---
> >
> > Any input on this? Or people I should add to CC?
>=20
> This was discussed on another thread:
>=20
> https://lkml.kernel.org/r/87mu3magfp.fsf@tynnyri.adurom.net
>=20
> Unless Intel folks object I'm planning to take this to
> wireless-drivers-next.

Cool, thanks for the heads up!


--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl8dynEACgkQFA3kzBSg
KbbLOA//cLtqhtfmDrzHrVvUxjU5Qa1RytBPogje3wfKQ0xIJ0UnI7IXDP04Lj7h
PhkvasA/m1WlvYy2/xnsuK/ThR1I9eCdoDOkv1oUnO9fQpJ7JvHxGSdRXSPzrCbQ
2UFwRleBH0uDm0aPn25HmI/O88CWaZiEEPugqCf6uGcUkfY66Z34u4045EJzOU3q
pkOHD51oHfuQAx+D4MUmUG8lxd5EK69lxHgr4aFMHbM0Kp3bcLR6zDNT0h1aS3U8
afRiOnPm3Vo11VZDadWu7NIsKoiWHpxKd7toNuvPZvpMkTETC6fmfHEP9mQYd7sA
aG8af/SD1rQGkgx81N/tjnwtVD8KEZ7dmz/nNsCyiJgpHUfoB1NamCWTNsMDBXGr
jKCB3kmf8IT3A/gn00+QpQ8G5XciGISHHZ/z2u8WHQzdPU2JYTdpETr91buFGXFz
qw4G7s/Wlb0LFS8vJTjN5CSJGNoMylV9ISVnluX/IISECAyeaWds3nd301wC9nwH
RZ1QENemFBFWuT7XI6+pKEPq1cwgdIJRGb/fHy3hvr+8ETkEPFQp4Yba7ydpiQgv
0KgKk2j5bLKCEMXCamoSViwVNv+zXyLzeEDBUDj733Soc1IeW/7LNlDJ97tt1S7W
6KdO4s1UEEXSdunmEOyAIbifTkDB52WVlAwKsTHZkhdcLwCKXJs=
=4VPO
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
