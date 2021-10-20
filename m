Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983D3434C15
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 15:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhJTNc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 09:32:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhJTNcY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 09:32:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8A2D26136A;
        Wed, 20 Oct 2021 13:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634736610;
        bh=6uQqYfRyWfKxFR/gwkwJPXaL2Gqb/Ta+wIyqTmzcdjA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lXI+atKdmyRkaadLKMB2RrZnzCGFuES7lr1IHYpZW65dvPM6KIeJDugFczsL6ZFfe
         ic0hJHlP8Xo4g93TfwJykyN1JWOQzP5VztiRPVu6+H5q9fXwMhjo3ufTNQNuKwtV71
         /w1VqRBtl58YxpXGBJ5vYuPfaCGYSndFjgZ6zyfA5csTW4AjuVlL1NMzxM0qpBQuOj
         uChlFFGFXROVrROr0HUZeOcCnHIUjyfi6Tdu7KHQZX0nNwhv/5yG0mY4/6iom5m/My
         ct7xqtoj6YlOnrbEek+z/nuflJloroXqAMrBuqjeCQZDjmNO16GmEfMhX7FpIZSEKo
         IR782zGkCM0uQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7EDBA60A24;
        Wed, 20 Oct 2021 13:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] mac802154: use dev_addr_set()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163473661051.3411.18302176926898716962.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Oct 2021 13:30:10 +0000
References: <20211019163606.1385399-1-kuba@kernel.org>
In-Reply-To: <20211019163606.1385399-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Oct 2021 09:36:05 -0700 you wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [1/2] mac802154: use dev_addr_set()
    https://git.kernel.org/netdev/net-next/c/659f4e02f15a
  - [2/2] mac802154: use dev_addr_set() - manual
    https://git.kernel.org/netdev/net-next/c/08bb7516e530

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


