Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01FD34A6F2
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 13:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhCZMO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 08:14:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49026 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229848AbhCZMOx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 08:14:53 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lPlMW-00D7sR-R8; Fri, 26 Mar 2021 13:14:48 +0100
Date:   Fri, 26 Mar 2021 13:14:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        radhey.shyam.pandey@xilinx.com, robh@kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 2/2] net: axienet: Enable more clocks
Message-ID: <YF3QOFw7jREj03Ut@lunn.ch>
References: <20210326000438.2292548-1-robert.hancock@calian.com>
 <20210326000438.2292548-3-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326000438.2292548-3-robert.hancock@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 06:04:38PM -0600, Robert Hancock wrote:
> This driver was only enabling the first clock on the device, regardless
> of its name. However, this controller logic can have multiple clocks
> which should all be enabled. Add support for enabling additional clocks.
> The clock names used are matching those used in the Xilinx version of this
> driver as well as the Xilinx device tree generator, except for mgt_clk
> which is not present there.
> 
> For backward compatibility, if no named clocks are present, the first
> clock present is used for determining the MDIO bus clock divider.
> 
> Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
