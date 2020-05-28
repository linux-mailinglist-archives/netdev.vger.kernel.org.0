Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F24A1E6576
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 17:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403991AbgE1PFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 11:05:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403787AbgE1PFy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 11:05:54 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1F9C2075F;
        Thu, 28 May 2020 15:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590678353;
        bh=+kL9LhCOGvjtZP4YPcHbUGU+IyjWZiXkw5UtPvN8QX4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=02+DmjcYGsOPMYRrYToS00mFAOc3pQ4g19iM0Fy59nj933Nkv7+e5rx7sIb0VHqu9
         8O43OO/vO5hIdQFf8GKi98VPOXae2ph3gzrRD6ys5uWZHSb08fWbJnzp8qeg+Vnx1z
         0/J8Q79nSxN+47MxvnioDrdV3jHWdViSDcngxlSk=
Date:   Thu, 28 May 2020 16:05:50 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        arm-soc <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>
Subject: Re: [PATCH v2 1/2] regmap: provide helpers for simple bit operations
Message-ID: <20200528150550.GH3606@sirena.org.uk>
References: <20200528142241.20466-1-brgl@bgdev.pl>
 <20200528142241.20466-2-brgl@bgdev.pl>
 <20200528144456.GG3606@sirena.org.uk>
 <CAMpxmJVB_L+otX2u80qwGjw4TXCJtwOXe=t11O4Daq3miMVk6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zq44+AAfm4giZpo5"
Content-Disposition: inline
In-Reply-To: <CAMpxmJVB_L+otX2u80qwGjw4TXCJtwOXe=t11O4Daq3miMVk6Q@mail.gmail.com>
X-Cookie: Small is beautiful.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zq44+AAfm4giZpo5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 28, 2020 at 04:49:06PM +0200, Bartosz Golaszewski wrote:
> czw., 28 maj 2020 o 16:45 Mark Brown <broonie@kernel.org> napisa=C5=82(a):

> > The tenery here is redundant, it's converting a boolean value into a
> > boolean value.  Otherwise this looks good.

> Do you mind if I respin it right away? I don't want to spam the list.

Sure, go ahead.

--zq44+AAfm4giZpo5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEyBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7P000ACgkQJNaLcl1U
h9AAggf4sQcyJHFUloflyzh/lLpY4EwFcuWbYHkDTzIGPDOo0qxyNCuTANexUK9i
0rryGP7sH+5PPNWfafBj96tM6tU6efhmBlMm/rz/LC0aFvi4zSf1tDZ58UeDUJ8j
CgEl1VwNyYXPOZ5Pyn1LyRddEBtBuohoC9+3ioc5bZKUT69FPscRSRDsqQ92fe2C
ryplo9IicX5u3ztzQKa00PhLqvPMMiJD+Q1D4siBOXy4M2GDESYc0WSJSPrkizCH
u9DaLdXZFPRpVpyKumF1eu60mtaZhS758X9gO3GHe+Vd+bng0C5ShbJ2w3rWcvsf
AFB+my302HXqBrtpIsfJs877uHpg
=efX/
-----END PGP SIGNATURE-----

--zq44+AAfm4giZpo5--
