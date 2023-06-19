Return-Path: <netdev+bounces-12083-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EE9C735F36
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 23:28:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5522280FD5
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 21:28:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA0FD14A8B;
	Mon, 19 Jun 2023 21:28:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE05B522A
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 21:28:14 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048FCE55
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 14:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=+POZFuadnwhwvTXMNn/ca8BPFVjr8nlqLt4Xeehehi8=; b=M5mQhDti2SI7kGiRs9LiffldzC
	J1Ym22vvRVWrM3nczLVR8AwRAJ/WpZeX4bH+zSTeUNc9UBa/IDMsyWsIXhyngaw6Kg1Ikj9cDWiiX
	7gBlj2XbmbaXsHa0wwf+j7lK9rkaeGm27tk0j1pB+mPr8EMbXzq4s1O+6/HLLb8qwB4E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qBMPn-00GwUE-9l; Mon, 19 Jun 2023 23:27:59 +0200
Date: Mon, 19 Jun 2023 23:27:59 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Simon Horman <horms@kernel.org>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
	Simon Horman <simon.horman@corigine.com>,
	netdev <netdev@vger.kernel.org>, ansuelsmth@gmail.com,
	Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v0 2/3] net: phy: phy_device: Call into the PHY
 driver to set LED offload
Message-ID: <f1af638e-98fe-47cf-bdf4-d788e2a2aac9@lunn.ch>
References: <20230618173937.4016322-1-andrew@lunn.ch>
 <20230618173937.4016322-2-andrew@lunn.ch>
 <ZJBjtWTtDqsyWPXE@corigine.com>
 <ZJCaODPt5cJVZqTf@shell.armlinux.org.uk>
 <ZJC71i4YFMCYOrti@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJC71i4YFMCYOrti@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Ok. I'll confess that I wasn't aware of that problem.
> But could we use one of the approaches approach already taken
> for existing members of this structure?

Yes, i will update the comments to start with /** so they look like
kerneldoc, even if they are not kerneldoc.

	Andrew

