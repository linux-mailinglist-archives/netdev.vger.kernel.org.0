Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4BC30E7CF
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 00:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbhBCXru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 18:47:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:27992 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233084AbhBCXrt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 18:47:49 -0500
IronPort-SDR: QRoc8yC+Yxbz+OxPz1IO2uvN6DgAlG8c1Bgm4YF9OH/6UoKoMqkPWhcgFvk2QqR8yFfqolEvdT
 XqMamOJFGfmA==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="168247871"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="168247871"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 15:47:01 -0800
IronPort-SDR: Ushzf0FPlMHsggKSCxr+u2N1KUBhdPJUbkbvwRKRtM9ulGVWmTCYwY/BQAeDfsX9H5DzZbja7E
 67UyxszPZmtw==
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="414765482"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.23.15])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 15:47:00 -0800
Date:   Wed, 3 Feb 2021 15:46:58 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] octeontx2-af: remove unneeded semicolon
Message-ID: <20210203154658.00001f2f@intel.com>
In-Reply-To: <1612318631-101349-1-git-send-email-yang.lee@linux.alibaba.com>
References: <1612318631-101349-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Li wrote:

> Eliminate the following coccicheck warning:
> ./drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c:272:2-3:
> Unneeded semicolon
> ./drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1809:3-4:
> Unneeded semicolon
> ./drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1788:3-4:
> Unneeded semicolon
> ./drivers/net/ethernet/marvell/octeontx2/af/rvu.c:1326:2-3: Unneeded
> semicolon
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/rvu.c         | 2 +-
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c | 4 ++--
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c  | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)

Trivial patch, recommend net-next as it's not a critical fix, Yang,
please include the targeted tree when sending like [PATCH net-next]

otherwise, for net-next:
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
