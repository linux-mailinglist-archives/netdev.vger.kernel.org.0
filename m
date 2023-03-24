Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2556C7AE4
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbjCXJKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbjCXJKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:10:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A081E1C7;
        Fri, 24 Mar 2023 02:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BA19B8231C;
        Fri, 24 Mar 2023 09:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C2ADC4339E;
        Fri, 24 Mar 2023 09:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679649020;
        bh=JhJR75w7EoOgr7niWhHvEz5xFKwr9R9uOGMJpARv/Uk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s9bZxTPmMf5HMs6EMA1WfJPbnj54SOsjfkQsHkg5yNqnlsE0raF+LVh6RtrYOk/S7
         rZb9gxE+CvTKUXrI0LqN/m/G1k/pWcCh2rUFEWQBbbEefzNYiYeljQVe3heFS+0wBt
         sT3ZJzK8Q+Pe7vElXFZVVspLefyznmGW+2fisCpu0uUsYGaZNwoh2hPbQoEM0JmgW5
         7W/O2Z+0o3VrUqYEjvEHLyRvs8mHc0iK+4L6Dac0Uci+5owXEde6GwnyCyKOfnyt4d
         TnaEUPyTgvxN3RZmC/iBfsgVZVqbQXxqLsAdwTOn5uHV9q4Je4k245tgwhVcvCjXJy
         U7SUfZwUExnPw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 114BFC41612;
        Fri, 24 Mar 2023 09:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] fix typos in net/sched/* files
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167964902006.16080.5424181528625121123.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Mar 2023 09:10:20 +0000
References: <20230323052713.858987-1-awkrail01@gmail.com>
In-Reply-To: <20230323052713.858987-1-awkrail01@gmail.com>
To:     Taichi Nishimura <awkrail01@gmail.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuah@kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 23 Mar 2023 14:27:13 +0900 you wrote:
> This patch fixes typos in net/sched/* files.
> 
> Signed-off-by: Taichi Nishimura <awkrail01@gmail.com>
> ---
>  net/sched/cls_flower.c | 2 +-
>  net/sched/em_meta.c    | 2 +-
>  net/sched/sch_pie.c    | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - fix typos in net/sched/* files
    https://git.kernel.org/netdev/net-next/c/4170f0ef582c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


