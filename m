Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D76D336846
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 01:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhCKAAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 19:00:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:44308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhCKAAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 19:00:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 878C164F8B;
        Thu, 11 Mar 2021 00:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615420808;
        bh=0E0I+ff1Liy2eFkOvayqYxAfMni3Xc/hDqlHV0i1ZPI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W8IOImecuFYTcq+YT3tLaUIjD28WzviVm0aKGcYsnDtQ+CcS13Lh48Z+xoYtlEJCE
         ACuVO/MVUpnZQ90CiiDV93vfPHU3Jxfw84+vDPcqr3y5X3B0QVhF7/sDCcFua3Wr5D
         f5GXLK02f+9KNiQ64i4G9bxdQOGQayIcVtXqSWSqzj+8muVGi7dNVv1L3VB1cjKGS6
         Ipi9OexhpB5LZJne8Bu3liGX9I6QFN/xiL/DdYBugQbc6QSp6TuXMRiH/BDkqZLWyw
         rPy3K+nPQqohqpwnwhpG2bn0BIH5J4KiPzOTTGvgpRrILbP0/UzhdTOe2eIKMdXzK9
         FgKC2+Pmzn4Zg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 772C8609B8;
        Thu, 11 Mar 2021 00:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sched: validate stab values
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161542080848.19331.15044653729480069535.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Mar 2021 00:00:08 +0000
References: <20210310162641.264570-1-eric.dumazet@gmail.com>
In-Reply-To: <20210310162641.264570-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 10 Mar 2021 08:26:41 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> iproute2 package is well behaved, but malicious user space can
> provide illegal shift values and trigger UBSAN reports.
> 
> Add stab parameter to red_check_params() to validate user input.
> 
> [...]

Here is the summary with links:
  - [net] net: sched: validate stab values
    https://git.kernel.org/netdev/net/c/e323d865b361

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


