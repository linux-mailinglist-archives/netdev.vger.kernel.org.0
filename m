Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0D56F02B5
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 10:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243022AbjD0Ik0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 04:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243194AbjD0IkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 04:40:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBE24EDF;
        Thu, 27 Apr 2023 01:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1404C61384;
        Thu, 27 Apr 2023 08:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7757FC433D2;
        Thu, 27 Apr 2023 08:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682584819;
        bh=w5SRwn8CFNVNdgkBQOCrjSauvflBmm8f8m+sEuKOc3Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uWXqQRzUmERpLQTakXm9//wxt0RKaGwqlreQ5v0TVTRawdKhFD+ln0fEichy01ByG
         BJohGv0VhyOb3H88g7ZzzXCvwvvgcD3yWUOAYms6R0QcD6ocP3W6ECAuzIk5/J1ncb
         vGjvv60PeDAQbuplk9nPZWJUz5DdVQkUDF1AKabSjvMqcyaoq+Rle5K8Hrr2KCXalw
         TDSPRv7qwmQHEakmK6NGIqOtyHazA+GjxfaKl6XdTLYxRWLWeQUR6mUX5UKwqW94ES
         2b/9OtwrtoW1jspjW/XE/HERyKuvSFB9cCuQre+6sHbY/DOYI6MiNTV553123Zp8kn
         c7XTqXyXuBtYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5B236E5FFC7;
        Thu, 27 Apr 2023 08:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: flower: Fix wrong handle assignment during
 filter change
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168258481936.11272.2256200940539905540.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Apr 2023 08:40:19 +0000
References: <20230425140604.169881-1-ivecera@redhat.com>
In-Reply-To: <20230425140604.169881-1-ivecera@redhat.com>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, simon.horman@corigine.com,
        marcelo.leitner@gmail.com, paulb@nvidia.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 25 Apr 2023 16:06:04 +0200 you wrote:
> Commit 08a0063df3ae ("net/sched: flower: Move filter handle initialization
> earlier") moved filter handle initialization but an assignment of
> the handle to fnew->handle is done regardless of fold value. This is wrong
> because if fold != NULL (so fold->handle == handle) no new handle is
> allocated and passed handle is assigned to fnew->handle. Then if any
> subsequent action in fl_change() fails then the handle value is
> removed from IDR that is incorrect as we will have still valid old filter
> instance with handle that is not present in IDR.
> Fix this issue by moving the assignment so it is done only when passed
> fold == NULL.
> 
> [...]

Here is the summary with links:
  - [net] net/sched: flower: Fix wrong handle assignment during filter change
    https://git.kernel.org/netdev/net/c/32eff6bacec2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


