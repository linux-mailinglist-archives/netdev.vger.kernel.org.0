Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5FE47E861
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 20:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350047AbhLWTcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 14:32:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40820 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350022AbhLWTcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Dec 2021 14:32:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GTJhaj2XCJscWkNa8lKeeUxD0omZidYOBZ+2c/Vg/no=; b=1/yxUF96lAwfOfZzel2ujl/6ug
        aZx4seCY/5ibhrMZ+mEdvMlMN5+tVOhjVYxQNqqInie4nk+K61GS85UJXRGT9LWFNWDx8etExiSEZ
        Qay0a7rnCaGunGW3SBkZR1nukreOndyGkNNL5SwlToEmXTMqq8BgPP9+ZK1cjIUJLM8g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n0ToT-00HJzO-HZ; Thu, 23 Dec 2021 20:31:41 +0100
Date:   Thu, 23 Dec 2021 20:31:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dt-bindings: net: dsa: Fix realtek-smi example
Message-ID: <YcTOnYFKpYOYiRrN@lunn.ch>
References: <20211223181741.3999-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211223181741.3999-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 23, 2021 at 10:17:41AM -0800, Florian Fainelli wrote:
> The 'ports' node is not supposed to have a 'reg' property at all, in
> fact, doing so will lead to dtc issuing warnings looking like these:
> 
> arch/arm/boot/dts/bcm47094-asus-rt-ac88u.dts:109.4-14: Warning (reg_format): /switch/ports:reg: property has invalid length (4 bytes) (#address-cells == 2, #size-cells == 1)
> arch/arm/boot/dts/bcm47094-asus-rt-ac88u.dtb: Warning (pci_device_reg): Failed prerequisite 'reg_format'
> arch/arm/boot/dts/bcm47094-asus-rt-ac88u.dtb: Warning (pci_device_bus_num): Failed prerequisite 'reg_format'
> arch/arm/boot/dts/bcm47094-asus-rt-ac88u.dtb: Warning (i2c_bus_reg): Failed prerequisite 'reg_format'
> arch/arm/boot/dts/bcm47094-asus-rt-ac88u.dtb: Warning (spi_bus_reg): Failed prerequisite 'reg_format'
> arch/arm/boot/dts/bcm47094-asus-rt-ac88u.dts:106.9-149.5: Warning (avoid_default_addr_size): /switch/ports: Relying on default #address-cells value
> arch/arm/boot/dts/bcm47094-asus-rt-ac88u.dts:106.9-149.5: Warning (avoid_default_addr_size): /switch/ports: Relying on default #size-cells value
> 
> Fix the example by remove the stray 'reg' property.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Fixes: 3b3b6b460f78 ("net: dsa: Add bindings for Realtek SMI DSAs")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
