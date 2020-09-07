Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CED925FACC
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 14:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgIGM4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 08:56:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46950 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729383AbgIGM4P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 08:56:15 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kFGgd-00Dc6L-QP; Mon, 07 Sep 2020 14:55:55 +0200
Date:   Mon, 7 Sep 2020 14:55:55 +0200
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
Message-ID: <20200907125555.GO3164319@lunn.ch>
References: <20200824.153738.1423061044322742575.davem@davemloft.net>
 <20200904081438.GA14387@laureti-dev>
 <20200904135255.GM3112546@lunn.ch>
 <20200907061533.GA2727@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907061533.GA2727@laureti-dev>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 07, 2020 at 08:15:33AM +0200, Helmut Grohne wrote:
> Hi Andrew,
> 
> On Fri, Sep 04, 2020 at 03:52:55PM +0200, Andrew Lunn wrote:
> > > +			dev_warn(dev->dev,
> > > +				 "Using legacy switch \"phy-mode\" missing on port %d node. Please update your device tree.\n",
> 
> This is inside ksz8795_port_setup.
> 
> > That message seems mangled.
> 
> I'm not sure that I understand what you are objecting to here.

Hi Helmut

The grammar seems wrong. 

"Using legacy switch \"phy-mode\" because \"phy-mode\" missing from port %d node. "
"Please update your device tree.\n"

	Andrew
