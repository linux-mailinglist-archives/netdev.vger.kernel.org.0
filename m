Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7221D30D074
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 01:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbhBCArE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 19:47:04 -0500
Received: from mga14.intel.com ([192.55.52.115]:15247 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233491AbhBCAq4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 19:46:56 -0500
IronPort-SDR: xnskqu8zCFSnQY7X6SC/Xk5JHpx/GUcRwqg17eKa/kxGf1WOslGPZ05h1fgwK9Sfh5OEPnWR7G
 Rd2jWK0qUKBw==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="180186460"
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="180186460"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 16:46:13 -0800
IronPort-SDR: zaozJxiwjmhc0shwh6x82NO8GyRu2mztg/9gLmMENZyiySxlKtwxLW2nYUd3RpjeHkwFOfTkfs
 qpARCtk/t+eg==
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="392026707"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.212.172.218])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 16:46:13 -0800
Date:   Tue, 2 Feb 2021 16:46:12 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>
Subject: Re: [Patch v3 net-next 6/7] octeontx2-pf: ethtool physical link
 status
Message-ID: <20210202164612.00007509@intel.com>
In-Reply-To: <1612157084-101715-7-git-send-email-hkelam@marvell.com>
References: <1612157084-101715-1-git-send-email-hkelam@marvell.com>
        <1612157084-101715-7-git-send-email-hkelam@marvell.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hariprasad Kelam wrote:

> From: Christina Jacob <cjacob@marvell.com>
> 
> Register get_link_ksettings callback to get link status information
> from the driver. As virtual function (vf) shares same physical link
> same API is used for both the drivers and for loop back drivers
> simply returns the fixed values as its does not have physical link.
> 
> ethtool eth3
> Settings for eth3:
>         Supported ports: [ ]
>         Supported link modes:   10baseT/Half 10baseT/Full
>                                 100baseT/Half 100baseT/Full
>                                 1000baseT/Half 1000baseT/Full
>                                 10000baseKR/Full
>                                 1000baseX/Full
>         Supports auto-negotiation: No
>         Supported FEC modes: BaseR RS
>         Advertised link modes:  Not reported
>         Advertised pause frame use: No
>         Advertised auto-negotiation: No
>         Advertised FEC modes: None
> 
> ethtool lbk0
> Settings for lbk0:
> 	Speed: 100000Mb/s
>         Duplex: Full
> 
> Signed-off-by: Christina Jacob <cjacob@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>

besides the slightly long lines, looks good.
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
