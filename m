Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE7573BA428
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 21:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhGBTCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 15:02:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230172AbhGBTCi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 15:02:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 260EB61420;
        Fri,  2 Jul 2021 19:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625252406;
        bh=xa/i1uOqu8sxFmOp3rjz1XohsFfxTdwnKDvS8p+KCoU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KNNRDgaGjpkZLc284sivlvPp2ljAiHA3vcW2vw++6KP82bf3u82e+05jDqC5zUSyC
         49r2PK/n2dL5kGQ0/D9OYz1+phqeFV0kbsqxoyC513N7PHhQOuV3idJ+fnGcyjzdaP
         KwWtqgJ5gY1+c60XwTmU1rBDJeg2qJWpm9fEShrsvSLrFS9BpsR/XoBnNcFfZWYEW+
         qx+05kAklBWOsPzuuLHHRpUss8+UtBe1eBusmi/EjyyU0/068LTu1crlVEIeFtK/eK
         Wip3GLvgABx2jisnaT9HAV//c9LLhL41uMonj2Ahid7Gg3tUQcHsym9Jp40FZRj6GN
         thdqE0/7JB+WA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 15E4860C09;
        Fri,  2 Jul 2021 19:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/sched: sch_taprio: fix typo in comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162525240608.2935.17440258239561986726.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Jul 2021 19:00:06 +0000
References: <162514541350.782166.18361886167078327975.stgit@firesoul>
In-Reply-To: <162514541350.782166.18361886167078327975.stgit@firesoul>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, dcaratti@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 01 Jul 2021 15:16:53 +0200 you wrote:
> I have checked that the IEEE standard 802.1Q-2018 section 8.6.9.4.5
> is called AdminGateStates.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  net/sched/sch_taprio.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net/sched: sch_taprio: fix typo in comment
    https://git.kernel.org/netdev/net/c/633fa666401c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


