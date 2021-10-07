Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623D0425E5E
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 23:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbhJGVCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 17:02:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55284 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231513AbhJGVCE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 17:02:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5t9Uq9pDfGhlTNstnpRIElreH30LAAQahsG93S0mqW8=; b=PP+d+28YbI6hZeLEUq8WuW2Tmt
        VECZkv2+recIqjG7oVmDJRTlqWC/lHSI4UBM5CfxuAaonRa4PNrwH95gy7OkLK9k606LTA40itT1S
        itflcBJYdlUxgghG0U9v4IfSkz7sKsSJVQpsUUUQZj0ba5klsP0M8Ao0g0NeyBeffWTY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mYaUk-009zgc-Ff; Thu, 07 Oct 2021 23:00:02 +0200
Date:   Thu, 7 Oct 2021 23:00:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcel Ziswiler <marcel@ziswiler.com>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Frank Rowand <frowand.list@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Olof Johansson <olof@lixom.net>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        soc@kernel.org
Subject: Re: [PATCH v3 3/3] ARM: dts: mvebu: add device tree for netgear
 gs110emx switch
Message-ID: <YV9f0qhwn770Hf8+@lunn.ch>
References: <20211007205659.702842-1-marcel@ziswiler.com>
 <20211007205659.702842-4-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007205659.702842-4-marcel@ziswiler.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 10:56:59PM +0200, Marcel Ziswiler wrote:
> Add the device tree for a Netgear GS110EMX switch featuring 8 Gigabit
> ports and 2 Multi-Gig ports (100M/1G/2.5G/5G/10G). An 88E6390X switch
> sits at its core connecting to two 88X3310P 10G PHYs. The control plane
> is handled by an 88F6811 Armada 381 SoC.
> 
> The following functionality is tested:
> - 8 gigabit Ethernet ports connecting via 88E6390X to the 88F6811
> - serial console UART
> - 128 MB commercial grade DDR3L SDRAM
> - 16 MB serial SPI NOR flash
> 
> The two 88X3310P 10G PHYs while detected during boot seem neither to
> detect any link nor pass any traffic.
> 
> Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
