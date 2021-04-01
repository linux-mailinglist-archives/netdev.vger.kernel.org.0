Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E10351C21
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236926AbhDASN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:13:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58858 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234723AbhDASGv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 14:06:51 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lS0ZU-00EMeP-V0; Thu, 01 Apr 2021 18:53:28 +0200
Date:   Thu, 1 Apr 2021 18:53:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:BROADCOM ETHERNET PHY DRIVERS" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: broadcom: Add statistics for all
 Gigabit PHYs
Message-ID: <YGX6iNr+OF9k1ton@lunn.ch>
References: <20210401164233.1672002-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401164233.1672002-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 01, 2021 at 09:42:33AM -0700, Florian Fainelli wrote:
> All Gigabit PHYs use the same register layout as far as fetching
> statistics goes. Fast Ethernet PHYs do not all support statistics, and
> the BCM54616S would require some switching between the coper and fiber
> modes to fetch the appropriate statistics which is not supported yet.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
