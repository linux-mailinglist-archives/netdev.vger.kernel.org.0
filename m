Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D550148F9B8
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 23:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbiAOWuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 17:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233832AbiAOWuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 17:50:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D45C061574;
        Sat, 15 Jan 2022 14:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF157B80B91;
        Sat, 15 Jan 2022 22:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4FF92C36AE7;
        Sat, 15 Jan 2022 22:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642287009;
        bh=vi7uEDaCxYBK6oXWpcU2RtiiAI+c1pZqZAFhM8LdGqA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A8PFWg6aCmqo999VeFLzNnZ5NjU/mGOi/xw1qhKSTJKvKY8OenNRGVOFXDe/mBABV
         punnmIcFccV9bEUyZOyjBF6yK+a+VBCpD2g5CDeERQfmKOpKUqJqblUAUWiXttr1zJ
         igHtwT6s2ZWSMQBter4S4RGpt18KsTVdGvBdTjOvKJMX+J66xnvbcxlWfsgRwCCDJY
         Qn8RzLTw5BAroskiO3UlJoSwRndxMLR16YJbhYKu36YgwLkq6lQcwINuzZzh+d+o0S
         QWT1mxhemK1se23FCEBh614d8ovvHtkAnddA72ivVHuKQahhIAyV/lr8EXGpg2oMpM
         +IJn/pBc5NpoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 37DB1F6079E;
        Sat, 15 Jan 2022 22:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: wwan: Fix MRU mismatch issue which may lead to data
 connection lost
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164228700922.30034.13139773140713647841.git-patchwork-notify@kernel.org>
Date:   Sat, 15 Jan 2022 22:50:09 +0000
References: <20220115023430.4659-1-slark_xiao@163.com>
In-Reply-To: <20220115023430.4659-1-slark_xiao@163.com>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wsj20369@163.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 15 Jan 2022 10:34:30 +0800 you wrote:
> In pci_generic.c there is a 'mru_default' in struct mhi_pci_dev_info.
> This value shall be used for whole mhi if it's given a value for a specific product.
> But in function mhi_net_rx_refill_work(), it's still using hard code value MHI_DEFAULT_MRU.
> 'mru_default' shall have higher priority than MHI_DEFAULT_MRU.
> And after checking, this change could help fix a data connection lost issue.
> 
> Fixes: 5c2c85315948 ("bus: mhi: pci-generic: configurable network interface MRU")
> Signed-off-by: Shujun Wang <wsj20369@163.com>
> Signed-off-by: Slark Xiao <slark_xiao@163.com>
> 
> [...]

Here is the summary with links:
  - [net] net: wwan: Fix MRU mismatch issue which may lead to data connection lost
    https://git.kernel.org/netdev/net/c/f542cdfa3083

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


