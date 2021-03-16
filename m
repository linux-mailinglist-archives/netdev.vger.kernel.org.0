Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C27333DF8C
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 21:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbhCPUvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 16:51:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231435AbhCPUu6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 16:50:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13BFE64F39;
        Tue, 16 Mar 2021 20:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615927857;
        bh=wG29cqpTFwh1U5z1wLV7rQaOMjdg76t/emDgukbgGPA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AlNQS3sIaueBa+aw2xmovMe1PfQpQm5qijVCOSGd8xp7M9iazzG1IUStwNGO5HeZC
         Woi/Dph3BYZAmC56XBt3kJr3bwnkvQj2aDY7UFFx2ivsYFJiciyKe45BxGDwaT8ehe
         M0RbWE1Y+H1S9cTONIecNzYWWaFu6v7xEZwQ5IfXL37A72SR2GKjPp8X/L5w1LVpxF
         ZFE26OAbbS/bVvfHkrxmrxSLnzqy6F/HxXLzSm9He8VegAzfrTEaUHv0/VaoXBnSZ1
         sovrSnWFj5M9cWzbaEB1C/kMkolcauJuX24Lxy1SVfPoCHZ39NRwxtVJ25aNatAnbG
         n7tMgcmC+O2Hg==
Date:   Tue, 16 Mar 2021 20:50:54 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Maxime Ripard <mripard@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Cheng-Yi Chiang <cychiang@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefan Wahren <wahrenst@gmx.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Odelu Kukatla <okukatla@codeaurora.org>,
        Alex Elder <elder@kernel.org>, Suman Anna <s-anna@ti.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        linux-gpio@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Drop type references on common properties
Message-ID: <20210316205054.GE4309@sirena.org.uk>
References: <20210316194858.3527845-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hwvH6HDNit2nSK4j"
Content-Disposition: inline
In-Reply-To: <20210316194858.3527845-1-robh@kernel.org>
X-Cookie: Results vary by individual.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hwvH6HDNit2nSK4j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 16, 2021 at 01:48:58PM -0600, Rob Herring wrote:
> Users of common properties shouldn't have a type definition as the
> common schemas already have one. Drop all the unnecessary type
> references in the tree.

Acked-by: Mark Brown <broonie@kernel.org>

--hwvH6HDNit2nSK4j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBRGi0ACgkQJNaLcl1U
h9Bd6wf8CLasn7HPb9h3JBOHpH6rnzMDSD3qxnwn0mb6TNjjFgQqLvwZXfWTvJiz
gkxGMMc+CwnV2uwRzJZLMaI25wo8z//d9xmFX/CVHiti3FZ45EooKQJ41a+CoHl7
l2J+X1NiGe7EoOgJDvfrHK0+1OuZXN3hnBeNrx8gjqOoBtnbQbvsVhcjnUnN+i3s
XMZwu0IJQ4MIFscfo3TlaXHt7MeWB4xg8uS/bU+6/OfuTIQmJ14midFU/YqJ6kSl
QXBZ0oYXIheB+dwso+WQgBRJ3p2r8ob2yZfVwQLkZps30q6VurGqNeDSdRILHbz1
IaOFXt46ttiq2cAG29TuJxNbVa8KzA==
=BRod
-----END PGP SIGNATURE-----

--hwvH6HDNit2nSK4j--
