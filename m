Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96CE12A0B2C
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 17:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgJ3QdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 12:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgJ3QdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 12:33:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6919DC0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 09:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ryVIkuid+LF6WtFs6BrRr2Th95p4uo4ZVGTQNSn9rs0=; b=WDi/eacdvO7n7BViQiCBlCLo9
        gWdWBx3n5bBujePKRJU89FxQgX9ykTelRspL4a0rqnd+4Qw3atuLmKruhfUORAKxSRrk1M5FkgNF0
        FGGs6wnlHG39j0rMSI466SJpNp0HJWFa8iyDZu3nMQ9mMua8gn0CPKkM16wfV2mAHsFNXxencQDLF
        bjnlG99Xg+EV6DYB9pjoXM51aEwRnwOEaftiS0IaXIwuMfz0NrMNEpbXneOfXs0JVaCs/R4lJ7rzL
        7AbcII8mvYfVkOYbo11hJ6WQzBSgzSbUIWt3UkBVcxvSC4j8zi5+e+Dy4Q4povmwXIULLK3cExVPl
        U86BG5DnQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52958)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kYXKr-0006ML-6i; Fri, 30 Oct 2020 16:33:05 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kYXKq-0007JH-W6; Fri, 30 Oct 2020 16:33:05 +0000
Date:   Fri, 30 Oct 2020 16:33:04 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 5/5] net: sfp: add support for multigig
 RollBall transceivers
Message-ID: <20201030163304.GF1551@shell.armlinux.org.uk>
References: <20201029222509.27201-1-kabel@kernel.org>
 <20201029222509.27201-6-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201029222509.27201-6-kabel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 11:25:09PM +0100, Marek Behún wrote:
> This adds support for multigig copper SFP modules from RollBall/Hilink.
> These modules have a specific way to access clause 45 registers of the
> internal PHY.
> 
> We also need to wait at least 25 seconds after deasserting TX disable
> before accessing the PHY. The code waits for 30 seconds just to be sure.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
