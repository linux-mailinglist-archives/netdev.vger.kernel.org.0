Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2486938CF85
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 23:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhEUVBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 17:01:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229613AbhEUVBe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 17:01:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AB3B5613F6;
        Fri, 21 May 2021 21:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621630810;
        bh=ghms6Xnact060zD3RhnBzr4n4P4odAXZYYmUVGHLzyI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bNn7NK3jX1Bg5Zc53+7xYzAvjMjubuWVByN6ZqwzYCxJ+5DM5W3s2+xK0FpLy5zzr
         nKFNH4U/p35g2acE9E1svh1iwNq19XZZipNAg5gaAiDDWTHLItRydDxHw8zj0lo+81
         KKIF3G0JJLJ7eYoTLQsSp4ut+AH9U7R0uVgJ0ylHPGXGwBjQZ7tlMdcZeVq4y7NBnY
         RVGCUvWBy8UQiKQjsz6ms5PadCH4SmfgoTIdHId78TKdtSVkLmL7BRjUACcy3JpvNT
         W+fVodY7+Ulwm0OGUfWB5YXwUm9puShgAmRktxmBFROPFL/XlEjDLsND62Fymq5FGI
         JNJTqkHqjftXg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A294360BCF;
        Fri, 21 May 2021 21:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] net: hns3: Fix return of uninitialized variable ret
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162163081066.24690.18151834351101510648.git-patchwork-notify@kernel.org>
Date:   Fri, 21 May 2021 21:00:10 +0000
References: <20210521100146.42980-1-colin.king@canonical.com>
In-Reply-To: <20210521100146.42980-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org, tanhuazhong@huawei.com,
        chenhao288@hisilicon.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 21 May 2021 11:01:46 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> In the unlikely event that rule_cnt is zero the variable ret is
> not assigned a value and function hclge_dbg_dump_fd_tcam can end
> up returning an unitialized value in ret. Fix this by explicitly
> setting ret to zero before the for-loop.
> 
> [...]

Here is the summary with links:
  - [next] net: hns3: Fix return of uninitialized variable ret
    https://git.kernel.org/netdev/net-next/c/030c8198d744

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


