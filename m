Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1476E42E47E
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 01:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbhJNXCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 19:02:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233187AbhJNXCO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 19:02:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DEB946109E;
        Thu, 14 Oct 2021 23:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634252408;
        bh=gKc1dtrt6zjcyIw8Z1B5+AaJQudEPmc7ISbtCUKCkPc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Rlnoj5AXwBfLVpN7wh3SEjl9rnXcmhkV073xg23NWnlIgzzHm3Wbvh00ZlG0AQ9aW
         /3CSpNVWQ2E8mHFnH2J5G6uOid18nxvD++g8pprcoWkheF0EGt1Agg0ZxnZdaJk6Pk
         nFgo4+9JfGFQowxyOK+CWKU1SCe50FkVkhP7NAuFhxWBPNlKxXXza0nt76USUZV3kp
         ma8zLkDbTIODW+EtczxI83sR4iIbwVmBChhcSXl7eOQkaunCH5naIk7RD3Jv+EfHGM
         5QNPsGyuQ83sUbvwxAR6ntfGIS+uo+worIOoWePYf+5mRjL1L9nGIVjYQr1eCXHdHb
         oJAJrRWV95J2w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C831560A89;
        Thu, 14 Oct 2021 23:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] ethernet: constify references to netdev->dev_addr
 in drivers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163425240881.7869.9308256579215409248.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Oct 2021 23:00:08 +0000
References: <20211014142432.449314-1-kuba@kernel.org>
In-Reply-To: <20211014142432.449314-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 14 Oct 2021 07:24:31 -0700 you wrote:
> This big patch sprinkles const on local variables and
> function arguments which may refer to netdev->dev_addr.
> 
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] ethernet: constify references to netdev->dev_addr in drivers
    https://git.kernel.org/netdev/net-next/c/766607570bec

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


