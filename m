Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D04539AD61
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 00:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhFCWBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 18:01:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230255AbhFCWBs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 18:01:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9EA1661401;
        Thu,  3 Jun 2021 22:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622757603;
        bh=IU+5OvP4cRpZHO3L2TrP/+gtSkkFfCGDB6eAcj0i19U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HKqioyqwljVbv91sXK+iXaXAhVTBnSRpchdv8/D/pE95tt7y0hyAFR6H0axv9YJFQ
         sQB4hvua1/XYpU22RUu3Tadjh4RBbMZ28bqVcv3N+leeLD/H5+FACVzJdcIzNDRZE6
         0K0npbTaTh3SWTfWUVrkWcQrj2oDL0oVVmWxw0tC/ETpu+XQ5j67demStKiEvMUdny
         a4AWTaeXW+ooANksg8NGJelND5hshpsI8yjZqSJ+Y0q31EoSIfi0XNLsXYkDJLAYw4
         XsLIhn9/GFOA1ywp3qZDmru0xdmA/mb6VeYioXy0Vl9eWBJznFBB1mEATrVfSIR2Wa
         8rkUresNweMWg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 920F560A6F;
        Thu,  3 Jun 2021 22:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] net:cxgb3: replace tasklets with works
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275760359.27338.14404110046111441464.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 22:00:03 +0000
References: <20210603063430.6613-1-ihuguet@redhat.com>
In-Reply-To: <20210603063430.6613-1-ihuguet@redhat.com>
To:     =?utf-8?b?w43DsWlnbyBIdWd1ZXQgPGlodWd1ZXRAcmVkaGF0LmNvbT4=?=@ci.codeaurora.org
Cc:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ivecera@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu,  3 Jun 2021 08:34:29 +0200 you wrote:
> OFLD and CTRL TX queues can be stopped if there is no room in
> their DMA rings. If this happens, they're tried to be restarted
> later after having made some room in the corresponding ring.
> 
> The tasks of restarting these queues were triggered using
> tasklets, but they can be replaced for workqueue works, getting
> them out of softirq context.
> 
> [...]

Here is the summary with links:
  - [1/2] net:cxgb3: replace tasklets with works
    https://git.kernel.org/netdev/net-next/c/5e0b8928927f
  - [2/2] net:cxgb3: fix code style issues
    https://git.kernel.org/netdev/net-next/c/6a8dd8b2fa5b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


