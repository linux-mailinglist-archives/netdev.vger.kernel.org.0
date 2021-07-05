Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242AB3BC233
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 19:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbhGERWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 13:22:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229689AbhGERWl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 13:22:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BF68F61975;
        Mon,  5 Jul 2021 17:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625505603;
        bh=pZvfPoM2igkilq31o+fx7LhV3GjNPev5aqnZ76i/5gs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JOw8/IRJByl3F86V7Y1JHpiv0RKVOieIzbf4w9CB//f/Py5EEsAbWpWpk+ul9NSg6
         w5DgBL18LRnkTnZ93n58TVJyfD8G1tILBORE0FP7nSX+zxxgO++CTCoLljnjt0vikN
         FbZ5+d0819b8HobORpYHo6zafB+0vYW3zAMVExMPJAV9ZtX0QHEq1FiupN6AtBFnTR
         3ZRs36mcSgzu3DEBUhjOfMbU/HTeQupT+tRAVNnlSiy/cPfI3ZoQETqie2CamqjAf0
         pGZK4jvAx9RTq9Yhp2NCMK8J78bKXuNpOp2fZcGJL123pcHi485Svszr3P7mEE6GOw
         eLqo69rxFOIjg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B25FC60A48;
        Mon,  5 Jul 2021 17:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net] ptp: fix NULL pointer dereference in ptp_clock_register
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162550560372.14411.14251053697722539414.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Jul 2021 17:20:03 +0000
References: <20210705085306.15470-1-yangbo.lu@nxp.com>
In-Reply-To: <20210705085306.15470-1-yangbo.lu@nxp.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        richardcochran@gmail.com, davem@davemloft.net, rui.sousa@nxp.com,
        sebastien.laveze@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  5 Jul 2021 16:53:06 +0800 you wrote:
> Fix NULL pointer dereference in ptp_clock_register. The argument
> "parent" of ptp_clock_register may be NULL pointer.
> 
> Fixes: 73f37068d540 ("ptp: support ptp physical/virtual clocks conversion")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net] ptp: fix NULL pointer dereference in ptp_clock_register
    https://git.kernel.org/netdev/net/c/55eac20617ca

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


