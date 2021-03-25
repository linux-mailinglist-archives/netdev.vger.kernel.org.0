Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D46E3485D2
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 01:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239235AbhCYAUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 20:20:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239163AbhCYAUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 20:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 58F5E61A02;
        Thu, 25 Mar 2021 00:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616631608;
        bh=nsdcKLMb8xraXL4xCa/SySreQQ8WiU9McUIyu3phn7U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z0RxrOG9thDLbAv4wYWeAPcIZadKM5u1KC7BEqZnzxbnlQEvZJHV7kmlw3l656r0P
         U5gH1i3eOvVtx5IAGcUdesGgmq7rL+UHdnwXAljDW2YvxVWtBBMEqrss8rDs7d3XMM
         SLYC4joKOldyO48tERlg8TdOngZpuSFIYrdrYBmnFDsp1BQgnzoZA25JRn7dpTgyeg
         HPKwcpUjDuQRuNzkPkJ+IpQnf05n4i5Qt4ue8VXO2M8x7crzWCodIwLldng5T9Dfos
         ZZMwp0viGfxR6QjYmvxtrJLSb/QmNONVXLllnwiLCoRTW1kMTijpbGFNRF58KPT2fi
         XN2M8LSFu9Hbg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4754760A6A;
        Thu, 25 Mar 2021 00:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] psample: Fix user API breakage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161663160828.5502.5337161431170465792.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Mar 2021 00:20:08 +0000
References: <20210324194332.153658-1-idosch@idosch.org>
In-Reply-To: <20210324194332.153658-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yotam.gi@gmail.com, jiri@nvidia.com, petrm@nvidia.com,
        chrism@mellanox.com, sfr@canb.auug.org.au, idosch@nvidia.com,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 24 Mar 2021 21:43:32 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Cited commit added a new attribute before the existing group reference
> count attribute, thereby changing its value and breaking existing
> applications on new kernels.
> 
> Before:
> 
> [...]

Here is the summary with links:
  - [net] psample: Fix user API breakage
    https://git.kernel.org/netdev/net/c/e43accba9b07

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


