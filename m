Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEBC30E840
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233915AbhBDAFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:05:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:56582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234215AbhBDADZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:03:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1371F64E27;
        Thu,  4 Feb 2021 00:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612396964;
        bh=YK1qwy/sWG8XR98c1NK+lV9i1eAmnBHDyI1M/Xu38mM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sN4iz0Ui0MLNX7Ky8VX6zt3lEiYpqQR2rX2Z0oZsJkEPVqwIj+VHHaVhIJKgREqHI
         ypDKr5SIpl27g7WEgOaGrhwVLD0d3V+k0t5vrff95bxGTb5RvJh6IzOL9ruW50vC/g
         zEQKkF441J+recptTXhfyHi9gmPIoqvmO1OHpuvUzZ3fMtL05maqLP6egBFLr2+YGr
         mqTA9VzUzScd+iQcMGG7Lu6FfLNDLopzzMtqC/DYvmKN5WRxUmqJjOmgg4jOpmmmOa
         np2B3/Z6Va4DNkC2jpXArrAOf9oTET0TFH0oJrh3g8Uc9ZzEManUDxLhAEXY+SptJe
         K8q6u3FLlGiKg==
Date:   Wed, 3 Feb 2021 16:02:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Yang Li <yang.lee@linux.alibaba.com>, <davem@davemloft.net>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] octeontx2-af: remove unneeded semicolon
Message-ID: <20210203160243.3cbed435@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210203154658.00001f2f@intel.com>
References: <1612318631-101349-1-git-send-email-yang.lee@linux.alibaba.com>
        <20210203154658.00001f2f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Feb 2021 15:46:58 -0800 Jesse Brandeburg wrote:
> Yang Li wrote:
> 
> > Eliminate the following coccicheck warning:
> > ./drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c:272:2-3:
> > Unneeded semicolon
> > ./drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1809:3-4:
> > Unneeded semicolon
> > ./drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1788:3-4:
> > Unneeded semicolon
> > ./drivers/net/ethernet/marvell/octeontx2/af/rvu.c:1326:2-3: Unneeded
> > semicolon
> > 
> > Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> > Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> > ---
> >  drivers/net/ethernet/marvell/octeontx2/af/rvu.c         | 2 +-
> >  drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c | 4 ++--
> >  drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c  | 2 +-
> >  3 files changed, 4 insertions(+), 4 deletions(-)  
> 
> Trivial patch, recommend net-next as it's not a critical fix, Yang,
> please include the targeted tree when sending like [PATCH net-next]
> 
> otherwise, for net-next:
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

The patch does not apply to net-next, please rebase, add Jesse's review
tag and repost.
