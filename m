Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4A964AB2E
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 00:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbiLLXKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 18:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiLLXKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 18:10:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63D264F7
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 15:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FD136126D
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 23:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B87C8C4339C;
        Mon, 12 Dec 2022 23:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670886616;
        bh=Q/pHK+g4PuUjojKaVqH7gPmJIwROXbMo7sn6wAgl6sA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NgYW4XbVvmXmnmK/yG/N8khPWUyTnbp98p+2A27uo9nMaBrEn0UNM+icK5OAvrnG6
         uIjfsLJ2Hbb7CPoUl4sLdSjP4ScK150lIWY//YWz6RrTYYVdWuadf4it/RDa3wm7EX
         Gjjw/1r5d8SwybWtBR/P1Icc5DyPKpJ4L/O6ZsXzpusQgh3/bnkFK16Wh/DjZjody2
         pjIV74JdBnWBUWMfgpIY1N4m9IDMr+rGSMOasLlZgzXeD+YguSJdhQmlGf6ncSBT9x
         NIIpMF5pPqLE4BNjsWmKmlRwrCCU1X4LKIkoz1mGvZPinw7FiOPz1VykcKCze38MXg
         FUK5FwuX7cs7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 97B79E21EF1;
        Mon, 12 Dec 2022 23:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: don't call ptp_classify_raw() if switch
 doesn't provide RX timestamping
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167088661661.21170.8949857070522055891.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 23:10:16 +0000
References: <20221209175840.390707-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221209175840.390707-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com
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

On Fri,  9 Dec 2022 19:58:40 +0200 you wrote:
> ptp_classify_raw() is not exactly cheap, since it invokes a BPF program
> for every skb in the receive path. For switches which do not provide
> ds->ops->port_rxtstamp(), running ptp_classify_raw() provides precisely
> nothing, so check for the presence of the function pointer first, since
> that is much cheaper.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: don't call ptp_classify_raw() if switch doesn't provide RX timestamping
    https://git.kernel.org/netdev/net-next/c/8f18655c49eb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


