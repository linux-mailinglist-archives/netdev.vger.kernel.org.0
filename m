Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F02F65B2C2
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 14:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjABNkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 08:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjABNkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 08:40:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D6DCC2
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 05:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C96C860FBC
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 13:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 33971C433EF;
        Mon,  2 Jan 2023 13:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672666816;
        bh=9pT+Z+qsOA+23Ff06CIYCVT0OrLPhU87joyTS71q1UM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pO0vxoq44iUXKQAwqJmyo4INXAJ0AGQmP+uSaQEI3IUO/QaXNOqvj5ZcacTMFdCrN
         e+Qp7ljtlYz8OZLF/TnyevIHPptnAurHjNe+bHB3nIA+8Ue1oddAzSR8KefS+3iLo3
         e+LdFajcc37+AOzVQDWTBE4ruFGbLka2EeJsVaAdnMThjrLC0ryStMgk/z9+9rTg9A
         Q6Jug5ODnHmmlaY9qtj++gjlpsvgAA8GJ6qKb+ntOUbOfleH10ri3vONqiWiQ4fpYI
         Tv+QyXTQx1xWZgcyC/i6MZ1Abvo1UTMffYH0ZDRD20bRlYF9/grKmCZdOnh6cRW+km
         4xrN00sJSD4Cg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1588CE5724D;
        Mon,  2 Jan 2023 13:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sched: htb: fix htb_classify() kernel-doc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167266681608.16415.4382115904031020341.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Jan 2023 13:40:16 +0000
References: <20230102071737.24378-1-rdunlap@infradead.org>
In-Reply-To: <20230102071737.24378-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
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

On Sun,  1 Jan 2023 23:17:37 -0800 you wrote:
> Fix W=1 kernel-doc warning:
> 
> net/sched/sch_htb.c:214: warning: expecting prototype for htb_classify(). Prototype was for HTB_DIRECT() instead
> 
> by moving the HTB_DIRECT() macro above the function.
> Add kernel-doc notation for function parameters as well.
> 
> [...]

Here is the summary with links:
  - [net-next] net: sched: htb: fix htb_classify() kernel-doc
    https://git.kernel.org/netdev/net/c/43d253781f63

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


