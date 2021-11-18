Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7DC455B1A
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 13:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344422AbhKRMDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 07:03:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:38746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344403AbhKRMDK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 07:03:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 15FEF61265;
        Thu, 18 Nov 2021 12:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637236810;
        bh=xdVEYePZ4MHyu6ftETBlzQeJgWfwxB+1LMLpvjRoQoU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l2P+oCjo0xnjxmgsdVbg4R6iotuwJyU/SJr/umzTdUXHNxtBsUzOknd2oLcehoEZ5
         mIwvHchDBzpsCt1fo17AZ2q80yJYpA55BO7y203ITmrRe/qnNQVvT6CoE14CCN3eQw
         U/+HjLREcA82kaLtNr7rWTpwWrOikjN1FTgqLOhLeZiYkbkzmH5E6rleuSaRhFvDa4
         hOqOFqFl4wh+Vwlu51MEUMhdNgjDkWCAW5mf3yyk8n46TpqLasC2gzbYGwgE+YyTiS
         yFZnbYv/6Ct++/7ZqCBnx8L2HWBzFv6pdiH4iIP99EBi6NW5uCNnMdF+Dt2rKBXamM
         fsQAtZ09tDeqg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0396160BE1;
        Thu, 18 Nov 2021 12:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: tulip: de4x5: fix the problem that the array
 'lp->phy[8]' may be out of bound
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163723681000.21585.16416019300090762726.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Nov 2021 12:00:10 +0000
References: <20211118054632.357006-1-zhangyue1@kylinos.cn>
In-Reply-To: <20211118054632.357006-1-zhangyue1@kylinos.cn>
To:     zhangyue <zhangyue1@kylinos.cn>
Cc:     davem@davemloft.net, jesse.brandeburg@intel.com,
        gregkh@linuxfoundation.org, ecree@solarflare.com,
        netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 13:46:32 +0800 you wrote:
> In line 5001, if all id in the array 'lp->phy[8]' is not 0, when the
> 'for' end, the 'k' is 8.
> 
> At this time, the array 'lp->phy[8]' may be out of bound.
> 
> Signed-off-by: zhangyue <zhangyue1@kylinos.cn>
> 
> [...]

Here is the summary with links:
  - [v2] net: tulip: de4x5: fix the problem that the array 'lp->phy[8]' may be out of bound
    https://git.kernel.org/netdev/net/c/61217be886b5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


