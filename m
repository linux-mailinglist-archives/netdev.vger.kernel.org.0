Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737942942B8
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 21:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437966AbgJTTHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 15:07:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37134 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437922AbgJTTHW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 15:07:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUwyb-002hWt-QH; Tue, 20 Oct 2020 21:07:17 +0200
Date:   Tue, 20 Oct 2020 21:07:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/3] dt-bindings: dp83td510: Add binding for
 DP83TD510 Ethernet PHY
Message-ID: <20201020190717.GK139700@lunn.ch>
References: <20201020171221.730-1-dmurphy@ti.com>
 <20201020171221.730-3-dmurphy@ti.com>
 <20201020185601.GJ139700@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020185601.GJ139700@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Humm. Are 1v and 2.4v advertised so it can be auto negotiated? Maybe a
> PHY tunable is not correct? Is this voltage selection actually more
> like pause and EEE?

[Goes and looks at the datasheet]

Register 0x20E, bit 13:

1 = Advertise that the 10BASE-T1L PHY has increased transmit/
receive level ability
0 = Do not advertise that the 10BASE-T1L PHY has increased
transmit/receive level ability (default)

So does this mean 2.4v?

 	Andrew
