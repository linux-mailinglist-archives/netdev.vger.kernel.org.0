Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C26347E5E
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 18:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236580AbhCXRAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 13:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236702AbhCXQ7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 12:59:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77032C061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 09:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Dx3GsMsjnRKf3hU0wPeldlErkG2HduYh05viTSHBUNg=; b=M2GTAHCJn4aGIffnZFz6sEtIu
        h37xJW1IxIqfdvYuRJwSphbl4nrPIdvlm3+XIQtnHkz4P79hdm5rOmjyw63tDWBO3IOjVLMlXBy4S
        f+3sw9/rSgsw1lrAXUa9+42TXrC7IFC2k11QxGhem3aWWRx+5u9ALS9dZ7vX+nxRKLeoGSWPjDtHm
        yEaN0Jqz2cBjvKuQ2h6MT3RCvuIdHPDS0ei7HnhZO4aN6CSc87UhjGpL5LHkhXuvftKqNC+4cmiMl
        oLihAs7H8LsfTtMXBJIBaIQnp60AMlVx7FCa35yxBHiM687VWTyqriV+ZdWlmpNMTXzdD7nCNApaQ
        VIBnKjwzg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51674)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lP6rD-0000k1-6t; Wed, 24 Mar 2021 16:59:47 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lP6rD-0005Cu-06; Wed, 24 Mar 2021 16:59:47 +0000
Date:   Wed, 24 Mar 2021 16:59:46 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org
Subject: Re: [PATCH net-next 5/7] net: phy: marvell10g: save MACTYPE instead
 of rate_matching boolean
Message-ID: <20210324165946.GG1463@shell.armlinux.org.uk>
References: <20210324165023.32352-1-kabel@kernel.org>
 <20210324165023.32352-6-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210324165023.32352-6-kabel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 05:50:21PM +0100, Marek Behún wrote:
> Save MACTYPE instead of rate_matching boolean. We will need this for
> other configurations.

This could lead us to having to test for multiple different mactype
values depending on the PHY type in mv3310_update_interface() which
is something I wanted to avoid.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
