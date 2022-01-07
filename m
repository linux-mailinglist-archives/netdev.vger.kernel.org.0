Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51E0487BA0
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 18:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348635AbiAGRs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 12:48:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34492 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348623AbiAGRsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 12:48:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D142CB82691
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 17:48:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9462DC36AE0;
        Fri,  7 Jan 2022 17:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641577703;
        bh=VdPAx9rmW+xrcEpPsYpOlQW9x6kTuv1FwkA/lv8VGzk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bmh2fxy7JS1L1nyl9uI4bhR2QxVsnD3sfZrWv9zoBcdgPfgGq9yD8+NfkBs14AIkp
         OsOKZdtzPxjeVqXM8X75ky2n79toO9LoEQt7tjYQpGojcqu9GNdLdN7OKXmUweDhv8
         vfI395cQLb6pUR0zBSzACxe8Dp8/voNistfTCNxXNWQNO9GdNtcwbGLLnSzyZRKel2
         Lg4YbWVMI1uf/PAFu92VmofaMrI64qNZqs31l52ZkW7pR1+1u12eKvYN5Q2Tj3Sm0a
         jbw3/EZzSodU9HHgv2NtxpAFY6fMCiSNB8RMm0TK6VwZXOrHl80LudKZJjKioyJbNV
         ifYT0a2E5qIkQ==
Date:   Fri, 7 Jan 2022 17:48:19 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next] ptp: don't include ptp_clock_kernel.h in spi.h
Message-ID: <Ydh842WVE/QeNwtg@sirena.org.uk>
References: <20220107155645.806985-1-kuba@kernel.org>
 <Ydhj3QP2VxXIWfZq@sirena.org.uk>
 <20220107085127.6cfaed55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="SLkGUcFtVecwYWpg"
Content-Disposition: inline
In-Reply-To: <20220107085127.6cfaed55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Cookie: teamwork, n.:
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SLkGUcFtVecwYWpg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 07, 2022 at 08:51:27AM -0800, Jakub Kicinski wrote:
> On Fri, 7 Jan 2022 16:01:33 +0000 Mark Brown wrote:

> > Nack, this is a purely SPI patch and should go via SPI (and you've not
> > even bothered to fix the subject line). =20

> Hold off unnecessary comments. If you want me to change something just
> tell me rather than making vague references to following "the style for
> the subsystem".

If you're unclear on feedback please do ask, in this case the issue is
that you've submitted a SPI patch with a subject line starting "ptp: "
instead of "spi: " or some close enough variant of that.  The message
I sent originally is a form letter that I send for any issue with
subjects, it's not a specific thing customised. =20

> > It's already in my queue with that fixed.

> What does it mean that it's in "your queue" is, it does not appear in
> any branch of
> ttps://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git/

I've queued it to be applied but I still need to actually do so and test
it, if it makes it through testing then it'll get merged - there's a
bunch of last minute patches running at the minute.  It's far enough
along that everything applied but tests are still running.

> Will this patch make 5.17?

If there's no problem with testing it should do.  I'm not sure what the
rush is though?  It's just a cleanup and this is the Friday before the
merge window.

--SLkGUcFtVecwYWpg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmHYfOIACgkQJNaLcl1U
h9ALhQf+KksBZzvyECVRRCyzSdQ/d0EDvhrtpHFN+CdUc6ttFWp8kyc+Eg1UtVjM
Bh1D0QW7kZYelKLr41HilqH7E6XsFAHZNoouoC3Sz+m+A3/ivGaJn2LgtkS9kIqx
QOjBSMcny6FfzzZFzd1GComyTmh/NaffFtCqS/U8471aNeR3g+iLu0V4xpbOhrGf
RMMoeNENTYFDlBc5cCaTtkrETGEfmY0ie9YYuRhWmO45eLjHn8PRUtu1WM4R7AL+
XiEC/MNbTbOlfHiYLapsMBUzjdBFHAKz9RiLs+hNs6bxGOh+jeeKXYi0xty8fOKb
irxM8i8YCO6bgaeYnsmDJMis3kQ+OQ==
=011G
-----END PGP SIGNATURE-----

--SLkGUcFtVecwYWpg--
