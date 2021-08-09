Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4363E427F
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbhHIJU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234298AbhHIJUZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 05:20:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 576E161055;
        Mon,  9 Aug 2021 09:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628500805;
        bh=3zRG7v/waZcxAgmTqiGZs19GVAjU11ZNwz9T0OMd2pc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c5ySM2xe1N9Z1UkysGSk1Giax4WGu+jOG2kUOZyOW9ViOI8O7fTYJNSE+RtTSWrqo
         c40Da9cVxoGQ6EN7BFp3ueXjiNT0o3DkAbk8DlGY8tssJJJ7pExrokaCugXb1/yf2T
         83QJO08iqFWq1xQ+AuaJif+AzAA4sEMG4hcmJ+igvd0rBnweGrTNq63+FIsej/lB1V
         eQGL5/zq0ueqAxpCdkd7ykYIrhyDAS1jDMtvMHFt+qBH2AwmwZOp7TBp0j+PLyP4mc
         OZbhX/zoFydbRGnc60GZhy+t5Vhoun+rjqypAzy3lq91RYmqawmhDlES7M7HHTCLsU
         k9XOcDRCa6A1w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 47841609B8;
        Mon,  9 Aug 2021 09:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: ethernet: ti: cpsw: fix min eth packet size for
 non-switch use-cases
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162850080528.12236.16924791752972517567.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Aug 2021 09:20:05 +0000
References: <20210805145511.12016-1-grygorii.strashko@ti.com>
In-Reply-To: <20210805145511.12016-1-grygorii.strashko@ti.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        ben.hutchings@essensium.com, linux-kernel@vger.kernel.org,
        vigneshr@ti.com, linux-omap@vger.kernel.org, lokeshvutla@ti.com,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 5 Aug 2021 17:55:11 +0300 you wrote:
> The CPSW switchdev driver inherited fix from commit 9421c9015047 ("net:
> ethernet: ti: cpsw: fix min eth packet size") which changes min TX packet
> size to 64bytes (VLAN_ETH_ZLEN, excluding ETH_FCS). It was done to fix HW
> packed drop issue when packets are sent from Host to the port with PVID and
> un-tagging enabled. Unfortunately this breaks some other non-switch
> specific use-cases, like:
> - [1] CPSW port as DSA CPU port with DSA-tag applied at the end of the
> packet
> - [2] Some industrial protocols, which expects min TX packet size 60Bytes
> (excluding FCS).
> 
> [...]

Here is the summary with links:
  - [net,v2] net: ethernet: ti: cpsw: fix min eth packet size for non-switch use-cases
    https://git.kernel.org/netdev/net/c/acc68b8d2a11

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


