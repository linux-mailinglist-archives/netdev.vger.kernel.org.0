Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3A8202B21
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 16:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbgFUOop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 10:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730154AbgFUOop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 10:44:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24572C061794
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 07:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1IBNbWP2mRjOOz9isesI/n3f0uoRtNyLNZuLK82kpiE=; b=Q18f5h200wAJaJp/ECnwjlrWm
        5tcAssKBVOZ2U5JTpR3IjrJRToay8eWCWkOvEYkYj2CAuk/X2Bg426j+yVENWA7k9eyu+3PrILdJr
        1F1dlbzoX5sKBGpzrd25eIP+inFXBgpYrfVluej2bZd1/1NVtcp87VJSMi1m2dzC308MzYBI3Zb/e
        pfUfAJ6zG7BlOIVXxrst+s2tLwv5bpQJx+VkXwAJdiiKbusD5s1XvZZ34nEOey8DPab+/UIB0FfdD
        6RnogS3F0cmrw4RxCPlJxKydhofL3I2dvUCVCMRAiDYkD7tFmss0uS5FZwoIv4VWH7KH3oYOVwc1C
        5M8CYk9gg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58900)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jn1D4-0007zD-Sr; Sun, 21 Jun 2020 15:44:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jn1D3-0007bK-3n; Sun, 21 Jun 2020 15:44:37 +0100
Date:   Sun, 21 Jun 2020 15:44:37 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Jakub Kicinski <kuba@kernel.org>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: remove Felix Fietkau for the Mediatek
 ethernet driver
Message-ID: <20200621144436.GJ1605@shell.armlinux.org.uk>
References: <20200218103959.GA9487@e0022681537dd.dyn.armlinux.org.uk>
 <20200218120036.380a5a16@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <6ec21622-f9fe-8cf9-0464-7f5e4bb0a47e@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ec21622-f9fe-8cf9-0464-7f5e4bb0a47e@nbd.name>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 09:54:44AM +0100, Felix Fietkau wrote:
> On 2020-02-18 21:00, Jakub Kicinski wrote:
> > On Tue, 18 Feb 2020 10:40:01 +0000 Russell King wrote:
> >> Felix's address has been failing for a while now with the following
> >> non-delivery report:
> >> 
> >> This message was created automatically by mail delivery software.
> >> 
> >> A message that you sent could not be delivered to one or more of its
> >> recipients. This is a permanent error. The following address(es) failed:
> >> 
> >>   nbd@openwrt.org
> >>     host util-01.infra.openwrt.org [2a03:b0c0:3:d0::175a:2001]
> >>     SMTP error from remote mail server after RCPT TO:<nbd@openwrt.org>:
> >>     550 Unrouteable address
> >> 
> >> Let's remove his address from MAINTAINERS.  If a different resolution
> >> is desired, please submit an alternative patch.
> >> 
> >> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> >> ---
> >>  MAINTAINERS | 1 -
> >>  1 file changed, 1 deletion(-)
> >> 
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index a0d86490c2c6..82dccd29b24f 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -10528,7 +10528,6 @@ F:	drivers/leds/leds-mt6323.c
> >>  F:	Documentation/devicetree/bindings/leds/leds-mt6323.txt
> >>  
> >>  MEDIATEK ETHERNET DRIVER
> >> -M:	Felix Fietkau <nbd@openwrt.org>
> >>  M:	John Crispin <john@phrozen.org>
> >>  M:	Sean Wang <sean.wang@mediatek.com>
> >>  M:	Mark Lee <Mark-MC.Lee@mediatek.com>
> > 
> > Let's CC Felix, I think he's using nbd@nbd.name these days.
> Yes, my address should simply be changed to nbd@nbd.name.
> 
> Thanks,

And _still_, in next-next, four months on, your MAINTAINERS entry is
still incorrect.

Can someone please merge my patch so I'm not confronted by bounces
due to this incorrect entry?  I really don't see why I should be
the one to provide a patch to correct Felix's address - that's for
Felix himself to do, especially as he has already been made aware
of the issue.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
