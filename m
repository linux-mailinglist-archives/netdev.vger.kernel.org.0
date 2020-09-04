Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036F325DADD
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 16:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730629AbgIDOC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 10:02:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43042 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730709AbgIDOCz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 10:02:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kECIf-00DCjd-1R; Fri, 04 Sep 2020 16:02:45 +0200
Date:   Fri, 4 Sep 2020 16:02:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        "David S . Miller" <davem@davemloft.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Richard Leitner <richard.leitner@skidata.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH] net: fec: Fix PHY init after phy_reset_after_clk_enable()
Message-ID: <20200904140245.GO3112546@lunn.ch>
References: <20200903202712.143878-1-marex@denx.de>
 <20200903210011.GD3112546@lunn.ch>
 <b6397b39-c897-6e0a-6bf7-b6b24908de1a@denx.de>
 <20200903215331.GG3112546@lunn.ch>
 <02ce2afb-7b9f-ba35-63a5-7496c7a39e6e@denx.de>
 <20200903220847.GI3112546@lunn.ch>
 <c67eb631-a16d-0b52-c2f8-92d017e39258@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c67eb631-a16d-0b52-c2f8-92d017e39258@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 04, 2020 at 12:45:44AM +0200, Marek Vasut wrote:
> On 9/4/20 12:08 AM, Andrew Lunn wrote:
> >>> b4 am 20200903043947.3272453-1-f.fainelli@gmail.com
> >>
> >> That might be a fix for the long run, but I doubt there's any chance to
> >> backport it all to stable, is there ?
> > 
> > No. For stable we need something simpler.
> 
> Like this patch ?

Yes.

But i would like to see a Tested-By: or similar from Richard
Leitner. Why does the current code work for his system? Does your
change break it?

       Andrew
