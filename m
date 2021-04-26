Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E7D36BAC7
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 22:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbhDZUky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 16:40:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234084AbhDZUkv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 16:40:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3D310613B2;
        Mon, 26 Apr 2021 20:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619469609;
        bh=RWQhGgfz3v9H66TUdyw2BmYNNnB2p3/kneaImfnbxm4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=czMUe8wp5RUgiI9JE0kUq8iJYg35GjiHbRbQewbTH3ym0msGp7EsqBK6MJ9hGC0wL
         m/xLSYeCpwEEWKavOt0Md3aO+tVdyY1WVYpsKpEdqF7RqaHed0WKzRXE9gz8qYSNeG
         3WWWJNS2LSdQvqtX8eRb3fePRikTQBQc+e3D1PWdRDvdIqjnsZuBUzDl6klvd1APh8
         WHoEALz8z79tXd9HCdLM1ekauwJOaOb9PeDpXTst1+xPzMXJ4syRGUF3DfwhHdm8MV
         9vRFRjS0UncmJt8FchDLcxARAwdT6n87qLLp5C3jC1Hb4KHEjBikNrbV71L2NNI07w
         Q89gJWRMkZtoQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 34408609D6;
        Mon, 26 Apr 2021 20:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] net: Fix typo in comment about ancillary data
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161946960920.8317.12432939911608312137.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Apr 2021 20:40:09 +0000
References: <YIa1vyM7xuTKUqAL@kernel.org>
In-Reply-To: <YIa1vyM7xuTKUqAL@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     davem@davemloft.net, mingo@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 26 Apr 2021 09:44:47 -0300 you wrote:
> Ingo sent typo fixes for tools/ and this resulted in a warning when
> building the perf/core branch that will be sent upstream in the next
> merge window:
> 
>   Warning: Kernel ABI header at 'tools/perf/trace/beauty/include/linux/socket.h' differs from latest version at 'include/linux/socket.h'
>   diff -u tools/perf/trace/beauty/include/linux/socket.h include/linux/socket.h
> 
> [...]

Here is the summary with links:
  - [1/1] net: Fix typo in comment about ancillary data
    https://git.kernel.org/netdev/net-next/c/63fa73e21518

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


