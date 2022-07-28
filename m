Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9058583674
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 03:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235951AbiG1BkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 21:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234289AbiG1BkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 21:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E131BEA;
        Wed, 27 Jul 2022 18:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4558B822CD;
        Thu, 28 Jul 2022 01:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 53513C43140;
        Thu, 28 Jul 2022 01:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658972413;
        bh=GvhLFpdZlbOT+6kq93Jkhi3Dp0hQr97wL4NsiUM5/WI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KXZdWiUCcP/BzXNo8xFUcjqs+UY8NqxwEFe3sp7tbwHoEJRRwqgBh+z2g8v7w0zW3
         aN5aiOPZJa+xaUOhYnI9hQ0ttRyArfIWdO0vpli3/s7YFYBUNVi3gyZxxNzmZ0DIgU
         QwFNRn+cwq3MwFF6qNTB7lBGrOFfeOmtJ/OBrMHUyZSsVDLavXtlY7TXVfaTImuftW
         S1k/NmP5QGCThkB40+xL4e/I6r9uBM0VaDYCXoFJ7/wHLb+q2IrEzG0tO6Bf99HxNW
         eRZ1Cfp+o/ZN3H4Ek70j2dJ6dEAeiIINHAif1bJ1UOJ69AHjAmcLWw4x3XGnp1i1TT
         PnX84rkhLWPjQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3D6EFC43140;
        Thu, 28 Jul 2022 01:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/sched: sch_cbq: change the type of cbq_set_lss
 to void
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165897241324.6801.12413372106833294210.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jul 2022 01:40:13 +0000
References: <20220726030748.243505-1-shaozhengchao@huawei.com>
In-Reply-To: <20220726030748.243505-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 26 Jul 2022 11:07:48 +0800 you wrote:
> Change the type of cbq_set_lss to void.
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  net/sched/sch_cbq.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] net/sched: sch_cbq: change the type of cbq_set_lss to void
    https://git.kernel.org/netdev/net-next/c/a482d47d33ac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


