Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E2B5FE9BD
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 09:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiJNHk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 03:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbiJNHkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 03:40:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764CE647C4;
        Fri, 14 Oct 2022 00:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E130CB82261;
        Fri, 14 Oct 2022 07:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8866EC43142;
        Fri, 14 Oct 2022 07:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665733216;
        bh=E9YS9LuaxDgBFcPWjoiYDHC4CqKREUCdE1gS66oYz0w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bog607pAnjNhwSRKDzo/kleN9OYjKVzR/HYkfnjQCl00pAB+gd4Qe3Bfy4YUSIj77
         PBFIAAjeJkAUrlFfyB3kBgW1syUKnqVGE8C4BW6pXTw0H6xSKfgqVluAzCig0i82RR
         87Qjd4/vRDIA4ASMi05X5ci284whZjoDoigihPwBQdrVxpuvg5I3Vo0BPwn+WYWpTq
         sCYLl7J527le1BF+smlDYywV5xKGBtlMaam+KP04WugXjorPX9ibiLx4nhmXXkz3k8
         4fv61fbEir+eBdz6jI+oPNXxIvCv8ECGgZZzbQrKzFnw7AYoZtW8i+PGngc7krGHQT
         ExYQpMDdM9BrQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 70480E52525;
        Fri, 14 Oct 2022 07:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: macvlan: change schedule system_wq to system_unbound_wq
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166573321645.24049.4297610580110367640.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Oct 2022 07:40:16 +0000
References: <1665646872-20954-1-git-send-email-zhangxiangqian@kylinos.cn>
In-Reply-To: <1665646872-20954-1-git-send-email-zhangxiangqian@kylinos.cn>
To:     zhangxiangqian <zhangxiangqian@kylinos.cn>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 13 Oct 2022 15:41:12 +0800 you wrote:
> For FT2000+/64 devices,
> when four virtual machines share the same physical network interface,
> DROP will occur due to the single core CPU performance problem.
> 
> ip_check_defrag and macvlan_process_broadcast is on the same CPU.
> When the MACVLAN PORT increases, the CPU usage reaches more than 90%.
> bc_queue > bc_queue_len_used (default 1000), causing DROP.
> 
> [...]

Here is the summary with links:
  - net: macvlan: change schedule system_wq to system_unbound_wq
    https://git.kernel.org/netdev/net/c/3d6642eac74d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


