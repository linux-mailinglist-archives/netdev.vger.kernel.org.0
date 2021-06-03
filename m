Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DB439AB8C
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 22:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhFCUKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 16:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229656AbhFCUKf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 16:10:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E68B0611C9;
        Thu,  3 Jun 2021 20:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622750930;
        bh=ohus4AnUUJOspGI/25odIC8ssfkU7zAoWzsK33rRY5c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fy7QLqvlvNvV19XtoYpomwc7SWdbn2/6Af6JfFQKmOnXkyzsT3KXef7oAcH6kPNo0
         GLwyKOBjpJ1Jb/6Ce/Jw/t1ViRXdPeurRK0ej+vZnjZrrkI/yhXlvOyI7M5y/skN4s
         4kgLGyIALAMWRz3YGnCqJ4rjNkQch2CKA3OyyHabrPyrvmSkAP/BC7PhHvypbvZc3i
         RfhMjmxRshaYL8K19qpFBeM32chXXhP3+Asgowcs3N/8n+UG0vjZl+Kkx4M2hH80ER
         c2hMo/d/VQ81ju9K9rwJiuQv/tsKrDF+IeHhwGFd2uKHzn5MTwgt97WTroKvNOtn+U
         Ncnha5C7tJUEA==
Date:   Thu, 3 Jun 2021 22:08:47 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Nishanth Menon <nm@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Roger Quadros <rogerq@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Tero Kristo <kristo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 03/12] dt-bindings: soc: ti: update sci-pm-domain.yaml
 references
Message-ID: <YLk2z0eEjX/kGpYb@kunai>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Nishanth Menon <nm@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Roger Quadros <rogerq@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, Stephen Boyd <sboyd@kernel.org>,
        Tero Kristo <kristo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>, Vinod Koul <vkoul@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>, devicetree@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-can@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
References: <cover.1622648507.git.mchehab+huawei@kernel.org>
 <c03020ff281054c3bd2527c510659e05fec6f181.1622648507.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="eSf5OGSJ/yHsEMv1"
Content-Disposition: inline
In-Reply-To: <c03020ff281054c3bd2527c510659e05fec6f181.1622648507.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--eSf5OGSJ/yHsEMv1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 02, 2021 at 05:43:09PM +0200, Mauro Carvalho Chehab wrote:
> Changeset fda55c7256fe ("dt-bindings: soc: ti: Convert ti,sci-pm-domain t=
o json schema")
> renamed: Documentation/devicetree/bindings/soc/ti/sci-pm-domain.txt
> to: Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml.
>=20
> Update the cross-references accordingly.
>=20
> Fixes: fda55c7256fe ("dt-bindings: soc: ti: Convert ti,sci-pm-domain to j=
son schema")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Acked-by: Wolfram Sang <wsa@kernel.org> # for I2C


--eSf5OGSJ/yHsEMv1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmC5Ns8ACgkQFA3kzBSg
KbYFTRAAqF9TWZ+pTISLuMKGVBuNthxVoeuiLigsWW/9vfC9QmT42WbmWQLx2hLk
hUIQK4Yk55RT94/cD1spz/yq0xYCXbk5J0VK0kVRt7+AcswPQG07pmbdwTpOjby8
Um5IjYunC0vYKPDfdcAW/k7ZO4SREKVCVZUBVzo5lB+eSTlUdkPdxCGS+JtLoszv
dzik1TD9wCS2DfdC0Mur4qvX2mdfZ+EIsh4UToC0FNN/JlowD/yUrKP9YdZco6Tt
rHMyx1u1FxLcdhSjwMxEAS613dDaKAQMjhUQYX0n41ycMBNXqnHtbhcIRNh/9pd5
hXumHx8IyZo/BBKUBEUjBWISpr9P9VJGbuToeDZQudumri3k8nLmGgntfrrnRSup
gmCcuPGibZbLmw6R5POgYHujlJWpW7uVPXUTJkyX1MY91o4826M6XwweA3GCcmQZ
CYy4XfE9EgEGYCCEPPhYw6Pbk4aJ+b2gfTeimssIBO9Ep4RtHEVr4qLR5w5QBkZM
fLVzxA/NJFc+9b4CxkWwte+j9q3Re+JgqtPJrLa21gRMdyg/ReuA6fSAyt6ktNBy
pM+ZxgyAcuL76EoF0qLH78ssshHX7ZRRDLWtpuE+n97YPQA0niwFkPPLwfEeVOYG
oyATxaZ1YV6BwyJYLgeYhu0TuMT/poG+nvaDeyed23Sze4Tgunk=
=k4Kj
-----END PGP SIGNATURE-----

--eSf5OGSJ/yHsEMv1--
