Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CCC5AA666
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 05:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235230AbiIBDaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 23:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233341AbiIBDaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 23:30:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E1E2DAA2;
        Thu,  1 Sep 2022 20:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A8792CE294F;
        Fri,  2 Sep 2022 03:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D62D0C433B5;
        Fri,  2 Sep 2022 03:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662089414;
        bh=FBK+gLOAYk4bUyFHWH7/4ROZIQr2TA1sFIc+RioXJPw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=szMIqPvYLVxQnF9F6U7huBXa+bOi7IXx7XEUl374kn/qtVDR6/ot5Vj8ijzmxyHXw
         4JpVPF0CY4yc/wsdlUK4ME7UlbjwI+qzPUzCdyaJTrE+cZpRVzjx12iZKHCVa53zU8
         KSRi3oe1smYbb0wCcWn/zbjJ0VZ0HgUicpE3pm47YFLGftvVxFwpU0mZou0DdRzVI9
         PpKX8PgLVDGwlmOURMLdzFp9UjEUwMSfUDcDPJO5wqrRgpf0CtkIc5MwVuOno+zUp6
         TyGoML0V3X0+wImMQ4gGNcri/J1J2bMzu9BjY4FI9ySqEByXnERJOhqzkUCMRXTdj8
         XPrKoBMXF6/cQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B62D6E924E6;
        Fri,  2 Sep 2022 03:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sched: etf: remove true check in
 etf_enable_offload()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166208941474.631.1304037912816857154.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Sep 2022 03:30:14 +0000
References: <20220831092919.146149-1-shaozhengchao@huawei.com>
In-Reply-To: <20220831092919.146149-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vinicius.gomes@intel.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, weiyongjun1@huawei.com,
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 31 Aug 2022 17:29:19 +0800 you wrote:
> etf_enable_offload() is only called when q->offload is false in
> etf_init(). So remove true check in etf_enable_offload().
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  net/sched/sch_etf.c | 3 ---
>  1 file changed, 3 deletions(-)

Here is the summary with links:
  - [net-next] net: sched: etf: remove true check in etf_enable_offload()
    https://git.kernel.org/netdev/net-next/c/75aad41ac3cf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


