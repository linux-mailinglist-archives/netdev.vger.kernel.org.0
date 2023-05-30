Return-Path: <netdev+bounces-6259-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F21F671569C
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:23:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99CF7280FEA
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ECFD111AB;
	Tue, 30 May 2023 07:23:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A23E9462
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:23:32 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27CE11C;
	Tue, 30 May 2023 00:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685431394; x=1716967394;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9WO6HuOPojrINY54Yg7NU+f2Z8AWxDcsvAJUoewCYH4=;
  b=g6/VkusCgk1Y27QWZj9IT595R6Csn88E9rq2q01ddKIZelyUy4o8vktx
   mfUY6YhJ1mHqwTzTMrR/AKxVA2BrMJF5Mllcg2irImetMwe9DaKpuQrLB
   McPPcDR6+9Mjjea3alx/J50SaCaKJAf5bG6+gjaEUzx1G6FBINjLvFHh7
   yRojgC0Vwu8gFmr8p+KlvYjE3lDzfT4g9bh6akj20bIn0oMuEvdYf/Ja3
   h8ihzW9xGzu41UASQJNou6/EvXCRpwgoo6WpwS+Sjxdg5hCNxe2mmCwMc
   MbfrNshZg6QPTG3QJfhnRJ+Lpr65kcWZVoFIqYG2v+9HaBtP6eQ4iC8MI
   g==;
X-IronPort-AV: E=Sophos;i="6.00,203,1681196400"; 
   d="asc'?scan'208";a="154546859"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 May 2023 00:22:52 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 30 May 2023 00:22:50 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 30 May 2023 00:22:48 -0700
Date: Tue, 30 May 2023 08:22:25 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
CC: Conor Dooley <conor@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
	"s.shtylyov@omp.ru" <s.shtylyov@omp.ru>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"robh+dt@kernel.org" <robh+dt@kernel.org>,
	"krzysztof.kozlowski+dt@linaro.org" <krzysztof.kozlowski+dt@linaro.org>,
	"conor+dt@kernel.org" <conor+dt@kernel.org>, "geert+renesas@glider.be"
	<geert+renesas@glider.be>, "magnus.damm@gmail.com" <magnus.damm@gmail.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-renesas-soc@vger.kernel.org" <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH net-next 1/5] dt-bindings: net: r8a779f0-ether-switch:
 Add ACLK
Message-ID: <20230530-nineteen-entryway-cab54d3e3624@wendy>
References: <20230529080840.1156458-1-yoshihiro.shimoda.uh@renesas.com>
 <20230529080840.1156458-2-yoshihiro.shimoda.uh@renesas.com>
 <20230529-cassette-carnivore-4109a31ccd11@spud>
 <15fece9d-a716-44d6-bd88-876979acedf1@lunn.ch>
 <20230529-ambiance-profile-d45c01caacc3@spud>
 <TYBPR01MB53413C7E1E5AE74ABE84ABE8D84B9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="NNnrGIyMcXO0vPhL"
Content-Disposition: inline
In-Reply-To: <TYBPR01MB53413C7E1E5AE74ABE84ABE8D84B9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--NNnrGIyMcXO0vPhL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey,

On Tue, May 30, 2023 at 12:19:46AM +0000, Yoshihiro Shimoda wrote:
> > From: Conor Dooley, Sent: Tuesday, May 30, 2023 5:44 AM
> > On Mon, May 29, 2023 at 10:11:12PM +0200, Andrew Lunn wrote:
> > > On Mon, May 29, 2023 at 07:36:03PM +0100, Conor Dooley wrote:
> > > > On Mon, May 29, 2023 at 05:08:36PM +0900, Yoshihiro Shimoda wrote:
> > > > > Add ACLK of GWCA which needs to calculate registers' values for
> > > > > rate limiter feature.
> > > > >
> > > > > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.co=
m>
> > > > > ---
> > > > >  .../bindings/net/renesas,r8a779f0-ether-switch.yaml    | 10 ++++=
++++--
> > > > >  1 file changed, 8 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/Documentation/devicetree/bindings/net/renesas,r8a779=
f0-ether-switch.yaml
> > b/Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch.y=
aml
> > > > > index e933a1e48d67..cbe05fdcadaf 100644
> > > > > --- a/Documentation/devicetree/bindings/net/renesas,r8a779f0-ethe=
r-switch.yaml
> > > > > +++ b/Documentation/devicetree/bindings/net/renesas,r8a779f0-ethe=
r-switch.yaml
> > > > > @@ -75,7 +75,12 @@ properties:
> > > > >        - const: rmac2_phy
> > > > >
> > > > >    clocks:
> > > > > -    maxItems: 1
> > > > > +    maxItems: 2
> > > > > +
> > > > > +  clock-names:
> > > > > +    items:
> > > > > +      - const: fck
> > > > > +      - const: aclk
> > > >
> > > > Since having both clocks is now required, please add some detail in=
 the
> > > > commit message about why that is the case. Reading it sounds like t=
his
> > > > is an optional new feature & not something that is required.
> > >
> > > This is something i wondered about, backwards compatibility with old
> > > DT blobs. In the C code it is optional, and has a default clock rate
> > > if the clock is not present.
>=20
> I'm sorry for lacking explanation. You're correct. this is backwards
> compatibility with old DT blobs.
>=20
> > Yeah, I did the cursory check of the code to make sure that an old dtb
> > would still function, which is part of why I am asking for the
> > explanation of the enforcement here. I'm not clear on what the
> > consequences of getting the default rate is. Perhaps if I read the whole
> > series and understood the code I would be, but this commit should
> > explain the why anyway & save me the trouble ;)
>=20
> The following clock rates are the same (400MHz):
>  - default rate (RSWITCH_ACLK_DEFAULT) in the C code
>  - R8A779F0_CLK_S0D2_HSC from dtb
>=20
> Only for backwards compatibility with old DT blobs, I added
> the RSWITCH_ACLK_DEFAULT, and got the aclk as optional.
>=20
> By the way, R8A779F0_CLK_S0D2_HSC is fixed rate, and the r8a779f0-ether-s=
witch
> only uses the rswitch driver. Therefore, the clock rate is always 400MHz.
> So, I'm thinking that the following implementation is enough.
>  - no dt-bindings change. (In other words, don't add aclk in the dt-bindi=
ngs.)
>  - hardcoded the clock rate in the C code as 400MHz.
>=20
> > > So the yaml should not enforce an aclk member.
> >=20
> > This however I could go either way on. If the thing isn't going to
> > function properly with the fallback rate, but would just limp on on
> > in whatever broken way it has always done, I would agree with making
> > the second clock required so that no new devicetrees are written in a
> > way that would put the hardware into that broken state.
> > On the other hand, if it works perfectly fine for some use cases without
> > the second clock & just using the default rathe then I don't think the
> > presence of the second clock should be enforced.
>=20
> Thank you very much for your comments! The it works perfectly fine for
> all use cases without the second clock & just using the default rate.
> That's why I'm now thinking that adding aclk into the dt-bindings is not
> a good way...

I am biased, but I think the binding should describe the hardware &
therefore the additional clock should be added.

Cheers,
Conor.

--NNnrGIyMcXO0vPhL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZHWkMQAKCRB4tDGHoIJi
0jWdAPoC+9S5r3aMYALDqrbWUf0p+Axc9SkVI4ZiFY93RhGEBwD7BPnUnnl48QEq
ltwW2HxGlqCVdFxVaTLQSGJJWF6VJgo=
=FvXg
-----END PGP SIGNATURE-----

--NNnrGIyMcXO0vPhL--

