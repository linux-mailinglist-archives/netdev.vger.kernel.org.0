Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A24F1EA43B
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 14:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgFAMu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 08:50:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgFAMuz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 08:50:55 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74AF520679;
        Mon,  1 Jun 2020 12:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591015855;
        bh=ZFR/1nKVvVuJNSvEtcPQ3+cbnQ1/sjfMOci6Hl3Vomw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B4HUeLw6T1dEx7cjm5s1OOZffbuSU+n6q80OA8IBpCQDiK9tJKDe6hFANLeSlnDQJ
         tF3q/4XO043Y78Wkj9AZoZEX5oMwI+voaTEw56yCkSKz4YwT/ZjJ39hVs90R6vrJSV
         oucpWFT0f4c4ZPSSRNvdowsFTsEgNKhzQ2f3yVxw=
Date:   Mon, 1 Jun 2020 13:50:52 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Subject: Re: [PATCH v3 net-next 01/13] regmap: add helper for per-port
 regfield initialization
Message-ID: <20200601125052.GD45647@sirena.org.uk>
References: <20200531122640.1375715-1-olteanv@gmail.com>
 <20200531122640.1375715-2-olteanv@gmail.com>
 <20200601105430.GB5234@sirena.org.uk>
 <CA+h21hqp92JBchpesxT8spZs7P7nmW_Vf0tev_Li4hjWw2_vUw@mail.gmail.com>
 <20200601115131.GA3720@piout.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="LTeJQqWS0MN7I/qa"
Content-Disposition: inline
In-Reply-To: <20200601115131.GA3720@piout.net>
X-Cookie: Help a swallow land at Capistrano.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--LTeJQqWS0MN7I/qa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 01, 2020 at 01:51:31PM +0200, Alexandre Belloni wrote:
> On 01/06/2020 14:12:38+0300, Vladimir Oltean wrote:

> > In my mind I am not exactly sure what the pull request does to improve
> > the work flow. My simplified idea was that you would send a pull
> > request upstream, then David would send a pull request upstream (or
> > the other way around), and poof, this common commit would disappear
> > from one of the pull requests.

> No, this would make you commit appear twice in the history with
> different hashes. If you want to have what you suggest, Dave needs to
> first take Mark's PR so both PR will have the same commit hash.

Right, in general you shouldn't resend patches which have already been
applied especially not to other maintainers.  It causes confusion like
we saw earlier with Dave applying the patch again (fortunately it seems
that he reverted it).  As well as the duplicated commits this is often a
source of merge confilicts if any changes are made on top of the patch. =20

I've now sent my pull request for this cycle so it should appear in
v5.8-rc1 but in case Dave is still applying stuff even after the merge
window opened:

The following changes since commit 8f3d9f354286745c751374f5f1fcafee6b3f3136:

  Linux 5.7-rc1 (2020-04-12 12:35:55 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/r=
egmap-per-port-field

for you to fetch changes up to 8baebfc2aca26e3fa67ab28343671b82be42b22c:

  regmap: add helper for per-port regfield initialization (2020-05-29 13:44=
:30 +0100)

----------------------------------------------------------------
regmap: Add per-port field initialization helpers

----------------------------------------------------------------
Vladimir Oltean (1):
      regmap: add helper for per-port regfield initialization

 include/linux/regmap.h | 8 ++++++++
 1 file changed, 8 insertions(+)

--LTeJQqWS0MN7I/qa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7U+awACgkQJNaLcl1U
h9Aqewf+KfQEFefZOnzCPzQpRswBYwn7Px1y8QWQWE7TelWGZPFgOH5erYvJlmlj
OQqURbHcIj8JvsCNkFHmJrSUprmGG3FgKIuvR1/WZjbuzhWQh2zs4MR7ZgR9UGF2
zgkd8izUQvqB1sms8LtqSOnfy3fH714A3/atRiove8Na3sTskN8qfK/6+YPM+AVS
sWrgwARgMSM04SP55X5TKHPpf2B4AfUjY1vBQgz6I2JFk95+o44INbJJrIh0rStV
WhbqncZDbJPK9OoggXr1Nr7AkqCEByn3cwuR6xOJDyJ6FzofRlli/km21bCE/Q6D
IO2OloqsgZcp/xN8LK7vYPN2EVExNA==
=Ebcz
-----END PGP SIGNATURE-----

--LTeJQqWS0MN7I/qa--
