Return-Path: <netdev+bounces-2360-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC3DB701785
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 15:51:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08367281AEB
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 13:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2B4B4C6B;
	Sat, 13 May 2023 13:51:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF77646B5
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 13:51:20 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB5819B0
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 06:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=+R/FnS93KhYCImdui0O1mA8kq9rJR7XuceCxaa7zuQI=; b=WTFaQidn7KwZSlzeXlJrkKcFdd
	1MNIrAEohJpd6geoqKXjvbkgvtIZgEC9iLQbzK3HYSgpcckKPKH6f6dkHeqY96YyzIRN9HFr1iG4q
	PsWpvDbfV/pQFvSozi7MFteFXDGuqCunAd0UlqO5WC3/Xr5xaztEpqho1umu8G9dgD0o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pxpeE-00Ckt7-A6; Sat, 13 May 2023 15:50:58 +0200
Date: Sat, 13 May 2023 15:50:58 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Michael Walle <michael@walle.cc>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: mdio: i2c: fix rollball accessors
Message-ID: <efc8f95c-22f4-44a8-ba7b-5f279f61d978@lunn.ch>
References: <E1pxl4B-00324m-NP@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pxl4B-00324m-NP@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 13, 2023 at 09:57:27AM +0100, Russell King (Oracle) wrote:
> Commit 87e3bee0f247 ("net: mdio: i2c: Separate C22 and C45 transactions")
> separated the non-rollball bus accessors, but left the rollball
> accessors as is. As rollball accessors are clause 45, this results
> in the rollball protocol being completely non-functional. Fix this.
> 
> Fixes: 87e3bee0f247 ("net: mdio: i2c: Separate C22 and C45 transactions")
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Ah, sorry about that.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

