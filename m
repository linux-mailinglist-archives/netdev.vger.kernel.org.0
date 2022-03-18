Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD794DE340
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 22:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241028AbiCRVLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 17:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbiCRVLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 17:11:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F291A8C14;
        Fri, 18 Mar 2022 14:10:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CD57611BC;
        Fri, 18 Mar 2022 21:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C69D3C340ED;
        Fri, 18 Mar 2022 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647637810;
        bh=HpbR6Gf7hzU2NJCes8CWXcz1ylM66O+q4ON2+LpUS64=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Yyng0ldJBHBXgEUH7SuucfTgWnZ9JDGJqHOFzbCU7FXJsBE67l0qDCCf0RE8jN8h7
         42F5UblLa6SB5NqgmA/YvjVv6rJtPGJfkmymfn16I9WfLVc5nTxBL8lrD1KWCHKohi
         +twmmVZX/IWtx4UZHQ+qqDG6SiGDzOkcJnT8MhbSrtbjk6gwa2FncIcjIBI8r+Sepa
         k1dI2vezbCXhH11DLFqEI5bKnFWYPqjCVaCSBnjwUqke2l4LXoI3Wk7AeXLJF+Dvnx
         JkW7sUTOYDl+wZoORJ8shNBKd/C9KqrFMQJWLmjDxGoXoV496+94RPJeJOwqrbDnhP
         EAqhXmASu1LGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A60A5F03841;
        Fri, 18 Mar 2022 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: set default rss queues num to physical cores /
 2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164763781067.14051.4349688731642301072.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Mar 2022 21:10:10 +0000
References: <20220315091832.13873-1-ihuguet@redhat.com>
In-Reply-To: <20220315091832.13873-1-ihuguet@redhat.com>
To:     =?utf-8?b?w43DsWlnbyBIdWd1ZXQgPGlodWd1ZXRAcmVkaGF0LmNvbT4=?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        bigeasy@linutronix.de, atenart@kernel.org, imagedong@tencent.com,
        petrm@nvidia.com, arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 15 Mar 2022 10:18:32 +0100 you wrote:
> Network drivers can call to netif_get_num_default_rss_queues to get the
> default number of receive queues to use. Right now, this default number
> is min(8, num_online_cpus()).
> 
> Instead, as suggested by Jakub, use the number of physical cores divided
> by 2 as a way to avoid wasting CPU resources and to avoid using both CPU
> threads, but still allowing to scale for high-end processors with many
> cores.
> 
> [...]

Here is the summary with links:
  - [net-next] net: set default rss queues num to physical cores / 2
    https://git.kernel.org/netdev/net-next/c/046e1537a3cf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


