Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26CAA573836
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 16:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236493AbiGMOA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 10:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236453AbiGMOAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 10:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72BE2DABE;
        Wed, 13 Jul 2022 07:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 690FB61D95;
        Wed, 13 Jul 2022 14:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C357CC341D0;
        Wed, 13 Jul 2022 14:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657720815;
        bh=CkJxKqhmnZhmUurljJ3cUucKOWLEMyD8Bt+kodalhts=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gYGYzL3otWNZcbRCBdm2VJSAOkrQyb6/IJlgbVBkmNckRSWu6hSomKLN5xP1i5PQ5
         7zFQxrxENvCjhoQ8z3W7z5gwQujE61ZI3ZHZ4WGRCiJIDAnImDiODwDt4rCQPXi0xc
         SDGvOdIsUVVqAxuEtR6tqZnvzW+mvAlbmNZHTrjhf3Ef2bAp6He9CZjb0cZ/+GN5OR
         tpNVU6uz99DCmhJ6JVu0DTf03I9BdyolDEpMsUfWQI54fugdn2Fh11VeMnp+8T+TXK
         FXWTfROlRJJ84+LME8dZnjV6nzt7r6EfLEUwoNAPjdzjNNcqQVJbN6FNbP99qTvXX2
         7qSR2LgbTCHjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A37C8E45227;
        Wed, 13 Jul 2022 14:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3,net-next] net/sched: remove return value of
 unregister_tcf_proto_ops
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165772081566.13863.12573773768490938550.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jul 2022 14:00:15 +0000
References: <20220713015438.87005-1-shaozhengchao@huawei.com>
In-Reply-To: <20220713015438.87005-1-shaozhengchao@huawei.com>
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 13 Jul 2022 09:54:38 +0800 you wrote:
> Return value of unregister_tcf_proto_ops is unused, remove it.
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  include/net/pkt_cls.h | 2 +-
>  net/sched/cls_api.c   | 5 +++--
>  2 files changed, 4 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [v3,net-next] net/sched: remove return value of unregister_tcf_proto_ops
    https://git.kernel.org/netdev/net-next/c/bc5c8260f411

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


