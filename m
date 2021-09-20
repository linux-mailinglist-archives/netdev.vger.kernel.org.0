Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEE14113E3
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 13:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237430AbhITMBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 08:01:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49968 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237411AbhITMA7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 08:00:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zs4vYiK3dw7mCMQq4P9I5K0e42UokZRzOZPIxpkd4PE=; b=HC9nBmOOIx1RnI74xPi6+bjtI8
        8obzDlvqzI0G8DcilBY8Z7/Bb3RaSb01BgRsJdFA1VIjwdiyIQWyqIMNikNyfp+JuNqWi83B0h+hL
        lTtl1BQPVNPHGkAUDuF/7EP4vUEmSJcziKOrzlBBwZAZ116RQLQQnNpyzslYbletrUHw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mSHxA-007UZU-GM; Mon, 20 Sep 2021 13:59:20 +0200
Date:   Mon, 20 Sep 2021 13:59:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        linux@armlinux.org.uk, f.fainelli@gmail.com,
        alexandre.belloni@bootlin.com, vladimir.oltean@nxp.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH net-next 02/12] net: phy: mchp: Add support for
 LAN8804 PHY
Message-ID: <YUh3mP9pcG4Elam7@lunn.ch>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
 <20210920095218.1108151-3-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920095218.1108151-3-horatiu.vultur@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 11:52:08AM +0200, Horatiu Vultur wrote:
> The LAN8804 SKY has same features as that of LAN8804 SKY except that it
> doesn't support 1588, SyncE or Q-USGMII.
> 
> This PHY is found inside the LAN966X switches.

Please add the new PHY to the micrel_tbl[].

       Andrew
 
