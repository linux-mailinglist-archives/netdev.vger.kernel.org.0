Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94472584B1D
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 07:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234360AbiG2FaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 01:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234369AbiG2FaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 01:30:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99EE3DEE7
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 22:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F4BBB826F2
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 05:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B17FAC433B5;
        Fri, 29 Jul 2022 05:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659072613;
        bh=QTA4WG3oXO1CEulm071lw1PITcjFT1aEknDBjGv85S4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ub+IMlVExQ+WA3k/coih0OJZupU2/g4u8qwWXGnFWkSxVt+CSNBjb+v3u7KvJwGgw
         R7cbAIrRnsVttuTKPE0Gk6aulrUz2Z539T36KJyhg/smIK+7e1XNF1MB7zI+HNUFz5
         bYU9awVSLej+F6muEjWc19sDayLkzTl2K45IBI2EKtnGHbOWwqadabNLkBAgt/Ad8O
         AUMpzXji2N9vVLt2WF6FHSYhQ1lbk8quPOGUZ59b+v1cVWXpzInfHpifjng6ey5zux
         pMFFg9SVQh2J0pWmAE0nQQeqMJplZwY4ji27MLAeT2l1VQ2ssRWq088Rcg/UJVE6xU
         gj+N+jmNk69Gw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 954F8C43143;
        Fri, 29 Jul 2022 05:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ax25: fix incorrect dev_tracker usage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165907261360.17632.6329795270179343317.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jul 2022 05:30:13 +0000
References: <20220728051821.3160118-1-eric.dumazet@gmail.com>
In-Reply-To: <20220728051821.3160118-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com, f6bvp@free.fr,
        duoming@zju.edu.cn
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 27 Jul 2022 22:18:21 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> While investigating a separate rose issue [1], and enabling
> CONFIG_NET_DEV_REFCNT_TRACKER=y, Bernard reported an orthogonal ax25 issue [2]
> 
> An ax25_dev can be used by one (or many) struct ax25_cb.
> We thus need different dev_tracker, one per struct ax25_cb.
> 
> [...]

Here is the summary with links:
  - [net] ax25: fix incorrect dev_tracker usage
    https://git.kernel.org/netdev/net/c/d7c4c9e075f8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


