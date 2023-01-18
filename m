Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1809671E34
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjARNlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:41:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjARNlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:41:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F08DC3819;
        Wed, 18 Jan 2023 05:10:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A269DB81CEA;
        Wed, 18 Jan 2023 13:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1B3E5C43396;
        Wed, 18 Jan 2023 13:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674047418;
        bh=/UtK2hJDAc3rH5mXOPwAYbrHlsExVHeOHP38jeGiqUw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ML41iOBzy3xZL2gqVoa3RRcYxYiyn3zUhr6vW2RBO6Fb+5tMhiGnFDHXM1tzmzZmV
         mVS19q8l+tV431NIenppGtxwF4ADaQ0USouXals8ebO/XJ8BYmHHGWyyMFC/SXVcO+
         P60I4SeRpr1VszxSEMSp8+WeBON2HvFDk+/joMx+SjCag7CgplTi0f2U41KhLjvI/P
         qkqSZ3WfXKMxZDA8liVKo31kEnod4Dvc4ttsosc+C2/E7VKlcNPrz2xu4KD2zHAVm2
         zYAd8Qu6c1OiGdwBFaNTaj10dlHbCENg84FsS0wrKKNjrqfu5ySHmi/0glWn4tVbH0
         XITuWabPf2kZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DCBCBC395C6;
        Wed, 18 Jan 2023 13:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipv6: Remove extra counter pull before gc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167404741790.5923.10782824313037719648.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Jan 2023 13:10:17 +0000
References: <20230116145500.44699-1-007047221b@gmail.com>
In-Reply-To: <20230116145500.44699-1-007047221b@gmail.com>
To:     Tanmay Bhushan <007047221b@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 16 Jan 2023 15:55:00 +0100 you wrote:
> Per cpu entries are no longer used in consideration
> for doing gc or not. Remove the extra per cpu entries
> pull to directly check for time and perform gc.
> 
> Signed-off-by: Tanmay Bhushan <007047221b@gmail.com>
> ---
>  net/ipv6/route.c | 4 ----
>  1 file changed, 4 deletions(-)

Here is the summary with links:
  - ipv6: Remove extra counter pull before gc
    https://git.kernel.org/netdev/net-next/c/9259f6b573cf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


