Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8756488119
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 04:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbiAHDaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 22:30:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:32998 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233459AbiAHDaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 22:30:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D0A5B82833
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 03:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A45AAC36AED;
        Sat,  8 Jan 2022 03:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641612611;
        bh=wKjBz6vBeNM25YnhndKA/5OLCto4jKt0AA366xEvizU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K9pJrB8qx2fT749c58LElUcQ+XGD0/ha35/oNujuf1Fi1GEg3LY8WHLt7D0is3VIf
         9wzbk/Ky0qYrJ3cZ693KMGOpdOgHAl4ZRYMA3BW5u3L4duT/s8C9d+6qCZYlV1gQFu
         kiipvdPPGU7VYIOI+X9FiKSgRR9gyamfPvgyeiHAEbZUoGeqFQatOUx5cqSwrw6RYG
         AtcCXeeSx9fUW50YBK0fhZVGxCLmt2+5Z/oNw0W1awGH4W2eoNZX7jgeGUpTb57+SZ
         jlvVQG8GSDSGXBguOxFUcOgL6ZU1TABzn8irD1KrZLzN1zund24nyPy8es7cbkBfrF
         xdMi32xBYF7jA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 895D1F7940C;
        Sat,  8 Jan 2022 03:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next 00/10] ENA: capabilities field and cosmetic
 changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164161261155.5484.12402822472455920603.git-patchwork-notify@kernel.org>
Date:   Sat, 08 Jan 2022 03:30:11 +0000
References: <20220107202346.3522-1-akiyano@amazon.com>
In-Reply-To: <20220107202346.3522-1-akiyano@amazon.com>
To:     Arthur Kiyanovski <akiyano@amazon.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dwmw@amazon.com, zorik@amazon.com, matua@amazon.com,
        saeedb@amazon.com, msw@amazon.com, aliguori@amazon.com,
        nafea@amazon.com, netanel@amazon.com, alisaidi@amazon.com,
        benh@amazon.com, ndagan@amazon.com, shayagr@amazon.com,
        darinzon@amazon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 7 Jan 2022 20:23:36 +0000 you wrote:
> V2 Changes
> ----------
> Fixed "mixing different enum types" warning in patch
> 10/10 "net: ena: Extract recurring driver reset code into a function"
> 
> 
> Original Cover Letter
> 
> [...]

Here is the summary with links:
  - [V2,net-next,01/10] net: ena: Change return value of ena_calc_io_queue_size() to void
    https://git.kernel.org/netdev/net-next/c/7dcf92215227
  - [V2,net-next,02/10] net: ena: Add capabilities field with support for ENI stats capability
    https://git.kernel.org/netdev/net-next/c/a2d5d6a70fa5
  - [V2,net-next,03/10] net: ena: Change ENI stats support check to use capabilities field
    https://git.kernel.org/netdev/net-next/c/394c48e08bbc
  - [V2,net-next,04/10] net: ena: Update LLQ header length in ena documentation
    https://git.kernel.org/netdev/net-next/c/273a2397fc91
  - [V2,net-next,05/10] net: ena: Remove redundant return code check
    https://git.kernel.org/netdev/net-next/c/09f8676eae1d
  - [V2,net-next,06/10] net: ena: Move reset completion print to the reset function
    https://git.kernel.org/netdev/net-next/c/e34454698033
  - [V2,net-next,07/10] net: ena: Remove ena_calc_queue_size_ctx struct
    https://git.kernel.org/netdev/net-next/c/c215941abacf
  - [V2,net-next,08/10] net: ena: Add debug prints for invalid req_id resets
    https://git.kernel.org/netdev/net-next/c/9b648bb1d89e
  - [V2,net-next,09/10] net: ena: Change the name of bad_csum variable
    https://git.kernel.org/netdev/net-next/c/d0e8831d6c93
  - [V2,net-next,10/10] net: ena: Extract recurring driver reset code into a function
    https://git.kernel.org/netdev/net-next/c/9fe890cc5bb8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


