Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3B93FC66E
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 13:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241454AbhHaLLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 07:11:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241382AbhHaLLD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 07:11:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2B5B36101C;
        Tue, 31 Aug 2021 11:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630408208;
        bh=2GhBBqMiH0rbLQVZ7IZ5SQdTj7uVsort/8HwmN8+jjg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LOHbCzlOolRFP1Hgeg8QG3+b/JT3ZWuCLMEm8VHA1bsORQD+4LYHzbR7zPtsosYgg
         NZtf01Tn2H4EqyutXGjvlYuvtKJ23SSn2C58JE4hdHgYy7kYQH6LlncVH6NSnBufuj
         bEajQ1TWO8/ufyFFnNBsa127eWUsCridGQ2UJLunchqQ0bwU1STjwIQb3qRZvkK/60
         zaDf3PW+bFt0MnadHfa1nxJYp04eABGTp3Dyrm1AfbjtkWrTmjlGscOxaqRPmEp4yz
         Fp1oxlFZRWg5lPNLhAhsEybfeksx7cY9fei3OSek7pmxqEl5aXY3/mCZZqf8CKjgog
         NbgT1W251SQCA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2495A6097A;
        Tue, 31 Aug 2021 11:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH 0/4] octeontx2-af: Miscellaneous fixes in npc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163040820814.5377.1613123403228127582.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Aug 2021 11:10:08 +0000
References: <1630346446-21609-1-git-send-email-sbhatta@marvell.com>
In-Reply-To: <1630346446-21609-1-git-send-email-sbhatta@marvell.com>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sgoutham@marvell.com, hkelam@marvell.com, gakula@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 30 Aug 2021 23:30:42 +0530 you wrote:
> This patchset consists of consolidated fixes in
> rvu_npc file. Two of the patches prevent infinite
> loop which can happen in corner cases. One patch
> is for fixing static code analyzer reported issues.
> And the last patch is a minor change in npc protocol
> checker hardware block to report ipv4 checksum errors
> as a known error codes.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] octeontx2-af: Fix loop in free and unmap counter
    https://git.kernel.org/netdev/net-next/c/6537e96d743b
  - [net-next,2/4] octeontx2-af: Fix mailbox errors in nix_rss_flowkey_cfg
    https://git.kernel.org/netdev/net-next/c/f2e4568ec951
  - [net-next,3/4] octeontx2-af: Fix static code analyzer reported issues
    https://git.kernel.org/netdev/net-next/c/698a82ebfb4b
  - [net-next,4/4] octeontx2-af: Set proper errorcode for IPv4 checksum errors
    https://git.kernel.org/netdev/net-next/c/1e4428b6dba9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


