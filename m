Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E571673FF9
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 18:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjASRaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 12:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjASRaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 12:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B703B1BE9
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 09:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5150C61D0B
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 17:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A86E0C433F0;
        Thu, 19 Jan 2023 17:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674149416;
        bh=GuTRFKSplx5f7H2FTsPLNYo7dSMEkGF+phy7L6xH/JQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u8M3UyeveybnceCbGGoiFDDxPowRXwe7v9LJ34wBS9t22S1xc8MlsnSoC0mZ/4ThG
         hirDCESXrhKlzaqZnjvQJiZ7Vt9qHE4qv1neKM+wzpu6Snv3Kw4CIWE9wMKlu6f6HS
         2aC07jI8OdZpVcK/cHFDx8Lcz9M3jKv4pacFZqo4O8tjSFc+dplD1QIbTW/plyUlGi
         GU4g/0hV8app0iYL3E9qQQsc5gbnBLt4CcYU5biwIqw4cMxe9kXbhSTpMO2Ug5iwGn
         rxN081swQHx4UJgcilWz1nq5lbHlU5XhNz2XYkOJg5Ftcg8PXojM6YQJJSbPf6A5vT
         xyONibjI/LDNQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 87E49E54D27;
        Thu, 19 Jan 2023 17:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] selftests/net: toeplitz: fix race on tpacket_v3 block
 close
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167414941654.32440.17800377620233873619.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Jan 2023 17:30:16 +0000
References: <20230118151847.4124260-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20230118151847.4124260-1-willemdebruijn.kernel@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, willemb@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 18 Jan 2023 10:18:47 -0500 you wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> Avoid race between process wakeup and tpacket_v3 block timeout.
> 
> The test waits for cfg_timeout_msec for packets to arrive. Packets
> arrive in tpacket_v3 rings, which pass packets ("frames") to the
> process in batches ("blocks"). The sk waits for req3.tp_retire_blk_tov
> msec to release a block.
> 
> [...]

Here is the summary with links:
  - [net,v2] selftests/net: toeplitz: fix race on tpacket_v3 block close
    https://git.kernel.org/netdev/net/c/903848249a78

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


