Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F351B11DA5C
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 01:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731431AbfLMADf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 19:03:35 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:37932 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731205AbfLMADe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 19:03:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qvxHJslPOOm/34wIy7NYJCw9gY0qPsLHTXeHXJSu1sA=; b=QHn+fS7vDfRakKK0iSDcGbKvU
        3a747Ll1leyRbNFZZpwh9DXHXB3PVyRlPn7L1FufKjn9CWwTLmTgCcWHrO6YgjTbrCLwqqea/TVsp
        EauIIN2/HnNVq3Rn7Gu8c+J5tf43189zHl9oE8cVcU0yVAw6S5aPGNHw6LDR3scCInxJWtbbbJAq5
        NiKXrbTXL18Abaj+Q8u7CT84w4ZmFEn5ktLzyv0/qxaDcpib2Vi1i7vdYir+Q6xv1IO/HrPgDXsQc
        7VOlZOEufvfW3DayDD6qeMaUH+IdT+MqHV2D+eUXhsbfFI75iuTKh3TrfQVYMzhwE49QPRM5vzc4A
        BHy9i0fVA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:48064)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ifYQZ-0001Pt-8f; Fri, 13 Dec 2019 00:03:27 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ifYQV-0007JU-RO; Fri, 13 Dec 2019 00:03:23 +0000
Date:   Fri, 13 Dec 2019 00:03:23 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phylink: fix interface passed to mac_link_up
Message-ID: <20191213000323.GN25745@shell.armlinux.org.uk>
References: <E1ifLlX-0004U8-Of@rmk-PC.armlinux.org.uk>
 <20191212.105544.1239200588810264031.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212.105544.1239200588810264031.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 10:55:44AM -0800, David Miller wrote:
> From: Russell King <rmk+kernel@armlinux.org.uk>
> Date: Thu, 12 Dec 2019 10:32:15 +0000
> 
> > A mismerge between the following two commits:
> > 
> > c678726305b9 ("net: phylink: ensure consistent phy interface mode")
> > 27755ff88c0e ("net: phylink: Add phylink_mac_link_{up, down} wrapper functions")
> > 
> > resulted in the wrong interface being passed to the mac_link_up()
> > function. Fix this up.
> > 
> > Fixes: b4b12b0d2f02 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net")
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> Does not apply to the 'net' tree.

The reason it doesn't apply is the change from link_an_mode to
cur_link_an_mode on the preceeding line that is in net-next.
Fixing this in net is going to create another merge conflict.

Would it be better to apply this one to net-next and a similar
fix to the net tree?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
