Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115084BF184
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 06:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiBVFhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 00:37:02 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:47304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiBVFgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 00:36:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500973A0
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 21:36:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E23FA615D5
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 05:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4EB00C340F0;
        Tue, 22 Feb 2022 05:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645506010;
        bh=yj2Fk8f3S+6W7aXkd03Owob4BygC8tVRBQrcIdeJx5o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B+ATwlZVRsw+nVrFkZWXgFl22RZniP+2WLhxzHFqg0S9ABfEK9K7IoF6pJJeXqqHE
         qFvEINw6qPCehnR0D2pzLoJ9qOJks0lg0j5RLES2Glg4Ctj7sJCn2ZNqASSAP/v17c
         fQtRvylLE9aNpNHOGLD4INe7dxrnYmaSmJqXeb8JpbdVYHbVScBlAMbotxWNp39pEo
         rhtPOjuQjw4TrO8uUOjlmxXlOJultabZGdDyXNJ3VwVV0+KvKZYXRPdgs6+z3AWamm
         MRAHEKpp+kriRUVm4z64fm2Bkmyh35UHFayfB3xdDdi7NXEOa0Dtku/AG4/gY9Z1gW
         V19QNh1yR7vsg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 36F6EE6D447;
        Tue, 22 Feb 2022 05:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: hsr: fix hsr build error when lockdep is not
 enabled
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164550601022.6244.4584908530321869685.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Feb 2022 05:00:10 +0000
References: <20220220153250.5285-1-claudiajkang@gmail.com>
In-Reply-To: <20220220153250.5285-1-claudiajkang@gmail.com>
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        eric.dumazet@gmail.com, ennoerlangen@gmail.com,
        george.mccollister@gmail.com, olteanv@gmail.com,
        marco.wenzel@a-eberle.de
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 20 Feb 2022 15:32:50 +0000 you wrote:
> In hsr, lockdep_is_held() is needed for rcu_dereference_bh_check().
> But if lockdep is not enabled, lockdep_is_held() causes a build error:
> 
>     ERROR: modpost: "lockdep_is_held" [net/hsr/hsr.ko] undefined!
> 
> Thus, this patch solved by adding lockdep_hsr_is_held(). This helper
> function calls the lockdep_is_held() when lockdep is enabled, and returns 1
> if not defined.
> 
> [...]

Here is the summary with links:
  - [net-next] net: hsr: fix hsr build error when lockdep is not enabled
    https://git.kernel.org/netdev/net-next/c/a0b92e0514bb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


