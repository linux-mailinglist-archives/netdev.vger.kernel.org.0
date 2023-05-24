Return-Path: <netdev+bounces-4957-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEC2270F5DC
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:04:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 776E02812E6
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:04:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4B8717ADB;
	Wed, 24 May 2023 12:03:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA1BC8FE
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:03:59 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54189D;
	Wed, 24 May 2023 05:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=QS4dRc2ejXzZCq6ibsWwYoY8UB/tpnmN3LUTUIuEaZY=; b=YUehNb+CS4U7sUnaAmcB1oF8j5
	HqVRuD3aD1Tb2L/c8bXndKfhqmMvU6lhn0FzTpyB0nXZ+UnwSmKBt6n8ly2/giEMiVglIA6khaZyz
	8ewSw8jR+cCaiSz1bQTElF4IrfDUF1IueAvfrlYK2M+fFzvddKuUC3wWfSLDtbEb85FA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q1nDS-00Dme2-Qf; Wed, 24 May 2023 14:03:42 +0200
Date: Wed, 24 May 2023 14:03:42 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Parthiban.Veerasooran@microchip.com
Cc: hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	ramon.nordin.rodriguez@ferroamp.se, Horatiu.Vultur@microchip.com,
	Woojung.Huh@microchip.com, Nicolas.Ferre@microchip.com,
	Thorsten.Kummermehr@microchip.com
Subject: Re: [PATCH net-next v2 4/6] net: phy: microchip_t1s: fix reset
 complete status handling
Message-ID: <e0ea8a35-3ea6-43a5-bb5b-a914f86cd492@lunn.ch>
References: <20230522113331.36872-1-Parthiban.Veerasooran@microchip.com>
 <20230522113331.36872-5-Parthiban.Veerasooran@microchip.com>
 <f0769755-6d04-4bf5-a273-c19b1b76f7f6@lunn.ch>
 <b226c865-d4a7-c126-9e54-60498232b5a5@microchip.com>
 <e9db9ce6-dee8-4a78-bfa4-aace4ae88257@lunn.ch>
 <2523bd58-2b2c-723f-6261-aa44ca92e00a@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2523bd58-2b2c-723f-6261-aa44ca92e00a@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> As per the datasheet DS-LAN8670-1-2-60001573C.pdf, during the Power ON 
> Reset(POR)/Hard Reset/Soft Reset, the Reset Complete status bit in the 
> STS2 register to be checked before proceeding for the initial 

register _has_ to be checked before proceeding _to_ the initial

> configuration. Reading STS2 register will also clear the Reset Complete 
> interrupt which is non-maskable.

Otherwise, this is O.K.

	Andrew

