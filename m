Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64D23509C5
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 23:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbhCaVuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 17:50:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230380AbhCaVuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 17:50:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A1FCD61002;
        Wed, 31 Mar 2021 21:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617227409;
        bh=hDAdns5yLLF9BpCAN27zqxPldK3OnK/qYN+VV4/kA8s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bptXsAIXXMkZYNsjhCETlP7MqHa2G/FIrm5/1+tx4WzEMxX6eF0PGRk13+lUZJon9
         qQ8II9PtYopjkg8z8H+25W5wvxprHg0yH/nsSsQ/yL/bUvS+praCU+GsineNGAcHPj
         9MiWasBBzBqmoM/8nVBFVSd0DtYsi1jaqXKSxYfIX9LT7zf2XZ64mMqh8PsenIGl9s
         y6YXWY5n3Hzmg7hNdy4slMHR8Z6t12WjGq6r8+WFqkO4AmvxgLbUtR2XPHnTm9tbNp
         wPiFOwHRCxCyl91ggSiegMsoXC21JTUJqLFrI9T2wvJeKXLve5eoao6JYgUahpn1qU
         OCHULlMyr7Nkg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 95C1760283;
        Wed, 31 Mar 2021 21:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] net: fix some coding style issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161722740960.23154.3629056358879323696.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 21:50:09 +0000
References: <1617178714-14031-1-git-send-email-liweihang@huawei.com>
In-Reply-To: <1617178714-14031-1-git-send-email-liweihang@huawei.com>
To:     Weihang Li <liweihang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linuxarm@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 31 Mar 2021 16:18:27 +0800 you wrote:
> Do some cleanups according to the coding style of kernel, including wrong
> print type, redundant and missing spaces and so on.
> 
> Yangyang Li (1):
>   net: lpc_eth: fix format warnings of block comments
> 
> Yixing Liu (6):
>   net: ena: fix inaccurate print type
>   net: ena: remove extra words from comments
>   net: amd8111e: fix inappropriate spaces
>   net: amd: correct some format issues
>   net: ocelot: fix a trailling format issue with block comments
>   net: toshiba: fix the trailing format of some block comments
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] net: ena: fix inaccurate print type
    https://git.kernel.org/netdev/net-next/c/b788ff0a7d7d
  - [net-next,2/7] net: ena: remove extra words from comments
    https://git.kernel.org/netdev/net-next/c/e355fa6a3f40
  - [net-next,3/7] net: amd8111e: fix inappropriate spaces
    https://git.kernel.org/netdev/net-next/c/ca3fc0aa0837
  - [net-next,4/7] net: amd: correct some format issues
    https://git.kernel.org/netdev/net-next/c/3f6ebcffaf67
  - [net-next,5/7] net: ocelot: fix a trailling format issue with block comments
    https://git.kernel.org/netdev/net-next/c/1f78ff4ff708
  - [net-next,6/7] net: toshiba: fix the trailing format of some block comments
    https://git.kernel.org/netdev/net-next/c/142c1d2ed966
  - [net-next,7/7] net: lpc_eth: fix format warnings of block comments
    https://git.kernel.org/netdev/net-next/c/44d043b53d38

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


