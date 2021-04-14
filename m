Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBA735F81A
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352337AbhDNPoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:44:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50740 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352285AbhDNPoN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 11:44:13 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lWhgD-00GiFt-4r; Wed, 14 Apr 2021 17:43:49 +0200
Date:   Wed, 14 Apr 2021 17:43:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: add
 nvmem-mac-address-offset property
Message-ID: <YHcNtdq+oIYcB08+@lunn.ch>
References: <20210414152657.12097-1-michael@walle.cc>
 <20210414152657.12097-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414152657.12097-2-michael@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 05:26:55PM +0200, Michael Walle wrote:
> It is already possible to read the MAC address via a NVMEM provider. But
> there are boards, esp. with many ports, which only have a base MAC
> address stored. Thus we need to have a way to provide an offset per
> network device.

We need to see what Rob thinks of this. There was recently a patchset
to support swapping the byte order of the MAC address in a NVMEM. Rob
said the NVMEM provider should have the property, not the MAC driver.
This does seems more ethernet specific, so maybe it should be an
Ethernet property?

	 Andrew
