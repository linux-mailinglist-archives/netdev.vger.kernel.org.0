Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA189455AEE
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344292AbhKRLx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:53:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:36018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344350AbhKRLxJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 06:53:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4DD54613DB;
        Thu, 18 Nov 2021 11:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637236209;
        bh=7kgdo1NyG7wX8rwxg1MlaziF0aHzwtvraPGAuiWFHyc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lzXgI9HKazZdECkJSKWlvj4hwNg9d9txJu9IQ20DCu5Jq/PdtroMVM5DJ8tpPyJG3
         lIkrrIWGPjlN/Ts1paNR+c04Cue4gCe7toN5mNoJkcb0SxMKepsYA3E03W+njaOp0v
         KPNttR2GfIYFXSqt+cHeT1t+++L+dZCK0SFvZW1iMz5iyyQjJBg7bAmeUQgSJDr4gi
         WD0QhJKzurns5uxGaFZSIQHMHCaXwlSXoc37TZNnA4X0Y0deFuCKfFXsAyqRbJ4gGl
         Cb39y8nBA5L28PGjSkG5lTjFruku5nTW16WYpuW0LBrEwr4/caLLHeYswJVpLrzyBt
         j2CpRqNcdJAAA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3D82460A4E;
        Thu, 18 Nov 2021 11:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] e100: fix device suspend/resume
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163723620924.17258.12932119103111984410.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Nov 2021 11:50:09 +0000
References: <20211117205952.3792122-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211117205952.3792122-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jesse.brandeburg@intel.com,
        netdev@vger.kernel.org, vaibhavgupta40@gmail.com, axet@me.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 17 Nov 2021 12:59:52 -0800 you wrote:
> From: Jesse Brandeburg <jesse.brandeburg@intel.com>
> 
> As reported in [1], e100 was no longer working for suspend/resume
> cycles. The previous commit mentioned in the fixes appears to have
> broken things and this attempts to practice best known methods for
> device power management and keep wake-up working while allowing
> suspend/resume to work. To do this, I reorder a little bit of code
> and fix the resume path to make sure the device is enabled.
> 
> [...]

Here is the summary with links:
  - [net,1/1] e100: fix device suspend/resume
    https://git.kernel.org/netdev/net/c/5d2ca2e12dfb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


