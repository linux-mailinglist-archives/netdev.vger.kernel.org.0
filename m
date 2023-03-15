Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72DAD6BA8E6
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbjCOHUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjCOHUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4A85A6DE
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4FC361AA2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 07:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C409C433EF;
        Wed, 15 Mar 2023 07:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678864817;
        bh=F4KuMifZ9ZEXsbkMqbp9u55Kbtjg/PyrEprE8+lnhlI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HUPTUeQkhivkIo3BDzRGBBC37sy9ktXzsI6XzOYz5dm8Ha1oWzRk9U56zhNO2VJFI
         0cKpHvBIBsYe1HudAAuEFTNkTQu5N6RKxBREceeF2qK1vcmyqzyEOjmChDA3q+yUsQ
         vUC1URMJoAC6cSfBWuq1Yj/kW4SzXkID6V9AymQpewardeyW3YmDRD82oWJdTCY41G
         ry0Gplmy4I5qja+8qQpB4K66ioW7iOzrecj//QvZZvlOthPx//IFQJqQdBBzT8zyOV
         gKPBjMas74WWU8EbPV2TWHpqCwVAVAxU8uIAIVZI9BE+W1sBYp2QZ+AeIvlzNamETZ
         SYEyLgC/zM9Bg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 100CFE66CBC;
        Wed, 15 Mar 2023 07:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: tunnels: annotate lockless accesses to
 dev->needed_headroom
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167886481706.27791.7565555807724134575.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Mar 2023 07:20:17 +0000
References: <20230310191109.2384387-1-edumazet@google.com>
In-Reply-To: <20230310191109.2384387-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
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

On Fri, 10 Mar 2023 19:11:09 +0000 you wrote:
> IP tunnels can apparently update dev->needed_headroom
> in their xmit path.
> 
> This patch takes care of three tunnels xmit, and also the
> core LL_RESERVED_SPACE() and LL_RESERVED_SPACE_EXTRA()
> helpers.
> 
> [...]

Here is the summary with links:
  - [net] net: tunnels: annotate lockless accesses to dev->needed_headroom
    https://git.kernel.org/netdev/net/c/4b397c06cb98

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


