Return-Path: <netdev+bounces-7725-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D0ADE721318
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 23:16:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1ACAD281927
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 21:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C88F101D3;
	Sat,  3 Jun 2023 21:16:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3FAC2E9
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 21:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9503C433EF;
	Sat,  3 Jun 2023 21:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685826963;
	bh=LJM8vKQSQ2RdRTp9RFziQNMxva4VRFMhJsh8lrUlmRk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EO0knllIEbHgMKF9bb/HSLeEyrNl2gcHYO2cqrr9UA3PsTXJnenHYAu7K+VbJFIwD
	 /RZU4zUCB9del9munixsYO0lqFugBAPh8B/HVIOstiqgvxT2MxYCkWZued6iiRDo5T
	 TicTu0H+y5VyOZ1R2mFWS4yPBozVSEnS0swMQDPRRxmiEPpsDoPVbY8Gsv6TKNwi2F
	 g5xp88gpKILBB5VyNZNZlSKa0G/txR0MYTC17ZrrCMRN7CyXARTMkqG227wm3T0GoO
	 XJI42e1GoB3IlVA+Kk+Sl34DruJbEIG6YAw6Id3Cbzqo1okisfHBVXK2bw3wO+vMey
	 cdrkXhcxZPQOA==
Date: Sat, 3 Jun 2023 22:15:54 +0100
From: Conor Dooley <conor@kernel.org>
To: Varshini Rajendran <varshini.rajendran@microchip.com>
Cc: tglx@linutronix.de, maz@kernel.org, robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
	claudiu.beznea@microchip.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	gregkh@linuxfoundation.org, linux@armlinux.org.uk,
	mturquette@baylibre.com, sboyd@kernel.org, sre@kernel.org,
	broonie@kernel.org, arnd@arndb.de, gregory.clement@bootlin.com,
	sudeep.holla@arm.com, balamanikandan.gunasundar@microchip.com,
	mihai.sain@microchip.com, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	netdev@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-pm@vger.kernel.org,
	Hari.PrasathGE@microchip.com, cristian.birsan@microchip.com,
	durai.manickamkr@microchip.com, manikandan.m@microchip.com,
	dharma.b@microchip.com, nayabbasha.sayed@microchip.com,
	balakrishnan.s@microchip.com
Subject: Re: [PATCH 03/21] dt-bindings: usb: generic-ehci: Document
 clock-names property
Message-ID: <20230603-skincare-ideology-bfbc3fd384c5@spud>
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-4-varshini.rajendran@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="nAMUQ1Zej8t05qRN"
Content-Disposition: inline
In-Reply-To: <20230603200243.243878-4-varshini.rajendran@microchip.com>


--nAMUQ1Zej8t05qRN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Varshini,

On Sun, Jun 04, 2023 at 01:32:25AM +0530, Varshini Rajendran wrote:
> Document the property clock-names in the schema.
>=20
> It fixes the dtbs_warning,

s/dtbs_warning/dtbs_check warning/?

> 'clock-names' does not match any of the regexes: 'pinctrl-[0-9]+'

Does this fix a warning currently in the tree, or fix a warning
introduced by some patches in this series? (Or both?)

Cheers,
Conor.

>=20
> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
> ---
>  Documentation/devicetree/bindings/usb/generic-ehci.yaml | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/usb/generic-ehci.yaml b/Do=
cumentation/devicetree/bindings/usb/generic-ehci.yaml
> index 7e486cc6cfb8..542ac26960fc 100644
> --- a/Documentation/devicetree/bindings/usb/generic-ehci.yaml
> +++ b/Documentation/devicetree/bindings/usb/generic-ehci.yaml
> @@ -102,6 +102,10 @@ properties:
>          - if a USB DRD channel: first clock should be host and second
>            one should be peripheral
> =20
> +  clock-names:
> +    minItems: 1
> +    maxItems: 4
> +
>    power-domains:
>      maxItems: 1
> =20
> --=20
> 2.25.1
>

--nAMUQ1Zej8t05qRN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZHutdAAKCRB4tDGHoIJi
0qo0AP492GWxNAZm5/JMwehSB/wjebZYTgg7CggXNDp4e+9ZmAEAqBHDVLVYKYXY
7h8c0U3NLQA8eGWDBjGhhXJ+h5Ab0gc=
=sdYv
-----END PGP SIGNATURE-----

--nAMUQ1Zej8t05qRN--

