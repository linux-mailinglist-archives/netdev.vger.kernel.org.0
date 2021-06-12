Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFFA13A502C
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 20:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbhFLSzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 14:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbhFLSzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 14:55:12 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41478C061574;
        Sat, 12 Jun 2021 11:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uvq8dxQiiwwc7ApFZalbuJ+kCc6b8NrOOcUJtnmw2y0=; b=iJEMucgc090mja/8itG5P9NwI
        AhbSYuo+x608B/MKU8/4PjWcjinyR5dmNy4+Wv+v06Y//+TxVVyvosl6lFLTb/PSY0nGDt+9m096e
        /cgfk7YX0WxUPtX5R79JT8Z72lgCOw4yP2vsdscOcXzw/LjwVAUx6vQwwRgO++GVRhmv48QKWlTnl
        UjgH3pJxX1VaudMhIUS7x9qHIP4Feh3EJm9nowtLz+YIl1yUvKDpx3Fd4pmKq34i0E2CeMDEKUVKA
        ZMveqphuN+m5X8xUGoSYxHNfRz7xnd68tdtXbEwWxU/TGR5API/ALjUOpMMjJk1EnpygI/zM24qE3
        dcc2pCqKQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44952)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ls8kl-0002kA-Sw; Sat, 12 Jun 2021 19:53:07 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ls8kl-0002SN-Lv; Sat, 12 Jun 2021 19:53:07 +0100
Date:   Sat, 12 Jun 2021 19:53:07 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>
Subject: Re: [PATCH net-next 3/4] net: sfp: add support for 25G BASE-R SFPs
Message-ID: <20210612185307.GN22278@shell.armlinux.org.uk>
References: <20210611125453.313308-1-steen.hegelund@microchip.com>
 <20210611125453.313308-4-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611125453.313308-4-steen.hegelund@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 02:54:52PM +0200, Steen Hegelund wrote:
> Add support for 25gbase-r modules. This is needed for the Sparx5 switch.
> 
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
