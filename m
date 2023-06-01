Return-Path: <netdev+bounces-7084-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BFD8719C23
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 14:29:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A9671C20FD7
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 12:29:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2E732343E;
	Thu,  1 Jun 2023 12:29:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AB623404
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 12:29:00 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11616133;
	Thu,  1 Jun 2023 05:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=OTsx+IOqxbYdUnQsgfql+uLXRlsYC1fAzy2R6BIpCx8=; b=e8/lNo1ypjP1KEshm7WVJlDFUL
	tQqn/KZGCuhfZPFNdjSNAqcU+2jwIxRHVOa2VInJ1CmeZUeBnwZ/x2SD3FRGvQVaKM3Qk6BuvZg7X
	IheD584crLZvrdy4wVkmoTLGB4pdNN4iAumLGITAzlYqKtCJA1Q7f0jE+rS0+kVmk6G4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q4hQD-00EZ7V-HV; Thu, 01 Jun 2023 14:28:53 +0200
Date: Thu, 1 Jun 2023 14:28:53 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
	Michael Hennerich <michael.hennerich@analog.com>,
	Alexandru Tachici <alexandru.tachici@analog.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v2 1/2] dt-bindings: net: adin: document a phy
 link status inversion property
Message-ID: <8cc9699c-92e3-4736-86b4-fe59049b3b18@lunn.ch>
References: <e7a699fb-f7aa-3a3e-625f-7a2c512da5f9@sord.co.jp>
 <7d2c7842-2295-4f42-a18a-12f641042972@lunn.ch>
 <6e0c87e0-224f-c68b-9ce5-446e1b7334c1@sord.co.jp>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e0c87e0-224f-c68b-9ce5-446e1b7334c1@sord.co.jp>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 09:29:01AM +0900, Atsushi Nemoto wrote:
> On 2023/05/31 23:35, Andrew Lunn wrote:
> >> The ADIN1200/ADIN1300 supports inverting the link status output signal
> >> on the LINK_ST pin.
> > 
> > Please could you add an explanation to the commit message why you
> > would want to do this?  Is this because there is an LED connected to
> > it, but its polarity is inverted?
> 
> Yes, the LINK_ST pin of AD1200/1300 is active-high but our custom
> board designer connected it to an LED as an active-low signal.

O.K. LED is the magic word here. And the fact that there is nothing
specific to this PHY. Being able to specify the polarity of an output
to an LED is pretty common.

Please take a look at:

ocumentation/devicetree/bindings/net/ethernet-phy.yaml

where it describes LEDs. Please add a generic DT property there for
everybody to use. See if the LED subsystem has a name for such a
property.

There is sufficient code in net-next to allow LED0 to be controlled in
a limited way. There are more patches coming soon which will give you
much more control.

Using LINK_ST to control an LED is not so easy to represent in the
current code because it appears you don't have manual control of the
LED, i.e. forced on/off. But you can offload functions when the new
code lands.

     Andrew

