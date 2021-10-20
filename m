Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20DB1434C1A
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 15:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhJTNc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 09:32:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230183AbhJTNcZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 09:32:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B340B6138B;
        Wed, 20 Oct 2021 13:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634736610;
        bh=xbn4yc7QTCfLe76IhXxYK9bwbKpk6YjlP4Oa+lF9OeE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RJO3mfZjpqPg3CfJHjtg6mi2P5lXrgwnTBeUjv/qqxF9wzWUHcQ2WE8332gZ2Abu/
         UpEirTHZzFucbVbrSXSnSaCZXMc2LXG7Cprgszkc8tfGMUZRQ0b2cCn3qSmMHOR64G
         izN2VKWvlBi5HP9TowWAt1l//CvWQYXjJvKU280AVIfO6XPH3KGiddBP59IN9/8Sju
         xqRrahs/3yK+slsoWMfXNKGvA239Yb6fXO3jKa7l2Lx6Xd3csrUYd2io6nSy55Xy1V
         Oc2V42FQNsHJrO0nuzulEQ0eE+36kXRhCs5gzxryZf+h7pS+OxdB1lXrihw6rzLLNI
         eqoS6Bs3/Xk/Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ABF6B60A4E;
        Wed, 20 Oct 2021 13:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] batman-adv: use eth_hw_addr_set() instead of
 ether_addr_copy()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163473661069.3411.9735167830822051485.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Oct 2021 13:30:10 +0000
References: <20211019163927.1386289-1-kuba@kernel.org>
In-Reply-To: <20211019163927.1386289-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Oct 2021 09:39:27 -0700 you wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
> 
> Convert batman from ether_addr_copy() to eth_hw_addr_set():
> 
> [...]

Here is the summary with links:
  - batman-adv: use eth_hw_addr_set() instead of ether_addr_copy()
    https://git.kernel.org/netdev/net-next/c/0f00e70ef645

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


