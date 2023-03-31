Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E539E6D176D
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 08:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjCaGab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 02:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjCaGaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 02:30:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077FC2685
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 23:30:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92C5AB82C07
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 06:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F30FC4339B;
        Fri, 31 Mar 2023 06:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680244220;
        bh=VLuIGnwHXYrPr7ZPQoQJf+nc2PoefbpDgzv1fZe4OtQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JlYT1kPH8ljlVg87RgWD95hAqaBwuTnwF1Ocz9KTgAjrsA4iVJQWvP/M5p71Cx9mR
         UQQo4b/9aQo76EHVEvkTuF/OuH3nXmVOvVLJEcesUAd9bWWnnhRy0qScryngaRtpTO
         JJ/+3S1Yd2ss/NqIEynqcBl+cOEk45YEw/96mD+V7Iid0D6quhTBSxylNh4YnU++x9
         WZO9kC0JenjJ4f2scWwSK0HXWgG5KpKsslG22xAoKDbkeOrgYU0kIJU9HSPu2E95S4
         dE6iNixYaBs4QtaSkja9WzDjXseAWEBOtyZCH3ZpWbr7ue+z4gXIyHibBWQcl85+7d
         n1CBYUUKMXkxw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1F68FC73FE0;
        Fri, 31 Mar 2023 06:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/4] net/sched: act_tunnel_key: add support for
 TUNNEL_DONT_FRAGMENT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168024422012.32019.367361104682792816.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Mar 2023 06:30:20 +0000
References: <cover.1680082990.git.dcaratti@redhat.com>
In-Reply-To: <cover.1680082990.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        i.maximets@ovn.org, kuba@kernel.org, netdev@vger.kernel.org,
        pctammela@mojatatu.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Mar 2023 11:54:51 +0200 you wrote:
> - patch 1 extends TC tunnel_key action to add support for TUNNEL_DONT_FRAGMENT
> - patch 2 extends tdc to skip tests when iproute2 support is missing
> - patch 3 adds a tdc test case to verify functionality of the control plane
> - patch 4 adds a net/forwarding test case to verify functionality of the data plane
> 
> v3->v4:
>  - remove misleading "failure" wording in the printout (thanks to Pedro
>    Tammela)
>  - fix permissions (+x) of net/forwarding kselftest
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/4] net/sched: act_tunnel_key: add support for "don't fragment"
    https://git.kernel.org/netdev/net-next/c/2384127e98db
  - [net-next,v4,2/4] selftests: tc-testing: add "depends_on" property to skip tests
    https://git.kernel.org/netdev/net-next/c/7f3f86402609
  - [net-next,v4,3/4] selftests: tc-testing: add tunnel_key "nofrag" test case
    https://git.kernel.org/netdev/net-next/c/b8617f8eed84
  - [net-next,v4,4/4] selftests: forwarding: add tunnel_key "nofrag" test case
    https://git.kernel.org/netdev/net-next/c/533a89b1940f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


