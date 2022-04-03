Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B574F0C40
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 21:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357034AbiDCTDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 15:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiDCTDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 15:03:33 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E9D369C3;
        Sun,  3 Apr 2022 12:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=K3d1qBuy7MJtwG6Zn9t9UXN1/76SstYxaTumemvMUcw=; b=eAJGKiESBQGu1X8y5Wlu+0i2aR
        tPTBAvvx46UzcSKsfrzsOcvQ5D952+IUBIqR1xdY8cD+Aodj9jSZV4ZMBAzqsg60USMFfgr9+ScTS
        LsGSKayxtXQdM3XhZM0sbiudxLJoQqi1AMQFEGqi1RKrY3bVIO4B+NCwAEcEBpOug9MPl+YVJnsw9
        /GyIplKBAQhxbjh1NN5guAYYoh7ufXGZ81htkOIfEV+Qgl6Q6mPRfTH+ED+2dP0cwjK98QjzJfnc/
        jvXlvLJ/5/PdYOJRaUgJfwEIxTn1BpxyLxYTxOKcH7VjmA11IYSiwDT+xnxKnO4APgaikt4Wohq/i
        vxgekIEQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58110)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nb5Tk-00084R-F8; Sun, 03 Apr 2022 20:01:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nb5Th-0002Ur-Vo; Sun, 03 Apr 2022 20:01:33 +0100
Date:   Sun, 3 Apr 2022 20:01:33 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Stijn Tintel <stijn@linux-ipv6.be>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pali@kernel.org, kabel@kernel.org, pabeni@redhat.com,
        kuba@kernel.org, davem@davemloft.net, hkallweit1@gmail.com,
        andrew@lunn.ch
Subject: Re: [PATCH] net: phy: marvell: add 88E1543 support
Message-ID: <YknvDRbRznWZpstM@shell.armlinux.org.uk>
References: <20220403172936.3213998-1-stijn@linux-ipv6.be>
 <YknlRh7MLgLllb9q@shell.armlinux.org.uk>
 <fa04f389-df01-4838-7304-2fb43b919b98@linux-ipv6.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa04f389-df01-4838-7304-2fb43b919b98@linux-ipv6.be>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 03, 2022 at 09:30:06PM +0300, Stijn Tintel wrote:
> On 3/04/2022 21:19, Russell King (Oracle) wrote:
> > Hi,
> >
> > On Sun, Apr 03, 2022 at 08:29:36PM +0300, Stijn Tintel wrote:
> >> Add support for the Marvell Alaska 88E1543 PHY used in the WatchGuard
> >> Firebox M200 and M300.
> > Looking at the IDs, this PHY should already be supported - reporting as
> > an 88E1545. Why do you need this patch?
> >
> Thanks for pointing that out, you're right. Please disregard the patch. 
> Would it be acceptable to change the name member to "Marvell
> 88E1543/88E1545" to make this more obvious?

Unfortuantely not, the driver name is used in sysfs, and as I'm sure
you're aware, "/" is a pathname element separator and thus can't be
used.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
