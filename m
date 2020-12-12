Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D27A2D89C7
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 20:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407820AbgLLTgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 14:36:49 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52116 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726309AbgLLTgs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 14:36:48 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1koAgN-00BfJG-MY; Sat, 12 Dec 2020 20:35:55 +0100
Date:   Sat, 12 Dec 2020 20:35:55 +0100
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
Subject: Re: [PATCH v10 3/4] phy: Add Sparx5 ethernet serdes PHY driver
Message-ID: <20201212193555.GD2779451@lunn.ch>
References: <20201211090541.157926-1-steen.hegelund@microchip.com>
 <20201211090541.157926-4-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211090541.157926-4-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 10:05:40AM +0100, Steen Hegelund wrote:
> Add the Microchip Sparx5 ethernet serdes PHY driver for the 6G, 10G and 25G
> interfaces available in the Sparx5 SoC.
> 
> Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
