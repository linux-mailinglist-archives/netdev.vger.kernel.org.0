Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75EF167CB42
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 13:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234999AbjAZMuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 07:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjAZMuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 07:50:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC3D35AD;
        Thu, 26 Jan 2023 04:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02D7EB81D77;
        Thu, 26 Jan 2023 12:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4E87C4339B;
        Thu, 26 Jan 2023 12:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674737417;
        bh=yDz83fE7q/0XQMOijEOYcAWFyQhdt8Jgn/4oZ3kirN0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nBQBMEDZojeav/XHfb7xQcbOVJ9raYxpGhKotqobgZWFgECjuvTigUdyl+C8vH8Na
         XdB1pcboyv488/ttisuYTltw3TDpds4Lq0Vbx/dAEt+r2EZVx3M/ztC9EcuFrni0zv
         PJi9HOyV/xosV6a1CydGO8zI9migJrCiecj5j2NVmIAiuRcTEaesEGcEs/dEv3lVQo
         CZTDaMgX3lPTtvWFz5TugZYWxzii7BpEPGnhRStqX3AZQMYZ3GAL+1hgQEeV+D7ANH
         w+qqIVplPgYFLZoS3PsTIl/S46FUlAbgNlEPicEBFfNm/P0qUJBQrATulj6TO46F+Z
         oJmqjv8Xj6E+g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8ADD7F83ED5;
        Thu, 26 Jan 2023 12:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] mptcp: add mixed v4/v6 support for the
 in-kernel PM
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167473741756.10605.18145706805093327804.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Jan 2023 12:50:17 +0000
References: <20230123-upstream-net-next-pm-v4-v6-v1-0-43fac502bfbf@tessares.net>
In-Reply-To: <20230123-upstream-net-next-pm-v4-v6-v1-0-43fac502bfbf@tessares.net>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     mathew.j.martineau@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        shuah@kernel.org, netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 25 Jan 2023 11:47:20 +0100 you wrote:
> Before these patches, the in-kernel Path-Manager would not allow, for
> the same MPTCP connection, having a mix of subflows in v4 and v6.
> 
> MPTCP's RFC 8684 doesn't forbid that and it is even recommended to do so
> as the path in v4 and v6 are likely different. Some networks are also
> v4 or v6 only, we cannot assume they all have both v4 and v6 support.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] mptcp: let the in-kernel PM use mixed IPv4 and IPv6 addresses
    https://git.kernel.org/netdev/net-next/c/b9d69db87fb7
  - [net-next,2/8] mptcp: propagate sk_ipv6only to subflows
    https://git.kernel.org/netdev/net-next/c/7e9740e0e84e
  - [net-next,3/8] selftests: mptcp: add test-cases for mixed v4/v6 subflows
    https://git.kernel.org/netdev/net-next/c/ad3493746ebe
  - [net-next,4/8] mptcp: userspace pm: use a single point of exit
    https://git.kernel.org/netdev/net-next/c/40c71f763f87
  - [net-next,5/8] selftests: mptcp: userspace: print titles
    https://git.kernel.org/netdev/net-next/c/f790ae03db33
  - [net-next,6/8] selftests: mptcp: userspace: refactor asserts
    https://git.kernel.org/netdev/net-next/c/1c0b0ee2640b
  - [net-next,7/8] selftests: mptcp: userspace: print error details if any
    https://git.kernel.org/netdev/net-next/c/10d4273411be
  - [net-next,8/8] selftests: mptcp: userspace: avoid read errors
    https://git.kernel.org/netdev/net-next/c/8dbdf24f4e9e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


