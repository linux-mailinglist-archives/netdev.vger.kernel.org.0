Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4203B3918
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 00:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbhFXWMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 18:12:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229848AbhFXWMX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 18:12:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6E3AE6109D;
        Thu, 24 Jun 2021 22:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624572603;
        bh=qTIbyY46K3usD4H56bxQFh3mYxCSH1t6ibhbbpdpcek=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eT5SQerIlcbsoRNNo2a6E0j1xYVHWocuAMPgFnIKzc6/eFI5HUA8BYaM0V+1bodz4
         9JxEjgcrI/+WOtZlzaEWJuKhgvQ3f6icnUic2RzcOxn04O/G+gQnnx8zefAEEl1vUE
         C7WT9kXxwXeYmzWxmKRJl0Ksw0zemZGZBpStOwvdKxO20i3YcaAQ91r4l0vmbukgPU
         ObaM2Av8GjSFOIk51XaW2uO4Eu3XoqZRmnPvO8UBAA81vmevWNT+3cqGemZdhBjkqZ
         Zd07M+qBrirDnyGJGbwDfOhCCDkaX2Oq0gHbX8HJV86BE+AZacBNXrXmQGyYLZOEx4
         oCx+lwceLmbhg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5B08860A3C;
        Thu, 24 Jun 2021 22:10:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] e1000e: Check the PCIm state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162457260336.15112.6117107677728024147.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Jun 2021 22:10:03 +0000
References: <20210624190248.1213590-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210624190248.1213590-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, sasha.neftin@intel.com,
        netdev@vger.kernel.org, vitaly.lifshits@intel.com,
        dvorax.fuxbrumer@linux.intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 24 Jun 2021 12:02:48 -0700 you wrote:
> From: Sasha Neftin <sasha.neftin@intel.com>
> 
> Complete to commit def4ec6dce393e ("e1000e: PCIm function state support")
> Check the PCIm state only on CSME systems. There is no point to do this
> check on non CSME systems.
> This patch fixes a generation a false-positive warning:
> "Error in exiting dmoff"
> 
> [...]

Here is the summary with links:
  - [net,1/1] e1000e: Check the PCIm state
    https://git.kernel.org/netdev/net/c/2e7256f12cdb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


