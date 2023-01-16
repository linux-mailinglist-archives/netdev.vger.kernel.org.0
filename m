Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D0966BF99
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjAPNUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjAPNUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:20:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68AA2A5E5
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 05:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07A2A60FAA
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 13:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 631F5C433F1;
        Mon, 16 Jan 2023 13:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673875217;
        bh=7gLO1+iYpXTGqPXElGoBoiL7mQRceK+8QVVuj35+e0E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qv3Thkou5dXZq9WEKbwiGrXeKX2+VYecfqoVfYuHzWnwuIeeGz18Cer3lntixRbjt
         AI+P6U4YaOZA7St8zY40Y3mlwq+dDL9uxDfxufhhIMOKKOD5rV4qe0PC0lRAL45hWQ
         dSv74yLnZU/q8lSP3XuTrcWarfbPigj0P8EanilF14cY+nAF7Gxw6eNCpBsrsZnGfg
         TX5VkB9XdRYbWq7zTJXU5wPakHxB3TepwO8W173aQcZtAO5AUqGatdHu8Y+bbz67BO
         vrIoamgpn9dYA9QbyQ+mgLdZeqUF+t4gGF8coudXmQI+ewuPL1A7anZsOO9xIQdnsX
         CSLEXwLnGwpkg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 448C5E54D26;
        Mon, 16 Jan 2023 13:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v1] net: stmmac: Fix queue statistics reading
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167387521727.30194.4776508390029520899.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Jan 2023 13:20:17 +0000
References: <20230114120437.383514-1-kurt@linutronix.de>
In-Reply-To: <20230114120437.383514-1-kurt@linutronix.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        vijayakannan.ayyathurai@intel.com, vee.khee.wong@linux.intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 14 Jan 2023 13:04:37 +0100 you wrote:
> Correct queue statistics reading. All queue statistics are stored as unsigned
> long values. The retrieval for ethtool fetches these values as u64. However, on
> some systems the size of the counters are 32 bit. That yields wrong queue
> statistic counters e.g., on arm32 systems such as the stm32mp157. Fix it by
> using the correct data type.
> 
> Tested on Olimex STMP157-OLinuXino-LIME2 by simple running linuxptp for a short
> period of time:
> 
> [...]

Here is the summary with links:
  - [net,v1] net: stmmac: Fix queue statistics reading
    https://git.kernel.org/netdev/net/c/c296c77efb66

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


