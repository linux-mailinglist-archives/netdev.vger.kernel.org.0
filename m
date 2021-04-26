Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B5236AA58
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 03:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbhDZBbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 21:31:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231624AbhDZBat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Apr 2021 21:30:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4488061078;
        Mon, 26 Apr 2021 01:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619400609;
        bh=6jb9AJs4kV6uHFTqtpcaVc1OuYzfoymaedOlUVvEJjI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O/LPHc9CMRDUDyLpTRFi/QMD5xQEf9TtbDnvoG519a37qyEpDEsYh8cpSaJQFyKfb
         mqey2vmvK1cFAAUUFX9JZkM5c8xI5as1D77KnFUl27qgtZuJUUxfyPewJfeHmzaYTR
         lCQLXiLtlUEgtgOhIJZdo8uMsZ/8TmWaYyUMybnrGdkhTxxkQJdTi9DMXZrH36LDze
         vl523rceuje6wlV4++uvqGw/atHlzBs84tWQm7J3Kyi7cf9om/kO1Vbtbe286pJr+A
         VES+kJE5mXop+Fx+1u37sZWFXN3bjfOOais10t27qrP11lS4fhw1+LUTpc9PZFXehJ
         SlK8gd9gUQyaw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 39FAE60283;
        Mon, 26 Apr 2021 01:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bnxt_en: Fix RX consumer index logic in the error path.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161940060923.7794.16850329658399665292.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Apr 2021 01:30:09 +0000
References: <1619215999-8880-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1619215999-8880-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 23 Apr 2021 18:13:19 -0400 you wrote:
> In bnxt_rx_pkt(), the RX buffers are expected to complete in order.
> If the RX consumer index indicates an out of order buffer completion,
> it means we are hitting a hardware bug and the driver will abort all
> remaining RX packets and reset the RX ring.  The RX consumer index
> that we pass to bnxt_discard_rx() is not correct.  We should be
> passing the current index (tmp_raw_cons) instead of the old index
> (raw_cons).  This bug can cause us to be at the wrong index when
> trying to abort the next RX packet.  It can crash like this:
> 
> [...]

Here is the summary with links:
  - [net] bnxt_en: Fix RX consumer index logic in the error path.
    https://git.kernel.org/netdev/net/c/bbd6f0a94813

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


