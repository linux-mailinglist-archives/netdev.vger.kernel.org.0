Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4DC2D89C8
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 20:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501946AbgLLTha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 14:37:30 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52128 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388996AbgLLThR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 14:37:17 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1koAgz-00BfJy-07; Sat, 12 Dec 2020 20:36:33 +0100
Date:   Sat, 12 Dec 2020 20:36:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 4/4] arm64: dts: sparx5: Add Sparx5 serdes driver node
Message-ID: <20201212193632.GE2779451@lunn.ch>
References: <20201211090541.157926-1-steen.hegelund@microchip.com>
 <20201211090541.157926-5-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211090541.157926-5-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 10:05:41AM +0100, Steen Hegelund wrote:
> Add Sparx5 serdes driver node, and enable it generally for all
> reference boards.
> 
> Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
