Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D963325DA84
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 15:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730698AbgIDNxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 09:53:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42974 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730690AbgIDNxJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 09:53:09 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kEC99-00DCbH-FY; Fri, 04 Sep 2020 15:52:55 +0200
Date:   Fri, 4 Sep 2020 15:52:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Helmut Grohne <helmut.grohne@intenta.de>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: microchip: look for phy-mode in port nodes
Message-ID: <20200904135255.GM3112546@lunn.ch>
References: <20200824.153738.1423061044322742575.davem@davemloft.net>
 <20200904081438.GA14387@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904081438.GA14387@laureti-dev>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +			dev_warn(dev->dev,
> +				 "Using legacy switch \"phy-mode\" missing on port %d node. Please update your device tree.\n",

That message seems mangled.

> +			if (!p->interface) {
> +				if (dev->compat_interface) {
> +					dev_warn(dev->dev,
> +						 "Using legacy switch \"phy-mode\" missing on port %d node. Please update your device tree.\n",
> +						 i);

Same warning again.

     Andrew
