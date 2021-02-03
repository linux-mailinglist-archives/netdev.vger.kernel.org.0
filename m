Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D3D30D068
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 01:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhBCAoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 19:44:25 -0500
Received: from mga07.intel.com ([134.134.136.100]:57386 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233127AbhBCAoY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 19:44:24 -0500
IronPort-SDR: 4xIoa1qk1jWtcKosX9tp0OT6ZgAJr5PPeURtwB608coLwecszm1XKFf1IzNWEmF6Y2nrBsAVz7
 R+RXQ6WMtncw==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="245037006"
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="245037006"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 16:43:43 -0800
IronPort-SDR: fIwu4ykjjFsLUBoK0RNPB/baMToHVlgaP/ChSFs0QX/IxSJtd35+DRv5cOg84JvgbGJH1iQIip
 o4d9cbOeILgQ==
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="392024346"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.212.172.218])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 16:43:43 -0800
Date:   Tue, 2 Feb 2021 16:43:43 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>
Subject: Re: [Patch v3 net-next 1/7] octeontx2-af: forward error correction
 configuration
Message-ID: <20210202164343.00005468@intel.com>
In-Reply-To: <1612157084-101715-2-git-send-email-hkelam@marvell.com>
References: <1612157084-101715-1-git-send-email-hkelam@marvell.com>
        <1612157084-101715-2-git-send-email-hkelam@marvell.com>
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
> CGX block supports forward error correction modes baseR
> and RS. This patch adds support to set encoding mode
> and to read corrected/uncorrected block counters
> 
> Adds new mailbox handlers set_fec to configure encoding modes
> and fec_stats to read counters and also increase mbox timeout
> to accomdate firmware command response timeout.
> 
> Along with new CGX_CMD_SET_FEC command add other commands to
> sync with kernel enum list with firmware.
> 
> Signed-off-by: Christina Jacob <cjacob@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
