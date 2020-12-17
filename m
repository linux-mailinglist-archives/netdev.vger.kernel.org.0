Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390452DD044
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 12:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgLQLXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 06:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbgLQLXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 06:23:02 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22885C061794;
        Thu, 17 Dec 2020 03:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1aCEEVpoJd1AIGaTr9ZimyjwtCpcRYK51chuyXemG1s=; b=F7jvY4ne31zP/fYF9eWsBaklJ
        6xirSytfI4FVqQf3lEPYxOvCTWDH/DSwogEccpVHKdyOe2+Ud6bImMjqZmIWw6EeENyb3KF9kWmyN
        l4y8AG6GpSDNOEtsWmbNCVFbsb37CwXcy2CWeuwjhiQ6TZ1wq1yU4Z1a0fmCbrRfk2uUTcRc9+Pcc
        WrI9wQ2oUoXZlx4twz/Enp7XdL7GymdPs9xrKXk70EJ6Fmin9xiYE41GRvYN0q7KTxCzB0UwgLc9D
        tQb8LjQXAz6LVEuliNLthlYKNmsp1Ay6d+btYJHbLi7q7I19yIgE4gdDGw7U0nzlUZEX1Na0BDNPi
        x05tTR73A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44306)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kprMG-0004MK-Ni; Thu, 17 Dec 2020 11:22:08 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kprMB-0006qr-Ie; Thu, 17 Dec 2020 11:22:03 +0000
Date:   Thu, 17 Dec 2020 11:22:03 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Stefan Chulski <stefanc@marvell.com>,
        netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, nadavh@marvell.com,
        Yan Markman <ymarkman@marvell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net v2 2/2] net: mvpp2: disable force link UP during port
 init procedure
Message-ID: <20201217112203.GY1551@shell.armlinux.org.uk>
References: <1608198007-10143-1-git-send-email-stefanc@marvell.com>
 <1608198007-10143-2-git-send-email-stefanc@marvell.com>
 <CAPv3WKcwT9F3w=Ua-ktE=eorp0a-HPvoF2U-CwsHVtFw6GKOzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPv3WKcwT9F3w=Ua-ktE=eorp0a-HPvoF2U-CwsHVtFw6GKOzQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 12:00:49PM +0100, Marcin Wojtas wrote:
> Hi Stefan,
> 
> czw., 17 gru 2020 o 10:42 <stefanc@marvell.com> napisał(a):
> >
> > From: Stefan Chulski <stefanc@marvell.com>
> >
> > Force link UP can be enabled by bootloader during tftpboot
> > and breaks NFS support.
> > Force link UP disabled during port init procedure.
> >
> > Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> > ---
> 
> What are the updates against v1? Please note them in this place for
> individual patches and list all in the cover letter (in case sending a
> group of patches).

It seems the only reason this has been resent is because it's
(incorrectly) part of a series that involved a change to patch 1
(adding the Fixes: tag).

As this is a stand-alone fix, it shouldn't be part of a series unless
there really is some kind of dependency with the other patch(es) of
that series.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
