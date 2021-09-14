Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC67340AF68
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 15:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbhINNm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 09:42:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233542AbhINNlZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 09:41:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7B30D61107;
        Tue, 14 Sep 2021 13:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631626808;
        bh=M5m8aOVqVbgMB0rsQlPtRMkCmz/sNk5nTp39tXw9pvk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tStRK2PJs+Ol1d9tsWF8QLjmnRjfJS4WjCTHshU5BhgKKE39XU8I3gu9k8ITIC9Nq
         thc0t3uh6N5OEIAp1/0ySy4qJFKPtVjN7R1J+AIEGqiwwpkg8Uwz6eba+GAUZVuL7k
         Y89AnCgww6Vptv5bsvtKGA7hl/C1LRP3tH8QJwYuiU96UD5quDVAJ8GbKz1gH/AVMI
         8rzyK0nUpWKPhyt50peYkG0RNNefkTUrOz/ibWWVmyOZf1iqhJXiDqNNgD0aqR1AT7
         xBS71G9TnR70Za+gptddfHsyyZksBeyqh185ysiLOh3KZHJB/6XDdkTyJBB7vK/Qdg
         XhuIbYWkO44Kg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6FEC460A7D;
        Tue, 14 Sep 2021 13:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] PF support get MAC address space assigned by
 firmware
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163162680845.2816.11518104751594889118.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Sep 2021 13:40:08 +0000
References: <20210914121117.13054-1-huangguangbin2@huawei.com>
In-Reply-To: <20210914121117.13054-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 14 Sep 2021 20:11:15 +0800 you wrote:
> This series add support PF to get unicast/multicast MAC address space
> assigned by firmware for the HNS3 ethernet driver.
> 
> Guangbin Huang (2):
>   net: hns3: PF support get unicast MAC address space assigned by
>     firmware
>   net: hns3: PF support get multicast MAC address space assigned by
>     firmware
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: hns3: PF support get unicast MAC address space assigned by firmware
    https://git.kernel.org/netdev/net-next/c/e435a6b5315a
  - [net-next,2/2] net: hns3: PF support get multicast MAC address space assigned by firmware
    https://git.kernel.org/netdev/net-next/c/5c56ff486dfc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


