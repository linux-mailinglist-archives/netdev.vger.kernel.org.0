Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E04836D7236
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 04:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbjDECAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 22:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235302AbjDECAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 22:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA753C03
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 19:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19CF963AD5
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C043C4339C;
        Wed,  5 Apr 2023 02:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680660019;
        bh=uzbLOAJkGqzhNm4eFHDxa1ZCRFEud8TrS2JBkV6z1iM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RfXyI2qsaDc7rVQ6jB9D2yrMXI3ti5mUQbmQxxecp6IDPjGmdI1gntC/pC1PSdraf
         n1TcbpEFFHJdWAanQqAgPSipkBBOHTFQKvSdpWc4FHW+YhbuF9s/HebjL2bQex1b3g
         u3bXSQ3sNMRoANY8gyVYLx/1Rv7Hyo/vZ1W74HSjDTp88LXq0mog+/+gGCaN5dMvPB
         74/9OKwuv0li5WHdsfLQLmCqD4sKbYXM50MbbH2lDxw5+rT/ZJzYmb27BtQXcQ5XhH
         3lECDKZIX9T+Wr0Ui4SD67eLEf9nDJT+dOzWknBC39hiwmYhij4AffHNuycchPqijj
         s9iCUQ+U6YhlA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1EB34E4D02D;
        Wed,  5 Apr 2023 02:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] gve: Secure enough bytes in the first TX desc for all
 TCP pkts
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168066001911.10193.12102353313476434083.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Apr 2023 02:00:19 +0000
References: <20230403172809.2939306-1-shailend@google.com>
In-Reply-To: <20230403172809.2939306-1-shailend@google.com>
To:     Shailend Chand <shailend@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  3 Apr 2023 10:28:09 -0700 you wrote:
> Non-GSO TCP packets whose SKBs' linear portion did not include the
> entire TCP header were not populating the first Tx descriptor with
> as many bytes as the vNIC expected. This change ensures that all
> TCP packets populate the first descriptor with the correct number of
> bytes.
> 
> Fixes: 893ce44df565 ("gve: Add basic driver framework for Compute Engine Virtual NIC")
> Signed-off-by: Shailend Chand <shailend@google.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] gve: Secure enough bytes in the first TX desc for all TCP pkts
    https://git.kernel.org/netdev/net/c/3ce934558097

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


