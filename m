Return-Path: <netdev+bounces-4394-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3319A70C552
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:38:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E26272810D0
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:38:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1B1614AA2;
	Mon, 22 May 2023 18:38:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840D716413
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 18:38:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1846C4339B;
	Mon, 22 May 2023 18:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684780726;
	bh=k+ztUyrowKth864y9ceYmAWMGnjd0ateRI2+IBMBGTg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G6zapAYinGWGAXCgi9YCLSqCkeZnvJoOD5d8xvy4wRW6jNl2ohF6pVQ8u56HA5CQU
	 8Za7fHKyr84PXQCmNRIYldR3q/LuumWnYUU+P+c01FQIg2UcLFQRuOE4UdTlSUBoEK
	 EpCcqYgAtTPftXzLuCb3kw1HUH4PoXDzk58p1FgYwp+yvR4QYioOn0fqCbJUzZ5dsq
	 +YrJ0D8Wlo3UIp0UcgrDkr3H4lx1uQOIkyDFRlOADYWQE66ktZjDb7hCCxU3+OeX+f
	 51gB3iRedQvPG6uMfsJsvNOMkMq9hxwlseWSW48z1BF2ycigUX8oMUut5BHNsxnNV0
	 HiIW8YJY3DECg==
Date: Mon, 22 May 2023 19:38:39 +0100
From: Conor Dooley <conor@kernel.org>
To: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Conor Dooley <mail@conchuod.ie>, Justin Chen <justin.chen@broadcom.com>,
	netdev@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	bcm-kernel-feedback-list@broadcom.com, justinpopo6@gmail.com,
	f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
	andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	richardcochran@gmail.com, sumit.semwal@linaro.org,
	christian.koenig@amd.com
Subject: Re: [PATCH net-next v3 1/6] dt-bindings: net: brcm,unimac-mdio: Add
 asp-v2.0
Message-ID: <20230522-outshine-resample-f0c96c9345ca@spud>
References: <1684531184-14009-1-git-send-email-justin.chen@broadcom.com>
 <1684531184-14009-2-git-send-email-justin.chen@broadcom.com>
 <2be2af5e-d117-fa2c-f960-e7f0c3ca3d0b@conchuod.ie>
 <ce4a0153-1a6b-92d5-b760-489b09bbec73@broadcom.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ce4a0153-1a6b-92d5-b760-489b09bbec73@broadcom.com>

On Mon, May 22, 2023 at 11:25:54AM -0700, Florian Fainelli wrote:
> On 5/22/23 11:17, Conor Dooley wrote:
> > On Fri, May 19, 2023 at 02:19:39PM -0700, Justin Chen wrote:
> >  > The ASP 2.0 Ethernet controller uses a brcm unimac.
> >  >
> >  > Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
> >  > Signed-off-by: Justin Chen <justin.chen@broadcom.com>
> >  > ---
> >  >  Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml | 2 ++
> >  >  1 file changed, 2 insertions(+)
> >  >
> >  > diff --git
> > a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
> > b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
> >  > index 0be426ee1e44..6684810fcbf0 100644
> >  > --- a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
> >  > +++ b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
> >  > @@ -22,6 +22,8 @@ properties:
> >  >        - brcm,genet-mdio-v3
> >  >        - brcm,genet-mdio-v4
> >  >        - brcm,genet-mdio-v5
> >  > +      - brcm,asp-v2.0-mdio
> >  > +      - brcm,asp-v2.1-mdio
> >  >        - brcm,unimac-mdio
> > 
> > 
> >  From V(N-1), there was some discussion between Rob & Florian:
> >  > > How many SoCs does each of these correspond to? SoC specific
> > compatibles
> >  > > are preferred to version numbers (because few vendors are disciplined
> >  > > at versioning and also not changing versions with every Soc).
> >  >
> >  > So far there is a 1:1 mapping between the number of versions and the
> >  > number of SoCs, and the older SoC uses v2.0, while the newer one uses
> > v2.1.
> > 
> > Rob's not around right now, but I don't really get why if there is a 1:1
> > mapping you don't just name these things after the SoCs?
> 
> There is a 1:1 mapping now, but in the future there may be more SoCs with a
> given implemented version. This is especially true for the MDIO controller
> which has been largely unchanged since it was introduced.

Figured that'd be it, but what was written in the previous thread made
the opposite appear true!
Acked-by: Conor Dooley <conor.dooley@microchip.com>

> > Also, my mailer **refused** to let me reply to you because of something
> > to do with a garbage S/MIME signature? Dunno wtf is happening there.
> 
> Our SMTP server is configured to automatically wrap the message in a S/MIME
> envelope, nothing invalid though AFAICT. What's your email client?

Mutt - I guess it was user-error because getting S/MIME stuff
auto-populated the security field on my end. Annoying but w/e...

