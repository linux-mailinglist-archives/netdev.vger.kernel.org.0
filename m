Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8C42B084C
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgKLPV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:21:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50894 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727796AbgKLPV7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 10:21:59 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kdEQ3-006fss-LP; Thu, 12 Nov 2020 16:21:51 +0100
Date:   Thu, 12 Nov 2020 16:21:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wong Vee Khee <vee.khee.wong@intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>
Subject: Re: [PATCH net-next 1/1] net: phy: Add additional logics on probing
 C45 PHY devices
Message-ID: <20201112152151.GA1456319@lunn.ch>
References: <20201112150351.12662-1-vee.khee.wong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112150351.12662-1-vee.khee.wong@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 11:03:51PM +0800, Wong Vee Khee wrote:
> For clause 45 PHY, introduce additional logics in get_phy_c45_ids() to
> check if there is at least one valid device ID, return 0 on true, and
> -ENODEV otherwise.

So does this mean you have a device which uses c45 and does not have
any valid IDs? What device is it? Can it be used via c22?

I would like to know more about why this is needed, since it sounds
like a workaround for a broken device.

     Andrew
