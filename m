Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2953845A269
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237111AbhKWMXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:23:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:48744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236987AbhKWMXS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 07:23:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 16BB561028;
        Tue, 23 Nov 2021 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637670010;
        bh=0lVcJZum6W4xNy+9ZKTwGVJW316u2ePgl5ubbQUy9m8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ACOM19bjqPG2q8pCNkpOnsuUMy+dk9Jc+lfknG8qt8fSC0hj+7gHO+fulwJwXgi3I
         74ZwoNdEafaIGPDLy4Y1wOdLjibRf0utSgGe9K5owA4KWXkB1hXKEjVFC6aSoPgUK+
         9n91HAmyZPUf/5tgfYZroLLpKI5oKv1COZB40u/sl+GRJzkHq2JkNvEk/aTUJzA6uF
         PIVAZh0TWCGbNT+sHgdPqJDGm28iBGGkfHUoskohSfxa5ECkvkoCI6lzCl7qgsZFXK
         sqp8lh3zfn3l/+cZCutpha6cwGZN9KS//6Y2QZg777coq6g3mjCS/NBnLf9aa1k9N7
         Uscldj1UepNCQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0DA5F60A22;
        Tue, 23 Nov 2021 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net: ipa: prevent shutdown during setup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163767001005.10565.5942873461526540232.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Nov 2021 12:20:10 +0000
References: <20211123001555.505546-1-elder@linaro.org>
In-Reply-To: <20211123001555.505546-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pkurapat@codeaurora.org,
        avuyyuru@codeaurora.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        evgreen@chromium.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 22 Nov 2021 18:15:53 -0600 you wrote:
> The setup phase of the IPA driver occurs in one of two ways.
> Normally, it is done directly by the main driver probe function.
> But some systems (those having a "modem-init" DTS property) don't
> start setup until an SMP2P interrupt (sent by the modem) arrives.
> 
> Because it isn't performed by the probe function, setup on
> "modem-init" systems could be underway at the time a driver
> remove (or shutdown) request arrives (or vice-versa).  This
> situation can lead to hardware state not being cleaned up
> properly.
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: ipa: directly disable ipa-setup-ready interrupt
    https://git.kernel.org/netdev/net/c/33a153100bb3
  - [net,2/2] net: ipa: separate disabling setup from modem stop
    https://git.kernel.org/netdev/net/c/8afc7e471ad3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


