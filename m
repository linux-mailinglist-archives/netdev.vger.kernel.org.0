Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD625BECC9
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 20:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiITSaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 14:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiITSaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 14:30:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D7B22503
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 11:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6101B82C21
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 18:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7BC7DC433C1;
        Tue, 20 Sep 2022 18:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663698617;
        bh=jf40FJDOqOfkSt9GmHV2rZo02i7EfKltW6jFsc8qiEU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OnJmcjKIs9r30Oojw2cppJCf8WQ/1Kav4IIiAKLovnkWu5Oi3crfduzEe1I5eKQ3x
         HBv4jtBM/zO+7AdH1VFG2Lud6r7tYArC5l1idITdt9XZOcy7rBjrhNwKrQDpPzrNn7
         V9UPEF/o9CMrNeoehwFkNJyvLNcThwpr0oxb9wdENzwsJ0TDLtFclXhblWLH9UOuH0
         NR3Uoxixkvi8Oo4hfshWHi5P8kzTiYVoF71CThpzAXzhZHDlQ1Ayj/E2KD1n8UGGiP
         UMXZIRoBiQ7vIbcq5csNLIyJMUMGSqKfcT9UK5fMWAQ4xK7gIKQ+K4cw9j7yMEt3lf
         CKnZ9SmdUx9EQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 579D6E5250E;
        Tue, 20 Sep 2022 18:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sfc/siena: fix null pointer dereference in
 efx_hard_start_xmit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166369861735.5026.2556791311009740902.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 18:30:17 +0000
References: <20220915141958.16458-1-ihuguet@redhat.com>
In-Reply-To: <20220915141958.16458-1-ihuguet@redhat.com>
To:     =?utf-8?b?w43DsWlnbyBIdWd1ZXQgPGlodWd1ZXRAcmVkaGF0LmNvbT4=?=@ci.codeaurora.org
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, tizhao@redhat.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 15 Sep 2022 16:19:58 +0200 you wrote:
> Like in previous patch for sfc, prevent potential (but unlikely) NULL
> pointer dereference.
> 
> Fixes: 12804793b17c ("sfc: decouple TXQ type from label")
> Reported-by: Tianhao Zhao <tizhao@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net] sfc/siena: fix null pointer dereference in efx_hard_start_xmit
    https://git.kernel.org/netdev/net/c/589c6eded10c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


