Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C1859EF52
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 00:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbiHWWk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 18:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiHWWkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 18:40:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ACD95C353
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 15:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4278616F8
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 22:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2EE3CC433D7;
        Tue, 23 Aug 2022 22:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661294419;
        bh=zBQyLFvqIqwLyK7U8hOrK6XFHw4aZZD8obGaUSjdBOM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V4PIUyDuceP1K7uTvxGLwUxVJVaEWFjE3b7wPdz7doQJ5N7LBYkRgAgwQvuRd5Ily
         C8FSup8nTW2WEUWGB67Z571o7rWGtYsWomxLBxcYUwzybe2SnHc0M45+XujdUOi1pE
         VYEpQj8j6Ur+MkxmMODSh4fZySrGA0pJf8ehTSdVY3LRdQfmIjXuc9HLIWO03NOlPQ
         CPjVOdBxmatBlbMWWAtn2VkzyRsQy1JKt45qCCm3gLcm8CXLyomWpitIXuhfnjn4SV
         lO2UCK+9BEh+9alYQsvuMYzs25taJgl8Clooqk+8LgGSd3y8lzr42Zj0Md9n+jCj7i
         lbFPgJf6uZ8cQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 12E96E1CF31;
        Tue, 23 Aug 2022 22:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] bnxt_en: Bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166129441906.23609.11464663202296011034.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Aug 2022 22:40:19 +0000
References: <1661180814-19350-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1661180814-19350-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, gospo@broadcom.com
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 22 Aug 2022 11:06:50 -0400 you wrote:
> This series includes 2 fixes for regressions introduced by the XDP
> multi-buffer feature, 1 devlink reload bug fix, and 1 SRIOV resource
> accounting bug fix.
> 
> Pavan Chebbi (1):
>   bnxt_en: Use PAGE_SIZE to init buffer when multi buffer XDP is not in
>     use
> 
> [...]

Here is the summary with links:
  - [net,1/4] bnxt_en: Use PAGE_SIZE to init buffer when multi buffer XDP is not in use
    https://git.kernel.org/netdev/net/c/7dd3de7cb1d6
  - [net,2/4] bnxt_en: set missing reload flag in devlink features
    https://git.kernel.org/netdev/net/c/574b2bb9692f
  - [net,3/4] bnxt_en: fix NQ resource accounting during vf creation on 57500 chips
    https://git.kernel.org/netdev/net/c/09a89cc59ad6
  - [net,4/4] bnxt_en: fix LRO/GRO_HW features in ndo_fix_features callback
    https://git.kernel.org/netdev/net/c/366c30474172

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


