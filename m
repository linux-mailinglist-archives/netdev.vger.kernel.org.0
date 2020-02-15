Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB5515FF2B
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 17:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgBOQMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 11:12:08 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47826 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgBOQMI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 11:12:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tnk0fGTywzPAA90j8Sm2ZZbY+ZC71gpvf+/OpGXzqJ0=; b=ElcycqFXOt8Cw2OyXNNzC5Kxy5
        qxTbItQk+y8sYRhIyXDRLINHcMMzcWLwrMQwrUdwbdl0WVpDvXfW4wZQHa5yxnG9pWNufYrBmgHCv
        jqpCPjI2nU+7l1bLY1JyBrdLQBGY3yOwTMG9kxz1Zikp9dgz132mK7yKM9zQ7gH5Wi3Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j3032-0004lK-9t; Sat, 15 Feb 2020 17:12:04 +0100
Date:   Sat, 15 Feb 2020 17:12:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: phy: broadcom: Wire suspend/resume for
 BCM54810
Message-ID: <20200215161204.GB8924@lunn.ch>
References: <20200214233853.27217-1-f.fainelli@gmail.com>
 <20200214233853.27217-4-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214233853.27217-4-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 03:38:53PM -0800, Florian Fainelli wrote:
> The BCM54810 PHY can use the standard BMCR Power down suspend, but needs
> a custom resume routine which first clear the Power down bit, and then
> re-initializes the PHY. While in low-power mode, the PHY only accepts
> writes to the BMCR register. The datasheet clearly says it:
> 
> Reads or writes to any MII register other than MII Control register
> (address 00h) while the device is in the standby power-down mode may
> cause unpredictable results.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
