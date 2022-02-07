Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 730B34AC923
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 20:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238490AbiBGTDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 14:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235610AbiBGTAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 14:00:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F35A4C0401DA
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 11:00:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 696BF61367
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 19:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CDDCBC340F1;
        Mon,  7 Feb 2022 19:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644260408;
        bh=Z6Dya7giJnXxWZyYslOxItvxEcXE7jdrnq4wWGqaWdY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MmHaLNYN48EIKqD8rdTB0RwSZZCAZBwu+/ti7D0aQUKz6QbuCWinQkRIgsNZZd+1h
         FIwOwRTlSPYj2cuaQKlh4Tvn4q+GVUc+u5yBvxNOZ5uBNK71NIGjdnHb1hiaf3sGKJ
         fMuoAmppugfKJNlG/AX67koFt+0WFyIQBb9d6bXL7vnrx1HkcUexbSf0rQ/XyWtujQ
         N1GTMfnQMwX/8WKzYzs0Xf5la5cUWZXye3itnVxrKzJ+o0+Q6lIBvDaJqvtr4cCxFW
         xyYGEanHLS4YQWQJCHlRXFM5UF/AocAWhIUzpRPswKM2B01TTcL61aTkWgSCE/+opG
         jqLP1RKUPKwsw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B5BADE5D09D;
        Mon,  7 Feb 2022 19:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 iproute2] iplink: add gro_max_size attribute handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164426040873.15558.13577097213222067691.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Feb 2022 19:00:08 +0000
References: <20220203044558.3039122-1-eric.dumazet@gmail.com>
In-Reply-To: <20220203044558.3039122-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        netdev@vger.kernel.org, edumazet@google.com, lixiaoyan@google.com
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

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Wed,  2 Feb 2022 20:45:58 -0800 you wrote:
> From: Coco Li <lixiaoyan@google.com>
> 
> Add the ability to display or change the gro_max_size attribute.
> 
> ip link set dev eth1 gro_max_size 60000
> ip -d link show eth1
> 5: eth1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 9198 qdisc mq master eth0 state UP mode DEFAULT group default qlen 1000
>     link/ether bc:ae:c5:39:69:66 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 46 maxmtu 9600
>     <...> gro_max_size 60000
> 
> [...]

Here is the summary with links:
  - [v2,iproute2] iplink: add gro_max_size attribute handling
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=5d57e130362a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


