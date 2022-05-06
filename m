Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B204751E1DF
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 01:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355746AbiEFWyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 18:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355654AbiEFWx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 18:53:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE3B6A01E
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 15:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4717BB839FA
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 22:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4A26C385B0;
        Fri,  6 May 2022 22:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651877411;
        bh=W0W8CQ0odyOO7hynQ2WvoTaG9Icxp2n9kKcoQmLoZrA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IYkqcwOat7cyUzw0WcOvObFQ43igx8rNIliUEyaOERMpV77tgMT7CdsP1QyOvlzjP
         GPJg9+nuLSC0qtkiRwfOSU3Y0TiQURjtkXuo7dJZ8JjBpwlzo6oVwKfqP3wVfve7iQ
         7YBshg3Ke2XbO3+wCUDJonZzZdlc6IBv8FDIA3wQg6xrCGRYR4GqMH14L5jdkbW4JJ
         t62yG6AuEGrPHnOsNSNsg0/buMwMNki4V+WuV78TOd8KgOUVtmVqsr1iP3nM384PEC
         4xoSVpNZgm3eU5LSesyVr7M+N6lb+Sac2XPmfkAlag/ZR6BDX5U/o+oYYbkPF7HufT
         xDEUuOvPt2B+g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BE6C3F03876;
        Fri,  6 May 2022 22:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2][pull request] 10GbE Intel Wired LAN Driver
 Updates 2022-05-05
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165187741176.22211.14290809849138167443.git-patchwork-notify@kernel.org>
Date:   Fri, 06 May 2022 22:50:11 +0000
References: <20220505155651.2606195-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220505155651.2606195-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu,  5 May 2022 08:56:49 -0700 you wrote:
> This series contains updates to ixgbe and igb drivers.
> 
> Jeff Daly adjusts type for 'allow_unsupported_sfp' to match the
> associated struct value for ixgbe.
> 
> Alaa Mohamed converts, deprecated, kmap() call to kmap_local_page() for
> igb.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] ixgbe: Fix module_param allow_unsupported_sfp type
    https://git.kernel.org/netdev/net-next/c/833fbbbbfc8b
  - [net-next,2/2] igb: Convert kmap() to kmap_local_page()
    https://git.kernel.org/netdev/net-next/c/b35413f415c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


