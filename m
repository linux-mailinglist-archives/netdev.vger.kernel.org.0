Return-Path: <netdev+bounces-4872-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4916870EEB2
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 08:56:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03B7D1C20B93
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 06:56:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FDDE5225;
	Wed, 24 May 2023 06:56:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD8C1FD1
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 06:56:53 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C134E62;
	Tue, 23 May 2023 23:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684911412; x=1716447412;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+2R1S8BzLBMD1ztIM0yjR1EZHQXg518QCyvLKtAnHR4=;
  b=OBKcukZF+S+Sto0Iw2uNs/L+M7A9SFDwxh3cPmpExPp98nTbkABAdZwz
   r+tWwGXub2t+Fb7syp0a9iKfGVsHCRitXs7SVbOm4EhAX7Dx8DsKJrnW3
   1gNdY6Pz2Uy4WNmsjQrp0oxWav3ToTgm8ICxIUHKDKQgMtSFprrw/HWNx
   HIhHmXPNsv55i8otYJSz6XMBuX+ZA6Y4vrO4uzf95Y/0YZ073JZ0iDWmf
   SjrYvf4iebngVu9IoQ2ngxuauYycrrwhfNP/XzlBYftd1ndAC1ohxaEna
   BRFNnkTW9sH3hPQh5gQs4SwY1NPHCnK2fvFVfpsTbrciHnelJluJoGQ3z
   g==;
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="asc'?scan'208";a="226743876"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 May 2023 23:56:51 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 23 May 2023 23:56:50 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 23 May 2023 23:56:47 -0700
Date: Wed, 24 May 2023 07:56:25 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Justin Chen <justin.chen@broadcom.com>
CC: Conor Dooley <conor@kernel.org>, <netdev@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<dri-devel@lists.freedesktop.org>, <bcm-kernel-feedback-list@broadcom.com>,
	<justinpopo6@gmail.com>, <f.fainelli@gmail.com>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
	<opendmb@gmail.com>, <andrew@lunn.ch>, <hkallweit1@gmail.com>,
	<linux@armlinux.org.uk>, <richardcochran@gmail.com>,
	<sumit.semwal@linaro.org>, <christian.koenig@amd.com>,
	<simon.horman@corigine.com>, Florian Fainelli <florian.fainelli@broadcom.com>
Subject: Re: [PATCH net-next v4 2/6] dt-bindings: net: Brcm ASP 2.0 Ethernet
 controller
Message-ID: <20230524-resample-dingbat-8a9f09ba76a5@wendy>
References: <1684878827-40672-1-git-send-email-justin.chen@broadcom.com>
 <1684878827-40672-3-git-send-email-justin.chen@broadcom.com>
 <20230523-unfailing-twisting-9cb092b14f6f@spud>
 <CALSSxFYMm5NYw41ERr1Ah-bejDgf9EdJd1dGNL9_sKVVmrpg3g@mail.gmail.com>
 <20230524-scientist-enviable-7bfff99431cc@wendy>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="oixSSIk8//11vX0i"
Content-Disposition: inline
In-Reply-To: <20230524-scientist-enviable-7bfff99431cc@wendy>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--oixSSIk8//11vX0i
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 24, 2023 at 07:51:07AM +0100, Conor Dooley wrote:
> Hey Justin,
> On Tue, May 23, 2023 at 04:27:12PM -0700, Justin Chen wrote:
> > On Tue, May 23, 2023 at 3:55=E2=80=AFPM Conor Dooley <conor@kernel.org>=
 wrote:
> > > On Tue, May 23, 2023 at 02:53:43PM -0700, Justin Chen wrote:
> > >
> > > > +  compatible:
> > > > +    enum:
> > > > +      - brcm,asp-v2.0
> > > > +      - brcm,bcm72165-asp
> > > > +      - brcm,asp-v2.1
> > > > +      - brcm,bcm74165-asp
> > >
> > > > +        compatible =3D "brcm,bcm72165-asp", "brcm,asp-v2.0";
> > >
> > > You can't do this, as Rob's bot has pointed out. Please test the
> > > bindings :( You need one of these type of constructs:
> > >
> > > compatible:
> > >   oneOf:
> > >     - items:
> > >         - const: brcm,bcm72165-asp
> > >         - const: brcm,asp-v2.0
> > >     - items:
> > >         - const: brcm,bcm74165-asp
> > >         - const: brcm,asp-v2.1
> > >
> > > Although, given either you or Florian said there are likely to be
> > > multiple parts, going for an enum, rather than const for the brcm,bcm=
=2E.
> > > entry will prevent some churn. Up to you.
> > >
> > Urg so close. Thought it was a trivial change, so didn't bother
> > retesting the binding. I think I have it right now...
> >=20
> >   compatible:
> >     oneOf:
> >       - items:
> >           - enum:
> >               - brcm,bcm72165-asp
> >               - brcm,bcm74165-asp
> >           - enum:
> >               - brcm,asp-v2.0
> >               - brcm,asp-v2.1
> >=20
> > Something like this look good?
>=20
> I am still caffeine-less, but this implies that both of
> "brcm,bcm72165-asp", "brcm,asp-v2.0"
> _and_
> "brcm,bcm72165-asp", "brcm,asp-v2.1"
> are. I suspect that that is not the case, unless "brcm,asp-v2.0" is a

I a word. s/are/are valid/

> valid fallback for "brcm,asp-v2.1"?
> The oneOf: also becomes redundant since you only have one items:.
>=20
> > Will submit a v5 tomorrow.
>=20
> BTW, when you do, could you use the address listed in MAINTAINERS rather
> than the one you used for this version?
>=20
> Cheers,
> Conor.

--oixSSIk8//11vX0i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZG21GQAKCRB4tDGHoIJi
0sO/AP9cRQ7+VO/SYpcRQ4CrYP3yQKQE6FbJdUJJekywN8ZxsQD/YqL7dDng/AoJ
XO0iNPz9c8Ma+pbj6hsXOiqs/AvLHQI=
=/k6/
-----END PGP SIGNATURE-----

--oixSSIk8//11vX0i--

