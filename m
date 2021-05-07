Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA57A376D2D
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 01:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbhEGXLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 19:11:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229880AbhEGXLM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 19:11:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7D56F61469;
        Fri,  7 May 2021 23:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620429011;
        bh=5rhx6cXnG6ECkS9pH0sj0FqvmpcKymOqmIfOKz1znjA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O8ASfUNE0oNYn9UUnsg85eimqjQzF+3Vp0JxiaUTE/i0yyEMFxfcqwDuWau9ABVUM
         fciYTc1HdN94b3swceOnlX0pJusdmheWmk1DzUdraHtmdcSKPWQfz7+A4KG5BdsCir
         14W7HGl3Y/USUKqDSll4xlYy4sXrxOJnxBD4kBNHIlV03cY0MBP2JZ8mwLkZ3FZW+I
         2N1iF0M3eUZSvb8KFM1n3BpuEzSTkvdi10ABHb1TUBr8sekbWZBH5E7hTteawFJ1LM
         n1mYDcJhnA/Xh86yy4vqlYnXV2jHUvCCovIKkbbb34YF20pI88SFfHPZunwamxSQPP
         rjjJ8nrvXTIHQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6DCBC60A5C;
        Fri,  7 May 2021 23:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mptcp: fix splat when closing unaccepted socket
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162042901144.19618.5919379422935351498.git-patchwork-notify@kernel.org>
Date:   Fri, 07 May 2021 23:10:11 +0000
References: <20210507001638.225468-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210507001638.225468-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, fw@strlen.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  6 May 2021 17:16:38 -0700 you wrote:
> From: Paolo Abeni <pabeni@redhat.com>
> 
> If userspace exits before calling accept() on a listener that had at least
> one new connection ready, we get:
> 
>    Attempt to release TCP socket in state 8
> 
> [...]

Here is the summary with links:
  - [net] mptcp: fix splat when closing unaccepted socket
    https://git.kernel.org/netdev/net/c/578c18eff162

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


