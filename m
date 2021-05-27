Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B6F39239A
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 02:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235120AbhE0ALf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 20:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235079AbhE0ALK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 20:11:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDD216128D;
        Thu, 27 May 2021 00:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622074178;
        bh=vMtE8GJot368Tn3TcyOZL6VuXezN7Ub9zGOci4pP/X8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ui9IOeN0otDfKgQuuX4DknoTf2cwPHyc9V0KQ3tFDV87+5TI2TEA/WQp8sk+iMyNz
         jPAXkHp/qLugE+PtrLSsrPKGsVWop+aB8NancOXhtAdGnY0PajnHYh+Q501eOQYYNd
         UXF/qqfFlqRQRwidSWlvQ3HcwQOHXnHTIC2/aOdWzTxTBjDiardd+2dMW8+Qj2T7wV
         TQkzbf4m2QoaahiDv/NO6HO2pO5OyJ4tKjkOVqfiiRl09t9cPYsmAh++DszGOc6CFY
         uvaKRTljL1vA3Z2HGy7JVldyTK0V5AqtBidmNqk1ssjBf6oEzjT2pH2Ml7bfsDB4Jh
         VFl94203eahhQ==
Date:   Wed, 26 May 2021 17:09:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/sungem: Fix inconsistent indenting
Message-ID: <20210526170937.4228f917@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1622024648-33438-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1622024648-33438-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 May 2021 18:24:08 +0800 Jiapeng Chong wrote:
> Eliminate the follow smatch warning:
> 
> drivers/net/sungem_phy.c:412 genmii_read_link() warn: inconsistent
> indenting.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/net/sungem_phy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/sungem_phy.c b/drivers/net/sungem_phy.c
> index 291fa44..4daac5f 100644
> --- a/drivers/net/sungem_phy.c
> +++ b/drivers/net/sungem_phy.c
> @@ -409,7 +409,7 @@ static int genmii_read_link(struct mii_phy *phy)
>  	 * though magic-aneg shouldn't prevent this case from occurring
>  	 */
>  
> -	 return 0;
> +	return 0;
>  }
>  
>  static int generic_suspend(struct mii_phy* phy)

Do you have any statistics on how many such patches we'd need to apply
to make the kernel free for such warning? If it's too many it's probably
not worth it, this patch for example has net zero effect on readability.
