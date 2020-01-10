Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24F96137108
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 16:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgAJPWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 10:22:50 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59802 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727866AbgAJPWu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 10:22:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OID1dlSTSaamVryi8LpcNEnO4aY2wUMBFndKhtzt064=; b=YNCJV+sUCXt2W5mSotj16fSaar
        fokY4RYQbPWvs3Euir9u1Io2CTIPDHwYmXK9h1y4agZS/mgaPE5lEhKboyRl8hcP7s36UhulvgVcH
        uW9K0VV/5rV0rvXxBxdlYoRVCTi4/7I+bZ0uFbWlZ+85jxbZ8tZpbUgHs0gRMhKrDGQM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ipw7V-000085-Uk; Fri, 10 Jan 2020 16:22:41 +0100
Date:   Fri, 10 Jan 2020 16:22:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/14] net: axienet: Autodetect 64-bit DMA capability
Message-ID: <20200110152241.GB10802@lunn.ch>
References: <20200110115415.75683-1-andre.przywara@arm.com>
 <20200110115415.75683-13-andre.przywara@arm.com>
 <20200110140852.GF19739@lunn.ch>
 <20200110141303.2e5863ab@donnerap.cambridge.arm.com>
 <20200110142250.GH19739@lunn.ch>
 <20200110150836.1f92a0a8@donnerap.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110150836.1f92a0a8@donnerap.cambridge.arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So far I couldn't be bothered to put my asbestos trousers on and go
> into BSP land ;-)

Are you in Cambridge? 7 degrees, so you can pop outside to cool off a
bit :-)

> So if you were hoping for an official blessing, I have to disappoint you ;-)

Well, everything you have done is at least sensible. The patches have
also drawn the interest of Radhey. Let see if he says this is safe for
IP version 0.0 through to 7.1.

   Andrew
