Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C50125BD977
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiITBkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiITBkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:40:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0D1F61
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 18:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAF7262003
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 01:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 161EEC433D7;
        Tue, 20 Sep 2022 01:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663638015;
        bh=RecsctphTo6PBAdTELYhZjtaNJz0l2EiPAXC883zTC4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L+FQ8CCHXPA4aqQdc6yLukxI37ghbU6nn9ZgGKuXaZ4825+vv59FSluXdMebIVclo
         dEh2FJz6xED3x/Ai7Rf4ueOxI61oH7qTutLXJdPju3fHeZUWwvyjXtg2DkxcX5w+Bc
         knymKYxcfDEwVkIHOt3tKJ2IJtaZ8n7GDJny9cx9PapMAeg79MPDiV+DZLANiC1v8C
         xfdNuSnfCMTHrpFOc4JXZpF8VPwo5Bd1dKDrbINElxyhlPTrUzs4wnm6CeamA7dQHa
         ejLeLVon6oE5ifLPRkgaPH4lIMTRudBsuIskjPvxPch+U1Dj/tgGtj7Ljcu1ADsXsi
         AKxPDKA0QefOw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E5D8CE52536;
        Tue, 20 Sep 2022 01:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] gve: Fix GFP flags when allocing pages
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363801493.6857.630804233082198906.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:40:14 +0000
References: <20220913000901.959546-1-jeroendb@google.com>
In-Reply-To: <20220913000901.959546-1-jeroendb@google.com>
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        shailend@google.com
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

On Mon, 12 Sep 2022 17:09:01 -0700 you wrote:
> From: Shailend Chand <shailend@google.com>
> 
> Use GFP_ATOMIC when allocating pages out of the hotpath,
> continue to use GFP_KERNEL when allocating pages during setup.
> 
> GFP_KERNEL will allow blocking which allows it to succeed
> more often in a low memory enviornment but in the hotpath we do
> not want to allow the allocation to block.
> 
> [...]

Here is the summary with links:
  - [net] gve: Fix GFP flags when allocing pages
    https://git.kernel.org/netdev/net/c/8ccac4edc8da

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


