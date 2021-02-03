Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477EA30D07A
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 01:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbhBCAtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 19:49:17 -0500
Received: from mga04.intel.com ([192.55.52.120]:22792 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232777AbhBCAtO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 19:49:14 -0500
IronPort-SDR: 3YrFodAK4ZOPIdys+3OxCZ29UNRmU65iG+xuJirtjMFMK6FC89lSShB7+uBRfcuQD9KMeBsGRH
 vg+kRd+3gVrA==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="178400388"
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="178400388"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 16:48:34 -0800
IronPort-SDR: 0qI+Y1YH9ejTpqA246UxtAXsyfZwZ88xht48Ea0eJW1ifZKqftmm+9s0xW43Y10ixLfEZL2EEz
 sZQACFyEVorw==
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="392028831"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.212.172.218])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 16:48:34 -0800
Date:   Tue, 2 Feb 2021 16:48:34 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>
Subject: Re: [Patch v3 net-next 7/7] octeontx2-pf: ethtool physical link
 configuration
Message-ID: <20210202164834.00004426@intel.com>
In-Reply-To: <1612157084-101715-8-git-send-email-hkelam@marvell.com>
References: <1612157084-101715-1-git-send-email-hkelam@marvell.com>
        <1612157084-101715-8-git-send-email-hkelam@marvell.com>
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
> Register set_link_ksetting callback with driver such that
> link configurations parameters like advertised mode,speed, duplex
> and autoneg can be configured.
> 
> below command
> ethtool -s eth0 advertise 0x1 speed 10 duplex full autoneg on
> 
> Signed-off-by: Christina Jacob <cjacob@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
