Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBCE6520A2C
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 02:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbiEJAeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 20:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233638AbiEJAeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 20:34:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0771A2A0A6F;
        Mon,  9 May 2022 17:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBC78B819FF;
        Tue, 10 May 2022 00:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7AFCAC385D3;
        Tue, 10 May 2022 00:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652142614;
        bh=VKqlSpMwsrf8kmGASDW+ONiJ1G6G8fKLEvEmo94TDJU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tDdv3+rwe99pTbx81NayFxAV9v/36UDmSr2muzVCGswqWPl04YsvEPWc6VpN5+3H/
         HpGa2rHfalgrZorUC+57W7UFX9PpW+cg6gECqR3gCiJvSJsFaUDoZ99ZrSCAMeOC3D
         crcYd4AiErK+MQKvzga8SZqW91x2FskDm+osnS1I+VUgt7YSEgG224FeW9QM3D80HA
         58zRuUxcV+Vk/LWJ6q6LT/vZn1orLUE8jqFCEjXnUdYZN0udwAbco9bPgzbK6Bq/Un
         px0zq6ijB8n4rTuNt3KJ3jk8jzpxs4qDLaJQKOkc634EscON33g7RmZIrKPJO2Ci5l
         UghSn82CTMqMQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 63591F0392B;
        Tue, 10 May 2022 00:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [NET] ROSE: Remove unused code and clean up some inconsistent
 indenting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165214261440.23610.14293636513999790192.git-patchwork-notify@kernel.org>
Date:   Tue, 10 May 2022 00:30:14 +0000
References: <20220507034207.18651-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20220507034207.18651-1-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     ralf@linux-mips.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        abaci@linux.alibaba.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  7 May 2022 11:42:07 +0800 you wrote:
> Eliminate the follow smatch warning:
> 
> net/rose/rose_route.c:1136 rose_node_show() warn: inconsistent
> indenting.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - [NET] ROSE: Remove unused code and clean up some inconsistent indenting
    https://git.kernel.org/netdev/net-next/c/eef0dc7e517e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


