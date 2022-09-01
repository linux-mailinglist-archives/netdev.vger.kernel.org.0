Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8085A8C21
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 06:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbiIAEAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 00:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIAEAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 00:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B4CA2A87
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 21:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F4416130B
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 04:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8EEF4C433B5;
        Thu,  1 Sep 2022 04:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662004815;
        bh=vAiXNfI2HJm9wflLhcN9dEQpLKyhhuOVunOFUssLGaU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ukQT7gdr2aMkxJpaQ7wZlGL12eJJHXkps9EQ5A3GDgQDJuzvVj/pVilTLJmCHiIfd
         7yO3iXSbSf2Z1Ml3l3ie/GS2X1P0noIxtP6e0uZVpXel25qHvUF1iGqUuTBk195XYy
         BlGDIPQeIUEBnLvza9Jze565Gf2Cd2/15q3KBckpvyIc5RbXqA1gTtYv2qTSIbv56O
         ELtl5y9Du/u9CI/pKjlAUifcOP1FMB+u//rx2cI0E071B0W8v2Kwblm5uu1O2GXpZ3
         EjlrJVOIr3PvgVtWQYh2ty/qpzQSpaEp0Y/JzWGIaOujiUHagW6DKiaoJo0wT6WotT
         4wXNClj5zoPag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 71173E924DA;
        Thu,  1 Sep 2022 04:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] tcp: tcp challenge ack fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166200481545.23405.15216665346905890864.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Sep 2022 04:00:15 +0000
References: <20220830185656.268523-1-eric.dumazet@gmail.com>
In-Reply-To: <20220830185656.268523-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, ncardwell@google.com, jbaron@akamai.com,
        edumazet@google.com
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 30 Aug 2022 11:56:54 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot found a typical data-race addressed in the first patch.
> 
> While we are at it, second patch makes the global rate limit
> per net-ns and disabled by default.
> 
> [...]

Here is the summary with links:
  - [net,1/2] tcp: annotate data-race around challenge_timestamp
    https://git.kernel.org/netdev/net/c/8c70521238b7
  - [net,2/2] tcp: make global challenge ack rate limitation per net-ns and default disabled
    https://git.kernel.org/netdev/net/c/79e3602caa6f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


