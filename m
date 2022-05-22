Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 516FD53061B
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 23:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351620AbiEVVUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 17:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240221AbiEVVUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 17:20:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD613616A
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 14:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0705B80B34
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 21:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 842F2C385B8;
        Sun, 22 May 2022 21:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653254412;
        bh=r4HW9MUWCE1K6Z2qBdkBViFhUf1UFB1uXySHr21HV/Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l80fcnMqgCQUKmj2Xv0q02XamAJ7wYvYeL47CbOThZjTLQlbvF/7BJppo6Yfixj9n
         Dmt69mkYVRNRdx50VZLLBNEaqVjSWcofF/5Rpp2WaLzTycwyIgtejWvRIDD+V8HzS4
         88gFs829NJNj9y+fnijo9RTaiXaZ/8dfQo0XQ1v4E67NEyUIdeuzGfdZIaUCtd+mHn
         BTfunvWeUI93qkEgXy2pb0jTNaOhzaaNd52lTmnSlyJA/z8GVE+VvOmuIefoFcmFsA
         f5eTfhpn7IDKHQYBrp099yxH3q9brKDfttxY1aVlDUSZSfzLNZXVANO62FSVKylKYQ
         YQI2U/kWr/npA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 67944F03938;
        Sun, 22 May 2022 21:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] Streamline Ocelot tc-chains selftest
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165325441242.2577.17495975339719125307.git-patchwork-notify@kernel.org>
Date:   Sun, 22 May 2022 21:20:12 +0000
References: <20220522095040.3002363-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220522095040.3002363-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 22 May 2022 12:50:37 +0300 you wrote:
> This series changes the output and the argument format of the Ocelot
> switch selftest so that it is more similar to what can be found in
> tools/testing/selftests/net/forwarding/.
> 
> Vladimir Oltean (3):
>   selftests: ocelot: tc_flower_chains: streamline test output
>   selftests: ocelot: tc_flower_chains: use conventional interface names
>   selftests: ocelot: tc_flower_chains: reorder interfaces
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] selftests: ocelot: tc_flower_chains: streamline test output
    https://git.kernel.org/netdev/net-next/c/980e74cac800
  - [net-next,2/3] selftests: ocelot: tc_flower_chains: use conventional interface names
    https://git.kernel.org/netdev/net-next/c/93196ef911ba
  - [net-next,3/3] selftests: ocelot: tc_flower_chains: reorder interfaces
    https://git.kernel.org/netdev/net-next/c/4ea1396a8bd5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


