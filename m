Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088C72EFD78
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 04:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbhAIDat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 22:30:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbhAIDat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 22:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id EBFEE23A23;
        Sat,  9 Jan 2021 03:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610163009;
        bh=IYGFO4MvnedkFA64oIZqSn4ZZZzbJMrWGvP/etkuUZA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b4+rOWYP2SzBj7Vzkn6kxoUrwJku3KuNaG2aeN/F5UshcgGYtvJlRlxGv3mSDuKn4
         4Kzrnzd8k6x63h4nxhRS+HQv12rve15hh4iopMqBqzbO95sUp1qdtm7gKR5kNUozY4
         FPJtNjyglI69IYUlXYdXVRKf6AJmoEVUyZKlCX7xJiUc4JsD8ZlHiJQjtrLc6dv7Jd
         u9GdflDTUdzaCRLUmRSz+igU+W7JuLc6GpiRbQmhnQoK3AjDMcVKMX6EPgBOCRArgL
         sXn3SnRczpOYat0Y6C89cJsjeqgUkfCH3KeyPQOc9vPpo7w2oBWFqSkgZVaR98roCm
         B2ngyCFi5oxZQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id DCE7F60077;
        Sat,  9 Jan 2021 03:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ppp: clean up endianness conversions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161016300890.29520.2938029470091032165.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Jan 2021 03:30:08 +0000
References: <20210107143956.25549-1-jwi@linux.ibm.com>
In-Reply-To: <20210107143956.25549-1-jwi@linux.ibm.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        xeb@mail.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  7 Jan 2021 15:39:56 +0100 you wrote:
> sparse complains about some harmless endianness issues:
> 
> > drivers/net/ppp/pptp.c:281:21: warning: incorrect type in assignment (different base types)
> > drivers/net/ppp/pptp.c:281:21:    expected unsigned int [usertype] ack
> > drivers/net/ppp/pptp.c:281:21:    got restricted __be32
> > drivers/net/ppp/pptp.c:283:23: warning: cast to restricted __be32
> 
> [...]

Here is the summary with links:
  - [net-next] ppp: clean up endianness conversions
    https://git.kernel.org/netdev/net-next/c/09b5b5fb3902

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


