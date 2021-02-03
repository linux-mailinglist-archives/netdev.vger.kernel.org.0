Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504A930D061
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 01:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhBCAlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 19:41:47 -0500
Received: from mga18.intel.com ([134.134.136.126]:23758 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232956AbhBCAlq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 19:41:46 -0500
IronPort-SDR: 749fQ67NyaAnw9rEKY5zcVvR3X/ABGRa50W0i7tZV1JnL0Qrse898X7mpPApLnGj8HCYpRiNgw
 jTo3b8c9PCvQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="168637249"
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="168637249"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 16:41:05 -0800
IronPort-SDR: fSThS5KHbBwVnaWg9jcAyeGQDN3wDWbEJq30e1UJftbL+ccoYFmeFU8bO4UzxOSd4TV3sniJSO
 7FR8nRmJ2LvQ==
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="392022012"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.212.172.218])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 16:41:04 -0800
Date:   Tue, 2 Feb 2021 16:41:04 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>
Subject: Re: [Patch v3 net-next 0/7] ethtool support for fec and link
 configuration
Message-ID: <20210202164104.0000180b@intel.com>
In-Reply-To: <1612157084-101715-1-git-send-email-hkelam@marvell.com>
References: <1612157084-101715-1-git-send-email-hkelam@marvell.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hariprasad Kelam wrote:

> This series of patches add support for forward error correction(fec) and
> physical link configuration. Patches 1&2 adds necessary mbox handlers for fec
> mode configuration request and to fetch stats. Patch 3 registers driver
> callbacks for fec mode configuration and display. Patch 4&5 adds support of mbox
> handlers for configuring link parameters like speed/duplex and autoneg etc.
> Patche 6&7 registers driver callbacks for physical link configuration.

For the series, in addition to the fact that Willem already replied to
the previous posting of v3 that it looked good.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
