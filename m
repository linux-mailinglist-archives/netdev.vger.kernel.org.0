Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D9731021D
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 02:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbhBEBOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 20:14:02 -0500
Received: from mga07.intel.com ([134.134.136.100]:38383 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230037AbhBEBOC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 20:14:02 -0500
IronPort-SDR: ZtNiZpLBsYRdDrDo/DJVnFEsBTpvWf3uACMIZzXtynmu5j8MfaRf42lPAr8i6sdsVXyGVh6MqG
 QNX7sYk7TVuA==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="245429282"
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="245429282"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 17:13:21 -0800
IronPort-SDR: Hhjyo0KJK2CEHDLbW/gEdYDOeP9zgke8bAFigVsQRKDVLj3wngL5W341XQ4iVZeEMh4YK7IfnC
 wQT9epFeEpiA==
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="393624785"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.212.188.246])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 17:13:20 -0800
Date:   Thu, 4 Feb 2021 17:13:19 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>
Subject: Re: [PATCH net] net: enetc: initialize the RFS and RSS memories
Message-ID: <20210204171319.00000c1b@intel.com>
In-Reply-To: <20210204134511.2640309-1-vladimir.oltean@nxp.com>
References: <20210204134511.2640309-1-vladimir.oltean@nxp.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean wrote:
> Discussion with the hardware design engineers reveals that on LS1028A,
> the hardware does not do initialization of that RFS/RSS memory, and that
> software should clear/initialize the entire table before starting to
> operate. That comes as a bit of a surprise, since the driver does not do
> initialization of the RFS memory. Also, the initialization of the
> Receive Side Scaling is done only partially.

...
 
> Reported-by: Michael Walle <michael@walle.cc>
> Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
