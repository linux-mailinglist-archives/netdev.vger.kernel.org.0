Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC7A41D9D1
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 14:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350872AbhI3Mbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 08:31:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244692AbhI3Mbt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 08:31:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 55DE66137A;
        Thu, 30 Sep 2021 12:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633005007;
        bh=3SV7CMgKoNYDF0EvsEmKmRphzDtH67oMAwQOqzdI+j0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MQ8s4Yw4qHN+vEXVUR92pPl+xO6jL1PAd9XLPobLJpCEE9oEjBNVWpDSKAbzWsKT4
         W3waQeF0r19khF0EF7RXq3a4lER9V1lfRecgqD9nfLEv85J16WxiAER+lkbQzNeQrO
         CyeLBmFj7brMBXBHbuVQ6+v/RTcZVMKpXqCil3sUWFMuw6GiI+lfAilpRqFdwZFsCU
         nr4BuflCDGheWNivSzJhhldxYd3VC52xyW3BVnNYemJVwTfxsgcAmkdcWcholg8mp/
         GxC/qYqMSNgnvpmj7nvJE+yO4Cnl93LvYqqnneok8QhauQJ+lM20fNNSkDUXErGGuf
         76MnArMC3WrbA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4A11A60A9F;
        Thu, 30 Sep 2021 12:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: introduce and use lock_sock_fast_nested()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163300500729.24074.16162617259711797260.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Sep 2021 12:30:07 +0000
References: <59164fda628b5169d2dac9ecf7e85d3d6f9690f5.1632909427.git.pabeni@redhat.com>
In-Reply-To: <59164fda628b5169d2dac9ecf7e85d3d6f9690f5.1632909427.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mptcp@lists.linux.dev, tglx@linutronix.de, edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 29 Sep 2021 11:59:17 +0200 you wrote:
> Syzkaller reported a false positive deadlock involving
> the nl socket lock and the subflow socket lock:
> 
> MPTCP: kernel_bind error, err=-98
> ============================================
> WARNING: possible recursive locking detected
> 5.15.0-rc1-syzkaller #0 Not tainted
> 
> [...]

Here is the summary with links:
  - [net] net: introduce and use lock_sock_fast_nested()
    https://git.kernel.org/netdev/net/c/49054556289e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


