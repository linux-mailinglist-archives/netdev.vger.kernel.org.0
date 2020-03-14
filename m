Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BED7185818
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbgCOByc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:54:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36040 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727123AbgCOByb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Mar 2020 21:54:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5jlhMOC+UmD+9/ZHo+msHHcbWx1FFxcsO03ey2pettQ=; b=wOVkaSbsQtaOmFpVQv94waqQw9
        693RCNHtvmOr31UvxdYqSKqfrsjRgz5WMBmE42u8twkt30o9x1f5JSqvFEiOQZvUpQ9NHnCuXjnGn
        BPwZfpkYZM0ngmZ3+xYT7cxfV+kRzVMEr0y0iOUFzGOsP+RhAXzioJqO5s1ZtSuEz9pA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jDBqO-0001gQ-0x; Sat, 14 Mar 2020 19:49:08 +0100
Date:   Sat, 14 Mar 2020 19:49:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 6/8] net: dsa: mv88e6xxx: combine port_set_speed
 and port_set_duplex
Message-ID: <20200314184908.GJ5388@lunn.ch>
References: <20200314101431.GF25745@shell.armlinux.org.uk>
 <E1jD3ph-0006Dq-Pd@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jD3ph-0006Dq-Pd@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 14, 2020 at 10:15:53AM +0000, Russell King wrote:
> Setting the speed independently of duplex makes little sense; the two
> parameters result from negotiation or fixed setup, and may have inter-
> dependencies. Moreover, they are always controlled via the same
> register - having them split means we have to read-modify-write this
> register twice.
> 
> Combine the two operations into a single port_set_speed_duplex()
> operation. Not only is this more efficient, it reduces the size of the
> code as well.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
