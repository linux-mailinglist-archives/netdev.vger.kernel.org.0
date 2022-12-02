Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E569B640E25
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 20:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234024AbiLBTBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 14:01:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234557AbiLBTBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 14:01:02 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A87BE345D;
        Fri,  2 Dec 2022 11:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9weWN0J9UlP3f78JROiu0G5wNY7vMBJUXZpIa0yvM1w=; b=yz/5laJq2eltamPH2JgAHpEag+
        Rfbg2bEzQyVhzXqphIxnwVAzuBFeGfxejG70bpNrc+7RkmWdW+YT+kzEbWQL8wX4gCFjG489ZOeXh
        +jyCUhedl5hxUeyDD+dTnOwnJmFDRxdP34AX2sNK+lE4XMAeI9CI7Ic6XJUXDCAaC7J675v4Wu+T3
        ZOSPjwXW2YFf4u0L50L0Yf3DzLul1FachcxPlGfNBSmLhp9LfwGtuhv/2qzdPNye+tFMRCVC5QlbR
        +ZmItZYwvU9fbUV2tP2zDurj8pGhfLHUJ85rsGbp3GNaaEpptyNcl3r5dR+QNDgGH0jTy5tUH8UFn
        qfb7+TBg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35538)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p1BHO-0004UF-5i; Fri, 02 Dec 2022 19:00:58 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p1BHN-0004d4-EM; Fri, 02 Dec 2022 19:00:57 +0000
Date:   Fri, 2 Dec 2022 19:00:57 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Tim Harvey <tharvey@gateworks.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v3 2/3] net: mdio: Update speed register bits
Message-ID: <Y4pLaQ4EB5jSuX5d@shell.armlinux.org.uk>
References: <20221202181719.1068869-1-sean.anderson@seco.com>
 <20221202181719.1068869-3-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202181719.1068869-3-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 01:17:17PM -0500, Sean Anderson wrote:
> This updates the speed register bits to the 2018 revision of 802.3. It
> also splits up the definitions to prevent confusion in casual observers.

Are you going to do it for the other registers so that there is
consistency?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
