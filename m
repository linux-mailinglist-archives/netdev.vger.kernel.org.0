Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164D265B2C3
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 14:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbjABNkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 08:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjABNkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 08:40:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B91CC2
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 05:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C7BDB80D5D
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 13:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A5C6C433F1;
        Mon,  2 Jan 2023 13:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672666816;
        bh=LzxVZX9ii0ENj0BpQitDqIiterb6Ut96yiDWtXEXR5I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ip8G2z9gvXmufBOToDK1qazK4kHvBWv68Nf0Zkx3kX+cROlas4VyrRxTgz6q3re8Q
         L+misNr/eJHLS6Y3NianWLabNCH0eTlQ5mMwa3gmfqvfpL78tx0yD1+I/yhWf4ljNi
         6/8FtBIPh7dwn/T0WQD5fo1DNsvoIa8iMV2UNikcLXjyj+AppMwPYdf2a8w1XR93zv
         PY19F6/1eNAErBgiv3VLuuyYF1z+EdZWOoQERTM+xMlCQxwEE4BgRM0xSZMWWvco9e
         TDqBxeiSugMK3Pfy5eRrQMokOkdeVn4HREbX1S/b7+3OCvsF8Gu2zF8d9k9ktxbPuI
         5BimVfV7ypU4A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 22DBDE5724C;
        Mon,  2 Jan 2023 13:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] dont intepret cls results when asked to drop
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167266681614.16415.10787367511404690308.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Jan 2023 13:40:16 +0000
References: <20230101215744.709178-1-jhs@mojatatu.com>
In-Reply-To: <20230101215744.709178-1-jhs@mojatatu.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netdev@vger.kernel.org, zengyhkyle@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun,  1 Jan 2023 16:57:42 -0500 you wrote:
> It is possible that an error in processing may occur in tcf_classify() which
> will result in res.classid being some garbage value. Example of such a code path
> is when the classifier goes into a loop due to bad policy. See patch 1/2
> for a sample splat.
> While the core code reacts correctly and asks the caller to drop the packet
> (by returning TC_ACT_SHOT) some callers first intepret the res.class as
> a pointer to memory and end up dropping the packet only after some activity with
> the pointer. There is likelihood of this resulting in an exploit. So lets fix
> all the known qdiscs that behave this way.
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: sched: atm: dont intepret cls results when asked to drop
    https://git.kernel.org/netdev/net/c/a2965c7be052
  - [net,2/2] net: sched: cbq: dont intepret cls results when asked to drop
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


