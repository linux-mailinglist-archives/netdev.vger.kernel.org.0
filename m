Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9AFD6BE40C
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 09:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbjCQImh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 04:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbjCQImK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 04:42:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0CB67833
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 01:40:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3767662217
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 808C6C4339C;
        Fri, 17 Mar 2023 08:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679042419;
        bh=JDcdH5YXxWZfCrWM1hAOGSrG9KNopw1+gv4sUYcgxiM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CQziaa5IRRDNkcBNv8CjpLY17pQA8QUvBSf9OGPgZpyqEHBmM+BaF4OvYdYLdpRg6
         pV6f/o+p3epPLXYdccpBQ+2wPUC/FMcg7gPg1er5QO1DsQBRGXsjTrIPCWzKp56AXA
         1xVcIvAWDUSxHPkGc62Oxto3cj+qWNzNFu4lWgtIHnqxFHTRg5hlpKY4V5ZcchrGSD
         bY6bSwraAmxcCzyZYAsW16EnhmoZvdkEoyMHBSPVEq2/EtPQS5LQSFAMMeVhItnan6
         057GBaC6S1efeviWRJaj5wMOUYsrUu1MSW5BBpM9q+MjEs81NCoAlmOparQTJm4AYv
         3fGp1NbI84vBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6859BE2A03A;
        Fri, 17 Mar 2023 08:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/5] gve: Add XDP support for GQI-QPL format
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167904241942.20100.16841405978849456209.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 08:40:19 +0000
References: <20230315233312.568731-1-pkaligineedi@google.com>
In-Reply-To: <20230315233312.568731-1-pkaligineedi@google.com>
To:     Praveen Kaligineedi <pkaligineedi@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        michal.kubiak@intel.com, maciej.fijalkowski@intel.com
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

On Wed, 15 Mar 2023 16:33:07 -0700 you wrote:
> Adding support for XDP DROP, PASS, TX, REDIRECT for GQI QPL format.
> Add AF_XDP zero-copy support.
> 
> When an XDP program is installed, dedicated TX queues are created to
> handle XDP traffic. The user needs to ensure that the number of
> configured TX queues is equal to the number of configured RX queues; and
> the number of TX/RX queues is less than or equal to half the maximum
> number of TX/RX queues.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/5] gve: XDP support GQI-QPL: helper function changes
    https://git.kernel.org/netdev/net-next/c/2e80aeae9f80
  - [net-next,v4,2/5] gve: Changes to add new TX queues
    https://git.kernel.org/netdev/net-next/c/7fc2bf78a430
  - [net-next,v4,3/5] gve: Add XDP DROP and TX support for GQI-QPL format
    https://git.kernel.org/netdev/net-next/c/75eaae158b1b
  - [net-next,v4,4/5] gve: Add XDP REDIRECT support for GQI-QPL format
    https://git.kernel.org/netdev/net-next/c/39a7f4aa3e4a
  - [net-next,v4,5/5] gve: Add AF_XDP zero-copy support for GQI-QPL format
    https://git.kernel.org/netdev/net-next/c/fd8e40321a12

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


