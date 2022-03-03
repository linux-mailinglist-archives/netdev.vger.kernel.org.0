Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9BF4CB75E
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 08:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiCCHBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 02:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiCCHA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 02:00:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9CA32067
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 23:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91073B8241F
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 07:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24438C340F6;
        Thu,  3 Mar 2022 07:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646290811;
        bh=+1E/eXCwssLdUY1k6nzkdLpPzyWwu6u8P/Zy7hNsBkc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qGvwbnat8OyO8k/CjSoY3MYWCC4NSI1AtNgc3xcBJS+E1RXrLtf8roECobnM9I8a4
         Sn+JR5yOpLcrO8ciXZtsikYt3n0uD4cT/IrzQ23zHSMRfH/LmAuZCUuglr13tdO8So
         ZR6EKcWO2B5sC3EAIZhDTTmXr3KhQGBvRDFrHR5odP8033XNrptOm/5Ef/Q9mQzP0Z
         uUg6MjRdMY/UKA2hJEOqZcf2npSeDBktf5qiSEvsYH9dJ6WVlIAhlKJMYEybe4ZqAb
         GUKD3LqP1UJc823fHXLcj7l3MQ3D/9ro4Tk1bBuNbKBcgxcEE5GQk/X9isfbNqIvUC
         305sAqW6qeEjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0B260E7BB08;
        Thu,  3 Mar 2022 07:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1] flow_dissector: Add support for HSR
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164629081104.23910.1162758197965784868.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 07:00:11 +0000
References: <20220228195856.88187-1-kurt@linutronix.de>
In-Reply-To: <20220228195856.88187-1-kurt@linutronix.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        alobakin@pm.me, vladimir.oltean@nxp.com, edumazet@google.com,
        paulb@nvidia.com, komachi.yoshiki@gmail.com, zhangkaiheb@126.com,
        claudiajkang@gmail.com, ennoerlangen@gmail.com,
        george.mccollister@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, anthony.harivel@linutronix.de
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 28 Feb 2022 20:58:56 +0100 you wrote:
> Network drivers such as igb or igc call eth_get_headlen() to determine the
> header length for their to be constructed skbs in receive path.
> 
> When running HSR on top of these drivers, it results in triggering BUG_ON() in
> skb_pull(). The reason is the skb headlen is not sufficient for HSR to work
> correctly. skb_pull() notices that.
> 
> [...]

Here is the summary with links:
  - [net-next,v1] flow_dissector: Add support for HSR
    https://git.kernel.org/netdev/net-next/c/bf08824a0f47

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


