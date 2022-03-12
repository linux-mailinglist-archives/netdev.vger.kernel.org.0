Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50CE34D70BE
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 21:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbiCLUR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 15:17:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiCLUR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 15:17:27 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA241CAF0D
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 12:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cPy5CfZ4wj+f2GW3VzviHG8jwpkAZTX0xVT8wy0N5+A=; b=ONEhn+j1/Yjea0YrSP/oopl3LM
        jak1u0DiX4jqMgnTdVq2wKs7qivhx+Knk74X15ORSzaZs/Mu6NumMyNBnxx2OG43gmXQLsaP9Sb7Y
        lt09SdoY/UrmaNz/43YX8jseFQcejgmlUdlAmBQ7DqaoNPRUjRkNOMQz9iqFi/RV+sTVUj5kqjVH2
        lxt9vvUlIjCPt+fPOe0H13fiTGlD6KGCMqulwg9wgqAneIe+lttxDombYKgiz/dNXAYG/5pd2EmOo
        F6OP+fzL/Q9c1AORIfN63f3HBc9lyCO3LSQXwFgxKIJ/+KWe0IWzZE0ap49059WLEAFrvY4PW8wGa
        r6AYt2RQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57822)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nT89y-0001Xv-4T; Sat, 12 Mar 2022 20:16:17 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nT89w-0002ve-5c; Sat, 12 Mar 2022 20:16:16 +0000
Date:   Sat, 12 Mar 2022 20:16:16 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Kurt Cancemi <kurt@x64architecture.com>, netdev@vger.kernel.org,
        andrew@lunn.ch
Subject: Re: [PATCH v2 net] net: phy: marvell: Fix invalid comparison in the
 resume and suspend functions.
Message-ID: <Yiz/kEe9TkJstGR1@shell.armlinux.org.uk>
References: <20220312002016.60416-1-kurt@x64architecture.com>
 <20220312203038.5a67bdc7@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220312203038.5a67bdc7@thinkpad>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 12, 2022 at 08:30:38PM +0100, Marek Behún wrote:
> On Fri, 11 Mar 2022 19:20:19 -0500
> Kurt Cancemi <kurt@x64architecture.com> wrote:
> 
> > This bug resulted in only the current mode being resumed and suspended when
> > the PHY supported both fiber and copper modes and when the PHY only supported
> > copper mode the fiber mode would incorrectly be attempted to be resumed and
> > suspended.
> > 
> > Fixes: 3758be3dc162 ("Marvell phy: add functions to suspend and resume both interfaces: fiber and copper links.")
> > Signed-off-by: Kurt Cancemi <kurt@x64architecture.com>
> 
> Nitpick: We don't use dots to end subject lines.

However, the commit in question has, and the Fixes: quoted summary line
needs to exactly match the summary line from the commit in question. So,
the fixes line is unfortunately correct in this instance.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
