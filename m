Return-Path: <netdev+bounces-5391-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2A05711093
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:12:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D9BD28159F
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:12:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AF4419E7F;
	Thu, 25 May 2023 16:12:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C2F19BAF
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 16:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66545C433EF;
	Thu, 25 May 2023 16:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685031123;
	bh=eGwbDp7GXLadDVneGLrHlJAsKXAAFdJ2QiGxjfTabbE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IxidsszBRPguHI81Nrqgyg+PAPcJOt3TiumrloR5YDGscvCz+VunNxEx/Wv6qIgSp
	 rUDCv1bUuOyqUkrFJWBRdjWpSPDaKK0YuAfwFOqDXtspsCTRoznmTrNq2EoHFriG8T
	 TezQJsczQzq9lMXz7t5ulUCJWNCTgOSElTN2RAA4CBfgUuyZ+5KH/sFWMtH+ucPJBB
	 xZ616Zp/Wh0N7ggA0H3+h4fG9C8ZGOBZggavFJVEDVFbiwRWjiaM5fGM2Ge7JAFLr2
	 V9OQSP46Krk/xEqqnri/SCHRmjfJAem2SRcfgu4X5zw1MTGtkQWoBGRIwIHOjceFgs
	 B0//walKKKRiA==
Date: Thu, 25 May 2023 17:11:56 +0100
From: Conor Dooley <conor@kernel.org>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	bcm-kernel-feedback-list@broadcom.com,
	florian.fainelli@broadcom.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
	conor+dt@kernel.org, opendmb@gmail.com, andrew@lunn.ch,
	hkallweit1@gmail.com, linux@armlinux.org.uk,
	richardcochran@gmail.com, sumit.semwal@linaro.org,
	christian.koenig@amd.com, simon.horman@corigine.com
Subject: Re: [PATCH net-next v5 2/6] dt-bindings: net: Brcm ASP 2.0 Ethernet
 controller
Message-ID: <20230525-extent-osmosis-8d99bf7a780b@spud>
References: <1684969313-35503-1-git-send-email-justin.chen@broadcom.com>
 <1684969313-35503-3-git-send-email-justin.chen@broadcom.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="gQWeSQ/Xh494+0MG"
Content-Disposition: inline
In-Reply-To: <1684969313-35503-3-git-send-email-justin.chen@broadcom.com>


--gQWeSQ/Xh494+0MG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 24, 2023 at 04:01:49PM -0700, Justin Chen wrote:
> From: Florian Fainelli <florian.fainelli@broadcom.com>
>=20
> Add a binding document for the Broadcom ASP 2.0 Ethernet
> controller.
>=20
> Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
> Signed-off-by: Justin Chen <justin.chen@broadcom.com>
> ---
> v5
> 	- Fix compatible string yaml format to properly capture what we want
>=20
> v4
>         - Adjust compatible string example to reference SoC and HW ver
>=20
> v3
>         - Minor formatting issues
>         - Change channel prop to brcm,channel for vendor specific format
>         - Removed redundant v2.0 from compat string
>         - Fix ranges field
>=20
> v2
>         - Minor formatting issues
>=20
>  .../devicetree/bindings/net/brcm,asp-v2.0.yaml     | 149 +++++++++++++++=
++++++
>  1 file changed, 149 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/brcm,asp-v2.0.y=
aml
>=20
> diff --git a/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml b/D=
ocumentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
> new file mode 100644
> index 000000000000..c4cd24492bfd
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
> @@ -0,0 +1,149 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/brcm,asp-v2.0.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Broadcom ASP 2.0 Ethernet controller
> +
> +maintainers:
> +  - Justin Chen <justin.chen@broadcom.com>
> +  - Florian Fainelli <florian.fainelli@broadcom.com>
> +
> +description: Broadcom Ethernet controller first introduced with 72165
> +
> +properties:
> +  '#address-cells':
> +    const: 1
> +  '#size-cells':
> +    const: 1
> +
> +  compatible:
> +    oneOf:
> +      - items:
> +          - enum:
> +              - brcm,bcm74165-asp
> +          - const: brcm,asp-v2.1
> +      - items:
> +          - enum:
> +              - brcm,bcm72165-asp
> +          - const: brcm,asp-v2.0

Sorry if I did not notice this before, conventionally compatible goes
first here. IFF there is another version, could you shuffle things
around? Otherwise,
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--gQWeSQ/Xh494+0MG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZG+IzAAKCRB4tDGHoIJi
0t8LAP0XPuVe8Xv0rC6URYPWMiOetvVlRcErsx5TLDNGuD0U8AEA8RUP6BvGw9Pv
QWlVEE3X8asJ36V2w/7bvKuygsBc2wQ=
=IMJt
-----END PGP SIGNATURE-----

--gQWeSQ/Xh494+0MG--

