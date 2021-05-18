Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97FA53881CB
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 23:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352319AbhERVBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 17:01:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238437AbhERVB3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 17:01:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 01359611B0;
        Tue, 18 May 2021 21:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621371611;
        bh=FnWGp3CwJUEi1nwaH51FrDtvFq9Dx4mxdsde2YRjKMI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Lm3J//vLnkMVLIA2S6xecQYl01m5OBzT2aWO0wBhjPily8w4VN2x/jdOulKDr1Vy6
         OtLseSR+nM5BcvXLBh5edEguBMDiYOTvMGJoE8oKuNi1587yGmlXIuDS8O3taahy5g
         6LSmIZuNNhRkJCCecebiJf40dHqRXmMlg8dR6xdKAGyEVjFblQxfNM77TpuMjEZHM5
         wVqlvm9oU6Yur02x1EIIhBSDb5sEsJtzrBBd1k9uFzKfaPFcy+enZjfZ0VA5bY8psD
         Sq/uL9tUa3ygY7F8UEeVUplN3tNLOS2K7rvauXARNTiyv8qrLXm8/JuFZ4eOEVZOGK
         9HViPYclf/X6w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E7065608FB;
        Tue, 18 May 2021 21:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] net: hns3: fixes for -net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162137161094.17137.15312250778988192126.git-patchwork-notify@kernel.org>
Date:   Tue, 18 May 2021 21:00:10 +0000
References: <1621337763-61946-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1621337763-61946-1-git-send-email-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue, 18 May 2021 19:35:59 +0800 you wrote:
> This series includes some bugfixes for the HNS3 ethernet driver.
> 
> Huazhong Tan (1):
>   net: hns3: fix user's coalesce configuration lost issue
> 
> Jian Shen (1):
>   net: hns3: put off calling register_netdev() until client initialize
>     complete
> 
> [...]

Here is the summary with links:
  - [net,1/4] net: hns3: fix incorrect resp_msg issue
    https://git.kernel.org/netdev/net/c/a710b9ffbeba
  - [net,2/4] net: hns3: put off calling register_netdev() until client initialize complete
    https://git.kernel.org/netdev/net/c/a289a7e5c1d4
  - [net,3/4] net: hns3: fix user's coalesce configuration lost issue
    https://git.kernel.org/netdev/net/c/73a13d8dbe33
  - [net,4/4] net: hns3: check the return of skb_checksum_help()
    https://git.kernel.org/netdev/net/c/9bb5a495424f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


