Return-Path: <netdev+bounces-4870-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55B0F70EE81
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 08:51:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8E5528118A
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 06:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC90F3D7A;
	Wed, 24 May 2023 06:51:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11CF1FB9
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 06:51:36 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF1DE46;
	Tue, 23 May 2023 23:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684911094; x=1716447094;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=shsR1rGUNM1EmQeYgf3G+zkshdxAvDAMpbx1W7WU4Gc=;
  b=qImG/ic6v1owcJ3x2+ZCK460qsnKw8F+OYkAPisrWR4gRoIvmdc09kuJ
   zsxE9B7ma5/58WH53nZLFpEwu/TGcoXZeukyg+f30XSK6Xg4t0ajBfGcf
   vbPPL+2Y8dtKIKdQcKGFmT1glnnRoAqIEQP7zh4hgZKE4c//LZ8Bsik43
   OVDHrTck6hvDtwZwVea578Ibuxf+XPNwWu8ocfaDjfkh/jEv87Hlf2Yc0
   cOzWlTSnFyDGt8rVQVlK/4S9958AGxQx8lO7AFMcTvDxYvhcB1lb2tQ8R
   xJ6fgdH/z6PT+YyHLMPUJ42LfJgmVUnKnj/k6NFIIzsKhwIxQTWwN6jhb
   g==;
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="217000363"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 May 2023 23:51:33 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 23 May 2023 23:51:33 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 23 May 2023 23:51:29 -0700
Date: Wed, 24 May 2023 07:51:07 +0100
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
Message-ID: <20230524-scientist-enviable-7bfff99431cc@wendy>
References: <1684878827-40672-1-git-send-email-justin.chen@broadcom.com>
 <1684878827-40672-3-git-send-email-justin.chen@broadcom.com>
 <20230523-unfailing-twisting-9cb092b14f6f@spud>
 <CALSSxFYMm5NYw41ERr1Ah-bejDgf9EdJd1dGNL9_sKVVmrpg3g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CALSSxFYMm5NYw41ERr1Ah-bejDgf9EdJd1dGNL9_sKVVmrpg3g@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hey Justin,
On Tue, May 23, 2023 at 04:27:12PM -0700, Justin Chen wrote:
> On Tue, May 23, 2023 at 3:55=E2=80=AFPM Conor Dooley <conor@kernel.org> w=
rote:
> > On Tue, May 23, 2023 at 02:53:43PM -0700, Justin Chen wrote:
> >
> > > +  compatible:
> > > +    enum:
> > > +      - brcm,asp-v2.0
> > > +      - brcm,bcm72165-asp
> > > +      - brcm,asp-v2.1
> > > +      - brcm,bcm74165-asp
> >
> > > +        compatible =3D "brcm,bcm72165-asp", "brcm,asp-v2.0";
> >
> > You can't do this, as Rob's bot has pointed out. Please test the
> > bindings :( You need one of these type of constructs:
> >
> > compatible:
> >   oneOf:
> >     - items:
> >         - const: brcm,bcm72165-asp
> >         - const: brcm,asp-v2.0
> >     - items:
> >         - const: brcm,bcm74165-asp
> >         - const: brcm,asp-v2.1
> >
> > Although, given either you or Florian said there are likely to be
> > multiple parts, going for an enum, rather than const for the brcm,bcm..
> > entry will prevent some churn. Up to you.
> >
> Urg so close. Thought it was a trivial change, so didn't bother
> retesting the binding. I think I have it right now...
>=20
>   compatible:
>     oneOf:
>       - items:
>           - enum:
>               - brcm,bcm72165-asp
>               - brcm,bcm74165-asp
>           - enum:
>               - brcm,asp-v2.0
>               - brcm,asp-v2.1
>=20
> Something like this look good?

I am still caffeine-less, but this implies that both of
"brcm,bcm72165-asp", "brcm,asp-v2.0"
_and_
"brcm,bcm72165-asp", "brcm,asp-v2.1"
are. I suspect that that is not the case, unless "brcm,asp-v2.0" is a
valid fallback for "brcm,asp-v2.1"?
The oneOf: also becomes redundant since you only have one items:.

> Will submit a v5 tomorrow.

BTW, when you do, could you use the address listed in MAINTAINERS rather
than the one you used for this version?

Cheers,
Conor.

