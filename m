Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C4359BDB4
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 12:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbiHVKkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 06:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbiHVKkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 06:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E4C2ED66
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 03:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B22560FEF
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 10:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0FB6C433D7;
        Mon, 22 Aug 2022 10:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661164814;
        bh=X6E4AFfvXdacWSIfMJBaL552ypYSxcbnh9RJYUa3Ojw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AK11HxFmpwXXfXeCYa1uZB8O6Mu9vUZtNz/LSAaJl4cAffU9WDs5G+1/BDBphO+nX
         jprd+d7QveLd8gn6zHs4UuNmTYNtmE23qt8r+5KHFItTgMMkCISOu9p0HKWz4DOJ2T
         WaAxwyCwm8ADUsDRvQI3mGHg0rpnFLGcVEmkklcPb7HsYxEZshZ8xKjkXjvgHir3EI
         PgbQbSLLwBWLFwmKPBaTl9R8jgdPAhZwfLudNkFVrtVAJn2P4lNqRUck2WeZ3voENR
         1FEYrkrzrrK9qAewZo5KNn8Vn6Dc4VECGV1EGDlrk1jKZx/ajadtVV/ykyak/e2ots
         hJHui5ycgKqSw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D3CF6C4166E;
        Mon, 22 Aug 2022 10:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] af_unix: Show number of inflight fds for sockets in
 TCP_LISTEN state too
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166116481386.12316.17627358647167875417.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Aug 2022 10:40:13 +0000
References: <1cae5809-26b5-00e8-1554-38fae6d2f991@ya.ru>
In-Reply-To: <1cae5809-26b5-00e8-1554-38fae6d2f991@ya.ru>
To:     Kirill Tkhai <tkhai@ya.ru>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        viro@zeniv.linux.org.uk
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 17 Aug 2022 00:51:54 +0300 you wrote:
> TCP_LISTEN sockets is a special case. They preserve skb with a newly
> connected sock till accept() makes it fully functional socket.
> Receive queue of such socket may grow after connected peer
> send messages there. Since these messages may contain scm_fds,
> we should expose correct fdinfo::scm_fds for listening socket too.
> 
> Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
> 
> [...]

Here is the summary with links:
  - af_unix: Show number of inflight fds for sockets in TCP_LISTEN state too
    https://git.kernel.org/netdev/net-next/c/de4370892443

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


