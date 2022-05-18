Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E16752B95B
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236021AbiERMAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236003AbiERMAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4896179C3C;
        Wed, 18 May 2022 05:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 332A4614B4;
        Wed, 18 May 2022 12:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8735CC34118;
        Wed, 18 May 2022 12:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652875214;
        bh=prUwp4E7V9IqxGo2vLtfvwGH/+/rsuiX2MvcewChBaE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i7m91DSfQUhHrotPzC2zUO6JFWSK4j2P0qREhgPmtYe1F0wo9UCm/0fbMRdC+V0It
         1KEtIkqDYQF6cOfQsg4jNUd6fdpOqLR+/uzfl0YuqWq4qYYr67bkWg0rDsfv+tHZgZ
         5E8xQsSPRV8NyKzKVRlk1aMshVfEOSABKZMuRIX+sidb70LdVNmPs+8h3IUXqx4djL
         OTV8MSFUepsBEYBUG7NZpbJSEa6IQCvjO2LkBdTjK1uF1I+zC7VE2cb+j94eNvl/aa
         qaDMTV5VD6WvmKGpk/StKQmGc0AkBxXZ2FI1DBHLBnRF5cEXq1xf/uAcsvvACm0wlM
         eq/oxOL8ZfRcw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 64174F03935;
        Wed, 18 May 2022 12:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: af_key: add check for pfkey_broadcast in function
 pfkey_process
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165287521440.18230.13162864201621058008.git-patchwork-notify@kernel.org>
Date:   Wed, 18 May 2022 12:00:14 +0000
References: <20220517094231.414168-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20220517094231.414168-1-jiasheng@iscas.ac.cn>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Steffen Klassert <steffen.klassert@secunet.com>:

On Tue, 17 May 2022 17:42:31 +0800 you wrote:
> If skb_clone() returns null pointer, pfkey_broadcast() will
> return error.
> Therefore, it should be better to check the return value of
> pfkey_broadcast() and return error if fails.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> 
> [...]

Here is the summary with links:
  - net: af_key: add check for pfkey_broadcast in function pfkey_process
    https://git.kernel.org/netdev/net/c/4dc2a5a8f675

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


