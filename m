Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B58671E5C
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbjARNvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:51:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbjARNuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:50:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D124B4A3
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 05:20:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B70FB81D08
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BE5E9C433F1;
        Wed, 18 Jan 2023 13:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674048018;
        bh=qYEhTYz8A//0w3r9sfXJGK+P6wVL6jEN8oxCWRt852Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jIucHDYVKpD+HL0KtUrKGWKy8tj5qlvW2dgUYDmY8bIGv/ETLQevZlrphqd6VnQU0
         HK91HoYC49pxjO3t/q6XRDqvAdeLa+rMH3KvKmlDG/Z14GDvdzAMD+qjvmBiU+Hy1z
         laqcBmTMVpUbAIbvN7RHLSUVBxJHLZOQTrYHsYksQt8Xo5c3dh9vS0KmhdJNhtDVES
         00JIpDaNdnuwp85wTQOloZc2hFNJJT/x1Ixkor9hxIPuEgCdpq7wqWlWwIZ7TGbd8v
         IwnRoWX4B6vnB1mlKSwftyzNeG7eXY2FDDn7JyqQBUVwcKTVQhLEyOxxybZtI1GyJw
         0nZ/qv7jmz3aA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A5FDBC3959E;
        Wed, 18 Jan 2023 13:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 0/9] tsnep: XDP support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167404801867.10842.12920748675264358351.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Jan 2023 13:20:18 +0000
References: <20230116202458.56677-1-gerhard@engleder-embedded.com>
In-Reply-To: <20230116202458.56677-1-gerhard@engleder-embedded.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     netdev@vger.kernel.org, alexander.duyck@gmail.com,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 16 Jan 2023 21:24:49 +0100 you wrote:
> Implement XDP support for tsnep driver. I tried to follow existing
> drivers like igb/igc as far as possible. Some prework was already done
> in previous patch series, so in this series only actual XDP stuff is
> included.
> 
> Thanks for the NetDev 0x14 slides "Add XDP support on a NIC driver".
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/9] tsnep: Replace TX spin_lock with __netif_tx_lock
    https://git.kernel.org/netdev/net-next/c/25faa6a4c5ca
  - [net-next,v5,2/9] tsnep: Forward NAPI budget to napi_consume_skb()
    https://git.kernel.org/netdev/net-next/c/0625dff38b17
  - [net-next,v5,3/9] tsnep: Do not print DMA mapping error
    https://git.kernel.org/netdev/net-next/c/95337b938476
  - [net-next,v5,4/9] tsnep: Add XDP TX support
    https://git.kernel.org/netdev/net-next/c/d24bc0bcbbff
  - [net-next,v5,5/9] tsnep: Subtract TSNEP_RX_INLINE_METADATA_SIZE once
    https://git.kernel.org/netdev/net-next/c/59d562aa1983
  - [net-next,v5,6/9] tsnep: Prepare RX buffer for XDP support
    https://git.kernel.org/netdev/net-next/c/cc3e254f9443
  - [net-next,v5,7/9] tsnep: Add RX queue info for XDP support
    https://git.kernel.org/netdev/net-next/c/e77832abd90a
  - [net-next,v5,8/9] tsnep: Add XDP RX support
    https://git.kernel.org/netdev/net-next/c/65b28c810035
  - [net-next,v5,9/9] tsnep: Support XDP BPF program setup
    https://git.kernel.org/netdev/net-next/c/f0f6460f9130

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


