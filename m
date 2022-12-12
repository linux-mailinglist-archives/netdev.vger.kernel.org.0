Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8690649BC5
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 11:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbiLLKLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 05:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbiLLKLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 05:11:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F4AE0C2;
        Mon, 12 Dec 2022 02:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14C68B80CAD;
        Mon, 12 Dec 2022 10:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C06B9C433F1;
        Mon, 12 Dec 2022 10:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670839816;
        bh=Cc9bMhlR7SPryQkhPNCEWgDk3lmdIThBVKaEhr1FEXA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t+37C5m7B2Dn7JQVv7g6gNOMh3dVATR7LrcbIAHakeIZwyO43mGD/vTX1hYi0qcWe
         QynX249MJ3aLArcfvphhCYHVOQINEPN9RdiAyxrx8ZR9U5mYROOyrDJdxSSnSMVltt
         r16/7XEC0e/19Vs6+Ry6O0/HupqZjuZBWjQwAGJbqAT/vs2avTbBKVLAVlEzbn9+Km
         Tr4F3XUzpwl+0k3PwVjMZhlDjq5HmtZiNB7Unhc5LRi5EGz3mlPv6s4WdUOFrQ5SWa
         VrKTthLzkV0Yj6s1GEfB2uXprkjDwWlktpzZCcPIfZ67KzpVo1iE756NF29swpybhU
         t+EAVeT9kY9ig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9CB3AE21EF1;
        Mon, 12 Dec 2022 10:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] AMD XGBE active/passive cable fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167083981663.16910.3529522370154591077.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 10:10:16 +0000
References: <cover.1670516545.git.thomas.lendacky@amd.com>
In-Reply-To: <cover.1670516545.git.thomas.lendacky@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Shyam-sundar.S-k@amd.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 8 Dec 2022 10:22:23 -0600 you wrote:
> This series fixes some issues related to active and passive cables and
> consists of two patches:
> 
> - Provide proper recognition of active cables.
> 
> - Only check for a minimum supported speed for passive cables.
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: amd-xgbe: Fix logic around active and passive cables
    https://git.kernel.org/netdev/net/c/4998006c73af
  - [net,2/2] net: amd-xgbe: Check only the minimum speed for active/passive cables
    https://git.kernel.org/netdev/net/c/f8ab263d4d48

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


