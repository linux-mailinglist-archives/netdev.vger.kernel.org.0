Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99292627C2C
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 12:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236236AbiKNLZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 06:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236253AbiKNLYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 06:24:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBDC27CD7;
        Mon, 14 Nov 2022 03:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD903B80DEF;
        Mon, 14 Nov 2022 11:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6005FC433D7;
        Mon, 14 Nov 2022 11:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668424816;
        bh=Tv9+y0QN1QJQhRcbIocbFWCyTV78eEv+sOavReGHnFk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Jdr6DDJdft9Zl++encyFRZO30xW7kOe3ux+Eu9NVxyNS/wTB7b9xo/qUJ8igj4v1c
         cwn/1TcsxotgrJ3Mb/3NuA7h9iO0/XLQGOUuEsRP+K/q4GwKPGEmBuVTgQJSwitMe7
         YNFHmm4T3JLo8GBqoo5IMx5vyj3tsA/HVjq+X0kMVWSxV9QFbYiDH/VrHKyVhQebcn
         Y6WdzjQIvRGF3PGtZk13pC81K5VrMSKVaVwwRZqK1Fq3J4nfLO7uX9QRZAbFN71vDL
         c1XmXqJR4HN5Mqc1eCfeMQMKP4ZViVriAE88MrSZU8NP7WXQpO8vfCX0QVTCZpIf8u
         WnjJBF+8pQbQg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F85DE4D021;
        Mon, 14 Nov 2022 11:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] octeon_ep: fix several bugs in exception paths
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166842481625.26213.9696505508842840262.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Nov 2022 11:20:16 +0000
References: <cover.1668150074.git.william.xuanziyang@huawei.com>
In-Reply-To: <cover.1668150074.git.william.xuanziyang@huawei.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     vburru@marvell.com, aayarekar@marvell.com, sburla@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Fri, 11 Nov 2022 15:08:01 +0800 you wrote:
> Find several obvious bugs during code review in exception paths. Provide
> this patchset to fix them. Not tested, just compiled.
> 
> Ziyang Xuan (4):
>   octeon_ep: delete unnecessary napi rollback under set_queues_err in
>     octep_open()
>   octeon_ep: ensure octep_get_link_status() successfully before
>     octep_link_up()
>   octeon_ep: fix potential memory leak in octep_device_setup()
>   octeon_ep: ensure get mac address successfully before
>     eth_hw_addr_set()
> 
> [...]

Here is the summary with links:
  - [net,1/4] octeon_ep: delete unnecessary napi rollback under set_queues_err in octep_open()
    https://git.kernel.org/netdev/net/c/298b83e180d5
  - [net,2/4] octeon_ep: ensure octep_get_link_status() successfully before octep_link_up()
    https://git.kernel.org/netdev/net/c/9d3ff7131877
  - [net,3/4] octeon_ep: fix potential memory leak in octep_device_setup()
    https://git.kernel.org/netdev/net/c/e4041be97b15
  - [net,4/4] octeon_ep: ensure get mac address successfully before eth_hw_addr_set()
    https://git.kernel.org/netdev/net/c/848ffce2f0c9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


