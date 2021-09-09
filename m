Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39BB404828
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 12:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbhIIKBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 06:01:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233090AbhIIKBQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 06:01:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EE461611C1;
        Thu,  9 Sep 2021 10:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631181607;
        bh=/3DjLI1pXFFEQmud5Aht/uK4Vom8Qd+nzAirNRbDrC4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eoruNqu4KRsfH5d5VJkund9Ojv+WiISS0ql0dzjw//LlOrUXv8UvGYMprMo6xE6cM
         q3Bxgackgh6qfNC/Z2n85X1VxTLCjwLwtDTvmG7s9RzhPcunTDfphPSCkbRZYMYY/5
         jsLrFabI4jHRhd99sAwGOcJEFc84qDHVcWe1ZbD7nmQd342M71vpQTsoT7Bo2bZ4jG
         NUtjNCCfGw4PeO+LtEYoHS3X2FCEX2Z6hRsebhrNNNGzyO2zTldcKx5/Advm1jo+PJ
         3oeiPaGAAvYUCFuMT8l29ljblUFpgVTtrB18c6TwmGhwFmivTLIc208aKeTGvPVooa
         wIDnEgmoiDEuw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DE0A76098C;
        Thu,  9 Sep 2021 10:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/af_unix: fix a data-race in unix_dgram_poll
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163118160690.750.13446395925377334788.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Sep 2021 10:00:06 +0000
References: <20210909000029.1751608-1-eric.dumazet@gmail.com>
In-Reply-To: <20210909000029.1751608-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, cai@lca.pw
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  8 Sep 2021 17:00:29 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot reported another data-race in af_unix [1]
> 
> Lets change __skb_insert() to use WRITE_ONCE() when changing
> skb head qlen.
> 
> [...]

Here is the summary with links:
  - [net] net/af_unix: fix a data-race in unix_dgram_poll
    https://git.kernel.org/netdev/net/c/04f08eb44b50

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


