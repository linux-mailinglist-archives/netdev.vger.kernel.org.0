Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99136C6220
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 09:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbjCWImK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 04:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbjCWIlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 04:41:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD7C3801B
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 01:40:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25049624FD
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 756D3C433D2;
        Thu, 23 Mar 2023 08:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679560820;
        bh=ib/upVGJxm+b8wmfEgP/JGmSbs6uXw7/knZPsGNXP9E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A1wAunx3VYRxScwYSBx3ZwydU+69bVSQ//JFYTywbSIZ3WzurUtv+rjU3Tv5DLS5o
         sJPr/7c0hu16QnX746qh7UgZVym5Dh9b8Q5V/gI7yYQdoAsrlgceDk1FY9HuE+G0KT
         059DYOMnbBWkYAQMSIV/UOgCrtjB87CWm1V12dncpJZt/vhULQ31quHufLG2iNt75x
         R/bKYF5RzjGe+luGbUsndjpNSu3/RJtxLP+agAo0ZqPYRJEu1x1JB5IbwE3FlR0vh6
         ieJlgRjXLRpQIhdAq8GODNh4X63xoOS42stdcWXgBwfYFE22x+2LRkAKDEIPe1VIUR
         hIQ6OqfRlhcHg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5355EE61B86;
        Thu, 23 Mar 2023 08:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: Allow changing IPv4 address protocol
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167956082033.32268.14255202723457599070.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 08:40:20 +0000
References: <cover.1679399108.git.petrm@nvidia.com>
In-Reply-To: <cover.1679399108.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, dsahern@kernel.org,
        shuah@kernel.org, idosch@nvidia.com, Jacques.De.Laval@westermo.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 21 Mar 2023 12:51:58 +0100 you wrote:
> IPv4 and IPv6 addresses can be assigned a protocol value that indicates the
> provenance of the IP address. The attribute is modeled after ip route
> protocols, and essentially allows the administrator or userspace stack to
> tag addresses in some way that makes sense to the actor in question.
> 
> When IP address protocol field was added in commit 47f0bd503210 ("net: Add
> new protocol attribute to IP addresses"), the semantics included the
> ability to change the protocol for IPv6 addresses, but not for IPv4
> addresses. It seems this was not deliberate, but rather by accident.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: ipv4: Allow changing IPv4 address protocol
    https://git.kernel.org/netdev/net-next/c/5c4a9aa856c7
  - [net-next,2/3] selftests: rtnetlink: Make the set of tests to run configurable
    https://git.kernel.org/netdev/net-next/c/ecb3c1e675c7
  - [net-next,3/3] selftests: rtnetlink: Add an address proto test
    https://git.kernel.org/netdev/net-next/c/6a414fd77f61

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


