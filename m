Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFB4441BF7
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 14:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbhKANwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 09:52:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231366AbhKANwk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 09:52:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9E6C960FE8;
        Mon,  1 Nov 2021 13:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635774607;
        bh=y1crDa6gBtxW7kRDjE1D2YEflH5VMy/OoGBTkRYvQG4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IZ55QwxmLhZieMGb+vRJfxwJDk8/7d6LEaxOhSQyjuAgvpaVVkjk0HBgVuZXE7/bu
         e5uRqk7TkUjLUFUwIJk0FvB3bKVVz+NR5+lIAPGCVpZrNbWnAvf5U4vGZw0ihybux8
         enC2gVzXZEgOxY5zogb4SlG9Jpu3vPYdY9lwELM9OIDFQq9VH+52HcHdGIQXZS1bdb
         HVzhjHcAqnSlD0xvoXRzJrbDUU3V9zVgwIjYUSKgv7m3YbuNZEp69w8HOKW+5I2Ddf
         PGuDStV2hDWfmaI0E/eo8ExxsiPPTljiS96VX5YRjQIP22NJ6FomZMnYu8rbLGTgPF
         hnkrL5e2TYfmQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8D66C60A94;
        Mon,  1 Nov 2021 13:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] Tracepoints for SMC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163577460757.13123.13168194829580546848.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Nov 2021 13:50:07 +0000
References: <20211101073912.60410-1-tonylu@linux.alibaba.com>
In-Reply-To: <20211101073912.60410-1-tonylu@linux.alibaba.com>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        guwen@linux.alibaba.com, dust.li@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon,  1 Nov 2021 15:39:10 +0800 you wrote:
> This patch set introduces tracepoints for SMC, including the tracepoints
> basic code. The tracepoitns would help us to track SMC's behaviors by
> automatic tools, or other BPF tools, and zero overhead if not enabled.
> 
> Compared with kprobe and other dymatic tools, the tracepoints are
> considered as stable API, and less overhead for tracing with easy-to-use
> API.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net/smc: Introduce tracepoint for fallback
    https://git.kernel.org/netdev/net-next/c/482626086820
  - [net-next,2/3] net/smc: Introduce tracepoints for tx and rx msg
    https://git.kernel.org/netdev/net-next/c/aff3083f10bf
  - [net-next,3/3] net/smc: Introduce tracepoint for smcr link down
    https://git.kernel.org/netdev/net-next/c/a3a0e81b6fd5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


