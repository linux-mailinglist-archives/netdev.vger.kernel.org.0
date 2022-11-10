Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9623624D7F
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 23:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbiKJWKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 17:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiKJWKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 17:10:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB7622B1E
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 14:10:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 312F561E71
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 22:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8CC2BC433D7;
        Thu, 10 Nov 2022 22:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668118215;
        bh=5nVZrRICgSR5lLZ27uyJG5/6ie0X7VEbCmpuaJyakZE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B8EEvAWaBYhsCGTCej8E/kb4RConTfJcWGQNejPu2H3U/nFVFkbvYsWgnxt60YLfm
         9pcyJS6+QO9fY8eA52AM+h0GMzLM207uBVwXjhw7BRuSjXyaNqL6zz6aT1rTXNU2kC
         apBLRj8EewlS1OjwSqH9OP0MqpYni1AHkQtENJ1YRUwbKdnaBuDgd1VdIXqbBGxkdh
         AR9PJ3NLb2AfKQP3qkkgg6ekzTPboec0sxGObkL/7AOArdlBw2rcTQiLVgKhij55TG
         VnwsAmT3i4IZcVKZ1L0M/eWCG0t4bGAUkrNsowAZnU3QQ0kQ7fFaDywyDHgv13yQ3E
         K0fHGtNJtoz0Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 73893C395F8;
        Thu, 10 Nov 2022 22:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] genetlink: fix single op policy dump when do is
 present
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166811821546.11680.11763299054802321906.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Nov 2022 22:10:15 +0000
References: <20221109183254.554051-1-kuba@kernel.org>
In-Reply-To: <20221109183254.554051-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, bsd@meta.com, jacob.e.keller@intel.com,
        leon@kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  9 Nov 2022 10:32:54 -0800 you wrote:
> Jonathan reports crashes when running net-next in Meta's fleet.
> Stats collection uses ethtool -I which does a per-op policy dump
> to check if stats are supported. We don't initialize the dumpit
> information if doit succeeds due to evaluation short-circuiting.
> 
> The crash may look like this:
> 
> [...]

Here is the summary with links:
  - [net-next,v2] genetlink: fix single op policy dump when do is present
    https://git.kernel.org/netdev/net-next/c/c1b05105573b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


