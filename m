Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19DD5397303
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 14:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbhFAMMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 08:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbhFAMMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 08:12:23 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83108C061574
        for <netdev@vger.kernel.org>; Tue,  1 Jun 2021 05:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NGaSXG4E4P3N5IAsa7igmqa+gncWsSuN3WpGxPcbMiM=; b=GVM4ygepgICpLCfvYxVlDAxhF
        S0Pc2wk2NvBMujg28AYJtzRqc8EaQbGXJsj1UTkZBoJzp1h0GzgG6mhgRKvk/Ns1nI6xnCuXj8Bot
        eHXLRRYWK5w5SFmDF4y+h+PJ6R9KDhKbbWQZG/kkrUa8cvSWxTdkFeckgzQYmVZvYDvZKc5RfteOv
        lFIpGVgSiavLYhkVGIqxHltSTQUkROiCxYQ3AfaIgyf24quuiH19fh8UeyovT2Dyz2V1NX4J02S9a
        +B3UxpgIIkktmSLLlbgZQMljXi4MS4k7qUVWwOsAl6WiNfoGc1Yj8kwZoQTqlx+yf37BEJxwtTvYf
        8LkgqH1dw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44570)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lo3EC-0003yK-7z; Tue, 01 Jun 2021 13:10:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lo3E9-00005w-27; Tue, 01 Jun 2021 13:10:33 +0100
Date:   Tue, 1 Jun 2021 13:10:33 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 net-next 9/9] net: pcs: xpcs: convert to
 phylink_pcs_ops
Message-ID: <20210601121032.GV30436@shell.armlinux.org.uk>
References: <20210601003325.1631980-1-olteanv@gmail.com>
 <20210601003325.1631980-10-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601003325.1631980-10-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 03:33:25AM +0300, Vladimir Oltean wrote:
>  static const struct phylink_mac_ops stmmac_phylink_mac_ops = {
>  	.validate = stmmac_validate,
> -	.mac_pcs_get_state = stmmac_mac_pcs_get_state,
> -	.mac_config = stmmac_mac_config,

mac_config is still a required function.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
