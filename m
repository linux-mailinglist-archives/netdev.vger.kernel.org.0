Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A992517408B
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 20:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgB1Twy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 14:52:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39098 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgB1Twy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 14:52:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KF7q+Xs+vsES1d6sA8cRPzF/eOD6wdLXYTJbXQxl+7M=; b=1dIUX2GtzOyyU+MotTDwJTHnOm
        VACw0f2DCE/q81dmSY0tA0eJPgvMbpeWX4pFKVjVCjkhdYPY0/zpBR18OW6JHbTcYxO/gv0ewX/3W
        qx+/V2AxEcTeabCxezyg7lw6Fk0CQTauN132X4bHpWMT/xizwm0LrOCjnFWagI2tlsdw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j7lgl-00067Y-P1; Fri, 28 Feb 2020 20:52:47 +0100
Date:   Fri, 28 Feb 2020 20:52:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: fix lockup on warm boot
Message-ID: <20200228195247.GH29979@lunn.ch>
References: <E1j7lU5-0003px-JX@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j7lU5-0003px-JX@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 07:39:41PM +0000, Russell King wrote:
> If the switch is not hardware reset on a warm boot, interrupts can be
> left enabled, and possibly pending. This will cause us to enter an
> infinite loop trying to service an interrupt we are unable to handle,
> thereby preventing the kernel from booting.
> 
> Ensure that the global 2 interrupt sources are disabled before we claim
> the parent interrupt.
> 
> Observed on the ZII development revision B and C platforms with
> reworked serdes support, and using reboot -f to reboot the platform.
> 
> Fixes: dc30c35be720 ("net: dsa: mv88e6xxx: Implement interrupt support.")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
