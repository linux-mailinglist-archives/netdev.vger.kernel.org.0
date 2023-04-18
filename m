Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71556E5FB3
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbjDRLUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbjDRLUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:20:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA1A9760
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 04:20:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BD0F611B1
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 11:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D3656C433D2;
        Tue, 18 Apr 2023 11:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681816818;
        bh=PIFzaqcgPigdb4WUA3NU2Ne5uvkSB00mUXXU9YRAyFU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qk63XrCLTtkXVQA6E0/k0J6ZnwZKvUcDisho25vFRFMXF7VmNDnMn6PYSwSZwVZ5W
         XVKhbXeuDDWvpuBLUQibAvL/QdOSGvqriRLaMI1j6tT/ONBQVFBwIx4VACqXlF0G9y
         oeIjqXZM4IBwfiQ2rDJrLlvLi0wZHxhLHyWahAl+uU76ldvsLbZPkCjWj5jxcxYnKM
         7iC+roDrLOGp80DFEZD2UBqZMYoqSdACUb57ADKB7Dlk0bQHIngEb7IU+jQLVtHq9P
         M/YzUM1KrLvjRB6YRbfoPXAq83jYJbSLSakE/Ws70L7MrYwKUWrD+UAG5QvNTkh31w
         4PChMc9JkNLiA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B62D2C40C5E;
        Tue, 18 Apr 2023 11:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/3] r8169: use new macros from netdev_queues.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168181681874.3901.13608198363831110230.git-patchwork-notify@kernel.org>
Date:   Tue, 18 Apr 2023 11:20:18 +0000
References: <7147a001-3d9c-a48d-d398-a94c666aa65b@gmail.com>
In-Reply-To: <7147a001-3d9c-a48d-d398-a94c666aa65b@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, nic_swsd@realtek.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 17 Apr 2023 11:34:41 +0200 you wrote:
> Add one missing subqueue version of the macros, and use the new macros
> in r8169 to simplify the code.
> 
> Heiner Kallweit (3):
>   net: add macro netif_subqueue_completed_wake
>   r8169: use new macro netif_subqueue_maybe_stop in rtl8169_start_xmit
>   r8169: use new macro netif_subqueue_completed_wake in the tx cleanup path
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/3] net: add macro netif_subqueue_completed_wake
    https://git.kernel.org/netdev/net-next/c/cb18e5595df7
  - [net-next,v3,2/3] r8169: use new macro netif_subqueue_maybe_stop in rtl8169_start_xmit
    https://git.kernel.org/netdev/net-next/c/8624e9bbef64
  - [net-next,v3,3/3] r8169: use new macro netif_subqueue_completed_wake in the tx cleanup path
    https://git.kernel.org/netdev/net-next/c/1a31ae00482c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


