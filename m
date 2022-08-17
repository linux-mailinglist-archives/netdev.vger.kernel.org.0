Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC56B596787
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 04:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238379AbiHQCuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 22:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238370AbiHQCuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 22:50:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E318394EDD;
        Tue, 16 Aug 2022 19:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B6D7B81B93;
        Wed, 17 Aug 2022 02:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C787C43141;
        Wed, 17 Aug 2022 02:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660704615;
        bh=giCq005VdyqjcxCrnpeL8eE9Z9goPeBm8Ee63vOomws=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pFU+j5LZX3b8aZ7/MSmH5sYAscvawmDKSpBJPtE+8AbzWWfxbAcAlyqImmpSH+yGv
         xtTkuY2h75Zf/9qWZOUVoEp/aQZqH4PdG7YT+6HXD7o6xm2uREVEbuBFq/BoyYivel
         Hx/lx78N1xJ4Rg/j7fcwKOFFEpAJ0+j1/F4yg9TIAuxFSy2R4FK+0Ov7cobddwmgjM
         1SL8p+Rlb3Gf0WGGY/D0qV+Ko605aJnUpynZ37n8OoqVGOgCTg/0mtuPBNjR2rf7p2
         6jBCM2CzYsuuoFSpimoeE6nezw8bARx9c0qc4pbzJOpaH9mekpqb8TiKKhsMWj1f+J
         nC0CezsUTw5hA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1209BE2A04C;
        Wed, 17 Aug 2022 02:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sched: remove the unused return value of
 unregister_qdisc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166070461506.20872.3695006129479665537.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Aug 2022 02:50:15 +0000
References: <20220815030417.271894-1-shaozhengchao@huawei.com>
In-Reply-To: <20220815030417.271894-1-shaozhengchao@huawei.com>
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
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

On Mon, 15 Aug 2022 11:04:17 +0800 you wrote:
> Return value of unregister_qdisc is unused, remove it.
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  include/net/pkt_sched.h | 2 +-
>  net/sched/sch_api.c     | 5 +++--
>  2 files changed, 4 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] net: sched: remove the unused return value of unregister_qdisc
    https://git.kernel.org/netdev/net-next/c/52327d2e3996

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


