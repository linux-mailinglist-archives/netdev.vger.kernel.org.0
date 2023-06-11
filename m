Return-Path: <netdev+bounces-9950-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54D5B72B430
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 23:28:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D1C41C209BE
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 21:28:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5474B111B7;
	Sun, 11 Jun 2023 21:28:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465AC2CAB
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 21:28:53 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F267C1B9
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 14:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=3PtP12iKc05PZl1kT9mmI0ZFIBKT6CV6+VjKcpcNLi8=; b=w6Hvsc6PIoZWlxDv1tibY9KjGB
	Gy3mPdnJQfujJHh3l6pkKsxKWq3Mx9NDfYx4mQbsRX1Eu0hK8w6WoEnDU124ccez/+FtO0HfMXHjH
	kq0xoecWZQfFRMO/HukLLkcWMcIvtKnFjUpyN/PNtdlp6VDB8+rmHdIx6UU0n78VGnB0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q8Sbw-00FWq8-F3; Sun, 11 Jun 2023 23:28:32 +0200
Date: Sun, 11 Jun 2023 23:28:32 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Marcin Wojtas <mw@semihalf.com>,
	netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH RFC net-next 2/4] net: phylink: add EEE management
Message-ID: <bca7e7ec-3997-4d97-9803-16bfaf05d1f5@lunn.ch>
References: <ZILsqV0gkSMMdinU@shell.armlinux.org.uk>
 <E1q7Y9R-00DI8g-GF@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1q7Y9R-00DI8g-GF@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 10:11:21AM +0100, Russell King (Oracle) wrote:
> Add EEE management to phylink.

Hi Russell

I've been working on my EEE patches. I have all pure phylib drivers
converted. I've incorporated these four patches as well, and make use
of the first patch in phylib.

Looking at this patch, i don't see a way for the MAC to indicate it
actually does support EEE. Am i missing it?

What i proposed last time is to add another bit to
pl->config->mac_capabilities. Does that work for you?

Do you have time to respin these patches to address the comments? It
is probably easier for my series to wait until these are merged.

	Andrew

