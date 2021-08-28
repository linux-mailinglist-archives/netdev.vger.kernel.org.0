Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C02F3FA586
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbhH1Lk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:40:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233975AbhH1Lk4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Aug 2021 07:40:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B7A3760EE4;
        Sat, 28 Aug 2021 11:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630150805;
        bh=E9EMsV6iorQxskTrfqXypwjpfAPe+8dOmqVw4xtvOdI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AiNZk0Cmy0RvyCAtE1sVbODY82YDpDNWIQdpkA5SnGrv7jbRt+ls/n9/O8dx/D5ja
         zt/Z3f2Lw7C69IVwAIz5Ml/lBy04ikL2b9c049IcwCZj1azf16qk/fIo3wCENurfwt
         uPp1QFQPxLu000y5o78aA4KmOa1+EeIL2PbZGxWZumWuRcvOGUQj6P53PVyyoQ4N6X
         CY0chlJI2r+ezaMIkr9PNNAoXg/xWIC/pQzuDLKVhQ8kwba7RCi0pCMk6mwtTW8b2A
         pyG1/ATpDRbs3sNyLY7ZCLuXHdSMemfmNl9NY20PSyoJmSC41MiKRvyRPtFicM/71+
         cqE1TYklNhrSQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AA48F60A27;
        Sat, 28 Aug 2021 11:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates
 2021-08-27
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163015080569.10153.2604170346578282086.git-patchwork-notify@kernel.org>
Date:   Sat, 28 Aug 2021 11:40:05 +0000
References: <20210827204358.792803-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210827204358.792803-1-anthony.l.nguyen@intel.com>
To:     Nguyen@ci.codeaurora.org, Anthony L <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        richardcochran@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 27 Aug 2021 13:43:53 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Jake corrects the iterator used for looping Tx timestamp and removes
> dead code related to pin configuration. He also adds locking around
> flushing of the Tx tracker and restarts the periodic clock following
> time changes.
> 
> [...]

Here is the summary with links:
  - [net,1/5] ice: fix Tx queue iteration for Tx timestamp enablement
    https://git.kernel.org/netdev/net/c/84c5fb8c4264
  - [net,2/5] ice: remove dead code for allocating pin_config
    https://git.kernel.org/netdev/net/c/1f0cbb3e8916
  - [net,3/5] ice: add lock around Tx timestamp tracker flush
    https://git.kernel.org/netdev/net/c/4dd0d5c33c3e
  - [net,4/5] ice: restart periodic outputs around time changes
    https://git.kernel.org/netdev/net/c/9ee313433c48
  - [net,5/5] ice: Only lock to update netdev dev_addr
    https://git.kernel.org/netdev/net/c/b357d9717be7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


