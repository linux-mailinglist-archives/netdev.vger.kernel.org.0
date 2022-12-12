Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A5964AB95
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 00:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbiLLXa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 18:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbiLLXaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 18:30:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8735F1AA11
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 15:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CF92B80F93
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 23:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 00B1CC433EF;
        Mon, 12 Dec 2022 23:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670887818;
        bh=org/44E0K7bBYc3qmQc/2s/8Q7ecnB4GHSUA15aVWY4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YAS50ad+bieGiXXOkk3ss6ryRVahuwJlfJFHxyKEXl0pEW7O0aYUUKH1TwvdKucZi
         k29iwZJZ3bS/Hsgjk2zl8Kz5AjcmJh2MKy+/uTZxEsJugJHtUwghsYVaFs8KW0DRsd
         +MJBSyfdWzerocvHUAu1MQnCM6TDAoRDOgibrOtsN0/cLH40iLt3omfd03ak7AaoSH
         067/9ROCHE94x4qIseWs+ZEtgvTfsUgzJVXtBl7UPjdyd4/t4npTWqHK5S8Sjg/f15
         U1/dnJHbj6Hh+BzfkT9iVjYQAlKriuA9YDifl249B1EWT1dBe4qdI3Udg5X4SJzVFj
         BWGkEK0RYZtUA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DF3FDE21EF1;
        Mon, 12 Dec 2022 23:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] i40e: allow toggling loopback mode via
 ndo_set_features callback
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167088781791.32014.18156951828766184387.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 23:30:17 +0000
References: <20221209185553.2520088-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20221209185553.2520088-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tirthendu.sarkar@intel.com,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, alexandr.lobakin@intel.com,
        leonro@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  9 Dec 2022 10:55:53 -0800 you wrote:
> From: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> 
> Add support for NETIF_F_LOOPBACK. This feature can be set via:
> $ ethtool -K eth0 loopback <on|off>
> 
> This sets the MAC Tx->Rx loopback.
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] i40e: allow toggling loopback mode via ndo_set_features callback
    https://git.kernel.org/netdev/net-next/c/b1746fbab15a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


