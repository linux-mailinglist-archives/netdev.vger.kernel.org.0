Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0CC30ECB
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 15:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfEaNZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 09:25:23 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:60290 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfEaNZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 09:25:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=JNVjDJnWh24XETNeTTz0kr95SUG1MMZVr9hLM2Vjiuk=; b=hp4DjpLrUzF3KsPVsBuss1lXq
        YdXw25+DNru59I/TwzY1bRODEhq3O4gGIewmT3NRU+spvmFe4sVu3DfWCjgSvwwto8tAZAe9sp61J
        gzufr6tcpGvp0lxblOUBLSjOZsLCKV6eP2Mcgv6C8QX6h7EEaRu0aEDHoYES1vb5z+nA616NaertB
        45Wr6t6mApmzoeQt87R2rbBYdQAX9PWqlXpyhOz5uCMOXko8eiWkwuGRkMEFxI2R1gwxyYyZkK6zQ
        5zXWOnD/rGUyqCKc3B69iuutl+UdxKc99DVqexZdRQ++WfzUrapIEJTXJTUnUOBgK5Sr8dFlWuf3x
        qcenWfiwQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52748)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hWhX4-0000zY-7p; Fri, 31 May 2019 14:25:18 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hWhX1-0006NN-Qh; Fri, 31 May 2019 14:25:15 +0100
Date:   Fri, 31 May 2019 14:25:15 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phylink: ensure consistent phy interface mode
Message-ID: <20190531132515.6hc4myubgg3svvrb@shell.armlinux.org.uk>
References: <E1hVYO9-000584-J6@rmk-PC.armlinux.org.uk>
 <20190531130226.GE18608@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531130226.GE18608@lunn.ch>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 03:02:26PM +0200, Andrew Lunn wrote:
> On Tue, May 28, 2019 at 10:27:21AM +0100, Russell King wrote:
> > Ensure that we supply the same phy interface mode to mac_link_down() as
> > we did for the corresponding mac_link_up() call.  This ensures that MAC
> > drivers that use the phy interface mode in these methods can depend on
> > mac_link_down() always corresponding to a mac_link_up() call for the
> > same interface mode.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Hi Andrew,

davem already applied this patch a couple of days ago, since it is a
dependency for other patches.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
