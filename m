Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99FC639AE17
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 00:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhFCWcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 18:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231199AbhFCWbx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 18:31:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F073F61419;
        Thu,  3 Jun 2021 22:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622759408;
        bh=VR2EgFUzkhWsaVeoXpiw3g8oTbmLeCtrOY9/9p+B6Q4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ex1X+fKxL8h1GXmlcf0Mm1Rg93brthMNnpJDKXWKd485kWlGKl1J1w87yXqrCCTMM
         6try7PpVJgPJzdKeG8EhgNfu1LQRFHT45RNNgYn7wwIzrlmJidrefvbnxvBcvi7luD
         yc3YUn+ZJpkBz+5sRVDzUhqdD30wxyrbONZ6l/o2wxdRXuoydwQtUU3S1430OtUab+
         aBqUVmWOQfgBch7GCSa8gH4bkBIOfbPywHCzxCn9BzEHAY/hdOvJu22M0Vzx7svav9
         mky+9EbVgOb1bnXwC6O7hAO09gbsuAlJnKLHAt+Iv227TomQTyro1pYqk+CqHyJ/gq
         bDHqLNNZyMHkA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E182B60BCF;
        Thu,  3 Jun 2021 22:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ks8851: Make ks8851_read_selftest() return void
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275940791.8870.8895420469894707937.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 22:30:07 +0000
References: <20210603165612.2088040-1-nathan@kernel.org>
In-Reply-To: <20210603165612.2088040-1-nathan@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        ndesaulniers@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  3 Jun 2021 09:56:13 -0700 you wrote:
> clang points out that ret in ks8851_read_selftest() is set but unused:
> 
> drivers/net/ethernet/micrel/ks8851_common.c:1028:6: warning: variable
> 'ret' set but not used [-Wunused-but-set-variable]
>         int ret = 0;
>             ^
> 1 warning generated.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ks8851: Make ks8851_read_selftest() return void
    https://git.kernel.org/netdev/net-next/c/819fb78f6955

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


