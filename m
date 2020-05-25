Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156E51E1818
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389022AbgEYXGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:06:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48806 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388886AbgEYXG3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 19:06:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xU2BR0jRNvqfWcp6juRFsn6EmW9e+POp1k0nZuFOpOY=; b=lZ8YRvyZJomIn72luInBLWrHRt
        t6ip7f5SVtNVXVPLsfdM/ji9lAQGgGiNal7cbaDtXuR90CjQ68K/YRCc/cVaxbxLs8ucCsosRe0O8
        vkk6SayWmP1X82ujoMg0f17gFtCw4fA/x4Uj3Yst7o/ggSRnRlvD3NP7XUVMWrjNMoK8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdMAk-003EaY-Ez; Tue, 26 May 2020 01:06:18 +0200
Date:   Tue, 26 May 2020 01:06:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, madalin.bucur@oss.nxp.com,
        calvin.johnson@oss.nxp.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC 04/11] net: phy: Handle c22 regs presence better
Message-ID: <20200525230618.GE768009@lunn.ch>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-5-jeremy.linton@arm.com>
 <20200523183731.GZ1551@shell.armlinux.org.uk>
 <f85e4d86-ff58-0ed2-785b-c51626916140@arm.com>
 <20200525100612.GM1551@shell.armlinux.org.uk>
 <63ca13e3-11ea-3ddf-e1c7-90597d4a5f8c@arm.com>
 <20200525220614.GC768009@lunn.ch>
 <8868af66-fc1a-8ec2-ab75-123bffe2d504@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8868af66-fc1a-8ec2-ab75-123bffe2d504@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I know for sure we find phys that previously weren't found.

That is in itself somewhat dangerous. Those using primitive
configuration systems are probably going to use phy_find_first(),
rather than an address on the bus.  I always recommend against that,
because if another PHY suddenly pops up on the bus, bad things can
happen.

   Andrew
