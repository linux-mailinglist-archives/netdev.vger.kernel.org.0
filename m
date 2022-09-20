Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1715BD918
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiITBKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiITBKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:10:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B183ED70;
        Mon, 19 Sep 2022 18:10:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6CE561FF0;
        Tue, 20 Sep 2022 01:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39BB3C4314C;
        Tue, 20 Sep 2022 01:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663636221;
        bh=vFJRer4FOSTvYvl9YDrEZcwEhwDiKpOvDGSBqcmgIRo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Iq5ppgJWOajzethTp5qbcih3bG35ZwKDTkHN+3zI3D/0iVxQVVBjGPIlxNBDabHY1
         1Ydt7cbCaRT2WdF5HqvnDCs7flmS8vwZQj7fBDg+AvJPO/KpyJ2S11phc0qCTe+3Sd
         fV8qqKxBDzqpGosTSrXmbpSHl0CzbFBZNH9W5UafJQMPoAocWKIym6aSVYJxZeZgfe
         MaHfTtSrkWrpkV5QJJ++9Pthe5jcn8onXQzkWuds4YKT1k57hyXqGkk449/7Yfq70r
         XwSpKGBYhpq1gHbSPTO7v7w35FhtpWEW/qcFsMBsYrpYOyDxeT8ckniQNHhyxSlibd
         QuCxuzD2oPgUA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2637DE52537;
        Tue, 20 Sep 2022 01:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: rds: add missing __init/__exit annotations to
 module init/exit funcs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363622114.23429.5060828728541368587.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:10:21 +0000
References: <20220909091840.247946-1-xiujianfeng@huawei.com>
In-Reply-To: <20220909091840.247946-1-xiujianfeng@huawei.com>
To:     Xiu Jianfeng <xiujianfeng@huawei.com>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 9 Sep 2022 17:18:40 +0800 you wrote:
> Add missing __init/__exit annotations to module init/exit funcs.
> 
> Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
> ---
>  net/rds/af_rds.c         | 2 +-
>  net/rds/rdma_transport.c | 4 ++--
>  net/rds/tcp.c            | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [-next] net: rds: add missing __init/__exit annotations to module init/exit funcs
    https://git.kernel.org/netdev/net-next/c/f0bd32c83382

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


