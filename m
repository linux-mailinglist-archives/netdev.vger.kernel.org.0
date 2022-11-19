Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8455D630B91
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 04:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbiKSDyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 22:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiKSDx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 22:53:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC31C7212
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 19:50:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E8A362834
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 03:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7D89EC4314F;
        Sat, 19 Nov 2022 03:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668829818;
        bh=f85J10yYOfvWHcWDVrmXAQZaTxoJaMgw2hrzsxeja1M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uB9zyfAuY31MWm0QXEoyU4eI3zgu5ZItMT6Qu5XVe3Q2N280p6gA8zG73xzEvhsr3
         w/nHBsx9jWoWvm56jMtqVoTBV6J03396nDP+dOTxtLANP03tiMwmZxdr9jKwi5lBxG
         tTU7ypJGcPFE8niTRB6e/ru4wuDqPsBWPW5pa9Jw9YUcm+HveBIFTJNwNrwzkKEUMn
         JRVGOK29KcA+ifpW182lJBuobn0AzQqu8r5QyV7fDB984v3Q0TppyLQB7IQws8GhzX
         Oq7NWnvtJvevjyNVvxiwAgDZ9v9GCOZhhNQ0lUzPnLnqsF1Q1lAANyvw97D94vsCSK
         D1h3d3ToqYImg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6481AE4D017;
        Sat, 19 Nov 2022 03:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: pch_gbe: fix pci device refcount leak while module
 exiting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166882981839.27279.2756154167237549945.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Nov 2022 03:50:18 +0000
References: <20221117135148.301014-1-yangyingliang@huawei.com>
In-Reply-To: <20221117135148.301014-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, tshimizu818@gmail.com
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

On Thu, 17 Nov 2022 21:51:48 +0800 you wrote:
> As comment of pci_get_domain_bus_and_slot() says, it returns
> a pci device with refcount increment, when finish using it,
> the caller must decrement the reference count by calling
> pci_dev_put().
> 
> In pch_gbe_probe(), pci_get_domain_bus_and_slot() is called,
> so in error path in probe() and remove() function, pci_dev_put()
> should be called to avoid refcount leak. Compile tested only.
> 
> [...]

Here is the summary with links:
  - [net] net: pch_gbe: fix pci device refcount leak while module exiting
    https://git.kernel.org/netdev/net/c/5619537284f1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


