Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCE63A5006
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 20:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbhFLSIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 14:08:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60962 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhFLSIA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Jun 2021 14:08:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/35SgsFs9hgahTBuNzkzeWoHQo3+tcwGW6U2uOxlfB4=; b=a8ArgNX3CuWQyNAXlJiyw8yhgI
        4AQ20doaRWuLLoU+aRC9ETqgIgyUYRcNKGcD4y9UZOp+p42DcApLN/2uFYWVNIANwjnATZtvWiiJ1
        5bcucxdX9cwcgiMAE+TEczbA0x8iZTEA+HdSbRjcbQqeRU73LnI3/TjGC57koHWJRL3o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ls810-0091I4-BS; Sat, 12 Jun 2021 20:05:50 +0200
Date:   Sat, 12 Jun 2021 20:05:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>
Subject: Re: [PATCH net-next 1/4] dt-bindings: net: Add 25G BASE-R phy
 interface
Message-ID: <YMT3fm3BhOtn7FY6@lunn.ch>
References: <20210611125453.313308-1-steen.hegelund@microchip.com>
 <20210611125453.313308-2-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611125453.313308-2-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 02:54:50PM +0200, Steen Hegelund wrote:
> Add 25gbase-r PHY interface mode.
> 
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
