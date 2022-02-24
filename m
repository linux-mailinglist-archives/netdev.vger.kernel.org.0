Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4D54C33D9
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 18:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbiBXRko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 12:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbiBXRkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 12:40:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3896A1C2F4F
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 09:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D339AB82811
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 17:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 70519C340EC;
        Thu, 24 Feb 2022 17:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645724410;
        bh=la+SDmclhSCumBwNdWuAskMOlc37WAkunCPgYtqLh9s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g68sFXtEdrq1SPHcr4Za4ma2JB2jtwTHMkx5ioM/wbSTqvujDB9kxZdam4+nPlbpz
         UkobBrZyYjPDVqqdJN/EAkyDU3iHVsu+B7i7HCg/8Vn82GeRmtyEgriYU50Nl/636y
         pjczqlLDsJLFCzGVn9Y24gNTyYUUEwK06YOjG7SyfxsNqhHz6FLhBao3k025TZQdt9
         piQbhX4deEmwTuX1/gZ9MyREtBoQ1NQUBWG12YnwOQfUZfsH/jU1+jPGEqa+O0RJ/4
         8v7avf8pXAM+5JbUn4Ckgnl2dVH8UbfrxtGag5mNJbBZoX+scgaCioFZbqSiRz9amf
         th2YC0U2OvA+Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 523BAEAC09C;
        Thu, 24 Feb 2022 17:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ping: remove pr_err from ping_lookup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164572441033.16635.8987720104087310139.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Feb 2022 17:40:10 +0000
References: <1ef3f2fcd31bd681a193b1fcf235eee1603819bd.1645674068.git.lucien.xin@gmail.com>
In-Reply-To: <1ef3f2fcd31bd681a193b1fcf235eee1603819bd.1645674068.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 23 Feb 2022 22:41:08 -0500 you wrote:
> As Jakub noticed, prints should be avoided on the datapath.
> Also, as packets would never come to the else branch in
> ping_lookup(), remove pr_err() from ping_lookup().
> 
> Fixes: 35a79e64de29 ("ping: fix the dif and sdif check in ping_lookup")
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] ping: remove pr_err from ping_lookup
    https://git.kernel.org/netdev/net/c/cd33bdcbead8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


