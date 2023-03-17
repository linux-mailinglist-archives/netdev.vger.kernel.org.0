Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465DB6BE01F
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 05:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjCQEU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 00:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjCQEUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 00:20:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414C31B2FC;
        Thu, 16 Mar 2023 21:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2E3DB82407;
        Fri, 17 Mar 2023 04:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2E80C4339B;
        Fri, 17 Mar 2023 04:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679026817;
        bh=WkuvQ45VI59CkjPfrId68hy11ebBMAJeu21vglhHsGQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lQ7S4SHr6+1r/s/hJekQJQawWfVHToAXLFqP7G3MoOAjU5TLp4vXBqApMAOUVlx2y
         6PXFPYIxZkdcKPpghEIDjsehcLxSYAfh35HqogMzi9mILyBwHdOwGxCR9fF+1+Mc4Q
         4cMKUjgOcPlkU/oVk5blxDutUZBoGy15MzbRYIRva6vAjD2Jk9qMKnqo+Q9d77nbsS
         t8yrfNsfwHET6/BUtxVOOcyoR6LSQOW5HA0Mv0ZmOfdXE3ia3TQcM3/2Izl8pl6u1E
         X01UHtBbYncY6FZarB7t02EhVo0uGUGX/vDm84jkISPj7K9b5oyzNWiIYbDZmw84Eg
         fzkY+TAasJ8fg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 92473E21EE6;
        Fri, 17 Mar 2023 04:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qed/qed_mng_tlv: correctly zero out ->min instead of ->hour
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167902681759.31268.2829464988241573102.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 04:20:17 +0000
References: <20230315194618.579286-1-d-tatianin@yandex-team.ru>
In-Reply-To: <20230315194618.579286-1-d-tatianin@yandex-team.ru>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        sudarsana.kalluru@cavium.com, netdev@vger.kernel.org,
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

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 15 Mar 2023 22:46:18 +0300 you wrote:
> This fixes an issue where ->hour would erroneously get zeroed out
> instead of ->min because of a bad copy paste.
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE
> static analysis tool.
> 
> Fixes: f240b6882211 ("qed: Add support for processing fcoe tlv request.")
> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
> 
> [...]

Here is the summary with links:
  - qed/qed_mng_tlv: correctly zero out ->min instead of ->hour
    https://git.kernel.org/netdev/net/c/470efd68a465

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


