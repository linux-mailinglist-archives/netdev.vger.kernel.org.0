Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA292D89B9
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 20:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501913AbgLLTaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 14:30:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52078 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394329AbgLLTaN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 14:30:13 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1koAa5-00BfGw-1H; Sat, 12 Dec 2020 20:29:25 +0100
Date:   Sat, 12 Dec 2020 20:29:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v10 1/4] dt-bindings: phy: Add sparx5-serdes bindings
Message-ID: <20201212192925.GB2779451@lunn.ch>
References: <20201211090541.157926-1-steen.hegelund@microchip.com>
 <20201211090541.157926-2-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211090541.157926-2-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 10:05:38AM +0100, Steen Hegelund wrote:
> Document the Sparx5 ethernet serdes phy driver bindings.
> 
> Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Reviewed-by: Rob Herring <robh@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
