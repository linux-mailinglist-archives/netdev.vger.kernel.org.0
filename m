Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CD4379958
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 23:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbhEJVlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 17:41:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231681AbhEJVlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 17:41:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D13D361584;
        Mon, 10 May 2021 21:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620682809;
        bh=QPt/UNofegvAbsQWf0UqOyiog3LWLfMcVOqHqysjNSI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jsn7exXwy/aFUpfLjx1dDuZa9FzFCM2rXweaQeelLnvTCmU6xGK/QlaGpEm6YRjr4
         dvD2s1pByibSZzvZn2GuFT1ugqi9hzzsi+jdYZqZHIBsJwdEQ5yCP+MzZP2Oekcl4x
         8WiVJqaS9OkEFuAEJpa8PZJ3u+DdUkExGNtpsyHU+53EDCw9JjOG5zoasj+eutk9SI
         FsWnnB8tXY+/MwvDkLAydq0HomsZNQOXb7NuzlDnbm23TzC836CpI7hlbo09FXOcGM
         AkmY3hnY39QyZnjWIjsdcHAoC/3Ooy6KTM8d+voMgyJRhmq3Q4X0VNzCks3ybdtfy9
         tD0QWzBMDvObg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C5F5860A6F;
        Mon, 10 May 2021 21:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: fix a crash if ->get_sset_count() fails
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162068280980.31911.14508724758195860125.git-patchwork-notify@kernel.org>
Date:   Mon, 10 May 2021 21:40:09 +0000
References: <YJaSe3RPgn7gKxZv@mwanda>
In-Reply-To: <YJaSe3RPgn7gKxZv@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 8 May 2021 16:30:35 +0300 you wrote:
> If ds->ops->get_sset_count() fails then it "count" is a negative error
> code such as -EOPNOTSUPP.  Because "i" is an unsigned int, the negative
> error code is type promoted to a very high value and the loop will
> corrupt memory until the system crashes.
> 
> Fix this by checking for error codes and changing the type of "i" to
> just int.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: fix a crash if ->get_sset_count() fails
    https://git.kernel.org/netdev/net/c/a269333fa5c0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


