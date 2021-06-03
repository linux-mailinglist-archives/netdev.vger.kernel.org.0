Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5509039ACE6
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 23:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhFCVbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 17:31:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229963AbhFCVbw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 17:31:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 645C4613F9;
        Thu,  3 Jun 2021 21:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622755807;
        bh=9ZW1bmzV6h5W7yp3MKPtM4rE53pVvzC/kouhzRQX8Jk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oDZOWEm4EsRPcl19vi1KL5iM94ifxgkeuPZfWw2W8NXZo6dH8Egn2GcBcOxjRuPvW
         Oj7nLt8pAjApujZwb4QbZbQojnS2cWDvRceeVH2Nc7ijEaV+9pwPECyv7ff8lfJ3J3
         /T+OrFtgNLj6eKmO0TZezH73Zdu9NdPqAq26hu4/pnQLoDWMFb0fB24xdtKUSFoplS
         ygP6RMV7FwFLBblBypqvDkkBjz9kmIfEyrOkE8X0UEdlAKi9x+r0jwqdDaAajlfcES
         DeIpcpbq7dGzxv90oQjlTmn0YyIX2kSgEwnCIPihCanqagEx0HYY5BPWAeTvrFIuGO
         P+yCer0u8H+Sw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 52C03609D9;
        Thu,  3 Jun 2021 21:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: bonding: Use strscpy_pad() instead of
 manually-truncated strncpy()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275580733.14468.13433184773362130626.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 21:30:07 +0000
References: <20210602205820.361846-1-keescook@chromium.org>
In-Reply-To: <20210602205820.361846-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     jay.vosburgh@canonical.com, lkp@intel.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  2 Jun 2021 13:58:20 -0700 you wrote:
> Silence this warning by using strscpy_pad() directly:
> 
> drivers/net/bonding/bond_main.c:4877:3: warning: 'strncpy' specified bound 16 equals destination size [-Wstringop-truncation]
>     4877 |   strncpy(params->primary, primary, IFNAMSIZ);
>          |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Additionally replace other strncpy() uses, as it is considered deprecated:
> https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings
> 
> [...]

Here is the summary with links:
  - [v3] net: bonding: Use strscpy_pad() instead of manually-truncated strncpy()
    https://git.kernel.org/netdev/net-next/c/43902070fb7b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


