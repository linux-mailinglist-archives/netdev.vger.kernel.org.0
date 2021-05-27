Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62343938AA
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 00:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236337AbhE0WVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 18:21:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236210AbhE0WVh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 18:21:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CF59F6124B;
        Thu, 27 May 2021 22:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622154003;
        bh=3PMlWGVMmjxjgjd4jGhDuMNOCehjmfCu4VCWa2UVXDc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CM1Has/YmFo7lAYtc9PLIywwTbzGPFnmhEfvjeUvGfXz94iETdmqUbipzNaVgsgSD
         UK11VEmiaHcwE146xT8uyLDfqovbktbRKShU6rAnjkeB/jrWOmXch5NKrgRVKtQR/n
         15ilO/4mXum14MxtGnUdhvwESn/0/TcyxbyeCmN8cs7oG+CK5KY6gc6/TDkbn4ByC/
         WFCCbkhqDrApC/zqgmE04eEj8UjsnLTlnBcI0QsI72Yw5Gh0G4cjlSr2Nv1NOiXsqM
         U/X2xoU5AqnjH5kclAePBNaXyp1O1wHP7V0LrgtYGkEym1+2MfKl/KaPCqGyO9GqXB
         oJNy1DilsMuMA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BF12E609F5;
        Thu, 27 May 2021 22:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: act_ct: Offload connections with commit action
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162215400377.3007.14513223749779881059.git-patchwork-notify@kernel.org>
Date:   Thu, 27 May 2021 22:20:03 +0000
References: <1622029449-27060-1-git-send-email-paulb@nvidia.com>
In-Reply-To: <1622029449-27060-1-git-send-email-paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     jhs@mojatatu.com, davem@davemloft.net, kuba@kernel.org,
        xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        marcelo.leitner@gmail.com, ozsh@nvidia.com, roid@nvidia.com,
        jiri@nvidia.com, saeedm@nvidia.com, vladbu@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 26 May 2021 14:44:09 +0300 you wrote:
> Currently established connections are not offloaded if the filter has a
> "ct commit" action. This behavior will not offload connections of the
> following scenario:
> 
> $ tc_filter add dev $DEV ingress protocol ip prio 1 flower \
>   ct_state -trk \
>   action ct commit action goto chain 1
> 
> [...]

Here is the summary with links:
  - [net] net/sched: act_ct: Offload connections with commit action
    https://git.kernel.org/netdev/net/c/0cc254e5aa37

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


