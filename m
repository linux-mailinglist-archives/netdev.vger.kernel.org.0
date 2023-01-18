Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB05672054
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 15:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbjARO4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 09:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbjAROzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 09:55:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EFA37B5C
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 06:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 832A26186D
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 14:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0345C433EF;
        Wed, 18 Jan 2023 14:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674053416;
        bh=L3zuciie0HBRIDHkQAX+76NNfWJnVdooEWWvL++je90=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DTV5wpyDd7DYDbWMQYKbOp4icVVbSI7DtSY2rAQY3jjrizZoWYEboVwVlAvUhT+Vu
         6DZqZ2JDDgh+eMiUFd2mmtqNr3LC5xD5/BlBYFLQF6Zo7ZvYFugUyA0LkyKpQEY5a5
         4UMvvd+zwAv2BuIb5wEClm6dI1nuSytUkgZuCUJZ9i5uM6dTMKvf9tFPRNL9YKQ5y5
         In5qR71QBlsSTgwAcLufHJ/dc24g6NK7l+z6guiuHWvc1LZL8VzTEFfkkhNdkeehtd
         fcfwHIuKEd12Cgi8Nfy+Jk1zAg/NdK6TYqK3JpHKAqqd7rVMyseGWCwKSUi7V2cul9
         YfNf1j5K6Dx6w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BA9BAE54D2B;
        Wed, 18 Jan 2023 14:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] l2tp: prevent lockdep issue in l2tp_tunnel_register()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167405341676.27903.309021501818203952.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Jan 2023 14:50:16 +0000
References: <20230117110131.1362738-1-edumazet@google.com>
In-Reply-To: <20230117110131.1362738-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzbot+bbd35b345c7cab0d9a08@syzkaller.appspotmail.com,
        cong.wang@bytedance.com, gnault@redhat.com
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
by David S. Miller <davem@davemloft.net>:

On Tue, 17 Jan 2023 11:01:31 +0000 you wrote:
> lockdep complains with the following lock/unlock sequence:
> 
>      lock_sock(sk);
>      write_lock_bh(&sk->sk_callback_lock);
> [1]  release_sock(sk);
> [2]  write_unlock_bh(&sk->sk_callback_lock);
> 
> [...]

Here is the summary with links:
  - [net] l2tp: prevent lockdep issue in l2tp_tunnel_register()
    https://git.kernel.org/netdev/net/c/b9fb10d131b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


