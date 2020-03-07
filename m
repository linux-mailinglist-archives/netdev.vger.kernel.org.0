Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC23017CD1A
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 10:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgCGJHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 04:07:54 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:42994 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgCGJHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 04:07:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vQ0/BJOMshU2+y9nWoPsIwqFrdMLf/hu29jqZXdPM4Y=; b=LXnF/bS2CzAIeh6/8ySFa94MB
        HbnO4XS4CFGcOhO0h+PWHQaDZsTX6622taeD2xsxs6+NsUqa8rMA0ebW0tH1De8cRz/pka/i+KCZr
        /LMm01A2dcfMpxLASUWAUM9N2YMV7P+yB4296bGIaUa6vY2A9fimSB9TNDX5OA/DzMXH+qbNRq8s2
        vVIsV8rLsqrTDdMzr3DUr5JUv+RghY57hkw67ZE5Z/DFGir6y6wYUL8cTtq3rC4AtQ5EwuWUxrAYN
        NU3YROj37D5Q/S/Nkv/aYQ1hhViqTo9n+thaS8modL1jLH6N7qyDWd21KLOzc5g/luPnd0jSLHGt9
        ST/zjr6iA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:49792)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jAVQv-0001zo-30; Sat, 07 Mar 2020 09:07:45 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jAVQr-0001Ic-3z; Sat, 07 Mar 2020 09:07:41 +0000
Date:   Sat, 7 Mar 2020 09:07:41 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        antoine.tenart@bootlin.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/3] net: phy: marvell10g: add mdix control
Message-ID: <20200307090740.GH25745@shell.armlinux.org.uk>
References: <20200303180747.GT25745@shell.armlinux.org.uk>
 <E1j9By6-0003pB-UH@rmk-PC.armlinux.org.uk>
 <20200303195352.GC1092@lunn.ch>
 <20200303.160614.1176351857930966618.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303.160614.1176351857930966618.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 04:06:14PM -0800, David Miller wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Tue, 3 Mar 2020 20:53:52 +0100
> 
> > It would be nice to have Antoine test this before it get merged, but:
> > 
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> Ok, I'll give Antoine a chance to test it out.

Hi David,

Antoine has now tested it - do I need to resubmit now?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
