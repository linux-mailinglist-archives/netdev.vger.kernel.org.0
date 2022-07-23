Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5660A57EC2A
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 07:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbiGWFAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 01:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234859AbiGWFAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 01:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93189B1E7
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 22:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFB26B82BE8
        for <netdev@vger.kernel.org>; Sat, 23 Jul 2022 05:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 50221C341C0;
        Sat, 23 Jul 2022 05:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658552414;
        bh=Nl7KXwtGmgnTMP5qS1kk+dyaeAIqc3h2ibrPbWsWLFM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qj6jelwYHAQL0mhxdwt4V6G1f7jlWmKAej+etRW41Pj2ijo7JM2lq7oJ4yGU+u6Wr
         F/tuXCmZqhypLWpUaR0k+CDvPAt289N+DTUtpUfvcQSXqh74PQ7h03q0QVAzQ3f2ki
         I7pWGKsJm5HTDSZaEqvwqtzX0YbKMnSP2pE/RResuSCRXho4Wl8Xj3d1eOhtwlo7E2
         5Gzaatm8qnVemmCkL6ngo08317el2V9kVEeEVrG2G0ywfyjbfGpX6duskAUv1zu4Vm
         vTs3WaJhldAK2im0b/ULmwLeNWOQHMKTSDK9MO7WipNjljtEfPhpsmb6ZPuaG7QGdl
         lmTeDuvY//RZw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 380D3E451AD;
        Sat, 23 Jul 2022 05:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2][pull request] 100GbE Intel Wired LAN Driver
 Updates 2022-07-21
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165855241422.3532.1782010695576147512.git-patchwork-notify@kernel.org>
Date:   Sat, 23 Jul 2022 05:00:14 +0000
References: <20220721202842.3276257-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220721202842.3276257-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        richardcochran@gmail.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 21 Jul 2022 13:28:40 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Karol adds implementation for GNSS write; data is written to the GNSS
> module through TTY device using u-blox UBX protocol.
> ---
> v2:
> - Replace looped copy with memcpy() in ice_aq_write_i2c()
> - Adjust goto/return in ice_gnss_do_write() for readability
> - Add information to documentation
> - Drop, previous, patch 1; it was already accepted in another pull
> request.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] ice: add i2c write command
    https://git.kernel.org/netdev/net-next/c/fcf9b695a554
  - [net-next,v2,2/2] ice: add write functionality for GNSS TTY
    https://git.kernel.org/netdev/net-next/c/d6b98c8d242a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


