Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6A75BAE60
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 15:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiIPNkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 09:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiIPNkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 09:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49782C664;
        Fri, 16 Sep 2022 06:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4299B62BD3;
        Fri, 16 Sep 2022 13:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9C862C433D7;
        Fri, 16 Sep 2022 13:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663335616;
        bh=4oERv06eKf9jgPyu28yyrLztXaVivyopqZpP/JCtkSc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uXJtfVb1gosLAKhUbogSkFCS5zIr+yBj/6KCxYYfPFzsTwWX/Ox9HUIebgdr3qYjM
         h7nymM3mS2pvJhKOAUIrxuNmIlbg4WWDeTHHFgXtwYISPBjHEoqzGIqdMhRt4H/j58
         /5x+vPNb0PpwPWP92BObOwDdOq8m3rdo6F5iwqmvv3FVd0IsV49ZSo3CBH0H5EWbc+
         nLM7NVIr0se+aR+ehcJRw8n9kOfgGLDp9g35tR2430Ydet9fwXnZwqO0ip9Zgdc/CD
         hlHpe9VgxjFXkJvTsanTEa23mKagXZEFbf8lTAkK0urf40JYotDQk1HhkuDyVNzVJp
         TXCzQnsTW7QmQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7A87AC59A58;
        Fri, 16 Sep 2022 13:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/4] Unsync addresses from ports when stopping
 aggregated devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166333561648.19332.1506754631018938447.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Sep 2022 13:40:16 +0000
References: <20220907075642.475236-1-bpoirier@nvidia.com>
In-Reply-To: <20220907075642.475236-1-bpoirier@nvidia.com>
To:     Benjamin Poirier <bpoirier@nvidia.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jiri@resnulli.us,
        shuah@kernel.org, jtoppins@redhat.com,
        linux-kselftest@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Wed,  7 Sep 2022 16:56:38 +0900 you wrote:
> This series fixes similar problems in the bonding and team drivers.
> 
> Because of missing dev_{uc,mc}_unsync() calls, addresses added to
> underlying devices may be leftover after the aggregated device is deleted.
> Add the missing calls and a few related tests.
> 
> v2:
> * fix selftest installation, see patch 3
> 
> [...]

Here is the summary with links:
  - [net,v3,1/4] net: bonding: Share lacpdu_mcast_addr definition
    https://git.kernel.org/netdev/net/c/1d9a143ee340
  - [net,v3,2/4] net: bonding: Unsync device addresses on ndo_stop
    https://git.kernel.org/netdev/net/c/86247aba599e
  - [net,v3,3/4] net: team: Unsync device addresses on ndo_stop
    https://git.kernel.org/netdev/net/c/bd60234222b2
  - [net,v3,4/4] net: Add tests for bonding and team address list management
    https://git.kernel.org/netdev/net/c/bbb774d921e2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


