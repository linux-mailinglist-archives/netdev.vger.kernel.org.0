Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F55C2F640F
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 16:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729470AbhANPPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 10:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727824AbhANPPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 10:15:04 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472DDC0613ED;
        Thu, 14 Jan 2021 07:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xt6GBaiEr5blQqPG7EyFh4PFTGIl0+YLEE9qu/Wvz3Y=; b=kaSEuxBsQoCHYBZXy7z+YLZJm
        tnlqiqq30OZBUJWUFDV3dx9heK93tmFDkROpoHU0uyge/T4D5oqPf7E4zngKvJoeLCws3/gXI5rcS
        0rXAHNClzft3tlnhj5p+XruJOqmmrMaqV/oCRui+jome6jnA2DCfIZq7D14UDstYD4SfM8wiN5W6S
        H9CRYdImu+FuHSjMlVNj/WwGQad+ncR85ciR2S8OEVb2y0JMoJPzIx3luzL0Bn8y7Gfa9+i7G0fZI
        +OB3XbcO2WI9ieo7qkXykkislA3LygE2HIytxBOcGVwQMhTPBwMg8AaMvUGVdsiMDpvxpVcpUlURq
        hrnsKs1WA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47920)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l04K6-0002bC-5f; Thu, 14 Jan 2021 15:14:06 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l04K5-0008Ro-Vc; Thu, 14 Jan 2021 15:14:05 +0000
Date:   Thu, 14 Jan 2021 15:14:05 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v2 2/2] sfp: add support for 100 base-x SFPs
Message-ID: <20210114151405.GU1551@shell.armlinux.org.uk>
References: <20210113115626.17381-1-bjarni.jonasson@microchip.com>
 <20210113115626.17381-3-bjarni.jonasson@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113115626.17381-3-bjarni.jonasson@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 12:56:26PM +0100, Bjarni Jonasson wrote:
> Add support for 100Base-FX, 100Base-LX, 100Base-PX and 100Base-BX10 modules
> This is needed for Sparx-5 switch.
> 
> Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
