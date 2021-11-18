Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDC8455821
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 10:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245203AbhKRJhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 04:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245187AbhKRJhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 04:37:21 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B20C061764;
        Thu, 18 Nov 2021 01:34:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zvxyp/stBTTOZioY6Mktpyy1UQUpIf7tyfN5j1c9P00=; b=MDyTTys/bpFTWy0xl/aZPUinYa
        RnFlWEdneZT7dzA8fdvu1JwuJB10WXM1bbGgYzUGZsEMpDtz+eBgHoeCbFoPU8rFGGz9f0Lc5ZRTr
        cYBtfcmj+CUI6nz/SHjAkpcuk3Kaie4/b3T77vDCV0Mo4Ts4bLXcA1qKr1wi11joLuw4Rd1K1G8Br
        mrE/0KAu8CoSgXDXsEdfZB36p17fncijE5NOcFukw+POPC0R0gl3N/SC+7XbRnIbQ9syBUunMRzEk
        pCm0vu1CtpDkhB4Wt1RP5Nul7I2ISv/cEDzVV6zZ/fq28yOr6O1yaNqhl8hgJXOY082aN4GSVn6YJ
        NSIiUZig==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55704)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mndoC-0002lH-As; Thu, 18 Nov 2021 09:34:20 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mndoB-0003oS-UO; Thu, 18 Nov 2021 09:34:19 +0000
Date:   Thu, 18 Nov 2021 09:34:19 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 7/8] net: phy: marvell10g: Use tabs instead of
 spaces for indentation
Message-ID: <YZYeG/9AVU4MqbN7@shell.armlinux.org.uk>
References: <20211117225050.18395-1-kabel@kernel.org>
 <20211117225050.18395-8-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211117225050.18395-8-kabel@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 11:50:49PM +0100, Marek Behún wrote:
> Some register definitions were defined with spaces used for indentation.
> Change them to tabs.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
