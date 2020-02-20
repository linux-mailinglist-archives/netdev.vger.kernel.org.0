Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 688FA165A2E
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 10:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgBTJ3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 04:29:05 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57156 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbgBTJ3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 04:29:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=oyYeAcyFCFN/ozseNMQ3BFdmkcak6a7rBNc1Z7ew3Qw=; b=1asd5m46jHRZGpKmeLcMsHOGe
        ozGCh4zCKD7PJyEvTDNbNYsQtAAI0eXS/tyXoPIq6DvbWSeg49RTO++lZB7rsUD9d5UwPFQqmUlGm
        epMJ4ATKPIPBxFjIw83tF5OYzmMDdECSEzSoU+Aeshabdh84dgrdZ7drcZOFZcOMtwNYTCVdTxH2T
        llbpkr/uYphewFyxLVUy/bjguK2Bd0iJiwuF3HxEkmCfLxxTfcEkdSOxxWpGGBekT6Nr/Olt+qzxd
        NTRcXzr/GN56HyrJmSv7Xq72Nooi/fQbwPCr9un2Zu54t6Xwf4b/FBe6ONwHX+cRKjvAlxb0RUnJf
        YKViaBuUg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54460)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j4i8Z-0002O0-I8; Thu, 20 Feb 2020 09:28:51 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j4i8V-0002It-W1; Thu, 20 Feb 2020 09:28:48 +0000
Date:   Thu, 20 Feb 2020 09:28:47 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Jakub Kicinski <kuba@kernel.org>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: remove Felix Fietkau for the Mediatek
 ethernet driver
Message-ID: <20200220092847.GT25745@shell.armlinux.org.uk>
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

Please send a patch to that effect.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
