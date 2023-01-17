Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6863066D8AE
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 09:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236312AbjAQIvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 03:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236204AbjAQIuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 03:50:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B652ED69
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 00:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7D2361219
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 08:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3885BC433F0;
        Tue, 17 Jan 2023 08:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673945416;
        bh=p9/XchHLlDhDZ/kIv440MvqH6nGRtJsrFXFWn1BTQf0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q974K9bPI/lrh99GtmTblN2zgJXdLTDWKicVHVbGLhuuDP1wyQgSsoe+Cx7LqYG3o
         Opm1Y5awOs3+jGJl8hjL8irm2NR6jR37I/m9pFZgxv8RplBzJmSmrGDZmI7Ls0ZATS
         EyUxkcQ5RYUS14z8tZGvm2ZfMKGAOTuBZ6BgNWTVN83v8lG1ZiD43MTelQPmp7QTbO
         NilRWcmRfaQGV+gjJ4+4pWtBwAVCcywaWrOkafEzTGK8dVoutTZ5o33/20SzqduCb6
         jy5qyzGQAr22b/V584SNhzaLVQwaxpLXgbDTOqHRl0P/xHg1DUxrR5Q7zNqpRhFmtq
         ee0BdUlnIkUdg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 17DEAC41670;
        Tue, 17 Jan 2023 08:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv4 net-next] sched: add new attr TCA_EXT_WARN_MSG to report tc
 extact message
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167394541609.24163.5061851067282569620.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Jan 2023 08:50:16 +0000
References: <20230113034353.2766735-1-liuhangbin@gmail.com>
In-Reply-To: <20230113034353.2766735-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, dsahern@kernel.org,
        marcelo.leitner@gmail.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 13 Jan 2023 11:43:53 +0800 you wrote:
> We will report extack message if there is an error via netlink_ack(). But
> if the rule is not to be exclusively executed by the hardware, extack is not
> passed along and offloading failures don't get logged.
> 
> In commit 81c7288b170a ("sched: cls: enable verbose logging") Marcelo
> made cls could log verbose info for offloading failures, which helps
> improving Open vSwitch debuggability when using flower offloading.
> 
> [...]

Here is the summary with links:
  - [PATCHv4,net-next] sched: add new attr TCA_EXT_WARN_MSG to report tc extact message
    https://git.kernel.org/netdev/net-next/c/0349b8779cc9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


