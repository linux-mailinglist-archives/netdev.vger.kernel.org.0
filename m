Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD4B67F5C5
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 08:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbjA1HuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 02:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjA1HuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 02:50:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371FE3669F;
        Fri, 27 Jan 2023 23:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 888CE60A48;
        Sat, 28 Jan 2023 07:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC3F6C4339C;
        Sat, 28 Jan 2023 07:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674892218;
        bh=LgfNZKO5nHqGL1jvIEf4eVDX4YJ6I9yFP0Y2P1Y5iYs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ImXvrtl7wUQZIAklo5zFr/BpN26y6rc/NinXaX4Gs8TCyZOkhQ81OU6Ohs3Du8WKT
         cQL2RZOKlsKG4fRk3514Xa1Qi9ThzVMwxZ9mLKIAS3sl1Xe2v7CY3Z4mMQYpxV4vtF
         +zx2eaXn8gOHuNg4ZwOH1gR2Ya2G85MA8Qa8xZWe7nDeIeAEzsrqpCIOq2+25rIYea
         zmZwjvhp0K8wXdaMYLNDbmNDWLEONNqpb9JtUdg5GoEXOzbrPssPel8HEE9+WcZ3ij
         V0YQbZ3PxDzHXR6qARWMDXyMOMQ38kGf2pdLLIFnjbGuK35K1mGD7TwZ4u7H8WyqlW
         w8LBbCocablRQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BD6D2F83ED2;
        Sat, 28 Jan 2023 07:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH] skb: Do mix page pool and page referenced frags in GRO
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167489221877.30137.12578753687356815512.git-patchwork-notify@kernel.org>
Date:   Sat, 28 Jan 2023 07:50:18 +0000
References: <167475990764.1934330.11960904198087757911.stgit@localhost.localdomain>
In-Reply-To: <167475990764.1934330.11960904198087757911.stgit@localhost.localdomain>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     nbd@nbd.name, davem@davemloft.net, edumazet@google.com,
        hawk@kernel.org, ilias.apalodimas@linaro.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linyunsheng@huawei.com,
        lorenzo@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com
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

On Thu, 26 Jan 2023 11:06:59 -0800 you wrote:
> From: Alexander Duyck <alexanderduyck@fb.com>
> 
> GSO should not merge page pool recycled frames with standard reference
> counted frames. Traditionally this didn't occur, at least not often.
> However as we start looking at adding support for wireless adapters there
> becomes the potential to mix the two due to A-MSDU repartitioning frames in
> the receive path. There are possibly other places where this may have
> occurred however I suspect they must be few and far between as we have not
> seen this issue until now.
> 
> [...]

Here is the summary with links:
  - [net] skb: Do mix page pool and page referenced frags in GRO
    https://git.kernel.org/netdev/net/c/7d2c89b32587

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


