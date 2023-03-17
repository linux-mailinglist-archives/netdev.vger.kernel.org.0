Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69546BE4C0
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 10:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbjCQJCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 05:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231907AbjCQJCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 05:02:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51233E41D5
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 02:00:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA92362235
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 09:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2EBADC4339B;
        Fri, 17 Mar 2023 09:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679043622;
        bh=p2NYx1+oTKiyxLVa+cbiAIuoCNm/6GjuMgMptKR701w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rfJ9acd46HuFl/5o+7SWYU9f9NBWJQKY41xkD4U2XcKDCIHCQJ/yYp/nqJEbgXb8U
         D6GZ/4iZfXO0o3jK+Q+pSSVLlG9K5mk0CtaEifv1TXO++O16NFwZnlbWCU8MoPmU9U
         lmpt/wx5oYpsT2ry4bA8Jp8ZVIS9beMKWaEPg0bAJSG/iF5wWn0USl8kQmohhDyeID
         CEFHAvugrwug13GJDmWbv/O2vWOThfM9pPMN5ceHqEYuK6lLHQ3yoKUBNzNkz9j+9r
         nRGbqq+rIB+k/ZJU+xTRnhiV4zVD8OewoM6cq0Qp2M73h9Z52x4rtGhslCwrgwfZeV
         nSrN+Qc/nYCRg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 12C56E21EE9;
        Fri, 17 Mar 2023 09:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/8] inet: better const qualifier awareness
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167904362207.30854.15986606551068422676.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 09:00:22 +0000
References: <20230316153202.1354692-1-edumazet@google.com>
In-Reply-To: <20230316153202.1354692-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, dsahern@kernel.org,
        simon.horman@corigine.com, eric.dumazet@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 16 Mar 2023 15:31:54 +0000 you wrote:
> inet_sk() can be changed to propagate const qualifier,
> thanks to container_of_const()
> 
> Following patches in this series add more const qualifiers.
> 
> Other helpers like tcp_sk(), udp_sk(), raw_sk(), ... will be handled
> in following series.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/8] inet: preserve const qualifier in inet_sk()
    https://git.kernel.org/netdev/net-next/c/abc17a11ed29
  - [v2,net-next,2/8] ipv4: constify ip_mc_sf_allow() socket argument
    https://git.kernel.org/netdev/net-next/c/33e972bdf0b0
  - [v2,net-next,3/8] udp: constify __udp_is_mcast_sock() socket argument
    https://git.kernel.org/netdev/net-next/c/a0a989d30075
  - [v2,net-next,4/8] ipv6: constify inet6_mc_check()
    https://git.kernel.org/netdev/net-next/c/66eb554c6449
  - [v2,net-next,5/8] udp6: constify __udp_v6_is_mcast_sock() socket argument
    https://git.kernel.org/netdev/net-next/c/dc3731bad8e1
  - [v2,net-next,6/8] ipv6: raw: constify raw_v6_match() socket argument
    https://git.kernel.org/netdev/net-next/c/db6af4fdb150
  - [v2,net-next,7/8] ipv4: raw: constify raw_v4_match() socket argument
    https://git.kernel.org/netdev/net-next/c/0a8c2568209e
  - [v2,net-next,8/8] inet_diag: constify raw_lookup() socket argument
    https://git.kernel.org/netdev/net-next/c/736c8b52c8ad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


