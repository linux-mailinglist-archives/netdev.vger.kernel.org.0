Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C56655A764
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 08:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbiFYGAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 02:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiFYGAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 02:00:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D722250E
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 23:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9ABDB825EB
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 06:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 674A9C341C8;
        Sat, 25 Jun 2022 06:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656136814;
        bh=9IfhjINmCnVPe4B5oMS4WGEKHRHCo+dPUB51aGxRTSA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d/RWU6M768Fyri9TZmRu05+v+qcDxFzdD5MiNipdBBGl0B/kqN1VBtRd+OhgOcCJ8
         neIhG8hqcfhdV8z4lkkY6NuSxOyc0Anq3ixu7SWo8cfQyTwJdjivuTo/fdKBzSN6YY
         L26icfYw/1WCdfEVgdhCH7kRnWeipP/8zGIl2m8raV/SH2AZU00XUW896WjB56rXSG
         sogJkc8F9hsvNUP/tmT4FzZ2oeer2zeyP1JIucX2Q5gsTeb2O5n8pMhUcG9unsfY0O
         GYwukxP3mYsyOGeMOEqXET799lyb8FNZs2Zc/WMFtRxMG/a/44CaRPvEMDH0G4kU40
         VmWzrDgtpYqcw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 496E1E85C6D;
        Sat, 25 Jun 2022 06:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] raw: fix a typo in raw_icmp_error()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165613681429.10048.14710476185860491279.git-patchwork-notify@kernel.org>
Date:   Sat, 25 Jun 2022 06:00:14 +0000
References: <20220623193540.2851799-1-edumazet@google.com>
In-Reply-To: <20220623193540.2851799-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        jsperbeck@google.com
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

On Thu, 23 Jun 2022 19:35:40 +0000 you wrote:
> I accidentally broke IPv4 traceroute, by swaping iph->saddr and iph->daddr.
> 
> Probably because raw_icmp_error() and raw_v4_input()
> use different order for iph->saddr and iph->daddr.
> 
> Fixes: ba44f8182ec2 ("raw: use more conventional iterators")
> Reported-by: John Sperbeck<jsperbeck@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [net-next] raw: fix a typo in raw_icmp_error()
    https://git.kernel.org/netdev/net-next/c/97a4d46b1516

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


