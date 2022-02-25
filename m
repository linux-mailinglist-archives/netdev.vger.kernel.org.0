Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA3F4C4409
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240319AbiBYL5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 06:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiBYL5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 06:57:30 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9605E752
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 03:56:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5PCNepmBKcBrqIYcEYI4HA6q9IB+NOuUHPaU93SBuZU=; b=r2WRZ+0XqQNvtYnI4fJC66rGhP
        IgLZDlVMyV0NVtCElyjrWAIk/Lo0dTot1uuRlwjx9Jo5AGPSwFx36/nSxnEHiuTSDoQnKrhgJMWTT
        qfxjOV3kp9PJmPK0wNBYBc8HDvaRIEdm4Rgy1xwncU3LHGB9wp7KfEqQA7DV6Jxxn3EtufW08XCPc
        1j25yegTMD9LLBQfdpXzbkY8K9TWYBP/HA2X7FpM70MPH/qIKLhYt0mnyZLwTx9vr3xblpDWJPOII
        CX2+QMR11UbpW/Ek7wQKm8qNqEQsx4VCglc4FvQwV9Jr5Iaxvt6RHe3QDdbsIgpx8+3vD03F5iGAF
        l2x7ZSBA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57480)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nNZDS-0005II-0d; Fri, 25 Feb 2022 11:56:54 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nNZDR-00031s-Dq; Fri, 25 Feb 2022 11:56:53 +0000
Date:   Fri, 25 Feb 2022 11:56:53 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/6] net: dsa: sja1105: populate
 supported_interfaces
Message-ID: <YhjEBZGO2B7CpcZh@shell.armlinux.org.uk>
References: <YhjDvsSC1gZAYF74@shell.armlinux.org.uk>
 <E1nNZCc-00Ab1Q-Kg@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1nNZCc-00Ab1Q-Kg@rmk-PC.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 11:56:02AM +0000, Russell King (Oracle) wrote:
> Populate the supported interfaces bitmap for the SJA1105 DSA switch.
> 
> This switch only supports a static model of configuration, so we
> restrict the interface modes to the configured setting.
> 
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>                                Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Bl"%$y vi!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
