Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9CD6C0D09
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 10:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbjCTJUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 05:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbjCTJUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 05:20:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25D512F1A;
        Mon, 20 Mar 2023 02:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07A49B80DB4;
        Mon, 20 Mar 2023 09:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AC617C4339C;
        Mon, 20 Mar 2023 09:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679304017;
        bh=pIc4REO26VA4fV9d9grTiPVMmQaAS83Z9ApkwNAfUiQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AcaNYHMQuzqFfP+ruOymMYBRZk9X/jQ2naJ4Z2hN48sRtjDItcSEe8ZibwuT7eoAU
         f8InAsAs942GvOYEsE3SFgoOA1LIOw3wrVnXIlYTpkwAt00xwBE36kokrDPx2FQsc3
         jf2B56kLAS7n5/dp5yCKHmL4EAhsM45S3xOGblCMmc5YUbY9d8VppE4BJ9XN6Jc3z0
         Jriyrlm1+TXs3L+jp8HPfveWDDlPX19gOiyWEgpQ9kGL6g/LIeEEsSsKftqjQpa8iQ
         YH/fZMt5qBE8tI/C5Vs6U+fJxVrjzsBiZTi/afLHZsZH8J0a7UaxC8jTpnKjcIYeQi
         nCJzYQlAOL/Ig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 880FAE4F0D8;
        Mon, 20 Mar 2023 09:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: report rx_bytes unadjusted for ETH_HLEN
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167930401755.16850.9444829347109631863.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Mar 2023 09:20:17 +0000
References: <20230317231900.3944446-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230317231900.3944446-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Sat, 18 Mar 2023 01:19:00 +0200 you wrote:
> We collect the software statistics counters for RX bytes (reported to
> /proc/net/dev and to ethtool -S $dev | grep 'rx_bytes: ") at a time when
> skb->len has already been adjusted by the eth_type_trans() ->
> skb_pull_inline(skb, ETH_HLEN) call to exclude the L2 header.
> 
> This means that when connecting 2 DSA interfaces back to back and
> sending 1 packet with length 100, the sending interface will report
> tx_bytes as incrementing by 100, and the receiving interface will report
> rx_bytes as incrementing by 86.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: report rx_bytes unadjusted for ETH_HLEN
    https://git.kernel.org/netdev/net/c/a8eff03545d4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


