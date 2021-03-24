Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC67D348453
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 23:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238558AbhCXWFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 18:05:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45598 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232130AbhCXWEp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 18:04:45 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lPBcG-00CqYb-AA; Wed, 24 Mar 2021 23:04:40 +0100
Date:   Wed, 24 Mar 2021 23:04:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: Re: [PATCH net-next 2/2] net: phy: marvell10g: Add PHY loopback
 support
Message-ID: <YFu3eHycMkHj/HME@lunn.ch>
References: <20210323164641.26059-1-vee.khee.wong@linux.intel.com>
 <20210323164641.26059-3-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323164641.26059-3-vee.khee.wong@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 12:46:41AM +0800, Wong Vee Khee wrote:
> Add support for PHY loopback for Marvell 88x2110 and Marvell 88x3310.
> 
> This allow user to perform PHY loopback test using ethtool selftest.
> 
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
