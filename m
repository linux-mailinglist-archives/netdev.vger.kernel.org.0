Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849855A122D
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 15:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241728AbiHYNal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 09:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242713AbiHYNaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 09:30:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AAE0AE9F6;
        Thu, 25 Aug 2022 06:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90C8BB81DF1;
        Thu, 25 Aug 2022 13:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12C67C433B5;
        Thu, 25 Aug 2022 13:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661434215;
        bh=bopjZ3EAOBRbSKc1eZBc9NxU1rihzcKJjfdgqWzzU2E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TLr0xvGbFxxEp9YqEBDylyS6daeJz3vrb4F58qiKyEDJUeO3tOKr3hJLYJess5Was
         gAZFg3Jux//RFiPJ35IzPPs6ZVGQRLCBldTnJclsPy1uj1xSxtVqsoTyIiKWYVa7VI
         eHAd55QiY6OlwyiujUyGq0HY6K2npRYIiSJTv2h2VxoaZ5AMBtXjNQf+Mg1bS5RZ2o
         K/p+Y1pDQUpgrvq29h7MjHx/zA0Y5sQhfNKEdXYekxxQBiGkvRbrmdtPYDyCmYeXfj
         ma8kQF9DFwbimpOrfVer0A+9O4aZ8KE8vq0DR5id6IC6rM+AZYsXGZdPIJ37LqepNW
         TM/32k24YTV3w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E5282C4166E;
        Thu, 25 Aug 2022 13:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next,v2] net: sched: delete duplicate cleanup of backlog
 and qlen
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166143421493.23449.11479181390750074314.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Aug 2022 13:30:14 +0000
References: <20220824005231.345727-1-shaozhengchao@huawei.com>
In-Reply-To: <20220824005231.345727-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, vinicius.gomes@intel.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 24 Aug 2022 08:52:31 +0800 you wrote:
> qdisc_reset() is clearing qdisc->q.qlen and qdisc->qstats.backlog
> _after_ calling qdisc->ops->reset. There is no need to clear them
> again in the specific reset function.
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
> v1: changelog is slightly inaccurate.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: sched: delete duplicate cleanup of backlog and qlen
    https://git.kernel.org/netdev/net-next/c/c19d893fbf3f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


