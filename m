Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDFB6339AEF
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 02:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhCMBp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 20:45:56 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55038 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231392AbhCMBpf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 20:45:35 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lKtLM-00AdtA-AV; Sat, 13 Mar 2021 02:45:28 +0100
Date:   Sat, 13 Mar 2021 02:45:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     davem@davemloft.net, kuba@kernel.org, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: macb: Disable PCS auto-negotiation for
 SGMII fixed-link mode
Message-ID: <YEwZOKNaKegMCyGv@lunn.ch>
References: <20210311201813.3804249-1-robert.hancock@calian.com>
 <20210311201813.3804249-3-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311201813.3804249-3-robert.hancock@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 02:18:13PM -0600, Robert Hancock wrote:
> When using a fixed-link configuration in SGMII mode, it's not really
> sensible to have auto-negotiation enabled since the link settings are
> fixed by definition. In other configurations, such as an SGMII
> connection to a PHY, it should generally be enabled.

So how do you tell the PCS it should be doing 10Mbps over the SGMII
link? I'm assuming it is the PCS which does the bit replication, not
the MAC?

I'm surprised you are even using SGMII with a fixed link. 1000BaseX is
the norm, and then you don't need to worry about the speed.

    Andrew
