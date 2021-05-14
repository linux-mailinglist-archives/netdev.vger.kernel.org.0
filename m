Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4973813C5
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 00:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbhENWbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 18:31:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231377AbhENWbW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 18:31:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8FE9961440;
        Fri, 14 May 2021 22:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621031410;
        bh=Sr2DDLN/OytuLe9sXDaxByd6e67htdjdKJC34at71bA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s9oWQ7wZqKWTiNxsx+ZaYluFuRXPoeBns+GNgcKElX2GStvWihCbRrAn3y3gP3auV
         rdXfMUgMHozm0kU8yKO1aLSc8x4pPzbTBYSWJ7IJGpM9hAPJ+PMU2+CTM6nooaHT09
         LzLNuWs8e8ejF8qRD7iSosn/fNt0XmcbWtjHvKeN97+RehnSknps473RoDWmAY3KBO
         3r1SAwele9nygKTo6xXtUg+NF2oTYwxSP7alB/UjxxoHw1NZ1pJXFVybr383lFxZ5j
         ls04ADxeTBRn9QmCT/HY6fjQFQFE4pkr8TWI3zDV9DKXvPDNzw4dUItcIAwa2L3zyc
         wVAOhiUSY8D2w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 838B960981;
        Fri, 14 May 2021 22:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] tcp: add tracepoint for checksum errors
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162103141053.10202.2175233316256152170.git-patchwork-notify@kernel.org>
Date:   Fri, 14 May 2021 22:30:10 +0000
References: <20210514200425.279351-1-kuba@kernel.org>
In-Reply-To: <20210514200425.279351-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, netdev@vger.kernel.org,
        kernel-team@fb.com, rostedt@goodmis.org, dsahern@kernel.org,
        ntspring@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 14 May 2021 13:04:25 -0700 you wrote:
> Add a tracepoint for capturing TCP segments with
> a bad checksum. This makes it easy to identify
> sources of bad frames in the fleet (e.g. machines
> with faulty NICs).
> 
> It should also help tools like IOvisor's tcpdrop.py
> which are used today to get detailed information
> about such packets.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] tcp: add tracepoint for checksum errors
    https://git.kernel.org/netdev/net-next/c/709c03142399

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


