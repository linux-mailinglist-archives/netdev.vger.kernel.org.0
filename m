Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 143F66E1362
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 19:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjDMRU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 13:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjDMRUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 13:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6ED86AA;
        Thu, 13 Apr 2023 10:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98B9464071;
        Thu, 13 Apr 2023 17:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1C51C433A1;
        Thu, 13 Apr 2023 17:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681406417;
        bh=S5sD31Jvp5OI+X4BKzorxYUkvSHH+n1K8mZYMNpqKqg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gByR3pL9H8TzNuqsmpzcPScTnsJXlX+cV+j2Kns5Kl53p3jyKxrlxoI0gFQotr3qW
         KVgZTou7QwOQz246oF6y8eeLTnEsPcR++iPcCevadqOV1r06Qb/bEIKbDWdB1H1GB9
         gTJF1TqIGY9Rg8WOorHIDrt+Bxof1SokLeT5MTqJgTAFJr2rFeSRy4ZA6dWnFM+KaA
         jbSCloTURx5We9a/tNeUec9UJiOH1id/wQVSnVMcTItjMepCqZPg10BMG7EbLbN9A0
         QOkAAqK012CMv7QQypB2iZBjPhLv+Cl6TbzMj2PycBrEVyk+/MNFZXOPZ1yIfvlswv
         H34Xl5yDN71mw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ABEE6E21ED9;
        Thu, 13 Apr 2023 17:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests: add the missing CONFIG_IP_SCTP in net config
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168140641769.8255.7960016481150853509.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Apr 2023 17:20:17 +0000
References: <61dddebc4d2dd98fe7fb145e24d4b2430e42b572.1681312386.git.lucien.xin@gmail.com>
In-Reply-To: <61dddebc4d2dd98fe7fb145e24d4b2430e42b572.1681312386.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, marcelo.leitner@gmail.com,
        naresh.kamboju@linaro.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 12 Apr 2023 11:13:06 -0400 you wrote:
> The selftest sctp_vrf needs CONFIG_IP_SCTP set in config
> when building the kernel, so add it.
> 
> Fixes: a61bd7b9fef3 ("selftests: add a selftest for sctp vrf")
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] selftests: add the missing CONFIG_IP_SCTP in net config
    https://git.kernel.org/netdev/net/c/3a0385be133e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


