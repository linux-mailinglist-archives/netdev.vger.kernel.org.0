Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF223F417E
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 22:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbhHVUat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 16:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232619AbhHVUar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 16:30:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9E21161261;
        Sun, 22 Aug 2021 20:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629664205;
        bh=3cjp4bqzs+7T3s1Hs8ikAufhX2dnXQOXIF7Lqgv7CEQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uuDDIuzJ+poj3N9YlwpKlvPxNkFwBvZ1nplyN0ePfyOCh848oYF4buNqCy/nrYbVH
         6N1HUg+DTsXySLeoo1Bkygh+GOiMgTR8fw2UbJApPZ/zfv7+obSdHK1Cc7PajMi/qz
         BSRRvVJrn5/eo6x0i+kwDXsdiobxT1Nyuf84TTdioLk2PQz2PpD4BED2RdE22yEnKY
         B69AwKRnb659jRY/yEEume9Q7rd9C+YeVZi6D8zeTk5o4wkx1k6tVtkzWqVWvwi3vd
         iTgl2FEUPTq0HIlm2Njnqf/O96/CpgYn9uP7EeSb9Xce8GM9fl7heZvMCl/aAbJV/a
         JdmcGYeKd0QMg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 94FA0609D8;
        Sun, 22 Aug 2021 20:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2 net] ip_gre: add validation for csum_start
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162966420560.25599.8216294924602342012.git-patchwork-notify@kernel.org>
Date:   Sun, 22 Aug 2021 20:30:05 +0000
References: <20210821071425.512834-1-chouhan.shreyansh630@gmail.com>
In-Reply-To: <20210821071425.512834-1-chouhan.shreyansh630@gmail.com>
To:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pshelar@nicira.com,
        willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sat, 21 Aug 2021 12:44:24 +0530 you wrote:
> Validate csum_start in gre_handle_offloads before we call _gre_xmit so
> that we do not crash later when the csum_start value is used in the
> lco_csum function call.
> 
> This patch deals with ipv4 code.
> 
> Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
> Reported-by: syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com
> Signed-off-by: Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
> 
> [...]

Here is the summary with links:
  - [1/2,net] ip_gre: add validation for csum_start
    https://git.kernel.org/netdev/net/c/1d011c4803c7
  - [2/2,net] ip6_gre: add validation for csum_start
    https://git.kernel.org/netdev/net/c/9cf448c200ba

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


