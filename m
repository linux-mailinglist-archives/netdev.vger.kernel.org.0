Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942652DD2C6
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 15:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgLQORf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 09:17:35 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59424 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgLQORc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 09:17:32 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kpu5H-00CVt9-HG; Thu, 17 Dec 2020 15:16:47 +0100
Date:   Thu, 17 Dec 2020 15:16:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, marex@denx.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, richardcochran@gmail.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v4 net-next 1/2] net: phy: mchp: Add interrupt support
 for Link up and Link down to LAN8814 phy
Message-ID: <20201217141647.GC2981994@lunn.ch>
References: <20201217124119.8347-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217124119.8347-1-Divya.Koppera@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 06:11:19PM +0530, Divya Koppera wrote:
> This patch add supports for Link up and Link down interrupts
> to LAN8814 phy.
> 
> Signed-off-by: Divya Koppera<divya.koppera@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
