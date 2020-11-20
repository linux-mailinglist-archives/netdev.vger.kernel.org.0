Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53F12BB4E6
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 20:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732202AbgKTTKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 14:10:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:39536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730313AbgKTTKH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 14:10:07 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605899407;
        bh=VOEMY96QTF/Nl63l+dqKH+9SjH+GAXaBwT+S2w58TCY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PfBIDHq46sAPcJ4PfQf+Y1Xo0keRB8+TqaO8XsRXLCRbDHvMmaa5Y+0sdAZnhBHnC
         9Zim7gMpQTCQfqprbuyWCNIwV/6fJ1zLMNRu0ly8jkELzGYkCqH9KgmrYF8gP819pi
         aRiLQ/CMbVSMA3KL2u5aRwDdralvyjGbmAt36vIs=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] octeontx2-af: Fix return of uninitialized variable err
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160589940700.22082.1258915221742899209.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Nov 2020 19:10:07 +0000
References: <20201118132502.461098-1-colin.king@canonical.com>
In-Reply-To: <20201118132502.461098-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, davem@davemloft.net, kuba@kernel.org,
        naveenm@marvell.com, vattunuru@marvell.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 18 Nov 2020 13:25:02 +0000 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the variable err may be uninitialized if several of the if
> statements are not executed in function nix_tx_vtag_decfg and a garbage
> value in err is returned.  Fix this by initialized ret at the start of
> the function.
> 
> [...]

Here is the summary with links:
  - [next] octeontx2-af: Fix return of uninitialized variable err
    https://git.kernel.org/netdev/net-next/c/dd6028a3cb5d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


