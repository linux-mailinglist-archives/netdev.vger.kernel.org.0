Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADEA39ADD3
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 00:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhFCWVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 18:21:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230323AbhFCWVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 18:21:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3C4836140B;
        Thu,  3 Jun 2021 22:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622758806;
        bh=FYSlgkTTwKxUnCi1iKqfixMV2519veUXW+lTCer/ZME=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c7bk4MQPJO/ZL0bBUNZMmNGqTXnL1pwuQIPECBFD4jZGLnM6ws/djehrNQvF2C22m
         9R2aMZk1/azUrkKGthCB3jjiZfGiESY7TMb6H4Yx1AOZ/HfzoDWya6hbcChU4O2hog
         xnsitbys3CsQrNzZGgLtRRtX0/CMz0+Zbcd5GhWxxhMqiKjmPwC3jO5WtqEyiqo3iQ
         d3V5wMtEdPC2drQkPYzEtBQyHVvQPF2DIedU/e0JBXe8gwFYgdvw/AjuzTtz/uwiQe
         iIYXugXu+cBZtulVrnMymNBgtouPU6BJBJvyHqpXO8RQWTiuQ4jshZbDA9h1LnV/gd
         m0imPfpWmU3sw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2504660BCF;
        Thu,  3 Jun 2021 22:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] cxgb4: fix regression with HASH tc prio value update
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275880614.4249.16241829569001260386.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 22:20:06 +0000
References: <1622642939-21710-1-git-send-email-rahul.lakkireddy@chelsio.com>
In-Reply-To: <1622642939-21710-1-git-send-email-rahul.lakkireddy@chelsio.com>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rajur@chelsio.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  2 Jun 2021 19:38:59 +0530 you wrote:
> commit db43b30cd89c ("cxgb4: add ethtool n-tuple filter deletion")
> has moved searching for next highest priority HASH filter rule to
> cxgb4_flow_rule_destroy(), which searches the rhashtable before the
> the rule is removed from it and hence always finds at least 1 entry.
> Fix by removing the rule from rhashtable first before calling
> cxgb4_flow_rule_destroy() and hence avoid fetching stale info.
> 
> [...]

Here is the summary with links:
  - [net] cxgb4: fix regression with HASH tc prio value update
    https://git.kernel.org/netdev/net/c/a27fb314cba8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


