Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88F05F0AE4
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 13:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiI3Lp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 07:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiI3Los (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 07:44:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F679E0DE;
        Fri, 30 Sep 2022 04:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4FB2ECE2522;
        Fri, 30 Sep 2022 11:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9176DC433D7;
        Fri, 30 Sep 2022 11:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664538016;
        bh=JlUcLWa3IdWBwTiLWz49DomAY7fXWAkIw/g48+YHdIM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O9T9yMihbTz06XfPjjH5n2H+NrWakQyAO6fnEP12fBHVgRk3vjvv6JCUxZkDfu796
         7htozPOFboUMKRuYNmNluDnuT0YYCAN6SlwP+AlieK5DniiwACC8nn7E+UEfKSXlmF
         kNu4ioLpchqyxZhqKY2N13h/n8NMyf46IIx08YgH6zpaDi1ktdbg4/l3lvQk93v+ev
         u/F05L+E46ojI0I+eIigu6V7MHcWIH707t2Hgawfwo2yar68z9MZujhYfpM+ETAM04
         hKMMDraxgn1c/XwbVdF9YFzxL8S2Eiw47xCqq36oRxqJFBnmqKIp8qYOWmOFTk6azy
         Mgis1hR0hWDXw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 700BCE49FA5;
        Fri, 30 Sep 2022 11:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V4] mISDN: fix use-after-free bugs in l1oip timer handlers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166453801645.4225.5293167846550625477.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 11:40:16 +0000
References: <20220928133938.86143-1-duoming@zju.edu.cn>
In-Reply-To: <20220928133938.86143-1-duoming@zju.edu.cn>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        isdn@linux-pingi.de, kuba@kernel.org, leon@kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 28 Sep 2022 21:39:38 +0800 you wrote:
> The l1oip_cleanup() traverses the l1oip_ilist and calls
> release_card() to cleanup module and stack. However,
> release_card() calls del_timer() to delete the timers
> such as keep_tl and timeout_tl. If the timer handler is
> running, the del_timer() will not stop it and result in
> UAF bugs. One of the processes is shown below:
> 
> [...]

Here is the summary with links:
  - [V4] mISDN: fix use-after-free bugs in l1oip timer handlers
    https://git.kernel.org/netdev/net/c/2568a7e0832e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


