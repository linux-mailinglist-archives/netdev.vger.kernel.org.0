Return-Path: <netdev+bounces-6168-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D94FF71505F
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 22:11:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 488E8280F10
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 20:11:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C738DDDE;
	Mon, 29 May 2023 20:11:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A6ED309
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 20:11:30 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0E3CF;
	Mon, 29 May 2023 13:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=1rAW9JT281DChV4HgV3bBJET8wRpN/l5/QpeY2saKK4=; b=tgYM3BPPfiTWa7K5TW6BetLEez
	UirQhVdsxWYdKw+k5lbfh70FSMm0fgtIr8kavdXtmEpLJidWTrxYnkBXEiYrJ02+j2KGdX/BiPHUa
	mP3rrLR5RvjSZCDVWZvuu34F43680MPnlOH0CZhzBPznsRbv1ioge6t0hE5ohLdS0ToY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q3jCy-00EG3B-2g; Mon, 29 May 2023 22:11:12 +0200
Date: Mon, 29 May 2023 22:11:12 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Conor Dooley <conor@kernel.org>
Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>, s.shtylyov@omp.ru,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
	geert+renesas@glider.be, magnus.damm@gmail.com,
	netdev@vger.kernel.org, devicetree@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] dt-bindings: net: r8a779f0-ether-switch:
 Add ACLK
Message-ID: <15fece9d-a716-44d6-bd88-876979acedf1@lunn.ch>
References: <20230529080840.1156458-1-yoshihiro.shimoda.uh@renesas.com>
 <20230529080840.1156458-2-yoshihiro.shimoda.uh@renesas.com>
 <20230529-cassette-carnivore-4109a31ccd11@spud>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529-cassette-carnivore-4109a31ccd11@spud>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 07:36:03PM +0100, Conor Dooley wrote:
> Hey,
> 
> On Mon, May 29, 2023 at 05:08:36PM +0900, Yoshihiro Shimoda wrote:
> > Add ACLK of GWCA which needs to calculate registers' values for
> > rate limiter feature.
> > 
> > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > ---
> >  .../bindings/net/renesas,r8a779f0-ether-switch.yaml    | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch.yaml b/Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch.yaml
> > index e933a1e48d67..cbe05fdcadaf 100644
> > --- a/Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch.yaml
> > +++ b/Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch.yaml
> > @@ -75,7 +75,12 @@ properties:
> >        - const: rmac2_phy
> >  
> >    clocks:
> > -    maxItems: 1
> > +    maxItems: 2
> > +
> > +  clock-names:
> > +    items:
> > +      - const: fck
> > +      - const: aclk
> 
> Since having both clocks is now required, please add some detail in the
> commit message about why that is the case. Reading it sounds like this
> is an optional new feature & not something that is required.

This is something i wondered about, backwards compatibility with old
DT blobs. In the C code it is optional, and has a default clock rate
if the clock is not present. So the yaml should not enforce an aclk
member.

	Andrew

