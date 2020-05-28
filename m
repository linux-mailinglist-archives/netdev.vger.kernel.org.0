Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E737A1E6453
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 16:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728571AbgE1OpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 10:45:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbgE1OpA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 10:45:00 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BEB6207D3;
        Thu, 28 May 2020 14:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590677100;
        bh=X9YK+GDEsdW2T8WyDGxweojlNXR+vB7BnE1HKRUoVxo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l2E2WVrocVGuy1b/MoQhvijltZBfFRIPA1HuIMFqM5dN6XLFuQWc89P9MA+V3Em7x
         9Rgm9qI719tIY6fUpzodZNDu7Nt24Upte5jX83v0rzQGTFaN+0PlHnIxzjfDBJ8YwR
         f5bCGf7jklLlgV/qFq/P4M6JnQzRot0Ta1CnpqS0=
Date:   Thu, 28 May 2020 15:44:56 +0100
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
Subject: Re: [PATCH v2 1/2] regmap: provide helpers for simple bit operations
Message-ID: <20200528144456.GG3606@sirena.org.uk>
References: <20200528142241.20466-1-brgl@bgdev.pl>
 <20200528142241.20466-2-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="RMedoP2+Pr6Rq0N2"
Content-Disposition: inline
In-Reply-To: <20200528142241.20466-2-brgl@bgdev.pl>
X-Cookie: Small is beautiful.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--RMedoP2+Pr6Rq0N2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 28, 2020 at 04:22:40PM +0200, Bartosz Golaszewski wrote:

> +	return (val & bits) == bits ? 1 : 0;

The tenery here is redundant, it's converting a boolean value into a
boolean value.  Otherwise this looks good.

--RMedoP2+Pr6Rq0N2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7PzmcACgkQJNaLcl1U
h9DzXAf9EwegJko8ZtKiJNAmWI/0roZMdNBpTkKJLOfFqs0LbMZdg1Tg3UA+jOe6
AM9PSwU009hn4dmLdAbnqIfXhp1e1zPUb537lozVi/6cAbc6yzwzZBxajJjUxjk9
amrt61H/LZBJyyP1qrY4a/vNtu0R558ozAuMmINAfkEsFdGQq6WZ63N+bcJzPiF4
kxSTX7Mewb0jyB6ZAilOMkuRFNR+bCGjV0MNVd41MUT+zEcgaMP7Dv6eJ/PUBJ2y
klySoD2xOzlpxBUpKblFYuso9Q8iRrGGjr49/rh1rYuKjRz/wt8cbwe4NjrG0N+q
E8vZUZWNgG2ZVnG3DbKIx5QlNJxtDA==
=EkdN
-----END PGP SIGNATURE-----

--RMedoP2+Pr6Rq0N2--
