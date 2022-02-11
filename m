Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14FFD4B30FF
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 23:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347038AbiBKWuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 17:50:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234271AbiBKWuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 17:50:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823EEBF7;
        Fri, 11 Feb 2022 14:50:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24AC4618CF;
        Fri, 11 Feb 2022 22:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7873DC340F0;
        Fri, 11 Feb 2022 22:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644619809;
        bh=zf35T+DPghs6wwbhma26ekUXPywsVqqFMKqLgQMfhrQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VyGOxsJT1Jt3Vavr8bJYvPXLrHBE8MPixJrqUb8jjFqE9630jhhR6ve/rXULCU4rV
         HLzrsERtxCRrAJuFNbLjWqY5HLruaKOq9JuQh9xyDzxmo334THpUBbnfXw/gSUHH9I
         UX0/u91KWqz9b0xHscyZh/s8tQOeFVbNLhwrKVlZp2kb0LYZwaGeG6+ObsKb+q7QwR
         a81zdeCSfGhPbFew5wtGjfETywwpKktxsLhNChMim1S9DyrrEgWnafVcfJ3ErsAyZf
         6S34hWhZgCMTZMFWgVnNkEUJjOCA6Phb0VxlqZjbzVWPAryzPGy0pBjXkN6M91IYRW
         NMcTvC5a6ddVQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6208AE6D3DE;
        Fri, 11 Feb 2022 22:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] atl1c: fix tx timeout after link flap on Mikrotik 10/25G
 NIC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164461980939.21006.13425507661552185890.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Feb 2022 22:50:09 +0000
References: <20220211065123.4187615-1-gatis@mikrotik.com>
In-Reply-To: <20220211065123.4187615-1-gatis@mikrotik.com>
To:     Gatis Peisenieks <gatis@mikrotik.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, antons@mikrotik.com,
        eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Fri, 11 Feb 2022 08:51:23 +0200 you wrote:
> If NIC had packets in tx queue at the moment link down event
> happened, it could result in tx timeout when link got back up.
> 
> Since device has more than one tx queue we need to reset them
> accordingly.
> 
> Fixes: 057f4af2b171 ("atl1c: add 4 RX/TX queue support for Mikrotik 10/25G NIC")
> Signed-off-by: Gatis Peisenieks <gatis@mikrotik.com>
> 
> [...]

Here is the summary with links:
  - [net] atl1c: fix tx timeout after link flap on Mikrotik 10/25G NIC
    https://git.kernel.org/netdev/net/c/bf8e59fd315f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


