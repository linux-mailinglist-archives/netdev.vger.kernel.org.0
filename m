Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9029F3F0D37
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 23:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhHRVUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 17:20:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229519AbhHRVUl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 17:20:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7A298610FF;
        Wed, 18 Aug 2021 21:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629321606;
        bh=/Ry8S8Gj1z5W/LWOnqpEhoUqnnrO3LktMLFMyuYptzY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=maIX39IUTfdnCfhk2TFL4pjOrmfa2n05Hhzpr2RJ+8pUpyN/yMZhJ4bBqCuXDvnJQ
         FvliEoVDSAtwOH43cxkCJXG7pL7EQX+gc4MGNmBKOV7w7iONQ+A9NDLkMeu1GqjBGo
         0yYNemGqYNvXo3n67YYhwpoBaOVv4TV2tFN2nCZB+WZGkm1mryFP6yU+MhGnA8VJrB
         6f4YW62qMiNnJyYB0G+1FW3b9ba12W6OlYmMqt+/GDCwRFg9Sv+sB3RZU39hdRVhSC
         f7Ho4JHbQVmXloXBmrsaWCIxIRhlSdn6SxykTAW/l6j22dCz2YrrHMmy565wD/PrCE
         CiRVtbqd80shw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6C94760A2E;
        Wed, 18 Aug 2021 21:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2 v3 0/3] bridge: fixes regarding the colorized output
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162932160643.2784.11551596107880873812.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Aug 2021 21:20:06 +0000
References: <20210817172807.3196427-1-gokulkumar792@gmail.com>
In-Reply-To: <20210817172807.3196427-1-gokulkumar792@gmail.com>
To:     Gokul Sivakumar <gokulkumar792@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org,
        stephen@networkplumber.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2.git (refs/heads/main):

On Tue, 17 Aug 2021 22:58:04 +0530 you wrote:
> v3:
>  - Remove the unnecessary is_json_context() condition checks from patch 2/3
>    as the print_string() call is used with the argument PRINT_FP.
> 
> v2:
>  - Replace the 2 newly introduced fprintf() func calls with print_string()
>    to address Stephen's suggestion.
> 
> [...]

Here is the summary with links:
  - [iproute2,v3,1/3] bridge: reorder cmd line arg parsing to let "-c" detected as "color" option
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=82149efee939
  - [iproute2,v3,2/3] bridge: fdb: don't colorize the "dev" & "dst" keywords in "bridge -c fdb"
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=057d3c6d378b
  - [iproute2,v3,3/3] man: bridge: fix the typo to change "-c[lor]" into "-c[olor]" in man page
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=10ecd126900b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


