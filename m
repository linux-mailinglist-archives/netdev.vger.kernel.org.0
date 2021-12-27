Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C3247FCB1
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 13:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbhL0MkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 07:40:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33368 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbhL0MkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 07:40:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A44AB8102E;
        Mon, 27 Dec 2021 12:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8EC81C36AEB;
        Mon, 27 Dec 2021 12:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640608809;
        bh=/NK8+LkGhicZgiX/HgeQA3rLcix8TFZ17hv+wILvgKY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qgKLSjNkeM5+8xOVP2S/ZUzAVttCObwil0/5LZziLctPXqN9PLO0V9AG5Xk1aFK6+
         t/5TqdhGhfUug1/0UG6EopDJzCyx74R53L2+1aInBimtexChVkOogl7IMMWzYY8hCd
         WcY7RohF0HAVLWMcpynBkr1kiVvEuiubQqG/NmewJjeHZwNUC/jtZ2xvTJEgA+YEER
         iXDO7dCjJtE/3CABa0m6Tg7n4MU8Nf3ziDofJSm51pQLlqi/vQ6QuugXe0uTHiT/NH
         CLGWtNF/avPtQT6fs0ns3H7ocy3DwRSnjanXPmLGE4VFFbFi3vNfkrSEl9mPzlLkar
         R1zuBTTYFiLQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7B6A6C395E6;
        Mon, 27 Dec 2021 12:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bridge: Get SIOCGIFBR/SIOCSIFBR ioctl working
 in compat mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164060880950.2123.6082560093716021616.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Dec 2021 12:40:09 +0000
References: <20211224114640.29679-1-repk@triplefau.lt>
In-Reply-To: <20211224114640.29679-1-repk@triplefau.lt>
To:     Remi Pommarel <repk@triplefau.lt>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, nikolay@nvidia.com,
        arnd@arndb.de, davem@davemloft.net, kuba@kernel.org,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 24 Dec 2021 12:46:40 +0100 you wrote:
> In compat mode SIOC{G,S}IFBR ioctls were only supporting
> BRCTL_GET_VERSION returning an artificially version to spur userland
> tool to use SIOCDEVPRIVATE instead. But some userland tools ignore that
> and use SIOC{G,S}IFBR unconditionally as seen with busybox's brctl.
> 
> Example of non working 32-bit brctl with CONFIG_COMPAT=y:
> $ brctl show
> brctl: SIOCGIFBR: Invalid argument
> 
> [...]

Here is the summary with links:
  - [net-next] net: bridge: Get SIOCGIFBR/SIOCSIFBR ioctl working in compat mode
    https://git.kernel.org/netdev/net-next/c/fd3a45900055

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


