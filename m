Return-Path: <netdev+bounces-12135-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 292CE73661B
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:27:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C1D12810EA
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:27:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34CF7A92D;
	Tue, 20 Jun 2023 08:27:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D26AD37
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 08:27:32 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B10CC;
	Tue, 20 Jun 2023 01:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1687249650; x=1718785650;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZvWIZLnGk6a1F90IX6hAyqx9Id0pSBm9JE6pewSSCMo=;
  b=hWosyP0TWAl9EbdDx/f6Hkq77fGs6JiIuFLOuY++L0WvpMxnvZGjquda
   s8PHC+hG06PU4nBWXF0sJaq3CIew3kwiWpeS+NeP4n4JwKRmtB28N67yn
   +MgQ+b2JGOkdrgIV+RLrSA5Cd+6Hjvsem3Xgf+PUALo6330j8gHqnOgV9
   l+QKGM0KXIrB4sZ5nZEclj0acaZC/4jLGD7aLicJV1Zmb3mjmFL+96S0F
   6RPDauHYXRHFftbYKbGDib7b8nZVCGXI6PlwrM/VJaQ1br5mKfQ92LGZg
   NoTCosiARQQfSYEcJ/RKBXAylw31EumWENDPxUfYJqSyxqvCKE6cSVgTF
   A==;
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="asc'?scan'208";a="231073094"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jun 2023 01:27:29 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 20 Jun 2023 01:27:26 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 20 Jun 2023 01:27:23 -0700
Date: Tue, 20 Jun 2023 09:26:57 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Guo Samin <samin.guo@starfivetech.com>
CC: Andrew Lunn <andrew@lunn.ch>, Conor Dooley <conor@kernel.org>,
	<linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<netdev@vger.kernel.org>, Peter Geis <pgwipeout@gmail.com>, Frank
	<Frank.Sae@motor-comm.com>, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>, Krzysztof Kozlowski
	<krzysztof.kozlowski+dt@linaro.org>, Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>, Yanhong Wang
	<yanhong.wang@starfivetech.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: net: motorcomm: Add pad driver
 strength cfg
Message-ID: <20230620-clicker-antivirus-99e24a06954e@wendy>
References: <20230526090502.29835-1-samin.guo@starfivetech.com>
 <20230526090502.29835-2-samin.guo@starfivetech.com>
 <20230526-glutinous-pristine-fed571235b80@spud>
 <1dbf113c-7592-68bd-6aaf-05ff1d8c538c@starfivetech.com>
 <15eb4ffe-ea12-9a2c-ae9d-c34860384b60@starfivetech.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="NvJVgXFV5BWCi8Zi"
Content-Disposition: inline
In-Reply-To: <15eb4ffe-ea12-9a2c-ae9d-c34860384b60@starfivetech.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--NvJVgXFV5BWCi8Zi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey,

On Tue, Jun 20, 2023 at 11:09:52AM +0800, Guo Samin wrote:
> From: Guo Samin <samin.guo@starfivetech.com>
> > From: Conor Dooley <conor@kernel.org>
> >> On Fri, May 26, 2023 at 05:05:01PM +0800, Samin Guo wrote:
> >>> The motorcomm phy (YT8531) supports the ability to adjust the drive
> >>> strength of the rx_clk/rx_data, the value range of pad driver
> >>> strength is 0 to 7.

> >>> +  motorcomm,rx-clk-driver-strength:
> >>> +    description: drive strength of rx_clk pad.
> >>> +    $ref: /schemas/types.yaml#/definitions/uint32
> >>> +    enum: [ 0, 1, 2, 3, 4, 5, 6, 7 ]
> >>
> >> I think you should use minimum & maximum instead of these listed out
> >> enums.

> >  You have also had this comment since v1 & were reminded of it on
> >> v2 by Krzysztof: "What do the numbers mean? What are the units? mA?"

> > The good news is that we just got some data about units from Motorcomm.=
=20
> > Maybe I can post the data show of the unit later after I get the comple=
te data.

> Sorry, haven't updated in a while.

NW chief.

> I just got the detailed data of Driver Strength(DS) from Motorcomm , whic=
h applies to both rx_clk and rx_data.
>=20
> |----------------------|
> |     ds map table     |
> |----------------------|
> | DS(3b) | Current (mA)|
> |--------|-------------|
> |   000  |     1.20    |
> |   001  |     2.10    |
> |   010  |     2.70    |
> |   011  |     2.91    |
> |   100  |     3.11    |
> |   101  |     3.60    |
> |   110  |     3.97    |
> |   111  |     4.35    |
> |--------|-------------|
>=20
> Since these currents are not integer values and have no regularity,
> it is not very good to use in the drive/dts in my opinion.

Who says you have to use mA? What about uA?

> Therefore, I tend to continue to use DS(0-7) in dts/driver, and adding
> a description of the current value corresponding to DS in dt-bindings.=20

I think this goes against not putting register values into the dts &
that the accurate description of the hardware are the currents.

> Like This:
>=20
> +  motorcomm,rx-clk-driver-strength:
> +    description: drive strength of rx_clk pad.

You need "description: |" to preserve the formatting if you add tables,
but I don't think that this is a good idea. Put the values in here that
describe the hardware (IOW the currents) and then you don't need to have
this table.

> +      |----------------------|
> +      | rx_clk ds map table  |
> +      |----------------------|
> +      | DS(3b) | Current (mA)|
> +      |   000  |     1.20    |
> +      |   001  |     2.10    |
> +      |   010  |     2.70    |
> +      |   011  |     2.91    |
> +      |   100  |     3.11    |
> +      |   101  |     3.60    |
> +      |   110  |     3.97    |
> +      |   111  |     4.35    |
> +      |--------|-------------|
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [ 0, 1, 2, 3, 4, 5, 6, 7 ]
> +    default: 3
> +

> Or use minimum & maximum instead of these listed out enums

With the actual current values, enum rather than min + max.

Cheers,
Conor.

--NvJVgXFV5BWCi8Zi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZJFi0QAKCRB4tDGHoIJi
0jkZAQD0AdtEo8r1ss1UMAX71qHvpw4XtFiP6Xp6aLVVVsyKfwEAzivJCNzTBl+1
IBDsXO2BNofaxXz2KLZ8JtK/8Lp0vww=
=+VHM
-----END PGP SIGNATURE-----

--NvJVgXFV5BWCi8Zi--

