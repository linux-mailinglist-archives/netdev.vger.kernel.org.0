Return-Path: <netdev+bounces-2434-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C918701EF7
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 20:32:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 092151C2098E
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 18:32:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E830A948;
	Sun, 14 May 2023 18:32:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9381C33
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 18:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C23C433D2;
	Sun, 14 May 2023 18:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684089155;
	bh=7SF2s/sBjm/0i3IHqpFOWVHtaUTAVHvigECCD/BwQZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fBv4gT0G2WLmIM2s3wpKCKMCHzLJSbrIaF0LQmVMkHU9IL4GOHumqYc7Q9/nP9Nc3
	 b02ZzB9lW0oKDDmTObpGCL83CfYVwO66CCohkgiO9ipv+f0d7xm9uJUxkm50H6Uysp
	 nn80PCSpDU0pPCmzEmJywZLkX/xjT7y30Ryuys/KxVeb4I8/aP+gfo9N0zodaf/dMS
	 fh4fbaefm9FDUL2CI/JVlCS2+SbDthyhAwUHiRH6V/R2vXqOaruvYOyK4+rS0wCmnd
	 9j5vA4CXqzAWR1LCHSj8UzlGKhqMDu/CIDJAlhH9JV97t6couYBxfk1EVqOaqh91jz
	 lD8IcJ+zwNP3w==
Date: Sun, 14 May 2023 19:32:30 +0100
From: Conor Dooley <conor@kernel.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, netdev@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] dt-bindings: net: nxp,sja1105: document spi-cpol/cpha
Message-ID: <20230514-turf-phrase-10b6d87ff953@spud>
References: <20230514115741.40423-1-krzysztof.kozlowski@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="mSAgB206fnXq8olk"
Content-Disposition: inline
In-Reply-To: <20230514115741.40423-1-krzysztof.kozlowski@linaro.org>


--mSAgB206fnXq8olk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 14, 2023 at 01:57:41PM +0200, Krzysztof Kozlowski wrote:

> +allOf:
> +  - $ref: dsa.yaml#/$defs/ethernet-ports
> +  - $ref: /schemas/spi/spi-peripheral-props.yaml#
> +  - if:
> +      properties:
> +        compatible:
> +          enum:
> +            - nxp,sja1105e
> +            - nxp,sja1105t

Is there a particular reason you did not put the "t" variant after the
"s" one?

> +            - nxp,sja1105p
> +            - nxp,sja1105q
> +            - nxp,sja1105r
> +            - nxp,sja1105s

Otherwise,
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--mSAgB206fnXq8olk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZGEpPgAKCRB4tDGHoIJi
0ralAQDLtAfoq69IAyctRckQJLLDRDFiNaMMYGsE5X8hCvDWdgEA7KUux1pUvOp7
2A0BVBw6RL9NP4JYF3JnNb5MuGtPZAg=
=VMqL
-----END PGP SIGNATURE-----

--mSAgB206fnXq8olk--

