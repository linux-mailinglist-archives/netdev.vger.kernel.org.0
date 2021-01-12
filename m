Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA182F256C
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbhALBUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 20:20:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:52614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728780AbhALBUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 20:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5B04522DFB;
        Tue, 12 Jan 2021 01:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610414408;
        bh=+gg0Cg0pJI4V34RGadeFCvEn3nPCnw3lYatoiligCEo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QkZG1lJ87iGBn4ylD5QeYWPW/nacdnFstBcnu5K4tO4r4ruT+Xj7+qIOld2k5nCta
         mPw66rVH9Q+5baGQb+U48zKVTVQ4fSU8vH7XamoeRRuruZd0V09PpKWF9EblOzH9m8
         W84zEU5AdhFghdSmTE4hMPZfInJfoiK7gWs20TRbteKGt7KS2LQeghWFczsVplnnbe
         0k3w24iL9Q65HZZeBcJIrn2kGgwnnRkLDdfshsOkCalHQFe3idXsfnrF+tqW4jRVn9
         49wzqBAlDFZOsIB6L/0a61BfveOryUIvNmU6K46IlHQizcOWLZ5au+eoz+YHiqPMQN
         1u/MlmN5Ilyhw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 515C66013D;
        Tue, 12 Jan 2021 01:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bareudp: simplify error paths calling dellink
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161041440832.22670.14754081260970591975.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Jan 2021 01:20:08 +0000
References: <20210111052922.2145003-1-kuba@kernel.org>
In-Reply-To: <20210111052922.2145003-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 10 Jan 2021 21:29:22 -0800 you wrote:
> bareudp_dellink() only needs the device list to hand it to
> unregister_netdevice_queue(). We can pass NULL in, and
> unregister_netdevice_queue() will do the unregistering.
> There is no chance for batching on the error path, anyway.
> 
> Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net: bareudp: simplify error paths calling dellink
    https://git.kernel.org/netdev/net-next/c/1d04ccb916ce

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


