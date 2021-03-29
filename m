Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D46734D90D
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhC2UaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229555AbhC2UaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 16:30:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5F8BC6190A;
        Mon, 29 Mar 2021 20:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617049810;
        bh=n5sC0+OOVDbRFfQJz7LzXaIdKSGVR7Fah840BRB0Gks=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RSR52RtgDirrCZjaPbEYJhZ8e3WgKmhqtR6tWHi9Dlxqn7/pyIRro1rIblFbwf9DJ
         BoEGtW4GACSMdjMxNfW57SmGX6xaQFkhIXxT/7uCKAslWi1J2rWfDEI5dnk3olFEFA
         tnRaDKYnMpQo9XtWEtwvAXDrGliexuMoMr9FOMgndKx7+RAxdfkE5V6CIXjN7RMzNM
         YxRh1CFkttSFHmbJJI8MNcl9hWdNJ8ZKUE+amAmNnEoB5K7OjlmH9zmiQEjgow5zGy
         u3x++/u0t0tm2XC1Q8lfvqx8veaD4X5lbktbDHDJJvUoaFlLxEJJ7yOyix69bUwVd4
         b22gZM7BjFn+Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4DD3860A3B;
        Mon, 29 Mar 2021 20:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] net: hns3: misc updates for -next
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161704981031.11616.3770181458721662169.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 20:30:10 +0000
References: <1616990273-46426-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1616990273-46426-1-git-send-email-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@openeuler.org, linuxarm@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 29 Mar 2021 11:57:44 +0800 you wrote:
> This series include some updates for the HNS3 ethernet driver.
> 
> #1 & #2 fix two bugs in commit fc4243b8de8b ("net: hns3: refactor
>    flow director configuration").
> #3 modifies a potential overflow risk.
> #4 remove the rss_size limitation when updating rss size.
> #5 optimizes the resetting of tqp.
> #6 & #7 add updates for the IO path.
> #8 expands the tc config command.
> #9 adds a new stats.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] net: hns3: fix missing rule state assignment
    https://git.kernel.org/netdev/net-next/c/989f7178b066
  - [net-next,2/9] net: hns3: fix use-after-free issue for hclge_add_fd_entry_common()
    https://git.kernel.org/netdev/net-next/c/64ff58fa3bfc
  - [net-next,3/9] net: hns3: remediate a potential overflow risk of bd_num_list
    https://git.kernel.org/netdev/net-next/c/a2ee6fd28a19
  - [net-next,4/9] net: hns3: remove the rss_size limitation by vector num
    https://git.kernel.org/netdev/net-next/c/5be36fb78554
  - [net-next,5/9] net: hns3: optimize the process of queue reset
    https://git.kernel.org/netdev/net-next/c/8fa865510069
  - [net-next,6/9] net: hns3: add handling for xmit skb with recursive fraglist
    https://git.kernel.org/netdev/net-next/c/d5d5e0193ee8
  - [net-next,7/9] net: hns3: add tx send size handling for tso skb
    https://git.kernel.org/netdev/net-next/c/811c0830eb4c
  - [net-next,8/9] net: hns3: expand the tc config command
    https://git.kernel.org/netdev/net-next/c/33a8f7649913
  - [net-next,9/9] net: hns3: add stats logging when skb padding fails
    https://git.kernel.org/netdev/net-next/c/97b9e5c131f1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


