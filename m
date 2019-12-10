Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E29DD118EDE
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbfLJRVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:21:41 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:54704 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727553AbfLJRVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:21:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=EszEF+NWqacihph1Q06qnn0xOrM62nzVpSJqfh1GZgY=; b=aE3vSSWUxtANhanaDabLqOsng
        x+GFWjJ4pdfdMy3/DylUUqg/T5WauUbPZf+nvdneHm/0WZMJQ2xosXmQQdSCBFvfx4FMVAr43xCEq
        DtlnK2xGhuV+IOWHFA24u5eRnaoyf/P/bc1jQcLkDETtVv1qPRx1Jg0ttPj+BAvU505dkHGuxHiCm
        DsZCRq+5SOVtq2s2M2Lljfl7m0mTQqFzvLno/8KATdMJNnR1Jo8Dev9cmTUek4++DRGX5+TB8AXKs
        pyykQTUapJvmRCNh6PoBoSrB0e3xUPDBggFrqbSHb67w7Lbkz/PX2+5liDhhZmfa7yyT3p2SERojJ
        vkzKUwt7A==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:39504)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iejCX-0002pq-CF; Tue, 10 Dec 2019 17:21:33 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iejCV-0004ow-1z; Tue, 10 Dec 2019 17:21:31 +0000
Date:   Tue, 10 Dec 2019 17:21:31 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 03/14] net: sfp: add more extended compliance
 codes
Message-ID: <20191210172130.GX25745@shell.armlinux.org.uk>
References: <20191209151553.GP25745@shell.armlinux.org.uk>
 <E1ieKo3-0004um-R5@rmk-PC.armlinux.org.uk>
 <20191210165716.GI27714@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210165716.GI27714@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 05:57:16PM +0100, Andrew Lunn wrote:
> On Mon, Dec 09, 2019 at 03:18:39PM +0000, Russell King wrote:
> > SFF-8024 is used to define various constants re-used in several SFF
> > SFP-related specifications.  Split these constants from the enum, and
> > rename them to indicate that they're defined by SFF-8024.
> > 
> > Add and use updated SFF-8024 extended compliance code definitions for
> > 10GBASE-T, 5GBASE-T and 2.5GBASE-T modules.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> > +	case SFF8024_CONNECTOR_SG: /* guess */
> 
> Does SFF8024 say anything about this, or is it still a guess?

SFF-8024 doesn't describe the connectors.  It just gives a table:

            09h        MU (Multiple Optical)
	    0Ah        SG
            0Bh        Optical Pigtail
	    0Ch        MPO 1x12 (Multifiber Parallel Optic)

Searching for "SFP SG connector" or "fiber SG connector" on google
doesn't provide anything useful.  So yes, it remains a guess until
someone can say what it actually is.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
