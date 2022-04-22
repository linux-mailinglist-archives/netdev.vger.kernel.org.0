Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDCA950C482
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbiDVW4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbiDVW4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:56:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0898E1FD4DE;
        Fri, 22 Apr 2022 15:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16510B83271;
        Fri, 22 Apr 2022 22:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98723C385A0;
        Fri, 22 Apr 2022 22:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650666012;
        bh=zGGEdPIjAESTGghxl2+i/vefsBQOdeJfq4cy+l6eReo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u15rco15cZ+7+uEEjvLIzCA6R9ZD0Gy4abMM61dxnT6p5dKGjrsLwOzGP4t1jwiM8
         k6tvIJGuyxGRI+hik7bHBzOvqzjRaMK7as9KDsuEbjcvFJvwOieZpFn+KrhAbURU/P
         yit2vdFCE/TqQOmPQ1RtxkdmFHbGFcLlIEZI0sU57xkTbTuxXkTlFGLEcbTQY4yjoE
         UltUKGG7ZQbOdtf2cfBb0VDg8aIzbZi5RRc3npZGoYtOG+nO9EmEDVVBxuquMOfekf
         hmB0lZ3eRLlEe2F5tZ7vmTvEK/JFJ3AIbVgDCrfOUuetJSlp0BU8BfqH4XIfeOBXhd
         B7P3d3g1lmTzQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 78A36E8DD61;
        Fri, 22 Apr 2022 22:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bridge: switchdev: check br_vlan_group() return
 value
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165066601248.17746.1567097686981466441.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Apr 2022 22:20:12 +0000
References: <20220421101247.121896-1-clement.leger@bootlin.com>
In-Reply-To: <20220421101247.121896-1-clement.leger@bootlin.com>
To:     =?utf-8?b?Q2zDqW1lbnQgTMOpZ2VyIDxjbGVtZW50LmxlZ2VyQGJvb3RsaW4uY29tPg==?=@ci.codeaurora.org
Cc:     roopa@nvidia.com, razor@blackwall.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, tobias@waldekranz.com,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 21 Apr 2022 12:12:47 +0200 you wrote:
> br_vlan_group() can return NULL and thus return value must be checked
> to avoid dereferencing a NULL pointer.
> 
> Fixes: 6284c723d9b9 ("net: bridge: mst: Notify switchdev drivers of VLAN MSTI migrations")
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  net/bridge/br_switchdev.c | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - [net-next] net: bridge: switchdev: check br_vlan_group() return value
    https://git.kernel.org/netdev/net/c/7f40ea2145d9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


