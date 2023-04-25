Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18456EDA09
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 03:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbjDYBuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 21:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjDYBuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 21:50:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8983A9ED1;
        Mon, 24 Apr 2023 18:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 219DC62AE9;
        Tue, 25 Apr 2023 01:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78626C433EF;
        Tue, 25 Apr 2023 01:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682387420;
        bh=1uW7/zKMfdIEGeOS4OK5rft0JIk45QU2wNABsTDJdnU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Zzww72QXSZ6E3K8SLV2/Zqqlt+BF6voJHEd+JCA99uusIxwJO1W1aMAtbUScVRqaA
         OD6i+4C+ksO8TF/UECN3UqXuC5trMv7oCnnaPoFUcXD/rgNQj96WvDnBLKcei+Exu3
         oACfpPe+5jmHFdlEb0qRBSKgLieud556OsQbe3wKLPueKg0PSV4foMYz3KiS6e302D
         5Ur6uXNJkCDoDUv83G9RsEywMhA2CyT4P2W4/y7UwmjsMJCHT9kMXy3FbdN0z96cDt
         44R0YDIpD2vYajWJWvAH/iT8eJqiXXtXYaU/P94SpAvfX6dKOLE3q8ihBsKL+tQjv5
         m1gQYEUBcJdHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 55EC1C395D8;
        Tue, 25 Apr 2023 01:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/6] tsnep: XDP socket zero-copy support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168238742034.25988.7042719252736011480.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Apr 2023 01:50:20 +0000
References: <20230421194656.48063-1-gerhard@engleder-embedded.com>
In-Reply-To: <20230421194656.48063-1-gerhard@engleder-embedded.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 21 Apr 2023 21:46:50 +0200 you wrote:
> Implement XDP socket zero-copy support for tsnep driver. I tried to
> follow existing drivers like igc as far as possible. But one main
> difference is that tsnep does not need any reconfiguration for XDP BPF
> program setup. So I decided to keep this behavior no matter if a XSK
> pool is used or not. As a result, tsnep starts using the XSK pool even
> if no XDP BPF program is available.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/6] tsnep: Replace modulo operation with mask
    https://git.kernel.org/netdev/net-next/c/42fb2962b4a6
  - [net-next,v4,2/6] tsnep: Rework TX/RX queue initialization
    https://git.kernel.org/netdev/net-next/c/33b0ee02c84c
  - [net-next,v4,3/6] tsnep: Add functions for queue enable/disable
    https://git.kernel.org/netdev/net-next/c/2ea0a282ba09
  - [net-next,v4,4/6] tsnep: Move skb receive action to separate function
    https://git.kernel.org/netdev/net-next/c/c2d64697f41b
  - [net-next,v4,5/6] tsnep: Add XDP socket zero-copy RX support
    https://git.kernel.org/netdev/net-next/c/3fc2333933fd
  - [net-next,v4,6/6] tsnep: Add XDP socket zero-copy TX support
    https://git.kernel.org/netdev/net-next/c/cd275c236b3f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


