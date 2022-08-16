Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C35C595310
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 08:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiHPGx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 02:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiHPGxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 02:53:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFD420D588;
        Mon, 15 Aug 2022 20:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC5CEB815D1;
        Tue, 16 Aug 2022 03:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E80EC433C1;
        Tue, 16 Aug 2022 03:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660619413;
        bh=DgELfrZ0BMLHj580s1IZ2+t3v2xO5Trjdz/WI7oyhyg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hFgf1OHAdnsrdtk+mZCYXToTZZsdeU9sphgkB1xFmFX0y8PE23yukRONyzySTWj6n
         b+aQ0hYiLP/BtvBI5sj54shZRLfKdldREH1d4CO8NtEov+D8Iuntva5X7QBjg1EGfP
         rwBvyrgVbpDAEcLcTK66v1483UrxuhU/GcMOUsqcvVhx42ZTwrTLljWf6xskKrnFNR
         aKC+GnB4bYK+b2L4YI1SZzCSYem4ZQ0wcn0cWH9PSxn0m9l9G7PKLd7Ec4EWB3nKfY
         +JmmQGwbH/N/6cIupFToA0vzsHF13X4TyhnlzMGQzmRwv6jc6q1PIhP1z7lUW6uirh
         kTHMIVI539YDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 814C0E2A051;
        Tue, 16 Aug 2022 03:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: rtnetlink: fix module reference count leak
 issue in rtnetlink_rcv_msg
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166061941352.11018.11327419247038105589.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Aug 2022 03:10:13 +0000
References: <20220815024629.240367-1-shaozhengchao@huawei.com>
In-Reply-To: <20220815024629.240367-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, idosch@nvidia.com, petrm@nvidia.com,
        florent.fourcot@wifirst.fr, razor@blackwall.org,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 15 Aug 2022 10:46:29 +0800 you wrote:
> When bulk delete command is received in the rtnetlink_rcv_msg function,
> if bulk delete is not supported, module_put is not called to release
> the reference counting. As a result, module reference count is leaked.
> 
> Fixes: a6cec0bcd342("net: rtnetlink: add bulk delete support flag")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: rtnetlink: fix module reference count leak issue in rtnetlink_rcv_msg
    https://git.kernel.org/netdev/net/c/5b22f62724a0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


