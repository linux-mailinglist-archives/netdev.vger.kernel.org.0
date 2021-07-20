Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1BE3CFAB1
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239176AbhGTMyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 08:54:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239090AbhGTMtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 08:49:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7686660FF3;
        Tue, 20 Jul 2021 13:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626787810;
        bh=p5jcj52IyZ640oKL6LZiP8/fatySjZanfn0z9tObNho=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P7mfuviJQBDFKNKVh6x8Rg0M5hp56ZPZT86wKvpQLLNr0mT3kCkMgzjCyTftStcnR
         9lwpMVE1swO58/Oonikt4hA3ug/bFPmAhfoRYAO1/sXTaVw9nP2USnYi4Ye5ODsnr/
         wEGKVPJFiDwUuTLgmaN8Hhfpzr3vG7Ext+U46LE6ay4SSkHaMxYNsuDZXKNkW/D9iD
         IDCvWUwKyKdgawsiq2MwEqH8st3CCub5h7LHPs71FocfAr9NjHqPoiSsNLZ+9IoiHL
         Yil8UJxRaxq2jylOMKzE9PosuX7kOfVNOihVx7ElStABsy/ZRuteUsVFQadfEyeSdW
         0zJoaRDzP8FXg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6BD1060CCF;
        Tue, 20 Jul 2021 13:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3][pull request] 40GbE Intel Wired LAN Driver
 Updates 2021-07-19
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162678781043.19709.4855822079849128090.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 13:30:10 +0000
References: <20210719163154.986679-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210719163154.986679-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@kpanic.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 19 Jul 2021 09:31:51 -0700 you wrote:
> This series contains updates to iavf and i40e drivers.
> 
> Stefan Assmann adds locking to a path that does not acquire a spinlock
> where needed for i40e. He also adjusts locking of critical sections to
> help avoid races and removes overriding of the adapter state during
> pending reset for iavf driver.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] i40e: improve locking of mac_filter_hash
    https://git.kernel.org/netdev/net-next/c/8b4b06919fd6
  - [net-next,2/3] iavf: do not override the adapter state in the watchdog task
    https://git.kernel.org/netdev/net-next/c/22c8fd71d3a5
  - [net-next,3/3] iavf: fix locking of critical sections
    https://git.kernel.org/netdev/net-next/c/226d528512cf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


