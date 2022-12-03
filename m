Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783C264145B
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 06:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiLCFu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 00:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiLCFu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 00:50:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E637ACEFA6
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 21:50:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A177603F7
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 05:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E7D0C433D7;
        Sat,  3 Dec 2022 05:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670046624;
        bh=YqmU56PtILuScQenpLY/c3qP5BlQLYV8PPeImNtFRbk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hmQ8wfeyJuWMBZf5ws3Ncw3p8+oCRMA1CKjDxIb4hd+tRuOyTQaB+RlKa8ow8XvD+
         i+KoRC13mzkREhKfgG97CJ3vejNoVwIZxEh6jf5NnnQiPmXL5e7gfUYBpR9WQlIal4
         qBBv4CC7l0qya0ocdFwoBSBuwGN6wCeBLeGP7yRXyPJ80Z1VuiS3MjY35qzszhp67Y
         FYKIoa8oYf8qf3gJqQZWcIqs6/GMAbXlRRWrDI198lk540UHDtYcIL2C1TNkGpNO67
         +jmkny2TIzszmxllZ++/IxTj5n2MiQkyihIPCpGAg6iUUSsPRQm5ivD+MCSH3uPavH
         Ma48PGyGoq4bw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 81062C395F5;
        Sat,  3 Dec 2022 05:50:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: use 2-arg optimal variant of kfree_rcu()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167004662452.29967.13612462517553246760.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Dec 2022 05:50:24 +0000
References: <20221202052847.2623997-1-edumazet@google.com>
In-Reply-To: <20221202052847.2623997-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com, dima@arista.com,
        paulmck@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  2 Dec 2022 05:28:47 +0000 you wrote:
> kfree_rcu(1-arg) should be avoided as much as possible,
> since this is only possible from sleepable contexts,
> and incurr extra rcu barriers.
> 
> I wish the 1-arg variant of kfree_rcu() would
> get a distinct name, like kfree_rcu_slow()
> to avoid it being abused.
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: use 2-arg optimal variant of kfree_rcu()
    https://git.kernel.org/netdev/net-next/c/55fb80d518c7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


