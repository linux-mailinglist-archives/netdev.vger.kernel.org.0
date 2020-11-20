Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D961B2BB4E2
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 20:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732191AbgKTTKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 14:10:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730455AbgKTTKH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 14:10:07 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605899407;
        bh=m0TWQf6lpOpr7lYhJVYQzvYp9Jc3GxNVnWqsgJgRPsE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=w+hYde8Tm7U7Jy/WLVGvJY+CCzAAj1EZ+QJuyLjv5QGXUEn8uMtiIRzKMsoVIQ3Ls
         4j+ehgxj0YpFs1dX1APi0rWZptmNFev4F88AElpAxJSK8EB20yFgxmGDJLXCtAzIaG
         tTNGrNyEfP+sBW1EdotbyXLEE+hm0JWNWlMg64k0=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] octeontx2-af: Fix access of iter->entry after iter
 object has been kfree'd
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160589940705.22082.10268101858431094788.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Nov 2020 19:10:07 +0000
References: <20201118143803.463297-1-colin.king@canonical.com>
In-Reply-To: <20201118143803.463297-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, davem@davemloft.net, kuba@kernel.org,
        naveenm@marvell.com, sbhatta@marvell.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 18 Nov 2020 14:38:03 +0000 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The call to pc_delete_flow can kfree the iter object, so the following
> dev_err message that accesses iter->entry can accessmemory that has
> just been kfree'd.  Fix this by adding a temporary variable 'entry'
> that has a copy of iter->entry and also use this when indexing into
> the array mcam->entry2target_pffunc[]. Also print the unsigned value
> using the %u format specifier rather than %d.
> 
> [...]

Here is the summary with links:
  - [next] octeontx2-af: Fix access of iter->entry after iter object has been kfree'd
    https://git.kernel.org/netdev/net-next/c/76483980174c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


