Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5488732DCDF
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbhCDWUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:20:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:54510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230173AbhCDWUH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 17:20:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 40D6B64FF1;
        Thu,  4 Mar 2021 22:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614896407;
        bh=9ZTghIdFnsjkM1MUFxGMu5Fb2MQbJL4mdxolzcpC3Y8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gdnNZl39/0bTaMmdLcqfNVmJ5pTL5aQuArCRe2hVZ6ZvRVcVKsgQ1QnHpVIbGuAM3
         FiueZ3TXBHjs5UsnLTUyc+DVN47p0suGm30TR9F/AQGZ6IAP24hA1v44jbzK1WlOU3
         zaO3Ekne0Kasxw6Y4OBbcdghIDYI1lZdvy5kewUNYKe8/GlC96o/M0MWi6GOn5N7rE
         Ub8tE+5QjKy6Hqn5GvTjXciCF35yXohE/wXAl38haAUanQ0OreHjDr0SWHTeVsQNuX
         /txak1UX2axzYdfYUqNDpV8SQDVs4H7rmdQhdu0YDpuGFaH80Kw/ehDVP8u0w4cmL0
         VKKE3FOQnXigQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3481D609E7;
        Thu,  4 Mar 2021 22:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mscc: ocelot: properly reject destination IP keys in
 VCAP IS1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161489640721.7668.3874779244511641169.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Mar 2021 22:20:07 +0000
References: <20210304102943.865874-1-olteanv@gmail.com>
In-Reply-To: <20210304102943.865874-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, vladimir.oltean@nxp.com,
        colin.king@canonical.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  4 Mar 2021 12:29:43 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> An attempt is made to warn the user about the fact that VCAP IS1 cannot
> offload keys matching on destination IP (at least given the current half
> key format), but sadly that warning fails miserably in practice, due to
> the fact that it operates on an uninitialized "match" variable. We must
> first decode the keys from the flow rule.
> 
> [...]

Here is the summary with links:
  - [net] net: mscc: ocelot: properly reject destination IP keys in VCAP IS1
    https://git.kernel.org/netdev/net/c/f1becbed411c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


