Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4381E6918EA
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 08:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbjBJHAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 02:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjBJHAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 02:00:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736991714;
        Thu,  9 Feb 2023 23:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7C8861CB7;
        Fri, 10 Feb 2023 07:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F8F1C4339B;
        Fri, 10 Feb 2023 07:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676012418;
        bh=a56rPAwwEZhssyB1VBYcvbdT2/G9c0VKg8a4rmFUU/A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lfZA7naA3moeHuummCRIsDwVWsvFOgDHWH/g9bBCW3TJaY4+gzPf3ZkQewfUsCSD4
         MGI4NN3Z4lkBk6nxPr72kh2DhlvL0RkQs7ycGftw5x6fAcwq03IY6tbSPKaVvf633a
         KQZXZKaFh40NGhb52J8bY5WlJ5vcjHImsZka/pz3fhH0lZfGOb2UOUD4Q0RXwUKbp1
         hGnoAfFatqb+Jp4v4UbqpopxA5SRiAa4ivnZccp/srWRzI0E98UnyocjJZbua9CkKO
         PunZjJ8KHa+T7fGyfWY5X5ezzaYCGMMgI5BAKqB0Quu6GVwqVIjbhHVDSJB6Dc6nDm
         00+8Sm+Mw37bA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 10CD0E21EC7;
        Fri, 10 Feb 2023 07:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] vmxnet3: move rss code block under eop descriptor
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167601241806.12809.13336166295565756361.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Feb 2023 07:00:18 +0000
References: <20230208223900.5794-1-doshir@vmware.com>
In-Reply-To: <20230208223900.5794-1-doshir@vmware.com>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org,
        pv-drivers@vmware.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, gyang@vmware.com,
        linux-kernel@vger.kernel.org
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

On Wed, 8 Feb 2023 14:38:59 -0800 you wrote:
> Commit b3973bb40041 ("vmxnet3: set correct hash type based on
> rss information") added hashType information into skb. However,
> rssType field is populated for eop descriptor. This can lead
> to incorrectly reporting of hashType for packets which use
> multiple rx descriptors. Multiple rx descriptors are used
> for Jumbo frame or LRO packets, which can hit this issue.
> 
> [...]

Here is the summary with links:
  - [net,v3] vmxnet3: move rss code block under eop descriptor
    https://git.kernel.org/netdev/net/c/ec76d0c2da5c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


