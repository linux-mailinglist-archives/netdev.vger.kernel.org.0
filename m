Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B59F3F48F5
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 12:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236352AbhHWKus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 06:50:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236198AbhHWKur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 06:50:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8D3D16138B;
        Mon, 23 Aug 2021 10:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629715805;
        bh=+NZm6SwBfuOmiLXrfx1E0+0v6lXO50bdoG+42+61gNE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=moRS2eYBgIO1QS2aOLtcfpxRLXaup2DvbdAphg4r7kj6QWouNEy10z/qHJw1EoAgc
         Bz6Xii10+JGvpscfpWDhHSVUGaj+s/eJ5VBpz3g/xyLakjlNfOCCK7klyIcBuEGkZo
         PoLDTVXjA9oj1H0c+BMiLYNHSqq85+/UAA2hJBySHYYacndCMEPXUuzBkfAmz3gbKO
         sm+RDX4oavjQni/KDU0yay6ef8JB/59sMDoggd4Hwt7LsovZKN9Zld1KHvjxWm1pX5
         UwWrAJn9GLHHJSK4aXMaxrc3wFTw6kie+JB9xUoYLR3pQwkgH/ESJMbYZQ7qDe1ZWe
         pNW42EAmEj3GQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7D49060075;
        Mon, 23 Aug 2021 10:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] xgene-v2: Fix a resource leak in the error handling path of
 'xge_probe()'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162971580550.31139.11625637788314697314.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Aug 2021 10:50:05 +0000
References: <ea7a73e68cd33652850b5392303b417693575dc4.1629531259.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <ea7a73e68cd33652850b5392303b417693575dc4.1629531259.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     iyappan@os.amperecomputing.com, keyur@os.amperecomputing.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 21 Aug 2021 09:35:23 +0200 you wrote:
> A successful 'xge_mdio_config()' call should be balanced by a corresponding
> 'xge_mdio_remove()' call in the error handling path of the probe, as
> already done in the remove function.
> 
> Update the error handling path accordingly.
> 
> Fixes: ea8ab16ab225 ("drivers: net: xgene-v2: Add MDIO support")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - xgene-v2: Fix a resource leak in the error handling path of 'xge_probe()'
    https://git.kernel.org/netdev/net/c/5ed74b03eb4d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


