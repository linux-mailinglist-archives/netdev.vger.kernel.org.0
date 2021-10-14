Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587E342DD2A
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 17:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbhJNPEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 11:04:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233500AbhJNPDY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 11:03:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0EAD561220;
        Thu, 14 Oct 2021 15:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634223607;
        bh=smSENC3mLTuLUUlqpLohgWwuWCO3+iCKcSSrOeSQGhE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Frfgox0Xwp13WynuW8Cds35rBaV0fSUOBQR4ywTt7HiBif3kNa9JtzuQgqimUtjE2
         ArMn+9EAK0xD/2zHBLLsUUXP6aXwAbqeursBh6r79ccOswYigTaWVr9zD3okS0vRb6
         cnHzAO864JR1KpsV1h2yf6vDVNXzcCRpnEeUzKmcZuVHp46jn7qq27qGmQSqkY7dhC
         irZ0tvGgweVxGB62C2+5bF0454WFAYslWhArx+Zwqg7O4MwUGr9pFjcHRV9BsZ8KH5
         K30CN0pqN4Kss4C0ebHOrAxIfVEfIwXJfI5B0Z682xm755mOi6ap5bfyXPMnC0s+d9
         V3kjeeQU32vyA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F048D609ED;
        Thu, 14 Oct 2021 15:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 net] icmp: fix icmp_ext_echo_iio parsing in icmp_build_probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163422360697.15607.12769502675386988307.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Oct 2021 15:00:06 +0000
References: <31628dd76657ea62f5cf78bb55da6b35240831f1.1634205050.git.lucien.xin@gmail.com>
In-Reply-To: <31628dd76657ea62f5cf78bb55da6b35240831f1.1634205050.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, dan.carpenter@oracle.com,
        andreas.a.roeseler@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 14 Oct 2021 05:50:50 -0400 you wrote:
> In icmp_build_probe(), the icmp_ext_echo_iio parsing should be done
> step by step and skb_header_pointer() return value should always be
> checked, this patch fixes 3 places in there:
> 
>   - On case ICMP_EXT_ECHO_CTYPE_NAME, it should only copy ident.name
>     from skb by skb_header_pointer(), its len is ident_len. Besides,
>     the return value of skb_header_pointer() should always be checked.
> 
> [...]

Here is the summary with links:
  - [PATCHv3,net] icmp: fix icmp_ext_echo_iio parsing in icmp_build_probe
    https://git.kernel.org/netdev/net/c/1fcd794518b7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


