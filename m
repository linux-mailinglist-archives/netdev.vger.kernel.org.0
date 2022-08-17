Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96BBF596C15
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 11:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234739AbiHQJaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 05:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232632AbiHQJaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 05:30:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1703A5AA2B
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 02:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4751B81CB2
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 09:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A50DC433B5;
        Wed, 17 Aug 2022 09:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660728615;
        bh=1NcO4FxhYu30h+kaseVjjlv2E9VMTVbJD+F4ULymaXg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CK9bMnzbEXWuabbKNFOkfbAqp2Q9VXu6XSwZy7oYtGzj+ABTzrQgFRzPt5yUEN4TT
         lw8TvUVbwfh/wtZTovZe89GYrZr9eRxtayMhtWrhkcdFlEKpen841V/0+awxAhk4/M
         Y+6lr0sLUIDR2JfANIBTkKnAgCC7kD06BL9y0a9ZJf6srCqr5LXXadf5G3E3LBYxMp
         7bPgpId2c9xywJSWIIZnoYc65ZLDdhe4c/X0UxlCc5Fe7XFW9N8WKMxWzsT7PW9Gg5
         9N+IriFGMZyGOgzoI49DBbzyvtQZ7ewOYJvmsU3alp/dRtHvu63R/c6Qvo4Gu43mZ9
         MYSNtcU1uRSFQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 52123E2A051;
        Wed, 17 Aug 2022 09:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tls: rx: react to strparser initialization errors
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166072861533.2597.6129378092338068381.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Aug 2022 09:30:15 +0000
References: <20220816002358.509148-1-kuba@kernel.org>
In-Reply-To: <20220816002358.509148-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com,
        syzbot+abd45eb849b05194b1b6@syzkaller.appspotmail.com,
        borisp@nvidia.com, john.fastabend@gmail.com
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 15 Aug 2022 17:23:58 -0700 you wrote:
> Even though the normal strparser's init function has a return
> value we got away with ignoring errors until now, as it only
> validates the parameters and we were passing correct parameters.
> 
> tls_strp can fail to init on memory allocation errors, which
> syzbot duly induced and reported.
> 
> [...]

Here is the summary with links:
  - [net] tls: rx: react to strparser initialization errors
    https://git.kernel.org/netdev/net/c/849f16bbfb68

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


