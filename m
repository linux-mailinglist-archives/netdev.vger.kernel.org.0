Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49DC7690FBF
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 19:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjBISAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 13:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjBISAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 13:00:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A035A9D0
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 10:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52DFD61B7A
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 18:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B1140C4339B;
        Thu,  9 Feb 2023 18:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675965617;
        bh=FGahsbTKemRAuZnCelWSL+9oZe/N4pttm9gQzb3eduI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N1o+UT8TcjTsA4hLtpTldZJ+6Hn2Avzvg2T93bqyJHaOzz9LSlvoHhPOWu713d+mT
         KsxuUpZA55NCscHBATJMoF2AuaMUUJJj3/p+Mk7vw6BhOzzsiNGjbqFDQLXedu0llz
         CaSTKB6Y1/Oa5DbmKdnyG4mjYRpeIFxakGit9OTpqVDa6IIDxwmYEvHtB646D1b6zD
         MtPmWFWlAWjW9l0DYiTSjLGmCLklNdDzGrAxcAFRwaUGTF1Mn3rk+6uAUIpiWqinO3
         aTkATr3+eKYHFbjN3OT/6sppQhVdo5svMx2cmux9z1BzXEdbQFxtfS+rNZUQu2Cg6w
         I4Yr4WFSkAMfw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 97794E21EC9;
        Thu,  9 Feb 2023 18:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: enable usercopy for skb_small_head_cache
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167596561761.3775.10656458363335717304.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Feb 2023 18:00:17 +0000
References: <20230208142508.3278406-1-edumazet@google.com>
In-Reply-To: <20230208142508.3278406-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com, soheil@google.com,
        alexanderduyck@fb.com, syzkaller@googlegroups.com
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

On Wed,  8 Feb 2023 14:25:08 +0000 you wrote:
> syzbot and other bots reported that we have to enable
> user copy to/from skb->head. [1]
> 
> We can prevent access to skb_shared_info, which is a nice
> improvement over standard kmem_cache.
> 
> Layout of these kmem_cache objects is:
> 
> [...]

Here is the summary with links:
  - [net-next] net: enable usercopy for skb_small_head_cache
    https://git.kernel.org/netdev/net-next/c/0b34d68049b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


