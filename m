Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D53B56762C8
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 03:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjAUCAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 21:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjAUCAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 21:00:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BA23AAE
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 18:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95626620E8
        for <netdev@vger.kernel.org>; Sat, 21 Jan 2023 02:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E9FA1C4339B;
        Sat, 21 Jan 2023 02:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674266417;
        bh=U+yCdfRCBfmdvB1BFfb77fwK0H1d21Lld/l/ex9OGZQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H5QPC/nvhy+p7JzsX7NHHLOg7hiu+JMGbHvvzdJlEr1K2p23JSFAsMk3R+3d1gtrS
         TFePuOt23swlBonQxum+O6HikJYYU2dWVA07ZVMKM3AUB1IxxHVXIWD+GAKVc+/rpF
         IvTMmEw2Fy268SawjYyti9Bk7CS3rp1DwfW7cfZV51jJbz+Rauz7i0UpM8l2ixjtTV
         UKkX3bjVKErICMayWKiQOQVo+0Rf4hXHHLS9cZF3g01qlRc6qDZpPzI4/I8OWSXCAG
         MMtkkWRXeIQP9Wv+no6yhaFFxkwC0SZ8++52Z4mYG0V11QiNnIwbCeLedeghtSpN2Y
         e51tJ8xzrFR1g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C13F5C395DC;
        Sat, 21 Jan 2023 02:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netlink: prevent potential spectre v1 gadgets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167426641678.22020.4200875243915232545.git-patchwork-notify@kernel.org>
Date:   Sat, 21 Jan 2023 02:00:16 +0000
References: <20230119110150.2678537-1-edumazet@google.com>
In-Reply-To: <20230119110150.2678537-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 19 Jan 2023 11:01:50 +0000 you wrote:
> Most netlink attributes are parsed and validated from
> __nla_validate_parse() or validate_nla()
> 
>     u16 type = nla_type(nla);
> 
>     if (type == 0 || type > maxtype) {
>         /* error or continue */
>     }
> 
> [...]

Here is the summary with links:
  - [net] netlink: prevent potential spectre v1 gadgets
    https://git.kernel.org/netdev/net/c/f0950402e8c7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


