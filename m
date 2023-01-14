Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 570FB66A987
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 07:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjANGAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 01:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjANGAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 01:00:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E21E4480;
        Fri, 13 Jan 2023 22:00:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC17960B49;
        Sat, 14 Jan 2023 06:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 17803C433F0;
        Sat, 14 Jan 2023 06:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673676020;
        bh=zSW9xNwnAPa+T+qNFUMkGIU7UVe2Fp1a6h9A6ybeOr8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Drb/dcmDy+h8yz/wQHF48cLelF9O+iSey/khNWeOEqpBAQhIr/wzC0JOkY9PCAulK
         BmrQg2NdMBQRCwIyR/NIFWjyYPsIA+2GDUgxVyWTgKp4ANUuWwCK2HDW7WyKa6zlMO
         UgHnyAqYSgto/AkmZRIDq/MMTKzezfWPZ51bRM1V1fjK69F73d6zbiLx/pM2rCGAs4
         h4VctwzlJReFQpJVBexsBnE4r6p91MLZE3wtXAubate5ixs8IKsjrK2/q9U5Mi5igy
         grXrqXkbWYqlPYfGmCdTLyTtgYT5Eu8E2fTa3g4FeE4iuph3X/kcyDJUd1tA+iCtNJ
         jMT14vjp5ymlA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F27FCC395C8;
        Sat, 14 Jan 2023 06:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] mptcp: userspace pm: create sockets for the right
 family
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167367601998.19323.13140716148478946794.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Jan 2023 06:00:19 +0000
References: <20230112-upstream-net-20230112-netlink-v4-v6-v1-0-6a8363a221d2@tessares.net>
In-Reply-To: <20230112-upstream-net-20230112-netlink-v4-v6-v1-0-6a8363a221d2@tessares.net>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kishen.maloor@intel.com, fw@strlen.de, shuah@kernel.org,
        netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        pabeni@redhat.com, mathew.j.martineau@linux.intel.com,
        stable@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 12 Jan 2023 18:42:51 +0100 you wrote:
> Before these patches, the Userspace Path Manager would allow the
> creation of subflows with wrong families: taking the one of the MPTCP
> socket instead of the provided ones and resulting in the creation of
> subflows with likely not the right source and/or destination IPs. It
> would also allow the creation of subflows between different families or
> not respecting v4/v6-only socket attributes.
> 
> [...]

Here is the summary with links:
  - [net,1/3] mptcp: explicitly specify sock family at subflow creation time
    https://git.kernel.org/netdev/net/c/6bc1fe7dd748
  - [net,2/3] mptcp: netlink: respect v4/v6-only sockets
    https://git.kernel.org/netdev/net/c/fb00ee4f3343
  - [net,3/3] selftests: mptcp: userspace: validate v4-v6 subflows mix
    https://git.kernel.org/netdev/net/c/4656d72c1efa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


