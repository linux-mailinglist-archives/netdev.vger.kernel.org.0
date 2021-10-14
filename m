Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400E242DFA9
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 18:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbhJNQwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 12:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbhJNQwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 12:52:11 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C05C061570;
        Thu, 14 Oct 2021 09:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=L8vQVL4Z/wW90mg9Pxa0X4pdgoVeP92j548BY6X1HAY=; b=gylFeuihRA/+IUrKBHTMHEbVoh
        shFKGqVcboUilOboIq8Vw9C8D944VUxvR1M79SaIepDSxHqfcu8DTW6bJDzRJqbRPgKFK4Qa/+O+9
        n1EMNhu/GGnPJQJh3eAFMbTbS/+9SVdOnZQNa9zYG6ihyH7taU/hw2AkkALOwPKeJQhA7bey3oSjj
        i1AQHQZiMMy44+grMrWtnzLFLTq/bKLQf9h78WtDRLRdJPpUTSzt6381YaU2sO03ZDKrVPS1BF4lh
        TX0xHLNDASKeh0q2YQJv3F6AGEUSToeONi/JobCNDx+R2noxUQR8I7aoqb/xdflCpHtTTLogGey+k
        ZrpHmKQg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55114)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mb3vY-0001Yl-Fo; Thu, 14 Oct 2021 17:49:56 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mb3vW-0002JY-8o; Thu, 14 Oct 2021 17:49:54 +0100
Date:   Thu, 14 Oct 2021 17:49:54 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sfp: add quirk for Finisar FTLF8536P4BCL
Message-ID: <YWhfsiA6Vngi/1l+@shell.armlinux.org.uk>
References: <20211013104542.14146-1-pmenzel@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013104542.14146-1-pmenzel@molgen.mpg.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 12:45:42PM +0200, Paul Menzel wrote:
> From: Taras Chornyi <taras.chornyi@plvision.eu>
> 
> Finisar FTLF8536P4BCL can operate at 1000base-X and 10000base-SR, but
> reports 25G & 100GBd SR in it's EEPROM.
> 
> Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
> 
> [Upstream from https://github.com/dentproject/dentOS/pull/133/commits/b87b10ef72ea4638e80588facf3c9c2c1be67b40]
> 
> Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>

Hi Paul,

Please can you send me the file resulting from:

ethtool -m ethX raw on > file

please - it will be binary data, and that is exactly what I'm after.
I would like to see what the EEPROM contains before making a decision
on this patch.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
