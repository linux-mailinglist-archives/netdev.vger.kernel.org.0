Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA3E6918E8
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 08:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbjBJHAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 02:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbjBJHAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 02:00:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73EB31BED
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 23:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F39A861B83
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 07:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45045C4339E;
        Fri, 10 Feb 2023 07:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676012418;
        bh=lHnCcaxnmDfqmyZvm2pPITVDt4JHfWlDxjMv2gQwOeo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C9oKzQq9vCh1oHu70kDwASKuZdxICwM81yuqRlCccL+ijarU05yEhh4mQM60b08f4
         xUjvDkyORXZ7vtIo0yf8KPDJ8vRyMIZj56TgWNiPCp+uidrIuw9/sXKohradX5OJjL
         C1l4pn1f+9KR6PRSJyt9ftrvifUq/YIcwtNEjZDlTQsVUKk32+fwwsGhmTTm2zTo7r
         w/KWWz5MSGai9vJd1g5hsuA5FDbZi9LJmR5gO9iJw7lnQQhNbKq1+I9kP7JJYlTB0I
         5w2+Lnb/V4OR3udfyUtQyyRPn4JoxG+jy+E5+enG87NbEVBcz030ofFK35A4Xw/0eM
         p11O4tT8amDVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2746EE29F46;
        Fri, 10 Feb 2023 07:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: initialize net->notrefcnt_tracker earlier
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167601241814.12809.11543031404590118868.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Feb 2023 07:00:18 +0000
References: <20230208182123.3821604-1-edumazet@google.com>
In-Reply-To: <20230208182123.3821604-1-edumazet@google.com>
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Feb 2023 18:21:23 +0000 you wrote:
> syzbot was able to trigger a warning [1] from net_free()
> calling ref_tracker_dir_exit(&net->notrefcnt_tracker)
> while the corresponding ref_tracker_dir_init() has not been
> done yet.
> 
> copy_net_ns() can indeed bypass the call to setup_net()
> in some error conditions.
> 
> [...]

Here is the summary with links:
  - [net] net: initialize net->notrefcnt_tracker earlier
    https://git.kernel.org/netdev/net/c/6e77a5a4af05

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


