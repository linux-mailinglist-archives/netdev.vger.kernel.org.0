Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D5542B3D3
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 05:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhJMDus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 23:50:48 -0400
Received: from mga12.intel.com ([192.55.52.136]:43664 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229717AbhJMDus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 23:50:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="207454944"
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="207454944"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 20:48:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="442119721"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga003.jf.intel.com with ESMTP; 12 Oct 2021 20:48:37 -0700
Received: from linux.intel.com (vwong3-iLBPG3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 5A52D58066D;
        Tue, 12 Oct 2021 20:48:35 -0700 (PDT)
Date:   Wed, 13 Oct 2021 11:48:32 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: phy: dp83867: add generic PHY loopback
Message-ID: <20211013034832.GA3256@linux.intel.com>
References: <20211013034128.2094426-1-boon.leong.ong@intel.com>
 <20211013034128.2094426-3-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013034128.2094426-3-boon.leong.ong@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 11:41:28AM +0800, Ong Boon Leong wrote:
> From: "Lay, Kuan Loon" <kuan.loon.lay@intel.com>
> 
> TI DP83867 supports loopback enabled using BMCR, so we add
> genphy_loopback to the phy driver.
> 
> Tested-by: Clement <clement@intel.com>
> Signed-off-by: Lay, Kuan Loon <kuan.loon.lay@intel.com>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> ---
>  drivers/net/phy/dp83867.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> index bb4369b75179..af47c62d6e04 100644
> --- a/drivers/net/phy/dp83867.c
> +++ b/drivers/net/phy/dp83867.c
> @@ -878,6 +878,7 @@ static struct phy_driver dp83867_driver[] = {
>  
>  		.suspend	= genphy_suspend,
>  		.resume		= genphy_resume,
> +		.set_loopback	= genphy_loopback,

Isn't this already handled in phy_loopback() in 
drivers/net/phy/phy_device.c?

>  	},
>  };
>  module_phy_driver(dp83867_driver);
