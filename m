Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733B16CAC87
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbjC0R5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjC0R5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:57:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40E11B0
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 10:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cVJ28Y2IgdgmbzRnYRYQzSimRp8HEDsOJ9Tut0ieumM=; b=pLAIBulBqqTSUSJhItc40gJNID
        U6gEBG4cCMVrB2FdlV5kU/aFcbkb+70bVf7Y2e/XJ9GEHNnKKENYuz8/T+gUWeR6cBr4f1d8xcluR
        pEPdWMq8HIqFwEgFyKVjQByw9im424OURGYxda+6Cl8IO6/eAYykJFcVMvKlv+QXHXayNSkl7Xh93
        KP8iXDsC5KU1QWXTCv/X9wBFECGiJVCUR+CrxT+8k2vwf2XDsEkg3QqF7OhBM/AKgkU6kU9mLHXW1
        9Eni5cvbpYNFwVK+CCTH6yT/C3LS4s7nvM9vsZ9HVvQJEt2M6S7wneHpP0ZazlOdHp1QYVOm7Tuty
        u0Q0Bk9Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43278)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pgr6M-0004Ov-BT; Mon, 27 Mar 2023 18:57:50 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pgr6L-0005cw-Nf; Mon, 27 Mar 2023 18:57:49 +0100
Date:   Mon, 27 Mar 2023 18:57:49 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [RFC/RFT 02/23] net: phylink: Plumb eee_active in mac_link_up
 call
Message-ID: <ZCHZHY4/47bXoJsj@shell.armlinux.org.uk>
References: <20230327170201.2036708-1-andrew@lunn.ch>
 <20230327170201.2036708-3-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327170201.2036708-3-andrew@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 07:01:40PM +0200, Andrew Lunn wrote:
> MAC drivers need to know the result of the auto negotiation of Energy
> Efficient Ethernet. This is a simple boolean, it should be active or
> not in the MAC. Extend the mac_link_up call to pass this.
> 
> Currently the correct value should be passed, however no MAC drivers
> have been modified to actually use it. Yet.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
