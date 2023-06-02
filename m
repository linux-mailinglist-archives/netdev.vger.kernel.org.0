Return-Path: <netdev+bounces-7567-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F29827209FD
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 21:43:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E0081C21210
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:43:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FE7E1E533;
	Fri,  2 Jun 2023 19:43:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BD317759
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 19:43:40 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E21B19B;
	Fri,  2 Jun 2023 12:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=p2kx53FIkLSzM3l59PYme95Et3nogdbgkEjsVJ+GbYY=; b=mBN8lN82hw72k5hWdJGwf9dN7a
	nCTt8kw/sUpcFmsarHCKX/+XUQGB/bn/IGgc1kGZFdICq0TO6B6+hiQMPJottKXIxFa92Y0w+1inY
	pBzrIjkMP8jPOtmhlHlrz0t4WX8xHBYL3ZExa3hsvhgHp4iciYV8qeHDjfKcycH//mvA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q5AgG-00EhxJ-4o; Fri, 02 Jun 2023 21:43:24 +0200
Date: Fri, 2 Jun 2023 21:43:24 +0200
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
Subject: Re: [PATCH v2 2/3] dt-bindings: net: phy: Document support for
 external PHY clk
Message-ID: <b188ba63-5e9e-403b-9caa-a52085279e3d@lunn.ch>
References: <20230602182659.307876-1-detlev.casanova@collabora.com>
 <20230602182659.307876-3-detlev.casanova@collabora.com>
 <4255bc0a-491c-4fbb-88ea-ec1d864a1a24@lunn.ch>
 <2288019.ElGaqSPkdT@arisu>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2288019.ElGaqSPkdT@arisu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> What about "Ethernet PHYs can have an external clock that needs to be 
> activated before communicating with the PHY" ?

That good.

Thanks
	Andrew

