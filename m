Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82AD401B19
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 14:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241723AbhIFMZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 08:25:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239957AbhIFMZK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Sep 2021 08:25:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E7AD560FBF;
        Mon,  6 Sep 2021 12:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630931045;
        bh=YAc5dCYA4VM0Orw/LMoUZvLHc5htkmQhu3WMS+sCNzY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nxGevUahmMXK/vCLLiu8LgqPjtL1eknQEL1el5Jiiio8uixFuvpDGwK7S+teMjTbO
         azJeJljg826AODCQ3RgJ348aBKl5QZJEtTkLhnkXnK94sv51gSotdFSNn4ZPEPgifD
         IL6UIBulo83koggUIvq9KLG8D2H6hu3XIn6KFtAJ9s4adu1rPA5q6b3hJhQI9M8iFO
         0Y8Bg4+2RjjHrTcdecg7yNoK+7XGnsk9Cnsbe76uMpq5Mo2yssrhr0e1jM2pF3WYz6
         oXBjYUJYhce5pynQYBJSuOHEHhpBZLSJ8hv7r9muu77s9t3KkZojXnxd2TH4ttgFSR
         odcqHx1qMTy7A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D8EBA60A6D;
        Mon,  6 Sep 2021 12:24:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] bonding: Fix negative jump count reported by syzbot
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163093104588.13830.13062104077711276057.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Sep 2021 12:24:05 +0000
References: <20210906085638.1027202-1-joamaki@gmail.com>
In-Reply-To: <20210906085638.1027202-1-joamaki@gmail.com>
To:     Jussi Maki <joamaki@gmail.com>
Cc:     netdev@vger.kernel.org, ardb@kernel.org, jbaron@akamai.com,
        peterz@infradead.org, rostedt@goodmis.org, jpoimboe@redhat.com,
        daniel@iogearbox.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon,  6 Sep 2021 10:56:36 +0200 you wrote:
> This patch set fixes a negative jump count warning encountered by
> syzbot [1] and extends the tests to cover nested bonding devices.
> 
> [1]: https://lore.kernel.org/lkml/0000000000000a9f3605cb1d2455@google.com/
> 
> Jussi Maki (2):
>   bonding: Fix negative jump label count on nested bonding
>   selftests/bpf: Extend XDP bonding tests with unwind and nesting
> 
> [...]

Here is the summary with links:
  - [net,1/2] bonding: Fix negative jump label count on nested bonding
    https://git.kernel.org/netdev/net/c/6d5f1ef83868
  - [net,2/2] selftests/bpf: Test XDP bonding nest and unwind
    https://git.kernel.org/netdev/net/c/4a9c93dc47de

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


