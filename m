Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E0B39E845
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 22:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbhFGUWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 16:22:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231576AbhFGUVz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 16:21:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3F3C8611BD;
        Mon,  7 Jun 2021 20:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623097204;
        bh=ah//rITmD8l8j3hYYYq4hJIc2/tES3W55o2hZs5N/vM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dmHyqQZU8knhSygJI3JQ6/giisKCdpcm8zbrn32lGALKtlFVTGiaMJpGELoy8j8BR
         nvopFx2SKWngfyetzubhyQw/JKkkXakSh4IucQPLRzSA534BhdLzUuGt8ul3T9CelN
         VWVY+TX9gNxlA4LiL5MxhteSDqPUJa1WKnhUOZd199YX1XWpz1WuTtoyf6TiQlv0TA
         AtG4mu0oqibL4kFhvIcJpY1r6lfLkGWq1xzLRnDBZdwm0FELiyMfDPXoRbxuQiy9Bd
         d3dn+b7ik4GB3XnYGK7PJ4KFMrVsR53T1HBeAichJYjx34eQ1fWdTCIg94Pi3s2bU+
         eOBDVVCIY+4tw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3359B60283;
        Mon,  7 Jun 2021 20:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] pktgen: add pktgen_handle_all_threads() for the same code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162309720420.9512.14035963799887435600.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 20:20:04 +0000
References: <1623033461-3003-1-git-send-email-yejune.deng@gmail.com>
In-Reply-To: <1623033461-3003-1-git-send-email-yejune.deng@gmail.com>
To:     Yejune Deng <yejune.deng@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yebin10@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon,  7 Jun 2021 10:37:41 +0800 you wrote:
> The pktgen_{run, reset, stop}_all_threads() has the same code,
> so add pktgen_handle_all_threads() for it.
> 
> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> ---
>  net/core/pktgen.c | 38 +++++++++++++-------------------------
>  1 file changed, 13 insertions(+), 25 deletions(-)

Here is the summary with links:
  - pktgen: add pktgen_handle_all_threads() for the same code
    https://git.kernel.org/netdev/net-next/c/cda9de0b8daf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


