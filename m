Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548031E6245
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 15:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390268AbgE1N3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 09:29:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390425AbgE1N3m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 09:29:42 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 657F5207D3;
        Thu, 28 May 2020 13:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590672582;
        bh=VbVffYZ9WuhrTKtlvAZN7dWKp6BJwRmGIOc4s2SHMVM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e2a6o2ZN6Np0K45Iawn8mRD4HE3IlheKZ8Q+L5IcK88V9cyt75e174rdcp9rbMcHk
         IDPXs4jfsoyWbNc+vbUrg2haSKzUHFxhsmQxCXYKbzQ9h6rew50Mfz86o7l0jflU8r
         G/iHlnSeeX/Yc4LJmCTwxHThDoxF24h3fHuoptts=
Date:   Thu, 28 May 2020 14:29:38 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH 1/2] regmap: provide helpers for simple bit operations
Message-ID: <20200528132938.GC3606@sirena.org.uk>
References: <20200528123459.21168-1-brgl@bgdev.pl>
 <20200528123459.21168-2-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="/e2eDi0V/xtL+Mc8"
Content-Disposition: inline
In-Reply-To: <20200528123459.21168-2-brgl@bgdev.pl>
X-Cookie: Small is beautiful.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--/e2eDi0V/xtL+Mc8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 28, 2020 at 02:34:58PM +0200, Bartosz Golaszewski wrote:

> This adds three new macros for simple bit operations: set_bits,
> clear_bits and test_bits.

Why macros and not static inlines?

--/e2eDi0V/xtL+Mc8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7PvMEACgkQJNaLcl1U
h9BJSwf/dYRTjyQ2Yy7iTcNYVOuamZoSQgG3ZL6ANS748UWNttQaOUnNCc46dxSw
MowHobHyRDcWopIfxiDE/ZiBeNAZD971eifLIHjTnHtUdrsZWXrsfGg/BSUGJYTA
pRhv0h3uHXvIBlGhOXCGcuNDUV+bAhHv0xWr00E0bKIjoHff9Rnw9PaEOI24sSzy
x5NVhciZzUFnROu1RHResg2qzDYcROM5lNBaOnz3tD4+0E2YtF0dgoQYnf0WjWV3
R02uaFjFRsfdbr+NmpoKgVKbzZa+Z9/0eY3BYBiBk9MdfkJaex52O55AiGHy6V8v
W4E4Q9Nh0PrJJ+AZwItYtnNqeaWSQA==
=dUDC
-----END PGP SIGNATURE-----

--/e2eDi0V/xtL+Mc8--
