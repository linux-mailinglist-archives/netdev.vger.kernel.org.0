Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9271C66A999
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 07:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjANGVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 01:21:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjANGVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 01:21:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEB230DB
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 22:21:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E74D160B04
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 06:21:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 43E0CC433EF;
        Sat, 14 Jan 2023 06:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673677270;
        bh=4f8WjXkLIMpxprsdR4zY6Zu1am9KsIi3YuBAhU9cufs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r8rBDoik7opjxeLSia8ZypvDeh9b0UtjZzmhtOmiKCBcev5IA4s3oPG0NoLOQ57GG
         5mWZ0thgsDXclQ5z17G7gVADUWLF3OJrnchs2X+uwfk5Z1PPLSAC7BW+t5xK9yufaa
         zKVBi8lt5LdgDJMwd0AlL2zDKRsbqnRrHhLbySLstze39CQHCBRWjhoBNHfpdITTIj
         3qQXC+1YtYRVfA48ZhmVweHfd8cUWfjglPS7v4LaQVxH7l8WZaQxbqsn1gNE8SuCCV
         0RuqzJA6ZoQL3xPIpvG3iyHUjdSADVqb6ofPhf6QK9VriQ6vJ5z/nKXyoFV33QQRGk
         /fq+dHWq+jpPQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1A0D5C395C8;
        Sat, 14 Jan 2023 06:21:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] sch_htb: Avoid grafting on htb_destroy_class_offload
 when destroying htb
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167367727010.27500.2744425299070821375.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Jan 2023 06:21:10 +0000
References: <20230113005528.302625-1-rrameshbabu@nvidia.com>
In-Reply-To: <20230113005528.302625-1-rrameshbabu@nvidia.com>
To:     Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc:     netdev@vger.kernel.org, tariqt@nvidia.com, gal@nvidia.com,
        saeedm@nvidia.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuba@kernel.org, pabeni@redhat.com,
        davem@davemloft.net, edumazet@google.com, maxtram95@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 12 Jan 2023 16:55:29 -0800 you wrote:
> Peek at old qdisc and graft only when deleting a leaf class in the htb,
> rather than when deleting the htb itself. Do not peek at the qdisc of the
> netdev queue when destroying the htb. The caller may already have grafted a
> new qdisc that is not part of the htb structure being destroyed.
> 
> This fix resolves two use cases.
> 
> [...]

Here is the summary with links:
  - [net,v3] sch_htb: Avoid grafting on htb_destroy_class_offload when destroying htb
    https://git.kernel.org/netdev/net/c/a22b7388d658

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


