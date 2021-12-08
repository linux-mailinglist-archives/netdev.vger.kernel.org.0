Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2081A46CD66
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 06:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237017AbhLHFxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 00:53:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbhLHFxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 00:53:45 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2E8C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 21:50:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B33F7CE200A
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 05:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DAE3AC00446;
        Wed,  8 Dec 2021 05:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638942610;
        bh=J+033KzidV3ml77vTwu2y6u4CkEYru6F1Y39cL5zY8s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V3T6Kr14EtXe3g8vsBcOSSyNpnBxgr2iWCCadMym4oWBz96zxjpZvEWhZHiDZjkWg
         l/VAlQeHjATvPquAJ//KN7MzCEPtQZwgRKcNY01EOGOhGgwjdCOLnMPQVVpMQgOvfI
         34PP4sCY0dTWdR9BPox6XSVeu1cKVNmUL1YiWKOJ74BGSkYavt7ldTdnsjtwvG/AnF
         NaXf6wrhCOWXAjggeMAtbpsA65gvqKipj5aiKBjv73KzYYqRSumInBawhJ+fdt1FBq
         yVfP7LqZfSMOEApOJYVrgEM8DJR6sTZ4n5jBvMSrS31o5wsNeUkx2DmcFecX6nw/Uu
         0DmiWgGq7PVkA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C65D360A53;
        Wed,  8 Dec 2021 05:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/5][pull request] Intel Wired LAN Driver Updates
 2021-12-06
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163894261080.12550.11980303493381086009.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Dec 2021 05:50:10 +0000
References: <20211206183519.2733180-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211206183519.2733180-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon,  6 Dec 2021 10:35:14 -0800 you wrote:
> This series contains updates to iavf and i40e drivers.
> 
> Mitch adds restoration of MSI state during reset for iavf.
> 
> Michal fixes checking and reporting of descriptor count changes to
> communicate changes and/or issues for iavf.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/5] iavf: restore MSI state on reset
    https://git.kernel.org/netdev/net/c/7e4dcc13965c
  - [net,v2,2/5] iavf: Fix reporting when setting descriptor count
    https://git.kernel.org/netdev/net/c/1a1aa356ddf3
  - [net,v2,3/5] i40e: Fix failed opcode appearing if handling messages from VF
    https://git.kernel.org/netdev/net/c/61125b8be85d
  - [net,v2,4/5] i40e: Fix pre-set max number of queues for VF
    https://git.kernel.org/netdev/net/c/8aa55ab422d9
  - [net,v2,5/5] i40e: Fix NULL pointer dereference in i40e_dbg_dump_desc
    https://git.kernel.org/netdev/net/c/23ec111bf354

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


