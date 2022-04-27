Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38C55115A3
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 13:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbiD0Ld0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 07:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232590AbiD0LdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 07:33:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21DE13818F
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 04:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBC69B82662
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 11:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 92FA5C385AA;
        Wed, 27 Apr 2022 11:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651059012;
        bh=nfiXQlePTjHJuvziNrw8lVIJhEu3Dvoz0UWRvPteiAU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gW1I+TfY+zZmXTwjrXVVSteY5eKEm7PWNgKjJoYenDbLd9ZvNobaapd0UCddvMmaC
         71Hq9AnR/rsggY1TH8K7a/i5PvQYvs5CVgudl1xxIDUCPwFTR/lJsIbKZCzO7yy8oe
         CRvZjF5Y8Tb/g+7kWhE/Njw+VPHNuD6YwKT36jaLWqtguXEJ7kJcfLyxN6KuIltk8i
         X9tAsnBzwJTwcX82VD5LBmWSz2t4M67+tWzHrev7Xuuw2L2fYCaE+GKev4XXDUfsYr
         lhxtL2mqZq7O4NgKHXAZyglix+chIVi+ThCDMBc25Xyq22JEi84BOHXiG94Ux1Y5ss
         4OOYmnagbcD8A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7A562F0383D;
        Wed, 27 Apr 2022 11:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: remove non-Ethernet drivers using
 virt_to_bus()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165105901249.32427.14792060408706399178.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Apr 2022 11:30:12 +0000
References: <20220426175436.417283-1-kuba@kernel.org>
In-Reply-To: <20220426175436.417283-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 26 Apr 2022 10:54:30 -0700 you wrote:
> Networking is currently the main offender in using virt_to_bus().
> Frankly all the drivers which use it are super old and unlikely
> to be used today. They are just an ongoing maintenance burden.
> 
> In other words this series is using virt_to_bus() as an excuse
> to shed some old stuff. Having done the tree-wide dev_addr_set()
> conversion recently I have limited sympathy for carrying dead
> code.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: atm: remove support for Fujitsu FireStream ATM devices
    https://git.kernel.org/netdev/net-next/c/41c335c82123
  - [net-next,2/6] net: atm: remove support for Madge Horizon ATM devices
    https://git.kernel.org/netdev/net-next/c/5b74a20d35ab
  - [net-next,3/6] net: atm: remove support for ZeitNet ZN122x ATM devices
    https://git.kernel.org/netdev/net-next/c/052e1f01bfae
  - [net-next,4/6] net: wan: remove support for COSA and SRP synchronous serial boards
    https://git.kernel.org/netdev/net-next/c/89fbca3307d4
  - [net-next,5/6] net: wan: remove support for Z85230-based devices
    https://git.kernel.org/netdev/net-next/c/bc6df26f1f78
  - [net-next,6/6] net: hamradio: remove support for DMA SCC devices
    https://git.kernel.org/netdev/net-next/c/865e2eb08f51

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


