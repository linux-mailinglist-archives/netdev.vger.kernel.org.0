Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A581427218
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 00:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbfEVWOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 18:14:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44026 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728027AbfEVWOS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 18:14:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=M6/V4Ln58iaBP2dK063ZH7jTVRU4CX4qclMImPWh5nw=; b=Fpp15kRuim/5sce+Py/VvJm/P9
        o5vfbEaWOSiw1QB7NVZp2lu/rBf5a7dlQkLz6oDISh/ch+Z2vzGymLYVHrUdROJpgEfo50ompuzia
        fxXDrjEixxycy51IgSWlT2Yx3Cnyoq/fxijCw7t2Srw/hI6WSYhdsZ42mIc8I0WDIqsk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hTZUt-0005JA-FC; Thu, 23 May 2019 00:14:07 +0200
Date:   Thu, 23 May 2019 00:14:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Subject: Re: [PATCH V5] net: phy: tja11xx: Add TJA11xx PHY driver
Message-ID: <20190522221407.GB15257@lunn.ch>
References: <20190517235123.32261-1-marex@denx.de>
 <20190518141456.GK14298@lunn.ch>
 <f5ab2d22-a7ab-aa6d-77e1-a3a73e334b04@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5ab2d22-a7ab-aa6d-77e1-a3a73e334b04@denx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 11:48:06PM +0200, Marek Vasut wrote:
> On 5/18/19 4:14 PM, Andrew Lunn wrote:
> > On Sat, May 18, 2019 at 01:51:23AM +0200, Marek Vasut wrote:
> >> Add driver for the NXP TJA1100 and TJA1101 PHYs. These PHYs are special
> >> BroadRReach 100BaseT1 PHYs used in automotive.
> > 
> > Hi Marek
> > 
> >> +	}, {
> >> +		PHY_ID_MATCH_MODEL(PHY_ID_TJA1101),
> >> +		.name		= "NXP TJA1101",
> >> +		.features       = PHY_BASIC_T1_FEATURES,
> > 
> > One thing i would like to do before this patch goes in is define
> > ETHTOOL_LINK_MODE_100baseT1_Full_BIT in ethtool.h, and use it here.
> > We could not do it earlier because were ran out of bits. But with
> > PHYLIB now using bitmaps, rather than u32, we can.
> 
> So now that "[PATCH net-next 0/2] net: phy: T1 support" is posted, does
> this patch require any change ? I don't think it does ?

Hi Marek

In the end, no it does not need any changes because of my patchset.

   Andrew
