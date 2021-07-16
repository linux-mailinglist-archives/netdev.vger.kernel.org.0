Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C963CBB65
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 19:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhGPRxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 13:53:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230317AbhGPRxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 13:53:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2847D61006;
        Fri, 16 Jul 2021 17:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626457810;
        bh=+OHq+QRUPz8J7Z8CUjSl5YweSjRjltsBg5wBtpB3NBQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z17ofL8c1OutwttK/+Up+3fYqSER7Uj7bZl8SnQx9ZZiJOif56Xfnzjx9Pi0Z2k5z
         NMRbA9VwlYBtVsCSex1AVBwqf7HYoElaIPHK7QtuXBfuvaSj6/7nJeosLoYIkbRfz8
         ick6/dYU99tdRJG8xeaSpsLsPcYx2dERtxZdnqazaD5GGuSuVjElCDACua5gzQBufg
         wEaM8m12b5g7b7qji1plH6IqnXybuesk5rRP8Ie4hVmcUCLHNvABPmffmfxJcMPs++
         Bk31zbMj/Ro0VhHT5c2IxvJgzPXxMdQN0acL6KIInv6FLetwHENbqkvYt5B1IXTa++
         nqaczTuAj0sTg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1B12D609CD;
        Fri, 16 Jul 2021 17:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1] gve: fix the wrong AdminQ buffer overflow check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162645781010.974.17788269720547248639.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Jul 2021 17:50:10 +0000
References: <20210714073501.133736-1-haiyue.wang@intel.com>
In-Reply-To: <20210714073501.133736-1-haiyue.wang@intel.com>
To:     Haiyue Wang <haiyue.wang@intel.com>
Cc:     netdev@vger.kernel.org, csully@google.com, sagis@google.com,
        jonolson@google.com, davem@davemloft.net, kuba@kernel.org,
        awogbemila@google.com, yangchun@google.com, willemb@google.com,
        bcf@google.com, kuozhao@google.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 14 Jul 2021 15:34:59 +0800 you wrote:
> The 'tail' pointer is also free-running count, so it needs to be masked
> as 'adminq_prod_cnt' does, to become an index value of AdminQ buffer.
> 
> Fixes: 5cdad90de62c ("gve: Batch AQ commands for creating and destroying queues.")
> Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
> ---
>  drivers/net/ethernet/google/gve/gve_adminq.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [v1] gve: fix the wrong AdminQ buffer overflow check
    https://git.kernel.org/netdev/net-next/c/63a9192b8fa1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


