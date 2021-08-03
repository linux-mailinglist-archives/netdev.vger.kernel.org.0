Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6842B3DEB78
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235583AbhHCLAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235566AbhHCLAR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:00:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CDF0661103;
        Tue,  3 Aug 2021 11:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627988406;
        bh=F62U+XGnjpU7rQkVwI2zkZXptJnDC2Ql5jZF+3KPQYE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IOKyrr9X5MN6JfRfF6WgmJ515KtPoOV9E6Dv9FQ5ZfuNsAZmCHHBINjZMhozFFOYq
         7rQL0imIM4JF4fHd9i5QYpvEKXo/BXcHVDMljUwvR/k7cS70L5JG0EA3YCC9YPoDrG
         c89LKxKrL7sgKHYFzWrEpjsJrZyKwThHAtTbA2vSbQEuqQm0YLjAHTcUMuSQh9Vdvy
         bZLezO5xXOY9W0M0BRKDV+LdzgiROgpYyx8Bjst39ger4vrT6WOKqaGaqlp3iXuhmJ
         hWeKScdrspNnU/+BpJbNmxnDgZ7kvCcNJjd+EvqFMcjrvtgfL+okt9n8Miq4FONSV6
         ATgry7VtgjM2g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C4C2C60A6A;
        Tue,  3 Aug 2021 11:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: Keep vertical alignment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162798840680.8237.7118417274045084461.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Aug 2021 11:00:06 +0000
References: <20210802080508.11971-1-yajun.deng@linux.dev>
In-Reply-To: <20210802080508.11971-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon,  2 Aug 2021 16:05:08 +0800 you wrote:
> Those files under /proc/net/stat/ don't have vertical alignment, it looks
> very difficult. Modify the seq_printf statement, keep vertical alignment.
> 
> v2:
>  - Use seq_puts() and seq_printf() correctly.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: Keep vertical alignment
    https://git.kernel.org/netdev/net-next/c/0547ffe6248c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


