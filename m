Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194CD4A5E1E
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 15:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239167AbiBAOUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 09:20:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39170 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239151AbiBAOUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 09:20:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 503D3B82E3E;
        Tue,  1 Feb 2022 14:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D14E4C340ED;
        Tue,  1 Feb 2022 14:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643725209;
        bh=Na67gv+49YjqY2yngHBViPya9GdQ6ph1gdzIMuK4dh4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YP9cfGLbJG1t7YYGe4cskZ45CDqBS0WF1vd7WAA+9UaR6LlRL1FvljgundvN3rFig
         BkplXUrKdP5JmTua9bc5gw/JqUZNXrQhOxbYN32wlWDyaBhCnyuzRG/KKoRSlIuy6N
         fEvQZ7hM74TGEO93FC2PGH31l2PHGGFShGPXoaZyiC+r7jK8XXHD65WLyNsLB1ciQq
         NTsBAFh+OMOU74UZByMkE2wp4bDQXFngm1/l04T1oF/BPDSBzkj7vmfHHV5NZ2cwUt
         k/hOXkwuWNg0fAP4K2FT562ck8+wi9sXdT7RmSS0HSaTaNUg5YCycbjTYYtlfaxxqS
         YvP6umA1uVzww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B969CE5D07D;
        Tue,  1 Feb 2022 14:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] selftests: fib rule: Small internal and test
 output improvments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164372520975.31623.1854554114084409693.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Feb 2022 14:20:09 +0000
References: <cover.1643643083.git.gnault@redhat.com>
In-Reply-To: <cover.1643643083.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        roopa@cumulusnetworks.com, liuhangbin@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 31 Jan 2022 16:41:54 +0100 you wrote:
> The first half of these patch set improves the code logic and has no
> user visible effect. The second half improves the script output, to
> make it clearer and nicer to read.
> 
> Guillaume Nault (4):
>   selftests: fib rule: Make 'getmatch' and 'match' local variables
>   selftests: fib rule: Drop erroneous TABLE variable
>   selftests: fib rule: Log test description
>   selftests: fib rule: Don't echo modified sysctls
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] selftests: fib rule: Make 'getmatch' and 'match' local variables
    https://git.kernel.org/netdev/net-next/c/8af2ba9a7811
  - [net-next,2/4] selftests: fib rule: Drop erroneous TABLE variable
    https://git.kernel.org/netdev/net-next/c/2e2521136327
  - [net-next,3/4] selftests: fib rule: Log test description
    https://git.kernel.org/netdev/net-next/c/21f25cd43672
  - [net-next,4/4] selftests: fib rule: Don't echo modified sysctls
    https://git.kernel.org/netdev/net-next/c/9f397dd5f155

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


