Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE5032248C
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 04:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhBWDKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 22:10:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:48898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230425AbhBWDKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 22:10:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 587C864E42;
        Tue, 23 Feb 2021 03:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614049808;
        bh=psVkPdOZPQJQE9+OBrmjZ3/UJdCVQgZG5WjWrSN/dZ0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c00EfgL4mKmTWr0n7R19EFAatZjZuwwnp5oFcPUlfUGXUxdIrXnN4Hr9+G2O7ZN2a
         t0/zlAKnsTaVqzFaNktbuiLzLrMI7CvaiivSBWyLIV8gMNFD5XovGftiPkwQ0WEfKv
         A9zyTRezGKtEgHYdubqcEEhrcemZ6guujsYa17qq22adY/TqDKAju+aS50aswQwtAa
         nC96qnqV08XmAB+NtFfjMBlXdob3PJIRvOZVMuf1TnmO3wMfwnO2RsnspVS5l8Xwg9
         G3gdnBDOxcjgnKTmXoLTX4a8TQ4lv+jPPW1rW7tKQTyh4MkVvpG3XnlLchQvhsWdeE
         FqSlK295I4FWw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 44DE6609CC;
        Tue, 23 Feb 2021 03:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] net: stmmac: fix CBS idleslope and sendslope
 calculation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161404980827.7081.5873991146634958711.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Feb 2021 03:10:08 +0000
References: <1613655653-11755-1-git-send-email-yoong.siang.song@intel.com>
In-Reply-To: <1613655653-11755-1-git-send-email-yoong.siang.song@intel.com>
To:     Song Yoong Siang <yoong.siang.song@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        boon.leong.ong@intel.com, weifeng.voon@intel.com,
        vee.khee.wong@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 18 Feb 2021 21:40:53 +0800 you wrote:
> From: "Song, Yoong Siang" <yoong.siang.song@intel.com>
> 
> When link speed is not 100 Mbps, port transmit rate and speed divider
> are set to 8 and 1000000 respectively. These values are incorrect for
> CBS idleslope and sendslope HW values calculation if the link speed is
> not 1 Gbps.
> 
> [...]

Here is the summary with links:
  - [net,1/1] net: stmmac: fix CBS idleslope and sendslope calculation
    https://git.kernel.org/netdev/net/c/24877687b375

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


