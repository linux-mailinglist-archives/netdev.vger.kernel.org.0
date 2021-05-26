Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF5C391FA9
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 20:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234650AbhEZSwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 14:52:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58816 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234611AbhEZSwq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 14:52:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lufu9izN5KFeXa2i31ylnzIhMsgQPb0wQgyqHrjCnkU=; b=pD/tjvvI1HyIpNRWooZ6nr4mhJ
        +D1brwXgnF54CMx0ODasuGkfRK5pscdgkrvt6lzsPOCkKVprVzLguzXWbvRwwzd/1GLTHl0syFk+F
        JflfMbvcxUGnM9+U0jX7IdUFugK/os6EgxU6OFtFP/gYCbvmTjpj2nppZ7r3zNK7EQ7E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1llycQ-006Ng3-HK; Wed, 26 May 2021 20:51:02 +0200
Date:   Wed, 26 May 2021 20:51:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] dt-bindings: net: Convert MDIO mux bindings to DT
 schema
Message-ID: <YK6YljEYXprM/8iD@lunn.ch>
References: <20210526181411.2888516-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526181411.2888516-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 01:14:11PM -0500, Rob Herring wrote:
> Convert the common MDIO mux bindings to DT schema.
> 
> Drop the example from mdio-mux.yaml as mdio-mux-gpio.yaml has the same one.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Ray Jui <rjui@broadcom.com>
> Cc: Scott Branden <sbranden@broadcom.com>
> Cc: bcm-kernel-feedback-list@broadcom.com
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: netdev@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Rob Herring <robh@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

> +        mdio@2 {  // Slot 2 XAUI (FM1)
> +            reg = <2>;
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +
> +            ethernet-phy@4 {
> +                compatible = "ethernet-phy-ieee802.3-c45";
> +                reg = <0>;

reg should really be 4 here. The same error existed in the .txt
version. I guess the examples are never actually verified using the
yaml?

	Andrew
