Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F7D315AA7
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234946AbhBJAHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:07:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:55280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234139AbhBIXbl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 18:31:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id CCB8264E0D;
        Tue,  9 Feb 2021 23:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612913407;
        bh=7lVs/dDtva8M6rzae0hpHLDBOhhd/Atiw4MgtlZBDDM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hkXbbvfUUT3/dlnbubBxzqp0DL2lpeCDNbIqFo2FUxBGuGjLMolmBD+Na8YjurfRm
         UneicrXf2+34fceuPUQoalf0H6Y/YJ7CgiLeNwHZmQcUTJEGDr8fizL0G+dg1BLCtx
         Bw195hWquajoEzD/ajZb6UpZxop5L+FoVXHXSmyUxiuTeZzmq2AzH1NV50xTqceuVM
         fXhIUidhkpxPRX5ssP9gsPHENCY8ec03vuKm/2grgBddEGp08/6oOa0l00GhWYiYPp
         OtcdGIkfHr3Jmj/xQPAUvPep63vOEKThd6ZANzd/xjSnTl0CbDPSFxPRClyZ9uxkgH
         2NIfikhv1GHeg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BAE9B609D6;
        Tue,  9 Feb 2021 23:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] net: hns3: fixes for -net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161291340776.23530.538116330448620412.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Feb 2021 23:30:07 +0000
References: <1612861387-35858-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1612861387-35858-1-git-send-email-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@openeuler.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue, 9 Feb 2021 17:03:04 +0800 you wrote:
> The parameters sent from vf may be unreliable. If these
> parameters are used directly, memory overwriting may occur.
> 
> So this series adds some checks for this case.
> 
> Yufeng Mo (3):
>   net: hns3: add a check for queue_id in hclge_reset_vf_queue()
>   net: hns3: add a check for tqp_index in
>     hclge_get_ring_chain_from_mbx()
>   net: hns3: add a check for index in hclge_get_rss_key()
> 
> [...]

Here is the summary with links:
  - [net,1/3] net: hns3: add a check for queue_id in hclge_reset_vf_queue()
    https://git.kernel.org/netdev/net/c/67a69f84cab6
  - [net,2/3] net: hns3: add a check for tqp_index in hclge_get_ring_chain_from_mbx()
    https://git.kernel.org/netdev/net/c/326334aad024
  - [net,3/3] net: hns3: add a check for index in hclge_get_rss_key()
    https://git.kernel.org/netdev/net/c/532cfc0df1e4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


