Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F17E2F1844
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 15:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388809AbhAKO1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 09:27:10 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33328 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388178AbhAKO1F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 09:27:05 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kyy9E-00HXcz-M6; Mon, 11 Jan 2021 15:26:20 +0100
Date:   Mon, 11 Jan 2021 15:26:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH v1 1/2] net: phy: Add 100 base-x mode
Message-ID: <X/xgDLptpbfgu9kB@lunn.ch>
References: <20210111130657.10703-1-bjarni.jonasson@microchip.com>
 <20210111130657.10703-2-bjarni.jonasson@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111130657.10703-2-bjarni.jonasson@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 02:06:56PM +0100, Bjarni Jonasson wrote:
> Sparx-5 supports this mode and it is missing in the PHY core.
> 
> Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
