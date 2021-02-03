Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891DD30D06D
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 01:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbhBCApL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 19:45:11 -0500
Received: from mga12.intel.com ([192.55.52.136]:17637 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233386AbhBCApH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 19:45:07 -0500
IronPort-SDR: OFwi3pPpE2BpgPicX8tigv5/v7GzqfXL2oC56IX9l/Vul8C1Iyrhx2ax41AzRNoNClRX2A9pXZ
 yLd75l5AJXuQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="160126524"
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="160126524"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 16:44:13 -0800
IronPort-SDR: SBwyy9m7AmQbzi5lTHTXj06tT8S6GvTTphLx8g/e+qCDYpExJmyEx3gZZ71OzdOa37kKinFwKl
 AAJMTxkQ6Pgg==
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="392024901"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.212.172.218])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 16:44:12 -0800
Date:   Tue, 2 Feb 2021 16:44:12 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>
Subject: Re: [Patch v3 net-next 3/7] octeontx2-pf: ethtool fec mode support
Message-ID: <20210202164412.00005b01@intel.com>
In-Reply-To: <1612157084-101715-4-git-send-email-hkelam@marvell.com>
References: <1612157084-101715-1-git-send-email-hkelam@marvell.com>
        <1612157084-101715-4-git-send-email-hkelam@marvell.com>
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
> Add ethtool support to configure fec modes baser/rs and
> support to fecth FEC stats from CGX as well PHY.
> 
> Configure fec mode
> 	- ethtool --set-fec eth0 encoding rs/baser/off/auto
> Query fec mode
> 	- ethtool --show-fec eth0
> 
> Signed-off-by: Christina Jacob <cjacob@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
