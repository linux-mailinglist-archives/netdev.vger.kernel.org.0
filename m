Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F1D65752E
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 11:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbiL1KKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 05:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232938AbiL1KKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 05:10:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1393010546
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 02:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C28D6135F
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 10:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F3D01C433F0;
        Wed, 28 Dec 2022 10:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672222216;
        bh=H+Z2REWbcVjNDtd/19bQCBslrq52DnhpClUQL6ZOdpg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RxiYo+upfHJKPh5ub+v4qFMQYHjfpJ8EyaM7pWFormdG2La430XUzsCK5w/a8po2v
         9YMmKOY65kxA8n8lax6P/g1mXd4PnP4cNHqj8sKPx8IGKsiFWqCw53JH1OVjVrV5MQ
         xaYVgFWKcN56j2mUC36+3wZwU/Vy4FGIQoBmUYMnLpUls5CLPCm0Ra6LnVJgZl8SKx
         X/30eur8By7iM9P0VSACcWklDd9BP2D+MFL7BD4ASvjy/eqgJhhx/RPHnmXcMe8n9c
         hql4tEPu9npcfD/B6rUrOW9JgRow5/LQb5KIfikWnoHu2G27MEMYp/X90JQLwdgQmf
         SMiPCGRMOy4Lg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DAE9BE50D70;
        Wed, 28 Dec 2022 10:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] netdev doc de-FAQization
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167222221589.7103.10053124658116345424.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Dec 2022 10:10:15 +0000
References: <20221222192248.1265007-1-kuba@kernel.org>
In-Reply-To: <20221222192248.1265007-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, f.fainelli@gmail.com, andrew@lunn.ch,
        rdunlap@infradead.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 22 Dec 2022 11:22:46 -0800 you wrote:
> We have outgrown the FAQ format for our process doc.
> I often find myself struggling to locate information in this doc,
> because the questions do not serve well as section headers.
> Reformat the document.
> 
> v2: update the headers
> v1: https://lore.kernel.org/all/20221221184007.1170384-1-kuba@kernel.org/
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] docs: netdev: reshuffle sections in prep for de-FAQization
    https://git.kernel.org/netdev/net/c/f4ef681115f8
  - [net,v2,2/2] docs: netdev: convert to a non-FAQ document
    https://git.kernel.org/netdev/net/c/ff249be5cca9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


