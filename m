Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0091469DEA0
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 12:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbjBULUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 06:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233439AbjBULUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 06:20:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017221C5A9;
        Tue, 21 Feb 2023 03:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A87BB80EA3;
        Tue, 21 Feb 2023 11:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1CD25C4339B;
        Tue, 21 Feb 2023 11:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676978418;
        bh=z3v0BkjXRNKDmfVmm9V7eZM46F9Q2Kbmj0LCyBxPig0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=STkzzgKE0hS3nI2M8pjI5MyjVuyqEAts+05JyV82btqYZvKLbWBP9hcbk2UmQmqn0
         W6ZOpqLW76LUY6pO94GyGGcdL9sFs3Zo2kxhtr3fICAeAGtIcMOpZNXIxansPq4Ej8
         Hl8YBybW9HjMG3j4RC1an2EDYcBQ85WdvVNe1xYaA8tDuBHvxfWXIz0TBsOAPhmI3i
         gZwpdDYHrSslibgGTGO14KuhE3LhtB4H0tO/zLxTL+NG7o+0s/OaqJ1bB6tb4KWffj
         TwBakV90H3PINEGG6uu3/ayGPWQ6qKfcjw9XnBEGZeUk+ml7300Xwy4E6Q2aMVB+8/
         +CR9HkXkbUK4A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 03052C43159;
        Tue, 21 Feb 2023 11:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/1] selftest: fib_tests: Always cleanup before exit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167697841800.23862.3511124706194686998.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Feb 2023 11:20:18 +0000
References: <20230220110400.26737-1-roxana.nicolescu@canonical.com>
In-Reply-To: <20230220110400.26737-1-roxana.nicolescu@canonical.com>
To:     Roxana Nicolescu <roxana.nicolescu@canonical.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 20 Feb 2023 12:03:59 +0100 you wrote:
> Usually when a subtest is executed, setup and cleanup functions
> are linearly called at the beginning and end of it.
> In some of them, `set -e` is used before executing commands.
> If one of the commands returns a non zero code, the whole script exists
> without cleaning up the resources allocated at setup.
> This can affect the next tests that use the same resources,
> leading to a chain of failures.
> 
> [...]

Here is the summary with links:
  - [1/1] selftest: fib_tests: Always cleanup before exit
    https://git.kernel.org/netdev/net/c/b60417a9f2b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


