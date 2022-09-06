Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2AA5AE400
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 11:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbiIFJUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 05:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbiIFJUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 05:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB562C66F
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 02:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7C136146C
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 09:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0EF78C433D7;
        Tue,  6 Sep 2022 09:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662456014;
        bh=O/ap3t702vznGlJJlm6WTu0EqYrj3mwuCkh5ee3sobc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r2XJAz9k33aSrYF3KdDMYtPydRpLgFBzAwH/bLOn1drtb5iUwnbRuJ2mdAqMQayXL
         tScXZ/a2umY5msZ5BoKm8Ph24/xzfLTpIrVHw3ut4hD3KMQLFbntwzh1/hkAUFaEPA
         eVE5Is9EMXMbrOsL5qOMZB9E4B0jWg+7tuJP194ZzkfIaAId9soIia7bsy7by81qHg
         Whfdc+DQqvmqeIKwQoHrKd3YR8UAShQ7cpgjYgJtmak3Ru702rXtRM7U4hGzorai7X
         I8YAIwmFto5enkMqGiTGCn4cvAccxI8dXDI+omwNhkRoK/10/LyE2TmnkK0VFARj6m
         lJ92CG7mnneGA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E9376C73FED;
        Tue,  6 Sep 2022 09:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: fix early ETIMEDOUT after spurious non-SACK RTO
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166245601395.18098.13368958295506156947.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Sep 2022 09:20:13 +0000
References: <20220903121023.866900-1-ncardwell.kernel@gmail.com>
In-Reply-To: <20220903121023.866900-1-ncardwell.kernel@gmail.com>
To:     Neal Cardwell <ncardwell.kernel@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ncardwell@google.com, nagaraj.p.arankal@hpe.com, ycheng@google.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Sat,  3 Sep 2022 08:10:23 -0400 you wrote:
> From: Neal Cardwell <ncardwell@google.com>
> 
> Fix a bug reported and analyzed by Nagaraj Arankal, where the handling
> of a spurious non-SACK RTO could cause a connection to fail to clear
> retrans_stamp, causing a later RTO to very prematurely time out the
> connection with ETIMEDOUT.
> 
> [...]

Here is the summary with links:
  - [net] tcp: fix early ETIMEDOUT after spurious non-SACK RTO
    https://git.kernel.org/netdev/net/c/686dc2db2a0f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


