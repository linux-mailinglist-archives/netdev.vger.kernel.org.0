Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D1D462F59
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 10:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240038AbhK3JRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 04:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239975AbhK3JRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 04:17:13 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7C6C061574;
        Tue, 30 Nov 2021 01:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vfVip3MECDMyIeGOjjxOzB5Bg6GorsBInxU7fF3JLNk=; b=DrWmzB52bwYOVZnn9XW/xn966p
        wM8uPLC9lMkhhsGtHmuQQcA16+MZIb95IyR8S+DdigP9XAOJRJqOQme4d/z5FC7AJb6KyB2k04KwH
        Gy/Ut0u3JjGf7IsuOuAuchiQRnxAeFgqVXKO2KMgu+/10xTE+wW0yRrvWd4N56l85f6YrZj6VZ4mm
        s9iNaNYmwIjxEYgSFVrATGdILbxl4Vs4wQSWxzHBTgnI6dqGpxFjS3pFtVksdUCh3d8UpnDPphthC
        ubVWpsxA2OhjBreggjgn0l+7Q7iqwBGI8jQ5FPRp5XGPHptTY747JizcQicCp95XptVYPaMsi4c/3
        SR8sXNug==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55972)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mrzCk-0006eg-Ss; Tue, 30 Nov 2021 09:13:38 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mrzCh-0006vi-Rz; Tue, 30 Nov 2021 09:13:35 +0000
Date:   Tue, 30 Nov 2021 09:13:35 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Yinbo Zhu <zhuyinbo@loongson.cn>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v3 1/2] modpost: file2alias: make mdio alias configure
 match mdio uevent
Message-ID: <YaXrP1AyZ3AWaQzt@shell.armlinux.org.uk>
References: <1638260517-13634-1-git-send-email-zhuyinbo@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1638260517-13634-1-git-send-email-zhuyinbo@loongson.cn>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 04:21:56PM +0800, Yinbo Zhu wrote:
> The do_mdio_entry was responsible for generating a phy alias configure
> that according to the phy driver's mdio_device_id, before apply this
> patch, which alias configure is like "alias mdio:000000010100000100001
> 1011101????", it doesn't match the phy_id of mdio_uevent, because of
> the phy_id was a hexadecimal digit and the mido uevent is consisit of
> phy_id with the char 'p', the uevent string is different from alias.
> Add this patch that mdio alias configure will can match mdio uevent.

This is getting rediculous. You don't appear to be listening to the
technical feedback on your patches, and are just reposting the same
patches. I don't see any point in giving the same feedback, so I'll
keep this brief for both patches:

NAK.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
