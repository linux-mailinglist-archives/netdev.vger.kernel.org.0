Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796982DC3B9
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 17:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbgLPQGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 11:06:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57714 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgLPQGj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 11:06:39 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kpZJK-00CJUm-RK; Wed, 16 Dec 2020 17:05:54 +0100
Date:   Wed, 16 Dec 2020 17:05:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, marex@denx.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v3 net-next 2/2] net: phy: mchp: Add 1588 support for
 LAN8814 Quad PHY
Message-ID: <20201216160554.GK2901580@lunn.ch>
References: <20201216152551.6517-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216152551.6517-1-Divya.Koppera@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 08:55:51PM +0530, Divya Koppera wrote:
> This patch add supports for 1588 Hardware Timestamping support
> to LAN8814 Quad Phy. It supports L2 and Ipv4 encapsulations.
> 
> Signed-off-by: Divya Koppera<divya.koppera@microchip.com>

You need to Cc: the PTP maintainer:

Richard Cochran <richardcochran@gmail.com>

	Andrew
