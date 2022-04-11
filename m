Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46BBF4FB8D0
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 12:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344966AbiDKKCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 06:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344955AbiDKKC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 06:02:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57AF51154
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 03:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0ABB7B811A6
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 10:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9AB12C385A5;
        Mon, 11 Apr 2022 10:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649671212;
        bh=8b52C6v+1eWvHsRvOxuF7AYZBwNTmD53lCxSeyvPcJE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ILmjhHmX6+fSo4OBcklPhGVfosRG7EfCh+jbR1V/KuGrYpnh3TljFIuMVAFsonb8B
         xfWGjvkqoHp9Dt9UUmHuaYDA+Xj9hMuuF9i76Z6z0isEhAWe7kxZ04flPNTx2FunSp
         BZpVZqcqE8qh/bEOeY8VS473yj9xc+k5SzEnORh8CCO24fOLyooE+iIIcAfH2ZJIYd
         n46H9WW4eciGylzlY9IFRcz2j/B/tbYRSR4W/CtbExKwme9AzMe3cio3uVk2kWhJay
         JxTM8wvslduw9ecH12730nqzFoGsicSxSVz82WDa89hN+1n9uv4Yb1LvN+kmpkxcXH
         RcC8H+T+x71Dw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 785F8E73CC8;
        Mon, 11 Apr 2022 10:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/1]  net/sched: taprio: Check if sk_flags are valid
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164967121248.20630.9119673935118140181.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Apr 2022 10:00:12 +0000
References: <20220408094745.3129754-1-b.spranger@linutronix.de>
In-Reply-To: <20220408094745.3129754-1-b.spranger@linutronix.de>
To:     Benedikt Spranger <b.spranger@linutronix.de>
Cc:     netdev@vger.kernel.org, kurt@linutronix.de,
        vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        kuba@kernel.org, vedang.patel@intel.com
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
by David S. Miller <davem@davemloft.net>:

On Fri,  8 Apr 2022 11:47:44 +0200 you wrote:
> While testing the software based scheduling of the taprio scheduler
> new TCP connection failed to establish. Digging it down let to a missing
> validity check in the enqueue function. Add the missing check.
> 
> v1..v2:
> Fix a typo
> Add a acked-by
> 
> [...]

Here is the summary with links:
  - [v2,1/1] net/sched: taprio: Check if socket flags are valid
    https://git.kernel.org/netdev/net/c/e8a64bbaaad1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


