Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000ED6979E2
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 11:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbjBOKaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 05:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233062AbjBOKaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 05:30:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC3B366A8;
        Wed, 15 Feb 2023 02:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BE9B61B18;
        Wed, 15 Feb 2023 10:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 70923C433A8;
        Wed, 15 Feb 2023 10:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676457018;
        bh=gOeYKBF6n3GYKAq9cm9aU42N9L+SqmlKSzHkYilK8RY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HsUuEBK95DmBqbp9dqWcYLYPuaoOiEbr3QjyXAcDeIJQ0NgnENM4XTYH5JZ7m4IY6
         PL+znS5u93/0UK63qCjP0+mXqY9f2fXgccu4IurqqQ+huqboepPeiOo3wSzShGAJuI
         bcXnYpo/8RPzXGqVakLrSfvrVvQw66Z8eTDtblMGqFeXOS3X3ez5+v9ZvubZDXdGjF
         PC+CqwSveA4JC8K+SV0JbljFOvjPpT/215rUsHHxsEKLAkJa5Jgs5A8jGr6FUiSbWR
         L0nnC/WxWnhNMx4eNnkhMXdASbH3WffY7w1Q/M/Rx8/Yl8WX+jUlVMe9zJGqjOK1W9
         L5lgRZ420GaNg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 56E64C41676;
        Wed, 15 Feb 2023 10:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: no longer support SOCK_REFCNT_DEBUG feature
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167645701835.29620.12786304012973070706.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Feb 2023 10:30:18 +0000
References: <20230214041410.6295-1-kerneljasonxing@gmail.com>
In-Reply-To: <20230214041410.6295-1-kerneljasonxing@gmail.com>
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     kuniyu@amazon.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, dsahern@kernel.org,
        matthieu.baerts@tessares.net, willemdebruijn.kernel@gmail.com,
        nhorman@tuxdriver.com, marcelo.leitner@gmail.com,
        lucien.xin@gmail.com, kgraul@linux.ibm.com, wenjia@linux.ibm.com,
        jaka@linux.ibm.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sctp@vger.kernel.org, mptcp@lists.linux.dev,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernelxing@tencent.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 14 Feb 2023 12:14:10 +0800 you wrote:
> From: Jason Xing <kernelxing@tencent.com>
> 
> Commit e48c414ee61f ("[INET]: Generalise the TCP sock ID lookup routines")
> commented out the definition of SOCK_REFCNT_DEBUG in 2005 and later another
> commit 463c84b97f24 ("[NET]: Introduce inet_connection_sock") removed it.
> Since we could track all of them through bpf and kprobe related tools
> and the feature could print loads of information which might not be
> that helpful even under a little bit pressure, the whole feature which
> has been inactive for many years is no longer supported.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: no longer support SOCK_REFCNT_DEBUG feature
    https://git.kernel.org/netdev/net-next/c/fe33311c3e37

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


