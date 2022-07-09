Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75D856C93C
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 13:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiGILkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 07:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGILkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 07:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F9B64E33
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 04:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75C0D60F31
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 11:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C76C7C341CD;
        Sat,  9 Jul 2022 11:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657366813;
        bh=Pe0HwMB8KQ4rUnzo/uFErSjljyuyd6WoYag92PaDJ48=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eePcL6IYzydI1CIGOwosmOMsCZRNYOGDZ1gYZvz7pEUqVvguNDXGjtBdcFmeoT4Uw
         uTUBiGLXWKpf+FPBAfGEWIGpwsgJ9rr/lUfq/Y+jDE+0tmecorAkHVi+VcrtdI4mkJ
         cRlthWq+dNHgT8KU2Q7Fvq5tdbhdkZpQ12UYgb8Au1LW+lS5orR39yHMRKxFWfAayN
         FvK8WI9VnwEkg2iNc67DaLDVqCYI/KbYvwefOd+LnqS5Zq2AHPXf9/M6IMUlZ/YQBD
         u8Z/qavyPTjTjLVeS2x4hJ2OtUHYbT7K8rTJkw3jgu311DfjKpf7DHFh25xCqKP3E5
         0HeQgDMxl6sgA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AEF9CE45BDE;
        Sat,  9 Jul 2022 11:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] af_unix: fix unix_sysctl_register() error path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165736681371.32617.14269179133084187915.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Jul 2022 11:40:13 +0000
References: <20220708162858.1955086-1-edumazet@google.com>
In-Reply-To: <20220708162858.1955086-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com, kuniyu@amazon.com,
        ebiederm@xmission.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri,  8 Jul 2022 16:28:58 +0000 you wrote:
> We want to kfree(table) if @table has been kmalloced,
> ie for non initial network namespace.
> 
> Fixes: 849d5aa3a1d8 ("af_unix: Do not call kmemdup() for init_net's sysctl table.")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> 
> [...]

Here is the summary with links:
  - [net] af_unix: fix unix_sysctl_register() error path
    https://git.kernel.org/netdev/net-next/c/44ac441a51a7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


