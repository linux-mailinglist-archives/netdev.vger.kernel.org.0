Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C82626719
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 06:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbiKLFK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 00:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233804AbiKLFKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 00:10:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E868D32BB1
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 21:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 907CEB828C8
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 05:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B864CC4314C;
        Sat, 12 Nov 2022 05:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668229817;
        bh=eOQWzMM3Vj8y4hLcSxOfie48+FOwsTWiywtGIS7Od5M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XLGDAxvVJ2LX909VWmwvYvFnBGFCcvCbqOVeVP+QTGAuK4OTkB/aqevOZV7tuPTaJ
         JY2C+XF7U8iJsBeGt4MMi4uZrBQA20MJEx3d8zeTvVE5t9CZ8l7Js5zgQyvn/Cp6XZ
         RqY3qjTvgSrlAgwUuFmGA6QArWPnEYxfF2Kued/b9c2FXMkKVu81ovOSNB9jjPeEot
         6/KXy6BdnqaD16nwE7uwt+nu1rpH0cyU0scX+SThKyktqfEu7V6yVPAqBHfmN7xCjZ
         ANxKDEy+0MO4+1H3FMFp19oaxu30HBP9LGxVbgopAVXAQzJmZ034JkjZICh7xURPaE
         NURbli09MXb2Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 65C3BE50D93;
        Sat, 12 Nov 2022 05:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: hinic: Fix error handling in hinic_module_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166822981741.20406.5355599118438547062.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Nov 2022 05:10:17 +0000
References: <20221110021642.80378-1-yuancan@huawei.com>
In-Reply-To: <20221110021642.80378-1-yuancan@huawei.com>
To:     Yuan Can <yuancan@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mqaio@linux.alibaba.com,
        shaozhengchao@huawei.com, christophe.jaillet@wanadoo.fr,
        gustavoars@kernel.org, luobin9@huawei.com, netdev@vger.kernel.org
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

On Thu, 10 Nov 2022 02:16:42 +0000 you wrote:
> A problem about hinic create debugfs failed is triggered with the
> following log given:
> 
>  [  931.419023] debugfs: Directory 'hinic' with parent '/' already present!
> 
> The reason is that hinic_module_init() returns pci_register_driver()
> directly without checking its return value, if pci_register_driver()
> failed, it returns without destroy the newly created debugfs, resulting
> the debugfs of hinic can never be created later.
> 
> [...]

Here is the summary with links:
  - [v2] net: hinic: Fix error handling in hinic_module_init()
    https://git.kernel.org/netdev/net/c/8eab9be56cc6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


