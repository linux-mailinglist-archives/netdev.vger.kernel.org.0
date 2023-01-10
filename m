Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8A93663CE7
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 10:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbjAJJbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 04:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238196AbjAJJaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 04:30:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA77BF52;
        Tue, 10 Jan 2023 01:30:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 746B6B81158;
        Tue, 10 Jan 2023 09:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C39D0C433EF;
        Tue, 10 Jan 2023 09:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673343020;
        bh=f4QTHvAm0bJlaNyG1w8X8LGEBVJeXQa6+G99Td7DxwI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aY4fBdAaomONwO++R8UD6H+R7x45b665OzF7DKR1xkD9r6SoNNvxT4j8vUi+zbC7z
         X6QMo/gpUwX6FVE9fIw1bI4FDd6qlxxXoBliLy3j6trkYN1CGmHf0kvnNH0qs/dC/0
         7/q69AvkVxqJ5IZtE0C6iAVfMPZTj0apG+z9+dE7gfa2rWmc1WmbbGbxRP4zlJZWio
         uU3ewTV6OEaatqicE2xYJ7a7ItputSyg7PhqNyKNKmQ3pac7zT7AIgbgKAqNtcJl/I
         QM+puWNBK8fKCN6Om5EyNPoFNIvMPixu1kb3aBrn7yIpoaplqcc9VJT9UFFHzCwNgt
         ExQXg1QL8LHhA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B0E77E21EEA;
        Tue, 10 Jan 2023 09:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] selftests/net: Isolate l2_tos_ttl_inherit.sh in its
 own netns.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167334302072.30821.3386784278245230829.git-patchwork-notify@kernel.org>
Date:   Tue, 10 Jan 2023 09:30:20 +0000
References: <cover.1673191942.git.gnault@redhat.com>
In-Reply-To: <cover.1673191942.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, shuah@kernel.org,
        matthias.may@westermo.com, linux-kselftest@vger.kernel.org,
        mirsad.todorovac@alu.unizg.hr
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 8 Jan 2023 16:45:31 +0100 you wrote:
> l2_tos_ttl_inherit.sh uses a veth pair to run its tests, but only one
> of the veth interfaces runs in a dedicated netns. The other one remains
> in the initial namespace where the existing network configuration can
> interfere with the setup used for the tests.
> 
> Isolate both veth devices in their own netns and ensure everything gets
> cleaned up when the script exits.
> 
> [...]

Here is the summary with links:
  - [net,1/3] selftests/net: l2_tos_ttl_inherit.sh: Set IPv6 addresses with "nodad".
    https://git.kernel.org/netdev/net/c/e59370b2e96e
  - [net,2/3] selftests/net: l2_tos_ttl_inherit.sh: Run tests in their own netns.
    https://git.kernel.org/netdev/net/c/c53cb00f7983
  - [net,3/3] selftests/net: l2_tos_ttl_inherit.sh: Ensure environment cleanup on failure.
    https://git.kernel.org/netdev/net/c/d68ff8ad3351

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


