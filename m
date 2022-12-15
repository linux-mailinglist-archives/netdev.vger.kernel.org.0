Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486F464D5EE
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 05:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiLOEkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 23:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiLOEkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 23:40:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2F546665;
        Wed, 14 Dec 2022 20:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0985361CDE;
        Thu, 15 Dec 2022 04:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 50794C433F1;
        Thu, 15 Dec 2022 04:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671079216;
        bh=fk91BOR0hlyREPynU0HBDYs/f8OQIa3Fmo8nBRBcbBU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZOmAT562USicfomRWAqxpOOyklKCPmxsZTFOCoO33wWZuGkUEjgrL0QGQFM7lto0D
         WhglD24ldG+fw6yiry6GB81Gov1/azUTNeBnMOZ42NZr7yOkmKGj0ICEA3naL7ObxV
         do53FlpCl0Tl0OO2GiJvLqM3nOZGTi5GkkLHFwc75xGWyLO7hn2cwrDzYSA1V6RuQI
         JWNVvQCB8+QnkavTwCZJUakbwcTwSXBNGBORxxLi6RVTa1l4dzZffBHnr/exxvLtpS
         e0ACHg4m37gI5hMrvLU33kX7hAf7GU+rWMprtLfVcBKxBAOJecSKRTMXPgBP+8cmJW
         YYYvhseRdLFNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 36C83E4D00F;
        Thu, 15 Dec 2022 04:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: enetc: avoid buffer leaks on xdp_do_redirect()
 failure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167107921622.17884.12888619554957211520.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Dec 2022 04:40:16 +0000
References: <20221213001908.2347046-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221213001908.2347046-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, claudiu.manoil@nxp.com,
        linux-kernel@vger.kernel.org, lorenzo.bianconi@redhat.com
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

On Tue, 13 Dec 2022 02:19:08 +0200 you wrote:
> Before enetc_clean_rx_ring_xdp() calls xdp_do_redirect(), each software
> BD in the RX ring between index orig_i and i can have one of 2 refcount
> values on its page.
> 
> We are the owner of the current buffer that is being processed, so the
> refcount will be at least 1.
> 
> [...]

Here is the summary with links:
  - [net] net: enetc: avoid buffer leaks on xdp_do_redirect() failure
    https://git.kernel.org/netdev/net/c/628050ec952d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


