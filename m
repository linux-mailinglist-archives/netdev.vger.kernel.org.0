Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F611446261
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 11:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbhKEKwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 06:52:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231645AbhKEKwr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 06:52:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 189D06126A;
        Fri,  5 Nov 2021 10:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636109408;
        bh=qMIiZiv0eQoteCXhrpdDrRcNzDI4p0mpSQ/gDae3tQ4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VNd0JMp4mdKweVUDz7VT2tpFFHqjYqDOPUuUualvg5tYuUrkeV5QIxmQAcETAzGb8
         yR1Xt+frG/JJDn+rWpJVrgRU2p76whKOnaYjFfxIZgaZrZm0lhWnCNZ+pQBPDUAT00
         IVlvAEl4FnsxZDNrLzMW1ckhlSAohDL7+wiJxwPOeOt44TPiaLc+g+WA0d7+kk+GQJ
         /jYMLlAHy2aO3nt5ny5eiEncqDBYqOL+jFlj6KqKbzjZJnSnmz/dULB0P0EETXoZRP
         ThR4JKT8B0FmL+u3i12TbEOqdowJH96U42FWvBvUO6l/zCLXsVw0+IXBdbEhANAi7b
         B6nBA3ekgbCMA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0EDCD609B8;
        Fri,  5 Nov 2021 10:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ax88796c: hide ax88796c_dt_ids if !CONFIG_OF
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163610940805.24664.14336515464359871243.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Nov 2021 10:50:08 +0000
References: <20211104175527.91343-1-kuba@kernel.org>
In-Reply-To: <20211104175527.91343-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        l.stelmach@samsung.com, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  4 Nov 2021 10:55:27 -0700 you wrote:
> Build bot says:
> 
> >> drivers/net/ethernet/asix/ax88796c_main.c:1116:34: warning: unused variable 'ax88796c_dt_ids' [-Wunused-const-variable]
>    static const struct of_device_id ax88796c_dt_ids[] = {
>                                     ^
> 
> The only reference to this array is wrapped in of_match_ptr().
> 
> [...]

Here is the summary with links:
  - [net] net: ax88796c: hide ax88796c_dt_ids if !CONFIG_OF
    https://git.kernel.org/netdev/net/c/6789a4c05127

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


