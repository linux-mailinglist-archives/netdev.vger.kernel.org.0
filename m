Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0531A4A8567
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 14:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242978AbiBCNlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 08:41:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40830 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231362AbiBCNlK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 08:41:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BXahNNmj5OnglQLhBi1AiMouqbl5Gv26/bmcSlh1648=; b=grzypXEOp9DIWJlwEB1oLCHBUd
        cEMJKeLn0WT1fg78aXfybT2f72NY//bwrVVOKoKQcujG659Xkj+I5HY1OBRoeu+AssESec76igZ21
        374qnW+z0eq4TVf2CK9MDWcJy89BVhgsacQIp8pdPsRmlXtvuXnKZhTRcZ6jmpu2BZO4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nFcME-0047Ky-5u; Thu, 03 Feb 2022 14:41:06 +0100
Date:   Thu, 3 Feb 2022 14:41:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Marek Beh__n <kabel@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] net: dsa: mv88e6xxx: add
 mv88e6352_g2_scratch_port_has_serdes()
Message-ID: <YfvbcpdxWr/Y/+aj@lunn.ch>
References: <YfvYxNAkOZ6aNxql@shell.armlinux.org.uk>
 <E1nFcC4-006WMi-WE@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1nFcC4-006WMi-WE@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 03, 2022 at 01:30:36PM +0000, Russell King (Oracle) wrote:
> Read the hardware configuration to determine which port is attached
> to the serdes.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
