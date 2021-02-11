Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEB1318EB0
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 16:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbhBKPcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 10:32:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:55456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230090AbhBKPas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 10:30:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D121864E08;
        Thu, 11 Feb 2021 15:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613057406;
        bh=esNDs2TlYczqNDnZSVpIIGwqAN75p1dL3/P370G6BcQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pxFyZt3qlj7tdMREFz0KVAL5/1JX+XeJXHEyCxF2Mry7KEZs/Jz3in5URYfNnIpRs
         Claji9U/INgPI5Eb6p1HLvRJ38RVJfOYHriUufUlb56mEyBbS/dZcapm9kc1ovVBBt
         LHPRKXPCO2cKU6AKkLc17U2tO3o7gvmiUoR8Q6Jrz5SR5W76oWGF/yw3uNzl/FZl0j
         ym8WWb+IoW05518owpKxPDVWjSOHcrh5L5wqqLdK2iAdwYeKSdZsNjTQK/zvbk5fF6
         mWvgo9q9Gwd/q3tnXD/NQ95eLeAzjRYZVfEyYlOwN2JKBY+misDFgE4bNWmZhscy5L
         n/xK/G0ka4CjQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C094260A28;
        Thu, 11 Feb 2021 15:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v4] selftests/bpf: convert test_xdp_redirect.sh to bash
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161305740678.13437.18186613523777295983.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Feb 2021 15:30:06 +0000
References: <20210211082029.1687666-1-bjorn.topel@gmail.com>
In-Reply-To: <20210211082029.1687666-1-bjorn.topel@gmail.com>
To:     =?utf-8?b?QmrDtnJuIFTDtnBlbCA8Ympvcm4udG9wZWxAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, bjorn.topel@intel.com, u9012063@gmail.com,
        rdunlap@infradead.org, andrii.nakryiko@gmail.com, andrii@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Thu, 11 Feb 2021 09:20:29 +0100 you wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> The test_xdp_redirect.sh script uses a bash feature, '&>'. On systems,
> e.g. Debian, where '/bin/sh' is dash, this will not work as
> expected. Use bash in the shebang to get the expected behavior.
> 
> Further, using 'set -e' means that the error of a command cannot be
> captured without the command being executed with '&&' or '||'. Let us
> restructure the ping-commands, and use them as an if-expression, so
> that we can capture the return value.
> 
> [...]

Here is the summary with links:
  - [bpf,v4] selftests/bpf: convert test_xdp_redirect.sh to bash
    https://git.kernel.org/bpf/bpf/c/732fa3233066

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


