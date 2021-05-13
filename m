Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32FA380099
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 01:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhEMXBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 19:01:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230471AbhEMXBU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 19:01:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 03BA96143D;
        Thu, 13 May 2021 23:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620946810;
        bh=nsJSRo+7Ytt7UcaicmFsSlaMaMiMjhx0ZooECTpsmO4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fyBYHYF2IUDVX3Rx/Rmfoo71p0EOR8QtrEGH9jC6llv915RTtU+zHmH/x6cO+EL7l
         Ef1/n80dZW2t/mWY1C62v+blmyJAxW+04UAuyGzjH7zIIW7N/7kjMUXd0lDqKGFG91
         qCPZH/LTZjGxfD2su+f4R3472PjFOTeqTLRtRsMGtfYgF6j69EQGIp1BtXrQkpkKLC
         Kn8EWN2KQGf6251AIGgXQ2x3Li7eek6kgxu4ULxvoUS/q8bkjlguXBSU9iligzk5Sf
         J5jUZWDY0+sGL8YIfUn85RVeXkaKIRTsbbo1Xn020/7AWPIsuvIVGXI2uj4xs0WIBa
         wnLX4b0NDjrNg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ED03960A71;
        Thu, 13 May 2021 23:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: korina: Fix return value check in korina_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162094680996.5074.17806365743510554760.git-patchwork-notify@kernel.org>
Date:   Thu, 13 May 2021 23:00:09 +0000
References: <20210513124621.2361806-1-weiyongjun1@huawei.com>
In-Reply-To: <20210513124621.2361806-1-weiyongjun1@huawei.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, tsbogend@alpha.franken.de,
        andrew@lunn.ch, akpm@linux-foundation.org,
        vvidic@valentin-vidic.from.hr, rppt@kernel.org,
        vincent.stehle@laposte.net, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, hulkci@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 13 May 2021 12:46:21 +0000 you wrote:
> In case of error, the function devm_platform_ioremap_resource_byname()
> returns ERR_PTR() and never returns NULL. The NULL test in the return
> value check should be replaced with IS_ERR().
> 
> Fixes: b4cd249a8cc0 ("net: korina: Use devres functions")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] net: korina: Fix return value check in korina_probe()
    https://git.kernel.org/netdev/net/c/c7d8302478ae

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


