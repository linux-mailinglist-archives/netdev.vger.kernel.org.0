Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBCD94ABEFF
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 14:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447882AbiBGNCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 08:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387646AbiBGLl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 06:41:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38379C03CA41
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 03:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AAB8B811BD
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 11:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1792C340F1;
        Mon,  7 Feb 2022 11:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644234010;
        bh=xvZD4FlCXL0u5QgPb//pjRw1qEsILyl23hEsjijrlbE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b1/RldIR0CN6YAvH+ZIqUR5FhXmn1jQt0xyr67C2CI9Qngo79/W0eA1jIhO0WRZVK
         l8RhbgETFi2gBZf/ASZQviz7Y3tRqFdJ3JpJSaz5KUhchrriWMqUfV4vYssJHi1qMU
         P9OwziBzoUCm49znXEgcvQ5XGsnR8lhGSWV7mP5vdrZiFMQmiQNQS4sghnKnC0R9y9
         SrK66fjor4v6xs1EO6rMtzGMxpPdbxBpQpdJaxpQAmNnlcsOIr/furwPIzZX917J4H
         sng55+0fDofo9RIwlJLw0b2trmQFOH6uhNQ9GOVR4otk86TcJQ0c2Kr9bkJRiNygzn
         o5q4MqEZHQhog==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AC144E5D09D;
        Mon,  7 Feb 2022 11:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ref_tracker: remove filter_irq_stacks() call
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164423401070.10014.12409721214852135910.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Feb 2022 11:40:10 +0000
References: <20220205172711.3775171-1-eric.dumazet@gmail.com>
In-Reply-To: <20220205172711.3775171-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, elver@google.com, glider@google.com,
        dvyukov@google.com
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  5 Feb 2022 09:27:11 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> After commit e94006608949 ("lib/stackdepot: always do filter_irq_stacks()
> in stack_depot_save()") it became unnecessary to filter the stack
> before calling stack_depot_save().
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Marco Elver <elver@google.com>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> 
> [...]

Here is the summary with links:
  - [net-next] ref_tracker: remove filter_irq_stacks() call
    https://git.kernel.org/netdev/net-next/c/c2d1e3df4af5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


