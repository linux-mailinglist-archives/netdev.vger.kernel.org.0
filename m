Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCEE355F4F5
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 06:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiF2EKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 00:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiF2EKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 00:10:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9774F20F5F
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 21:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57DF7B82193
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 04:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF98CC341D3;
        Wed, 29 Jun 2022 04:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656475814;
        bh=OUv3T85MfsZavgYuJpdPHsEiLs1YhcFhDTpmW8NaRB8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bNnNh9R/MTUpqCqlUCmOuvi4GdMxaPF17gjVlNwPT2MOYrJBIuNu3tQXtOxWFKA/i
         NpO6h9BlJ+Lg0EZ9b/cQ5lNyy5TUCQ/KK9hwm/k9lqijI6+TooAuSbPhWjBrqjjyup
         gE6SMZ+qQDckBn0NUcdGtB5CVWAU8agGsjrxydetdIDS6lKUAjG4rpf4R013hVmUIM
         HPPpuJCwOIhDx59+DmWfbYtO9PJJACuQBJ8V8PH7H2RRPLjT2a2vJkG0gMjq2J5nMc
         VdMFUDum5ikJ/R+E5Ou00iCdSm+geq9wrVvRlGW1rOC0QUoQQkytWbyoX2fvNUcnSE
         BAMAc4Qkzzt5g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D8F57E49BB8;
        Wed, 29 Jun 2022 04:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net] af_unix: Do not call kmemdup() for init_net's sysctl
 table.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165647581388.19740.11080442263785622294.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Jun 2022 04:10:13 +0000
References: <20220627233627.51646-1-kuniyu@amazon.com>
In-Reply-To: <20220627233627.51646-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ebiederm@xmission.com, xemul@openvz.org,
        herbert@gondor.apana.org.au, kuni1840@gmail.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 27 Jun 2022 16:36:27 -0700 you wrote:
> While setting up init_net's sysctl table, we need not duplicate the
> global table and can use it directly as ipv4_sysctl_init_net() does.
> 
> Unlike IPv4, AF_UNIX does not have a huge sysctl table for now, so it
> cannot be a problem, but this patch makes code consistent.
> 
> Fixes: 1597fbc0faf8 ("[UNIX]: Make the unix sysctl tables per-namespace")
> Acked-by: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> 
> [...]

Here is the summary with links:
  - [v3,net] af_unix: Do not call kmemdup() for init_net's sysctl table.
    https://git.kernel.org/netdev/net-next/c/849d5aa3a1d8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


