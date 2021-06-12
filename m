Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5B93A5025
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 20:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhFLSyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 14:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbhFLSyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 14:54:23 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDCDC061574;
        Sat, 12 Jun 2021 11:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6vyq8++fgJW9VT1oJ2gzeTKHAjPRKuu+Bi0OQsraujM=; b=f2K0vN6g33glZVIwNJPjlpw3V
        RsdE31t3s9zTKZ2JW/y1RZnp+73goQ37tIEwvLqIwzuc24lCsPOi0cT05xkWwVTAAeGuOQd31kbcD
        qL5FkTVbo5ci48qqBz7IUqEOTkfJFEeBc6ljCfx8aLI5Dz7z5I5wnkZBrSjI4fBJdBkLL8Zswnls/
        akhwB1/MNjN7cU8X2m+eWfJaN3acr2szPX9GTV0Y+72lV/OcjVtbozVCuR+wfkEO3vDgh6jYsRAHL
        9AaI8scmecUCV5JQXGOvICWlvDjBgYJq+9sP0G7nDYn7eFcGYZoLOolWClLBJsX1F2jSfnYS/rgcd
        51HExLDCQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44948)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ls8jv-0002jO-5b; Sat, 12 Jun 2021 19:52:15 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ls8jt-0002Rn-Rd; Sat, 12 Jun 2021 19:52:13 +0100
Date:   Sat, 12 Jun 2021 19:52:13 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>
Subject: Re: [PATCH net-next 1/4] dt-bindings: net: Add 25G BASE-R phy
 interface
Message-ID: <20210612185213.GL22278@shell.armlinux.org.uk>
References: <20210611125453.313308-1-steen.hegelund@microchip.com>
 <20210611125453.313308-2-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611125453.313308-2-steen.hegelund@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 02:54:50PM +0200, Steen Hegelund wrote:
> Add 25gbase-r PHY interface mode.
> 
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
