Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C1C1F6AD5
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 17:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbgFKPVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 11:21:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728365AbgFKPVF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 11:21:05 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DDE22067B;
        Thu, 11 Jun 2020 15:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591888865;
        bh=fU4053E/gEMjOvm/1ax+QwbZU9nEqKq0J4A2Bf6dWHQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N5Tn1ZgbQacjixDiubcV1IE5JEiq9iPEMWmGtJ2uM8xzzrHlI2gqPF2Q5iGG1JqLI
         A52kNMFN/6DvyS/5oAyXPU5yFTgGxFM4wQGGa3Q8/cyJWLM0NjP0KLKhMCXgaEEl3/
         wxbew7LG7ar+YC4EVflLnlWgU9cUn3sgLjAXk7+8=
Date:   Thu, 11 Jun 2020 16:21:03 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-rockchip@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] dt-bindings: Fix more incorrect 'reg' property sizes in
 examples
Message-ID: <20200611152103.GJ4671@sirena.org.uk>
References: <20200611151923.1102796-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pMCBjikF2xGw87uL"
Content-Disposition: inline
In-Reply-To: <20200611151923.1102796-1-robh@kernel.org>
X-Cookie: I like your SNOOPY POSTER!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pMCBjikF2xGw87uL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 11, 2020 at 09:19:23AM -0600, Rob Herring wrote:
> The examples template is a 'simple-bus' with a size of 1 cell for
> had between 2 and 4 cells which really only errors on I2C or SPI type
> devices with a single cell.

Acked-by: Mark Brown <broonie@kernel.org>

--pMCBjikF2xGw87uL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7iS94ACgkQJNaLcl1U
h9ALwgf9FJflzTQOP828gD9dhJPBLf9uqdG6GFRFf/iGqCG+0EHh1MxRNIBXMNFU
pFc2qOrOXnTCvFmSwYib4Ic2S+mc1j9JMhrEjEp6ybbJzWwTmqImDlCydJ81it+0
mJ2ohVbaOo8OsZprM11pEL6wflKweqzJgzQWsg7IgWJUebFsrzEXOKt0nElgxHwM
DxIkj39TRFocuWU1NqkIBefPYWejxr1I8DppfhMBZnAI74UaODz+zAo+EYGPsj+a
OFde9BISP8NNn/skIz7L+4sPP/vkKIw4NoG376dcODKCA88n9Z1clhYE5CkYLhlx
c/Of3H7INUOo4nh6sqkC+DMhtfn58g==
=GWWY
-----END PGP SIGNATURE-----

--pMCBjikF2xGw87uL--
