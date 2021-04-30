Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A23737037D
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 00:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbhD3WbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 18:31:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230290AbhD3Wa7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 18:30:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0E0626145B;
        Fri, 30 Apr 2021 22:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619821811;
        bh=Myr4XOwmHT+IHQx0Mj/iR8KB1OmmVSvQVlZp9jSYxgk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n99OsmUSsUH17QtL9U0ZM1Rx3n5jXvoa22Jn9aIFdWSXRhDHnPqJr66TBnRdJpWbi
         jTPh5OrzdBzWfI6MIg2c/4H8iXWQKocRTlYPmAG3FfIHH3JVUKeXqgBv9WXF/ltMp2
         9e5Z0LeEU8J6ZXL3HYu6puqm7zEdKWWnGUTvM6W5Vf+fPHH3ExFeNabzitYugDXWG0
         +tcgnQqBiZGuwlhP79FWcCU+xWfERevkzrh3bEo/2+Q2CwFdBV/fekRAqsyJOv7Rg5
         I7fTC5MyS8aytd2Ca9G8NVrRAfQa4fC2d/h4eYBueXvJQ0WqvB26OtQxxU5eB+uzqY
         0CBfR04vypBbg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0179E60A3A;
        Fri, 30 Apr 2021 22:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] afs, rxrpc: Add Marc Dionne as co-maintainer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161982181100.1234.5819018643280872365.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Apr 2021 22:30:11 +0000
References: <20210430175009.14795-1-marc.dionne@auristor.com>
In-Reply-To: <20210430175009.14795-1-marc.dionne@auristor.com>
To:     Marc Dionne <marc.dionne@auristor.com>
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 30 Apr 2021 14:50:09 -0300 you wrote:
> Add Marc Dionne as a co-maintainer for kafs and rxrpc.
> 
> Signed-off-by: Marc Dionne <marc.dionne@auristor.com>
> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - afs, rxrpc: Add Marc Dionne as co-maintainer
    https://git.kernel.org/netdev/net/c/c5197b4ec932

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


