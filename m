Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29634CD976
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 17:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240639AbiCDQvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 11:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234843AbiCDQvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 11:51:01 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9E01B5103
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 08:50:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 59D49CE2CD5
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 16:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6024DC340F1;
        Fri,  4 Mar 2022 16:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646412610;
        bh=qge6UYYQ22o6lOgmH5AJqQerPPxhJufHcdViaQX/+EM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=imh3a6UZ/3d3hK4ARZU7Gc9SYWtY03nAH0uQfwpp3Gui23+BePpWgXscCcnLAtxE1
         yCngPlmn2sK1r4w8TiMPjtOx+4p+fPGOV/ISH2JmPRbj6R8RlSfeUTK3SWVuB/ygz5
         dcc0Z2C0zhAEwhP4Fb/5X+YmDLLbDdSwmmB/9G32i5DwDDC9uJ7J1jo0v90Sm7PJtc
         BkeA6ar8iip7NzunVZ4L0+K9qhZTLNwpu4q1kavFOpXHy37LBW3b8mxqJLNTybnUqx
         0rX7R/REr3bAP23aZlf302zuidCZx7ptzWYTDc1zGfhrU3zDIOt/WTU6lcntfdl+YG
         n246OVgEUGiFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3C949EAC081;
        Fri,  4 Mar 2022 16:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v2] ss: display advertised TCP receive window
 and out-of-order counter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164641261024.1277.13900068400457242166.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Mar 2022 16:50:10 +0000
References: <01806a230fab4a6122f407fe96486cee2f6318dd.1646317132.git.dcaratti@redhat.com>
In-Reply-To: <01806a230fab4a6122f407fe96486cee2f6318dd.1646317132.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     ncardwell@google.com, dsahern@kernel.org, netdev@vger.kernel.org,
        sbrivio@redhat.com, tph@fb.com
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

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Thu,  3 Mar 2022 16:19:32 +0100 you wrote:
> these members of TCP_INFO have been included in v5.4.
> 
> tested with:
>  # ss -nti
> 
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v2] ss: display advertised TCP receive window and out-of-order counter
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=5e17b715295f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


