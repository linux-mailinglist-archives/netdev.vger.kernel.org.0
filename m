Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38456D176C
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 08:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjCaGa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 02:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjCaGaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 02:30:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1A9CDC8
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 23:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1162D623A1
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 06:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66E7DC433A7;
        Fri, 31 Mar 2023 06:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680244220;
        bh=0UoYp/w3BJNybXfYeYozyabD3ssYwOlTgIjh1G3VhMs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BOpM/9NlYhpK2khM0P/PKOTg7S50LkoOWDzXTZ5Pz1wjE+otTSOUtkXnSy/N4CDNT
         4on01IyIiFUwT/YW46oeekW6KoBELp6madwzwJZnRIQlixnXu0hx6dRbxHmfpHcUUy
         pp9dq4dN8wZDNJhzpUmoeUB6JCaCnvl4NRJkuoqNfWlx/3cbFWVCwBeipSxpj2fmvm
         7vRTM9/DCQe8XwsffLfCwZx8bYaH846uawSxs5qk+VeQW5rcrwuDxCe6UAL4x5tqgR
         wuk1JN+tjnwxlhP3ew4y3uCQ12xIDCVLo6pOqCZXzuYaHnoSXzapmgJHir9FHuIMWI
         lqZqdWk7iGspA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F358C73FE2;
        Fri, 31 Mar 2023 06:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: rtnetlink: Fix do_test_address_proto()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168024422025.32019.17339369326492125783.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Mar 2023 06:30:20 +0000
References: <53a579bc883e1bf2fe490d58427cf22c2d1aa21f.1680102695.git.petrm@nvidia.com>
In-Reply-To: <53a579bc883e1bf2fe490d58427cf22c2d1aa21f.1680102695.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, dsahern@kernel.org,
        idosch@nvidia.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Mar 2023 17:24:53 +0200 you wrote:
> This selftest was introduced recently in the commit cited below. It misses
> several check_err() invocations to actually verify that the previous
> command succeeded. When these are added, the first one fails, because
> besides the addresses added by hand, there can be a link-local address
> added by the kernel. Adjust the check to expect at least three addresses
> instead of exactly three, and add the missing check_err's.
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: rtnetlink: Fix do_test_address_proto()
    https://git.kernel.org/netdev/net-next/c/46e9acb7ae2a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


