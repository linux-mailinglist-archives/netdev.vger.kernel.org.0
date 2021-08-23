Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812563F4B44
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 15:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237242AbhHWNBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 09:01:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36672 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235731AbhHWNBI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 09:01:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9/tBCOrNN6HOH/HQzSZBbpwJBymsGtxfOYgu9nxvJp4=; b=BqMsOxowNDy/kNDClNSwwh6eO+
        Ijd7pC8aw3e2B+T264CWAdIrmTWbGkkRPCljTglOLTGYqbe9FXsc0doHboeo040GSTeQK07mJ2Vtc
        al2P5HlUh1X4khdI0Vg+QcAEwB1whh7HfOR4ldbw519VQHtuvGNNUG0WzT5SDNRHAwqo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mI9Ye-003T0A-B8; Mon, 23 Aug 2021 15:00:08 +0200
Date:   Mon, 23 Aug 2021 15:00:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "open list:ETHERNET PHY LIBRARY" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH net] net: phy: mediatek: add the missing suspend/resume
 callbacks
Message-ID: <YSOb2P43svWca9IJ@lunn.ch>
References: <20210823044422.164184-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823044422.164184-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 12:44:21PM +0800, DENG Qingfang wrote:
> Without suspend/resume callbacks, the PHY cannot be powered down/up
> administratively.
> 
> Fixes: e40d2cca0189 ("net: phy: add MediaTek Gigabit Ethernet PHY driver")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
