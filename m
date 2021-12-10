Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F34746F83B
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 02:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235095AbhLJBI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 20:08:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhLJBI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 20:08:57 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20D8C061746;
        Thu,  9 Dec 2021 17:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Ihe3pIT/HCvWCFS26J8tbL2HwT8v/yss1KgbxxM0/KE=; b=iNfuIt6MzxCnF5qWxG1iDHwdMZ
        tlmnN/eIodp7R/NvgSt1Ia9LJI6NMDjdRuImD8PXs/Z1ovurCRWqvvAkhaqRTUbjofZb8IXDdia2F
        GGETND5lim/jmjI04vvERRHZ+3EVPXVBojJHp3BLGkxAzsOkp2Lm8fOa6I26Nknpjs17Fk01qMdBL
        seiWaCjevuerLrrWRCfpJIrz9ovkEpoH8Sa/1RW61salFSpjEIk1H9BilhYZKgLnTEET/17Y5ovJh
        wRjkk6f8qeGepr7+QfH2WFvcu5hQxEmycutYGKXutLyt5vhryzr1q3rmYYrdvlxLnfUlODw2VOAlZ
        vzjF76VQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56212)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mvULc-0000bx-Ur; Fri, 10 Dec 2021 01:05:16 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mvULa-0007gx-Ag; Fri, 10 Dec 2021 01:05:14 +0000
Date:   Fri, 10 Dec 2021 01:05:14 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v3] net: phylink: Add helpers for c22 registers
 without MDIO
Message-ID: <YbKnypYPOdhjsywn@shell.armlinux.org.uk>
References: <20211119155809.2707305-1-sean.anderson@seco.com>
 <b0b80264-0a1d-f67b-b1ca-204857352b31@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0b80264-0a1d-f67b-b1ca-204857352b31@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 05:26:16PM -0500, Sean Anderson wrote:
> ping?

Hi Sean,

There is a version of the patch that is in net-next:

291dcae39bc4 net: phylink: Add helpers for c22 registers without MDIO

Looking at the date in that commit, it ties up with the date in your
v3 patch, but patchwork has been set to "Not applicable" - I think
someone didn't update patchwork correctly.

I think we can assume it has been merged, but incorrectly marked in
patchwork.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
