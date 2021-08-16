Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56CBD3ED5AA
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 15:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236691AbhHPNNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 09:13:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239500AbhHPNLZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 09:11:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2635961181;
        Mon, 16 Aug 2021 13:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629119406;
        bh=f8cophcSs/xA3I1ru18gymclsTpHCr85CeHZILHlY8M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MZkZT1/f9OiG8vXlM1LRAHRcx/ag/9UUTDJo9t5nigN/g7LsuoxSAgxG7kkm+vAGZ
         I1ssWX5WRMK+kllRYSsTaydTtOqSP+OnGlLciWUest34bnK++4ZAwlsfRvt5A0auJI
         +Ed7L7OsCZw2xRJEvMrJP5eiVH87zu6WJxTsTGrdB+rAmjiTr+D0usR1ozMZHFG9AZ
         lJPHsJdbH+7QUS1Dq7o305ytIykarzbv9DeJlkFHkItqni4fl8vp88oU7mH+znwzrO
         +eqJ8a0by+2mwjcOFmtnJfLOzTq0vlvWjqppBgqN9s2J5BeshkBCMjUd+HEdg8lE2v
         6wWm423/fAPog==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1AA5E604EB;
        Mon, 16 Aug 2021 13:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] bonding: improve nl error msg when device can't be
 enslaved because of IFF_MASTER
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162911940610.11903.10568526681617410281.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Aug 2021 13:10:06 +0000
References: <20210816100828.29252-1-atenart@kernel.org>
In-Reply-To: <20210816100828.29252-1-atenart@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 16 Aug 2021 12:08:28 +0200 you wrote:
> Use a more user friendly netlink error message when a device can't be
> enslaved because it has IFF_MASTER, by not referring directly to a
> kernel internal flag.
> 
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> ---
>  drivers/net/bonding/bond_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] bonding: improve nl error msg when device can't be enslaved because of IFF_MASTER
    https://git.kernel.org/netdev/net-next/c/1b3f78df6a80

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


