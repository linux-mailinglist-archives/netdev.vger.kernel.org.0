Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFEC36CDCD
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 23:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239261AbhD0VXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 17:23:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236994AbhD0VXb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 17:23:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 95B5461403;
        Tue, 27 Apr 2021 21:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619558567;
        bh=yi9fitUjboxBTm5645ZOiOa07p9YKZlOZULR6s5CH/o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mBMWJX+8WVBAgJ7shIZodBDGVwZsa2xfN2Fg0YjS+SazMofLIAQwz0fGwFHo3OEsz
         cSKRFmlDjeS8rD7W9RbSnmWeC/Rby5BI5VGqHp3DCqN98ipC52LoeOk0n+G1ijdgxU
         KAeoqpyflTlvjFZtfCcRSn7S77dJjskLt/6+mrZQu6KILwZ8feTFvz9ZQks1dEs2jc
         /pqQV1jvy1ySF0HmrcDTn9VifmgBJTzGAqFz3bC+vW7KhVxwedrUl4AM/bR+Xa3+db
         mUdpc7799ShR6C5vwh8zM5Qw53SSGKYvfcr6F3TPL1CtMilexaYCUZlcNVCVOmzlF5
         nIxePQ1wUdlgg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8DE5460A24;
        Tue, 27 Apr 2021 21:22:47 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/smc: Remove redundant assignment to rc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161955856757.21098.4108992296506992502.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Apr 2021 21:22:47 +0000
References: <1619519542-62846-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1619519542-62846-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 27 Apr 2021 18:32:22 +0800 you wrote:
> Variable rc is set to zero but this value is never read as it is
> overwritten with a new value later on, hence it is a redundant
> assignment and can be removed.
> 
> Cleans up the following clang-analyzer warning:
> 
> net/smc/af_smc.c:1079:3: warning: Value stored to 'rc' is never read
> [clang-analyzer-deadcode.DeadStores].
> 
> [...]

Here is the summary with links:
  - net/smc: Remove redundant assignment to rc
    https://git.kernel.org/netdev/net-next/c/6fd6c483e7ab

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


