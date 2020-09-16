Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753D226CC72
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728457AbgIPUos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:44:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbgIPUoQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 16:44:16 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E1A320770;
        Wed, 16 Sep 2020 20:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600289055;
        bh=mnxfeYAfsEprBTo+f/0fTxAbrg30Zc/L3eUOssXhil8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=wCoD7ieQgCw5bLU8tPvMAdeJwRw7m36ct6VQCNaRPjpv7GASgv0zQ5mTL47HBDV6A
         U2FGNaRc0t+crdufzCPwAMHGbLnrKfcPO+0GWHZiQV1OSLvyxHuXgtz/ZppffsTfwZ
         JGrsBk4M6+2lcz4+hQt8IfcTo0gnUARzrQR6p15E=
Message-ID: <9549dda016b3cc046eb9261b17afe0057e8fdb54.camel@kernel.org>
Subject: Re: [PATCH V2 net-next 0/6] net: hns3: updates for -next
From:   Saeed Mahameed <saeed@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, kuba@kernel.org
Date:   Wed, 16 Sep 2020 13:44:14 -0700
In-Reply-To: <1600248830-59477-1-git-send-email-tanhuazhong@huawei.com>
References: <1600248830-59477-1-git-send-email-tanhuazhong@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-16 at 17:33 +0800, Huazhong Tan wrote:
> There are some optimizations related to IO path.
> 
> Change since V1:
> - fixes a unsuitable handling in hns3_lb_clear_tx_ring() of #6 which
>   pointed out by Saeed Mahameed.
> 
> previous version:
> V1: 
> https://patchwork.ozlabs.org/project/netdev/cover/1600085217-26245-1-git-send-email-tanhuazhong@huawei.com/
> 
> Yunsheng Lin (6):
>   net: hns3: batch the page reference count updates
>   net: hns3: batch tx doorbell operation
>   net: hns3: optimize the tx clean process
>   net: hns3: optimize the rx clean process
>   net: hns3: use writel() to optimize the barrier operation
>   net: hns3: use napi_consume_skb() when cleaning tx desc
> 
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 225
> ++++++++++++---------
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  20 +-
>  drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   6 +-
>  3 files changed, 140 insertions(+), 111 deletions(-)
> 

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>


