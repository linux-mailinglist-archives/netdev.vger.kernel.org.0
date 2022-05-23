Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAF22531E16
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 23:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiEWVka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 17:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiEWVkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 17:40:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C515DD32;
        Mon, 23 May 2022 14:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7437B8169E;
        Mon, 23 May 2022 21:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 79D72C3411A;
        Mon, 23 May 2022 21:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653342013;
        bh=g7vbqwPB9Sr+7PEF+y9piN4eQKpUYLA914+AgtfLkKI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e2EKnBvACplQ4TDCPRN8pFT6kIZCkNCiLzn6F2JhPAz0IoIEYwufUeqSY7yXTrFuU
         mC3J33O1OBkUDAO4sQEq3ycucPaA5bDvxBrXKjHdUrT+LubnuLf26FWKejNdHFA/pa
         AKVsiLsJig6hHXeX9D4/dS5l83lMoRe8MfuZd6z2Ul3hzMsPcC/bVZjHE/TFDj1Sdm
         jfXz5PV5BI9jF3TixM2KXsdzPdqE8aLAZWW0cgzNvflWTs8V6BzvqvQZiPokLoj93e
         2CxiVG9I6r93HwBKj0q5YgdLkkD97aFyOnrKtQc2IbQuH9ohIzkyfdwwT+FtpFfg9o
         GVyZCjBUisdeQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 63CA3F03938;
        Mon, 23 May 2022 21:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request: bluetooth 2022-05-23
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165334201340.19887.13283028863120702469.git-patchwork-notify@kernel.org>
Date:   Mon, 23 May 2022 21:40:13 +0000
References: <20220523200349.3322806-1-luiz.dentz@gmail.com>
In-Reply-To: <20220523200349.3322806-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 23 May 2022 13:03:49 -0700 you wrote:
> The following changes since commit 8c3b8dc5cc9bf6d273ebe18b16e2d6882bcfb36d:
> 
>   net/smc: fix listen processing for SMC-Rv2 (2022-05-23 10:08:33 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-05-23
> 
> [...]

Here is the summary with links:
  - pull request: bluetooth 2022-05-23
    https://git.kernel.org/netdev/net/c/7fb0269720d7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


