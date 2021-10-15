Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1CE42EE77
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 12:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237765AbhJOKMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 06:12:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231776AbhJOKMN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 06:12:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3854860F5D;
        Fri, 15 Oct 2021 10:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634292607;
        bh=0MfS7M8bqmbo6Sa8T+anrOM8zgErxdkmqGBEWGlx3Bg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hNMFicw3CpcMLPWuRShyIjlkm5feBOZf6kE4hjgOBlxon/hzgi5rz4OiyAhsy4LIs
         /pJwSEyHuC4qL8TbeZ42P4Es4F60slIjsSN9Wbjh44faDDvssamEhLQ1EwQnbbxC87
         zP7ow4wU37rRHHlw/iJQOejJJmNTOitYuSu27hTHJVfGxqABUAZJ2LOIZynd1ed7lZ
         X29CtjtsqFSNDUcSsKi+ZrBThnZ9axSq52N4/njfg9DbdNZ6uLwfkF8Roy7a6r/qbc
         +4GG8zPK4mx76XUwn7MwUYMO00t8bJ+MFL6qLF+Vx0YoDMFtCUzt88dHHq1LtpfuW4
         E6lQ9rzuuT80g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2907B60A47;
        Fri, 15 Oct 2021 10:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] xen-netback: Remove redundant initialization of variable err
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163429260716.22961.1289715814535736615.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Oct 2021 10:10:07 +0000
References: <20211013165142.135795-1-colin.king@canonical.com>
In-Reply-To: <20211013165142.135795-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     wei.liu@kernel.org, paul@xen.org, davem@davemloft.net,
        kuba@kernel.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 13 Oct 2021 17:51:42 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable err is being initialized with a value that is never read, it
> is being updated immediately afterwards. The assignment is redundant and
> can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - xen-netback: Remove redundant initialization of variable err
    https://git.kernel.org/netdev/net-next/c/bacc8daf97d4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


