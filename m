Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5524EA3A4
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 01:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiC1Xb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 19:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiC1Xb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 19:31:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B113C70B;
        Mon, 28 Mar 2022 16:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57BC5B81597;
        Mon, 28 Mar 2022 23:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12A0CC340F0;
        Mon, 28 Mar 2022 23:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648510212;
        bh=3zrdFqyGpud/uRApHrDGXEF/fLQQPmJXTLAAjCWYFNQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VcDaG1Ms9P2d3Um7npY+5fxp5wlM6UrdKMcvWHh37i8LYYSQFky0WnFVICI7b5uY6
         vZuxyl3NqF+vyCeLlTYh8+6RYaBfhVtwTmKdsMwY0ysz4HdgnS3JVLCUQNJdlGTk70
         IOKs4YICOTj4K6CQlePmsHQTepXgwowx++VKVGPJdE6wAJ0ArKkJXPWZ5AOAzzpSJZ
         UbCpZgpU1pbB0BDR35GtWsTBwx8XrIbO2Kwk+xVkt4QfpJZ3mFRaSxB8eSNR2KSXbG
         BsV5G06lT3QhBma1GEclFyXYJcK/bTlFt9n4gJkECFDSKg9l+kKfH0ucq8hiWzwLeb
         29B4emmTI0yag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ECCB2F03848;
        Mon, 28 Mar 2022 23:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "selftests: net: Add tls config dependency for tls
 selftests"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164851021196.6043.16813612682176165760.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Mar 2022 23:30:11 +0000
References: <20220328212904.2685395-1-kuba@kernel.org>
In-Reply-To: <20220328212904.2685395-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, paolo@vger.kernel.org,
        shuah@kernel.org, naresh.kamboju@linaro.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 28 Mar 2022 14:29:04 -0700 you wrote:
> This reverts commit d9142e1cf3bbdaf21337767114ecab26fe702d47.
> 
> The test is supposed to run cleanly with TLS is disabled,
> to test compatibility with TCP behavior. I can't repro
> the failure [1], the problem should be debugged rather
> than papered over.
> 
> [...]

Here is the summary with links:
  - [net] Revert "selftests: net: Add tls config dependency for tls selftests"
    https://git.kernel.org/netdev/net/c/20695e9a9fd3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


