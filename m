Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C128C36F2AD
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 00:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhD2WlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 18:41:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229834AbhD2Wk6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 18:40:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 684AB6146D;
        Thu, 29 Apr 2021 22:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619736010;
        bh=kQFx8Pwf7KAmyZVuDu0CSPZWkOVdAGYFuE4Hv0jweNg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=INWBvu5ahgW03E8MPEByClQ1ZkRhxh97IovHaixR/0EfpkHqcQ3k1Nvl9EKjv5Y9Q
         Dp1V1USB56UNO63fuZhfiwcfL15YpT3UqqT5Svahfw2O6eHmhNIRalmrtp/zFaigHg
         plwp2TIQUQWKhWUwMdYmMAUTo/b8z0Itt0GHmuQu2C3KxPbNUEt03A0DlUxxysVMPa
         mEg+KSB41dt1d5wJ5y9iI7CzFA5D0TPq97/5QwX8lDiFbJgFBkVW1Vm+MAIlZC8Cgi
         Z1ARLaB9sJpNdJ/aZSBakmZVIXWbgdzfN9rDzswapPTbQnIiKS0BnD8C9hiiUCBq9+
         +OJGAfbXuj/rg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5E87560BCF;
        Thu, 29 Apr 2021 22:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] bridge: Fix possible races between assigning
 rx_handler_data and setting IFF_BRIDGE_PORT bit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161973601038.15907.11344410460500659654.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Apr 2021 22:40:10 +0000
References: <1619620694-12419-1-git-send-email-zhangzhengming@huawei.com>
In-Reply-To: <1619620694-12419-1-git-send-email-zhangzhengming@huawei.com>
To:     zhangzhengming <zhangzhengming@huawei.com>
Cc:     roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, wangxiaogang3@huawei.com,
        xuhanbing@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 28 Apr 2021 22:38:14 +0800 you wrote:
> From: Zhang Zhengming <zhangzhengming@huawei.com>
> 
> There is a crash in the function br_get_link_af_size_filtered,
> as the port_exists(dev) is true and the rx_handler_data of dev is NULL.
> But the rx_handler_data of dev is correct saved in vmcore.
> 
> The oops looks something like:
>  ...
>  pc : br_get_link_af_size_filtered+0x28/0x1c8 [bridge]
>  ...
>  Call trace:
>   br_get_link_af_size_filtered+0x28/0x1c8 [bridge]
>   if_nlmsg_size+0x180/0x1b0
>   rtnl_calcit.isra.12+0xf8/0x148
>   rtnetlink_rcv_msg+0x334/0x370
>   netlink_rcv_skb+0x64/0x130
>   rtnetlink_rcv+0x28/0x38
>   netlink_unicast+0x1f0/0x250
>   netlink_sendmsg+0x310/0x378
>   sock_sendmsg+0x4c/0x70
>   __sys_sendto+0x120/0x150
>   __arm64_sys_sendto+0x30/0x40
>   el0_svc_common+0x78/0x130
>   el0_svc_handler+0x38/0x78
>   el0_svc+0x8/0xc
> 
> [...]

Here is the summary with links:
  - [v2] bridge: Fix possible races between assigning rx_handler_data and setting IFF_BRIDGE_PORT bit
    https://git.kernel.org/netdev/net/c/59259ff7a81b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


