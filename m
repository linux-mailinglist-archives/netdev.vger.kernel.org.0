Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054733425D4
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 20:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhCSTKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 15:10:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230409AbhCSTKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 15:10:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 62B0761980;
        Fri, 19 Mar 2021 19:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616181009;
        bh=saxAoGIxGL4L6xLyFuwF3U+uMjJC9MvM2RF3gQ940U0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QE3CqL/Hoq/q465SHsdQB08P4gZyGLKLrzPCX2G70sfdKo5JAl9cfm5nX8928qw44
         Vkn4yeGiuWg6Xr2aojhCCcgZ4tvaAu/CYdGEyJisE6F7cl3KikWjLGMpt7wJozgv2N
         0vp2OcEnGqVQEwowuXzeyk2HDs7K8Iga+SNekaLLu5DRYwcH3hRCzGVRp/PClqIOoV
         JeoF7eVHmX0x49wgaycIZoEDjDr/HcfuWuItWhxE1S+WTBVaxzEz8nit4xEIhu1/gg
         mfPx2+bJDDsINOqNIAWz0ncarMrdgcciY/5XkbK/ft84MsTkQabZbBExpQxP38mzLy
         0ljreneloc+tw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 56B27626EE;
        Fri, 19 Mar 2021 19:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/1] taprio: Handle short intervals and large packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161618100935.534.1624173428310028848.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 19:10:09 +0000
References: <20210318073455.17281-1-kurt@linutronix.de>
In-Reply-To: <20210318073455.17281-1-kurt@linutronix.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     vinicius.gomes@intel.com, olteanv@gmail.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        kuba@kernel.org, bigeasy@linutronix.de, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 18 Mar 2021 08:34:54 +0100 you wrote:
> Hi,
> 
> there is a problem with the software implementation of TAPRIO and TCP
> communication. When using short intervals e.g. below one millisecond, large
> packets won't be transmitted. That's because the software implementation takes
> the packet length and calculates the transmission time. If the transmission time
> is larger than the configured interval, no packet will be transmitted. Fix that
> by segmenting the skb for the software implementation.
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] taprio: Handle short intervals and large packets
    https://git.kernel.org/netdev/net-next/c/497cc00224cf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


