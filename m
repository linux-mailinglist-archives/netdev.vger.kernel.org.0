Return-Path: <netdev+bounces-5195-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F44C710230
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 03:09:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAD6A1C20D41
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 01:09:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D94415B1;
	Thu, 25 May 2023 01:09:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E49915A9
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 01:09:28 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B90212B;
	Wed, 24 May 2023 18:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=9d6+XEpsXz1iSbOIpQ0TAWr8mqTs2ADpccgDRm6N8ao=; b=dgiCj6cqvvyR2Bd1CtNT4gL5Fo
	A3ae7YYNjjeXYj4R6zlN6X2TkWlRE9/Ce7EDlWSSjazyEPLlUWY08V+dXGRVY0shDm//2wGGu1fmX
	ka+NdCivPbTNAwMze/wWvS8fE8jjrDDyD6kSG9eL5y9xdyU4UZPWQhCvjp5aRel3kh/A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q1zTk-00DqwL-4J; Thu, 25 May 2023 03:09:20 +0200
Date: Thu, 25 May 2023 03:09:20 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
Cc: hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	ramon.nordin.rodriguez@ferroamp.se, horatiu.vultur@microchip.com,
	Woojung.Huh@microchip.com, Nicolas.Ferre@microchip.com,
	Thorsten.Kummermehr@microchip.com
Subject: Re: [PATCH net-next v3 4/6] net: phy: microchip_t1s: fix reset
 complete status handling
Message-ID: <b55f2483-8d8b-4eae-b224-7852c1f0ecdd@lunn.ch>
References: <20230524144539.62618-1-Parthiban.Veerasooran@microchip.com>
 <20230524144539.62618-5-Parthiban.Veerasooran@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524144539.62618-5-Parthiban.Veerasooran@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 08:15:37PM +0530, Parthiban Veerasooran wrote:
> As per the datasheet DS-LAN8670-1-2-60001573C.pdf, the Reset Complete
> status bit in the STS2 register has to be checked before proceeding to
> the initial configuration. Reading STS2 register will also clear the
> Reset Complete interrupt which is non-maskable.
> 
> Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

