Return-Path: <netdev+bounces-7540-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5B8D720951
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 20:43:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A59E281A98
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDD7B1B902;
	Fri,  2 Jun 2023 18:43:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F8433302
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 18:43:39 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EF51B3;
	Fri,  2 Jun 2023 11:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=jfneblYBOjYYxA0NKH+Vqb9gSU5XXDjXlUQAlaqb8HI=; b=HoI0OAuACVkzKpgJWsKJbktIJD
	jfegeMLt39LgEMSUbh27959JFDxXgl3RUwFN1PUuIPXhOnrLGp2TWssNB9zGNJskvwnh/3yAYrXuY
	uv0h7baMMsmjSX1J4gzNTPoH3/k8GLkt/bimnnsHQIRLZKafpPNKrwP9Jue7VAom2Uy0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q59kJ-00Ehgl-Fg; Fri, 02 Jun 2023 20:43:31 +0200
Date: Fri, 2 Jun 2023 20:43:31 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Detlev Casanova <detlev.casanova@collabora.com>
Cc: linux-kernel@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/3] net: phy: realtek: Add optional external PHY clock
Message-ID: <f009ffe1-a72a-4910-b705-5b633bac12a6@lunn.ch>
References: <20230602182659.307876-1-detlev.casanova@collabora.com>
 <20230602182659.307876-2-detlev.casanova@collabora.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602182659.307876-2-detlev.casanova@collabora.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 02:26:57PM -0400, Detlev Casanova wrote:
> In some cases, the PHY can use an external clock source instead of a
> crystal.
> 
> Add an optional clock in the phy node to make sure that the clock source
> is enabled, if specified, before probing.
> 
> Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

