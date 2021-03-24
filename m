Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A431D348450
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 23:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238541AbhCXWEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 18:04:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45582 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232242AbhCXWEc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 18:04:32 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lPBbu-00CqXv-Ap; Wed, 24 Mar 2021 23:04:18 +0100
Date:   Wed, 24 Mar 2021 23:04:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: Re: [PATCH net-next 1/2] net: phy: add genphy_c45_loopback
Message-ID: <YFu3YlYThBK3Pj2N@lunn.ch>
References: <20210323164641.26059-1-vee.khee.wong@linux.intel.com>
 <20210323164641.26059-2-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323164641.26059-2-vee.khee.wong@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 12:46:40AM +0800, Wong Vee Khee wrote:
> Add generic code to enable C45 PHY loopback into the common phy-c45.c
> file. This will allow C45 PHY drivers aceess this by setting
> .set_loopback.
> 
> Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
