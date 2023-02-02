Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8DB68879E
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 20:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbjBBTkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 14:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbjBBTkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 14:40:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334BE7B425
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 11:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C31C261CB4
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 19:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F8EFC433D2;
        Thu,  2 Feb 2023 19:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675366818;
        bh=w7KXPWrOWAcA3TnIzmhersFlKxMoBLGVmInfjacXeRw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mzeQFUYOHk9KRbirXeiYBlCzcWf3kfcX+z0oGVYB8w9m0Q5cPJRo4sF/DtoYjR+4Z
         mpxq+QH2EIdEqAtfCVGqzjVRrsFjmwTdSaqyplSL3pqlxbjFSkddQNkchv36Mtu8tK
         oV2Tt4/AUMSApH5VTM4edg6QaKHqmB4XFlOl/Y7GjKcr60JKFywEmPK1vXhT2ztxPA
         2X6sfI/CvKTzJeytxYSPKsbItzjpKFTq2Tv03qSPVMeGvIRRoR4G0E/RZ/Kka45BxI
         kxKfZvllBPX7cq8N2OD+XjnRcTlHBykbVxGexQYWcLuekXl+6um/+HICZcra4moRS0
         xKC8MB2JWzBUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1A918E270CC;
        Thu,  2 Feb 2023 19:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] MAINTAINERS: spring refresh of networking maintainers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167536681810.25016.11597910231241167781.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 19:40:18 +0000
References: <20230201182014.2362044-1-kuba@kernel.org>
In-Reply-To: <20230201182014.2362044-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  1 Feb 2023 10:20:10 -0800 you wrote:
> Use Jon Corbet's script for generating statistics about maintainer
> coverage to identify inactive maintainers of relatively active code.
> Move them to CREDITS.
> 
> Jakub Kicinski (4):
>   MAINTAINERS: bonding: move Veaceslav Falico to CREDITS
>   mailmap: add John Crispin's entry
>   MAINTAINERS: ipv6: retire Hideaki Yoshifuji
>   MAINTAINERS: update SCTP maintainers
> 
> [...]

Here is the summary with links:
  - [net,1/4] MAINTAINERS: bonding: move Veaceslav Falico to CREDITS
    https://git.kernel.org/netdev/net/c/57b24f8c30a0
  - [net,2/4] mailmap: add John Crispin's entry
    https://git.kernel.org/netdev/net/c/a35965625649
  - [net,3/4] MAINTAINERS: ipv6: retire Hideaki Yoshifuji
    https://git.kernel.org/netdev/net/c/c71a70c267eb
  - [net,4/4] MAINTAINERS: update SCTP maintainers
    https://git.kernel.org/netdev/net/c/cd101f40a419

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


