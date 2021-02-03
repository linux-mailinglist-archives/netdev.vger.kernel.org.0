Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F8830D06A
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 01:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbhBCAo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 19:44:28 -0500
Received: from mga17.intel.com ([192.55.52.151]:54175 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233191AbhBCAoY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 19:44:24 -0500
IronPort-SDR: U4kswUaYcsubBfbkEz1rfCwtIA3HxbTpHSdctmZMxkWDiWl1FoYyNwsaS9QhTr1gAqqfLwzvpT
 uQNqkUBvO3eQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="160723287"
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="160723287"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 16:44:00 -0800
IronPort-SDR: 1iqpe4biyUp95HA/1lIUDidByITcrbGU4RhuSnYGfmsbP6cDb2rcAp/idZl37O01iLXF2mV5F7
 nYI0JFItF3cg==
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="392024623"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.212.172.218])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 16:43:59 -0800
Date:   Tue, 2 Feb 2021 16:43:59 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>
Subject: Re: [Patch v3 net-next 2/7] octeontx2-af: Add new CGX_CMD to get
 PHY FEC statistics
Message-ID: <20210202164359.00005756@intel.com>
In-Reply-To: <1612157084-101715-3-git-send-email-hkelam@marvell.com>
References: <1612157084-101715-1-git-send-email-hkelam@marvell.com>
        <1612157084-101715-3-git-send-email-hkelam@marvell.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hariprasad Kelam wrote:

> From: Felix Manlunas <fmanlunas@marvell.com>
> 
> This patch adds support to fetch fec stats from PHY. The stats are
> put in the shared data struct fwdata.  A PHY driver indicates
> that it has FEC stats by setting the flag fwdata.phy.misc.has_fec_stats
> 
> Besides CGX_CMD_GET_PHY_FEC_STATS, also add CGX_CMD_PRBS and
> CGX_CMD_DISPLAY_EYE to enum cgx_cmd_id so that Linux's enum list is in sync
> with firmware's enum list.
> 
> Signed-off-by: Felix Manlunas <fmanlunas@marvell.com>
> Signed-off-by: Christina Jacob <cjacob@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <Sunil.Goutham@cavium.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
