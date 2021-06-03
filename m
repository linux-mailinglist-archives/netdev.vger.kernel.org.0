Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A1439ADD5
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 00:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhFCWVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 18:21:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230340AbhFCWVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 18:21:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4031F6140C;
        Thu,  3 Jun 2021 22:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622758806;
        bh=qMWKhQ9zVPFs5TLEZd8S+qNKxpNh8ZmKeEJ9BLZATJ0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=upEr3lVKkcsiVdatUkTxKa0L+cMURmjLvH2Yl94T2w3Aw6FPhzcZQYrous2JZG0Ci
         v5IGn7zR8cQuSfow7d7O+53JL0Qdh7s9TALjCA+kMrmbLJYdAoDSBeKHHjgolA4Dgq
         F7NgrP7DbD0fkjK0FI0YbmRq7AHAhCYGcpyiE2e0ormjzuvEF/iFYGq4gpVvh1PLWi
         Vsh6QOm62/IveQhDNNVmw6I3jm9iWfh1AVQKVzoZJJqsT9zF6W+s0LKZuTjejWAM3R
         lFbECjLELh4XMpWp+X3w+9RfuuPDHpCFnPP+LqoSRvpxWejqYDc1ZCbUNmusUNIfgl
         N/t4Xi+F4NEbw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2EA3060CFD;
        Thu,  3 Jun 2021 22:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] fib: Return the correct errno code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275880618.4249.18033822749874020105.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 22:20:06 +0000
References: <20210602140658.486553-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210602140658.486553-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 2 Jun 2021 22:06:58 +0800 you wrote:
> When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/core/fib_rules.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] fib: Return the correct errno code
    https://git.kernel.org/netdev/net/c/59607863c54e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


