Return-Path: <netdev+bounces-11982-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 89280735953
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:18:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 734961C20835
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:18:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 603B9125B0;
	Mon, 19 Jun 2023 14:18:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F5111182
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 14:18:10 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1172E55
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 07:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=dfNBKwWVOmt/OIPz/XxHPCvYGyQP0gtl/wfkhyzHXCo=; b=ol2D++gGnpOcJ9LBlf4FU2b4cr
	a37D0xCl6yip070ii9OwkqIYGcHOhUs6pHExp11L60eFtPR0wb8E4cZz0hOm4tlN9FwgwwkvyPXeL
	aSkBs8Cy+rI74nX/bmvDcG8ntzmvPAPr0PXBUjfgZzyPfljCzhOn9zE2wwagH6SlGXmg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qBFha-00Gup6-GL; Mon, 19 Jun 2023 16:17:54 +0200
Date: Mon, 19 Jun 2023 16:17:54 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: Re: [PATCH net] net: mdio: fix the wrong parameters
Message-ID: <ecae69cc-a7aa-41c6-9c49-47d82e883a7e@lunn.ch>
References: <20230619094948.84452-1-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619094948.84452-1-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 05:49:48PM +0800, Jiawen Wu wrote:
> PHY address and device address are passed in the wrong order.
> 
> Fixes: 4e4aafcddbbf ("net: mdio: Add dedicated C45 API to MDIO bus drivers")
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>

Thanks. I checked all the other c45 functions in this file. This
appears to be the only one i got wrong.

Cc: stable@vger.kernel.org
Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

