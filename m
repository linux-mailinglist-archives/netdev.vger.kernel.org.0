Return-Path: <netdev+bounces-1681-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EC756FECBF
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:26:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F228E1C20EEB
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 07:26:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5BD11B8EF;
	Thu, 11 May 2023 07:26:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2F781F
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:26:13 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0965136;
	Thu, 11 May 2023 00:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1683789942; x=1715325942;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Hj9/Xos0c73jvpI7skfzLdMH/vZFNW5unlnGn+GOZFg=;
  b=o9HoorndjnKoJ2Q4jemC+B8ONzZ6uhmKMd9pobZeaCQn9Ov3+TmYcUG1
   s769KOrURGJVx554nynlZAi8nnMGLb5XqZfuqzaHHa4p3O0fLjfyJgniG
   LqpWzGPMr6H5oXZS6wmJGnJomoyeC0lqp07Xs1kfioXrCNAKN8Qw4a6E5
   UH0WmA8CZdcgw7qiTNv7YVZhEvsueS6OjgNITR5nkW4F4W1W15vSThX+9
   u+4naXdPEcs9wutNKXTuzITszfW9NTuvRB0ivCmtiIJKorsinuIEjx9ml
   SQNPR2IlwUMf6QDAKSan74+Ewyu+9jw8EU+JAu5d5x5CmrfzxEW9sbfyc
   g==;
X-IronPort-AV: E=Sophos;i="5.99,266,1677567600"; 
   d="asc'?scan'208";a="210719448"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 May 2023 00:25:38 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 11 May 2023 00:25:38 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Thu, 11 May 2023 00:25:35 -0700
Date: Thu, 11 May 2023 08:25:15 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Pranavi Somisetty <pranavi.somisetty@amd.com>
CC: <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <richardcochran@gmail.com>, <linux@armlinux.org.uk>,
	<palmer@dabbelt.com>, <git@amd.com>, <michal.simek@amd.com>,
	<harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-riscv@lists.infradead.org>
Subject: Re: [PATCH net-next v2 1/2] dt-bindings: net: cdns,macb: Add
 rx-watermark property
Message-ID: <20230511-canned-gray-005130594368@wendy>
References: <20230511071214.18611-1-pranavi.somisetty@amd.com>
 <20230511071214.18611-2-pranavi.somisetty@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="H+osmLhakqf8SYZU"
Content-Disposition: inline
In-Reply-To: <20230511071214.18611-2-pranavi.somisetty@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--H+osmLhakqf8SYZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 11, 2023 at 01:12:13AM -0600, Pranavi Somisetty wrote:
> watermark value is the minimum amount of packet data
> required to activate the forwarding process. The watermark
> implementation and maximum size is dependent on the device
> where Cadence MACB/GEM is used.
>=20
> Signed-off-by: Pranavi Somisetty <pranavi.somisetty@amd.com>

Please send dt-binding patches to the dt-binding maintainers and list.
get_maintainer.pl should have told you to do so & without having done
so, the bindings will not get tested :/

Thanks,
Conor.

> ---
>  Documentation/devicetree/bindings/net/cdns,macb.yaml | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml b/Docum=
entation/devicetree/bindings/net/cdns,macb.yaml
> index bef5e0f895be..779bc25cf005 100644
> --- a/Documentation/devicetree/bindings/net/cdns,macb.yaml
> +++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
> @@ -109,6 +109,13 @@ properties:
>    power-domains:
>      maxItems: 1
> =20
> +  rx-watermark:
> +    maxItems: 1
> +    $ref: /schemas/types.yaml#/definitions/uint16
> +    description:
> +      Set watermark value for pbuf_rxcutthru reg and enable
> +      rx partial store and forward.
> +
>    '#address-cells':
>      const: 1
> =20
> @@ -166,6 +173,7 @@ examples:
>              compatible =3D "cdns,macb";
>              reg =3D <0xfffc4000 0x4000>;
>              interrupts =3D <21>;
> +            rx-watermark =3D /bits/ 16 <0x44>;
>              phy-mode =3D "rmii";
>              local-mac-address =3D [3a 0e 03 04 05 06];
>              clock-names =3D "pclk", "hclk", "tx_clk";
> --=20
> 2.36.1
>=20

--H+osmLhakqf8SYZU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZFyYUAAKCRB4tDGHoIJi
0jMaAP0Qag2Eb48tWi3gGaw/nHxQP9YRqnaVqNrnLGsYG7A38wEAxpLH3SseU5ek
OeYBBUqOa21Fw8xZH0uSrW8O94TXdAw=
=B22H
-----END PGP SIGNATURE-----

--H+osmLhakqf8SYZU--

