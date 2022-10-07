Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3315F793D
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 15:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiJGNuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 09:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiJGNue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 09:50:34 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02359DF9C
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 06:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=w6Lr3nOIe0/HPba6CG4rMSemtrAtDJOfzoJKXgOiVAc=; b=ZCytZSDf3JdXhrC9r/lt69XCsH
        +XqtMuFVuc9xdN71Z87+MwJk6UUtnZC1zm4oMTsL+Wx6cbJKo0jcAlWmEn0+msJ5YonY+Qxdi0e7X
        nrwSlNLYEF0qZc9dXdzRMUalA5KRpWNu1QEd9QumcvRoGYjSpBQIvFP61MDHG2BGJbH//yFAakdlB
        EOfr0ofRXd0nkzNOSdjPC1OioXgZnCWPOXEbDqQnSkkN6MAI7cbsWYYmL4Obk5UwkbmnJeUKX7FS6
        +YAWRBz6Y2iVZjQbtLPxiZ/8vsuhJY/8P/k11nhyHfnYAIBOhKQciT4TOPVAz+koByEnNS25ZX2tH
        WvHGcOjw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34622)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ognkD-0002Uj-0C; Fri, 07 Oct 2022 14:50:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ognkB-0007SP-52; Fri, 07 Oct 2022 14:50:27 +0100
Date:   Fri, 7 Oct 2022 14:50:27 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next] net: sfp: fill also 5gbase-r and 25gbase-r
 modes in sfp_parse_support()
Message-ID: <Y0Auo0tL8EmCa+rd@shell.armlinux.org.uk>
References: <20221007084844.20352-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221007084844.20352-1-kabel@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 07, 2022 at 10:48:44AM +0200, Marek Behún wrote:
> Fill in also 5gbase-r and 25gbase-r PHY interface modes into the
> phy_interface_t bitmap in sfp_parse_support().
> 
> Fixes: fd580c983031 ("net: sfp: augment SFP parsing with phy_interface_t bitmap")
> Signed-off-by: Marek Behún <kabel@kernel.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
