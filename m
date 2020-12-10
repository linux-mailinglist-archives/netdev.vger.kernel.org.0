Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C306C2D5D57
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 15:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389899AbgLJORK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 09:17:10 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48812 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389434AbgLJORB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 09:17:01 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1knMjq-00BEUo-5O; Thu, 10 Dec 2020 15:16:10 +0100
Date:   Thu, 10 Dec 2020 15:16:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 3/4] phy: Add Sparx5 ethernet serdes PHY driver
Message-ID: <20201210141610.GG2638572@lunn.ch>
References: <20201207121345.3818234-1-steen.hegelund@microchip.com>
 <20201207121345.3818234-4-steen.hegelund@microchip.com>
 <20201210021134.GD2638572@lunn.ch>
 <20201210125706.saub7c2rarifhbx4@mchp-dev-shegelun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210125706.saub7c2rarifhbx4@mchp-dev-shegelun>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > So why are returning link up information?
> 
> Yes that was a bit of a hijacking of the function.  I will remove that.
> I also removed the dependency on this behaviour in the client driver in the
> meantime.
> 
> I think a status function on the generic phy would be useful, but I will
> take that as separate issue.

In this context of an Ethernet SERDES, do you actually need it? You
would normally look at the PCS link status to determine if the link is
up.  But it is useful debug information. If the PCS is down, but the
PHY indicates up, you can guess you have a protocol misconfiguration.

What exactly does link at this level mean? And thinking of the wider
uses of the PHY subsystem, what would link mean at this level for
SATA, PCIe, USB? Don't these all have some protocol level above
similar to Ethernet PCS which is the real determiner of link?

     Andrew
