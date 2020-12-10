Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F1F2D4FD5
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 01:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731270AbgLJArg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 19:47:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47642 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730114AbgLJAod (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 19:44:33 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1knA3Y-00B8pg-CR; Thu, 10 Dec 2020 01:43:40 +0100
Date:   Thu, 10 Dec 2020 01:43:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wong Vee Khee <vee.khee.wong@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 net-next 1/1] net: stmmac: allow stmmac to probe for
 C45 PHY devices
Message-ID: <20201210004340.GA2638572@lunn.ch>
References: <20201209224700.30295-1-vee.khee.wong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209224700.30295-1-vee.khee.wong@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 06:47:00AM +0800, Wong Vee Khee wrote:
> Assign stmmac's mdio_bus probe capabilities to MDIOBUS_C22_C45.
> This extended the probing of C45 PHY devices on the MDIO bus.
> 
> Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
