Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A462F08F9
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 19:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbhAJSJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 13:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbhAJSJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 13:09:45 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF67CC061786;
        Sun, 10 Jan 2021 10:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qJCcM54W9qdHdCSey9uWoXcvCPstk8bBCLXY+rBiqs0=; b=1TKCY7uCdK1zl8PvHZhNZGHYE
        vVDAckFyLE82h8lesuW3acEcCNCDjeUTatpU1JDGzSHCPRY0fOLh/GD2BjVDKEnQV8d/MiPr5kyXW
        f1OPihZjSKBn7P+7KT6nkNEydkIE7SOihLaGguBktqYfS0BFcHQERbwqumwwM6LhOlHrdNkwqNcc+
        x3dtikq3yIQ9wumDuKErYVC0RIgtwOlSawcr8/rfdDc12z61lFhMMm52C5UGlUGGLqMnqbHAqPOB7
        rgcotsZM5ye7Ixs6rzG0JSufJNtk1B/gzRP/S3aWivOGPMjdYH8rOrx5d/IH6QJNzOj4T+tweZsbR
        zxzG7y45Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46250)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kyf9D-000654-A1; Sun, 10 Jan 2021 18:09:03 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kyf9C-0004Q1-Kj; Sun, 10 Jan 2021 18:09:02 +0000
Date:   Sun, 10 Jan 2021 18:09:02 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org
Subject: Re: [PATCH RFC net-next  12/19] net: mvpp2: enable global flow
 control
Message-ID: <20210110180902.GI1551@shell.armlinux.org.uk>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <1610292623-15564-13-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1610292623-15564-13-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 05:30:16PM +0200, stefanc@marvell.com wrote:
> +		/* Enable global Flow Control only if hanler to SRAM not NULL */

I think this comment needs fixing. I'm not sure what a "hanler" is,
and "handler" doesn't make sense here.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
