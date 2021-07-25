Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843E53D4CAC
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 10:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhGYHtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 03:49:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229853AbhGYHtg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 03:49:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2EE7D60E78;
        Sun, 25 Jul 2021 08:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627201805;
        bh=++iZHUFRJrnskPTVRZkWuBMQvmEVHC7Zc5nr1wFaCUM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WuMhQGPWEUDdwbqij8q1JqbW9r4oc0dW2IxNbcfNFjV0n1Qoxy9V/0mfr7yuca5+W
         5hE5EWMKRrlrD0T5EY5ECy7JswWuMysPqaqkID5vys42ttv88BZmTfp/nTQSVwKR06
         inFRPr1wKHZfW8pQn+ACJ/bCjrtFkyOqBj+csaNHRbXPII9b7WTxPgHxyaB2KdGHQw
         VsZIFjutzAxyX6PSv/3mDwNihQ2XTrxCjju5Y+j6iCWjZVy7nCGEvmvayVPdCE4h5n
         cNgnlGxWpHvZM/rDnhlH68WZqJ94aO70mezpOTg2CCEJINq55wF3BHllPj1NulILTS
         v6Ap6PP6SKWjw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 22BC260A39;
        Sun, 25 Jul 2021 08:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH] octeontx2-pf: Dont enable backpressure on LBK links
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162720180513.26018.10340703695058875462.git-patchwork-notify@kernel.org>
Date:   Sun, 25 Jul 2021 08:30:05 +0000
References: <20210725075937.6491-1-gakula@marvell.com>
In-Reply-To: <20210725075937.6491-1-gakula@marvell.com>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lcherian@marvell.com, tduszynski@marvell.com, kuba@kernel.org,
        davem@davemloft.net, hkelam@marvell.com, sbhatta@marvell.com,
        sgoutham@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 25 Jul 2021 13:29:37 +0530 you wrote:
> From: Hariprasad Kelam <hkelam@marvell.com>
> 
> Avoid configure backpressure for LBK links as they
> don't support it and enable lmacs before configuration
> pause frames.
> 
> Fixes: 75f36270990c ("octeontx2-pf: Support to enable/disable pause frames via ethtool")
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net] octeontx2-pf: Dont enable backpressure on LBK links
    https://git.kernel.org/netdev/net/c/4c85e57575fb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


