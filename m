Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE70C315754
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 21:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbhBIUAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 15:00:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:60492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233764AbhBITv5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 14:51:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4E53664ECD;
        Tue,  9 Feb 2021 19:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612898407;
        bh=6ml08oljkOTBm1M5u6bqlmApixnRbj2L/IRCvqbUrdY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QBu6ijnMNuS8Kwl4cYROW1suE5m8QAdQAHHOrWnJ+ceh9du3bfC21Lsr4u0Trttv5
         ZJ6b/D1bfL5xbZhCcS4vY7aMaRthDU9vGTUS1HPgWWkkC2jOKIN773o2D3vFLT+VXm
         pJ+/hZscQVHfOzj/FqCz6y/JvuKNxrHPQAHY9Wkg0NJimh4AG41u6u1KQLqKaqxCOm
         xSMcIG3VpkXm1Vv+K1zLGT6qMFW3tjcu468pDYs/wbyL1ebMqcomuj/QbmzqfioXW0
         zsXuQMq3e+WfbyXQdAHnioyVPplREMSKhPFyOiLzW/FgHDbF/qLN/uk8kWCGeODN2U
         S18DsOvwl2iMw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 423B2609E4;
        Tue,  9 Feb 2021 19:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Documentation: networking: ip-sysctl: Document
 src_valid_mark sysctl
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161289840726.9558.15613246762661154142.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Feb 2021 19:20:07 +0000
References: <1396.1612834621@famine>
In-Reply-To: <1396.1612834621@famine>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        corbet@lwn.net, linux-doc@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 08 Feb 2021 17:37:01 -0800 you wrote:
> Provide documentation for src_valid_mark sysctl, which was added
> in commit 28f6aeea3f12 ("net: restore ip source validation").
> 
> Signed-off-by: Jay Vosburgh <jay.vosburgh@canonical.com>
> 
> ---
>  Documentation/networking/ip-sysctl.rst | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)

Here is the summary with links:
  - [net] Documentation: networking: ip-sysctl: Document src_valid_mark sysctl
    https://git.kernel.org/netdev/net-next/c/8cf5d8cc3eae

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


