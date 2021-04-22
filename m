Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F16A3682E4
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 17:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236527AbhDVPDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 11:03:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232670AbhDVPDW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 11:03:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5319461104;
        Thu, 22 Apr 2021 15:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619103767;
        bh=lA/GNSCyeI1Pj+t7+7DZpMGeLfmqJrRWrLGosSrK6NI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dIo9YENOn/jqah6mTJoOOfW5dx0ilFhk+oldljHkvNYNfeBDP4Z559+kL8RlFwiOY
         gK18FWdZu3Wk367DErbogzkk4jk9Akaw559EBGzyqDqGMOJyrouW1tBUpN+yLz9h42
         x/N91/BL+qRLg7Yfjpc/QJbxSDZj0iflbp8o01A/mRxWAQT/ZEQ4PVuCHmSvz9I7bD
         VzXd8XBY6AGhbCe9DiMzlFCUbMMOpTX7MRu/vfKoP2cQj9YYnvjNNsxTc1bl3Npg0n
         rd0RiplcEqwdQ6j0+p8UkmbFVxNDE4dp69NvGHDxSe/bTXRW7xM1h3Qr1jDhwkBsE9
         saEbW0EfpE+AQ==
Date:   Thu, 22 Apr 2021 18:02:42 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: wwan: core: Return poll error in case
 of port removal
Message-ID: <YIGQEpbJvcOz2/VI@unreal>
References: <1619100361-1330-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1619100361-1330-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 04:06:01PM +0200, Loic Poulain wrote:
> Ensure that the poll system call returns proper error flags when port
> is removed (nullified port ops), allowing user side to properly fail,
> without further read or write.
> 
> Fixes: 9a44c1cc6388 ("net: Add a WWAN subsystem")
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  v2: get rid of useless locking for accessing port->ops
> 
>  drivers/net/wwan/wwan_core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 

Please take my ROB with a grain of salt.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
