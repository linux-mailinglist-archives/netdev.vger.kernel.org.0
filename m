Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D104E3C31
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 11:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbiCVKLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 06:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbiCVKLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 06:11:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712BB27CCE
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 03:10:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BEBC60AEA
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 10:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A33AC340F2;
        Tue, 22 Mar 2022 10:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647943810;
        bh=E9R6Zic3dR70tnHecmUnNwlFaNjPNpggOFpkucdWKjk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fi7ZhBEc7uZwhKJGbgEmpcjJGhlTz/1DTjRKIEPI1JivF8bpfs+vVYeHgaJFXZt8f
         uY6o0ApgO/PCW6m/SHE7DKH8adit/qDzRPTaHzojwjzOrD86Qi4oDdbVAnuWdlXO2e
         n0MSYxiyOvtxFlX2jN+d8fXMUqUFJyJolGn/p33Rdk5a8pjTzX9E8aarZgSEiau14t
         Dm0kFBIVTOUUKkNyF6HMC3GYU+Gpx9eMBX1b7v+3mVLWLGri5EUghZJ1BHnLdwLLfA
         Kj70sverB0VDhJtjBuECHLlCJj5SBaay+UXsnB1GBAXZ1S4upeqslKNST+CMdYrxki
         es7w03lj2Bhfg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 44428EAC09C;
        Tue, 22 Mar 2022 10:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net] tipc: fix the timer expires after interval 100ms
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164794381027.8007.5785450571155494676.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Mar 2022 10:10:10 +0000
References: <20220321042229.314288-1-hoang.h.le@dektech.com.au>
In-Reply-To: <20220321042229.314288-1-hoang.h.le@dektech.com.au>
To:     Hoang Le <hoang.h.le@dektech.com.au>
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        tung.q.nguyen@dektech.com.au, tuong.t.lien@dektech.com.au,
        duc.x.doan@dektech.com.au, kuba@kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 21 Mar 2022 11:22:29 +0700 you wrote:
> In the timer callback function tipc_sk_timeout(), we're trying to
> reschedule another timeout to retransmit a setup request if destination
> link is congested. But we use the incorrect timeout value
> (msecs_to_jiffies(100)) instead of (jiffies + msecs_to_jiffies(100)),
> so that the timer expires immediately, it's irrelevant for original
> description.
> 
> [...]

Here is the summary with links:
  - [net] tipc: fix the timer expires after interval 100ms
    https://git.kernel.org/netdev/net/c/6a7d8cff4a33

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


