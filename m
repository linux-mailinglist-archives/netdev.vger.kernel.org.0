Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82A0DF44D1
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 11:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731817AbfKHKmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 05:42:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:33176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731704AbfKHKmf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 05:42:35 -0500
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AD162178F;
        Fri,  8 Nov 2019 10:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573209754;
        bh=Tpjnf2GWTDvkR6aqCvBySs7nsoGgpKOv1/rmGC0yfaI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UptJ0S7oZTBv0d9I0RlV9aZeyCEKwOa/K/FY8IxrQu6u+AVWXByUglJFW4o/QdfZa
         nW5/cdTO9pZ4iLMlmWCLSXMP+RO3IwZk7aqhE2wUAuJMM8ixJcBNDnHM3eT4Ds9mTo
         Ah6/7qFO+bNIBK/SZ6Nrb03LlxJVz0bZ7J/OREu8=
Date:   Fri, 8 Nov 2019 11:42:31 +0100
From:   Maxime Ripard <mripard@kernel.org>
To:     Christophe Roullier <christophe.roullier@st.com>
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        martin.blumenstingl@googlemail.com, alexandru.ardelean@analog.com,
        narmstrong@baylibre.com, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH  1/2] dt-bindings: net: dwmac: increase 'maxItems' for
 'clocks', 'clock-names' properties
Message-ID: <20191108104231.GE4345@gilmour.lan>
References: <20191108103526.22254-1-christophe.roullier@st.com>
 <20191108103526.22254-2-christophe.roullier@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SWTRyWv/ijrBap1m"
Content-Disposition: inline
In-Reply-To: <20191108103526.22254-2-christophe.roullier@st.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SWTRyWv/ijrBap1m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Fri, Nov 08, 2019 at 11:35:25AM +0100, Christophe Roullier wrote:
> This change is needed for some soc based on snps,dwmac, which have
> more than 3 clocks.
>
> Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index 4845e29411e4..376a531062c2 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -27,6 +27,7 @@ select:
>            - snps,dwmac-3.710
>            - snps,dwmac-4.00
>            - snps,dwmac-4.10a
> +          - snps,dwmac-4.20a
>            - snps,dwxgmac
>            - snps,dwxgmac-2.10
>
> @@ -62,6 +63,7 @@ properties:
>          - snps,dwmac-3.710
>          - snps,dwmac-4.00
>          - snps,dwmac-4.10a
> +        - snps,dwmac-4.20a
>          - snps,dwxgmac
>          - snps,dwxgmac-2.10
>
> @@ -87,7 +89,8 @@ properties:
>
>    clocks:
>      minItems: 1
> -    maxItems: 3
> +    maxItems: 5
> +    additionalItems: true

Those additional clocks should be documented

Maxime
--SWTRyWv/ijrBap1m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXcVGlwAKCRDj7w1vZxhR
xbqKAQDvkfzfxpAJ6TR82T/DMy/J2ehuCMos4R9wkjU53VpciQEAmWKEhrULTnu0
xg9rU8jTzA5wsosJo34XQ8gcdH7JPgA=
=vzrR
-----END PGP SIGNATURE-----

--SWTRyWv/ijrBap1m--
