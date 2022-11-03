Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9C3617555
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 05:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiKCEAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 00:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKCEAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 00:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9977661
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 21:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAE62B82666
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 04:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 72466C433D6;
        Thu,  3 Nov 2022 04:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667448015;
        bh=37hrWeSpl3u5uDYuGFIDYqDHDgUtcWr43DcEZGl1e9Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GSP4jZIHpAJl/Ho2uafCJzRibRqa1GgIlTubvMrkjKZl/PZ7Ejm9O1PJ6Na0myjE2
         LBcIXgZ/tDun9ArloP43JYhAomKBflTICZTCaGZP+5VhPdNsS71Ir6ZKjOGaPAMlcw
         cObtMFVMSdH3TXTvdoD6S1Ohu7PR5Fg7mgSis0BgjM7b3pOHfj6etIMpdE80goryki
         r93GJo8l1AvoWHwBj/QJZ5p0u2MPqP1t+8tUXqyPeKkgGOVgjZuJgtyNGW5qQieuck
         cWgOUhFEWmVV2g2gx3ONtN5xbFLb1qC4d4N+UeUEXK6AUbnAJe8x6H7mBm5rLfjQhm
         oAviMCI40zvRw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 55DE8E270D3;
        Thu,  3 Nov 2022 04:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bridge: Fix flushing of dynamic FDB entries
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166744801534.16768.7709737010968160926.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Nov 2022 04:00:15 +0000
References: <20221101185753.2120691-1-idosch@nvidia.com>
In-Reply-To: <20221101185753.2120691-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  1 Nov 2022 20:57:53 +0200 you wrote:
> The following commands should result in all the dynamic FDB entries
> being flushed, but instead all the non-local (non-permanent) entries are
> flushed:
> 
>  # bridge fdb add 00:aa:bb:cc:dd:ee dev dummy1 master static
>  # bridge fdb add 00:11:22:33:44:55 dev dummy1 master dynamic
>  # ip link set dev br0 type bridge fdb_flush
>  # bridge fdb show brport dummy1
>  00:00:00:00:00:01 master br0 permanent
>  33:33:00:00:00:01 self permanent
>  01:00:5e:00:00:01 self permanent
> 
> [...]

Here is the summary with links:
  - [net] bridge: Fix flushing of dynamic FDB entries
    https://git.kernel.org/netdev/net/c/628ac04a75ed

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


