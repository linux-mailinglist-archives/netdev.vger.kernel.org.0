Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F1C4FBA94
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 13:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244790AbiDKLNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 07:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346044AbiDKLNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 07:13:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AB310F0;
        Mon, 11 Apr 2022 04:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 112296158C;
        Mon, 11 Apr 2022 11:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60EE0C385A4;
        Mon, 11 Apr 2022 11:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649675412;
        bh=NdzH7Z5bNggGZpiDfqQ3KFHAwQuSlUL0BEoDL24vQro=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bAwETcJYcGPDOlwL5zJbDY6X8QV7UnKxUY8Zpm2UKf+D36f7VvSctTpkWeyhg9/Y3
         o8/yiIDKioALIR571GiByMulK0w3MIqSBu4mdELqnIs/8rL5+xQgK7UEsZlHCUR2pl
         8656Q4DoTnHd3SvMbkzdRVeVNxOLmKHn6Hm1iLxQOepRfdAjVMz726jPr3/IRyd7P6
         u26gW5+wnw1TQDmlrCbGrkcvBfoKbaSzncBnYZRhtG+eNkB0u7ktPcQe2PDBbTDhZw
         L08IjhJsYdg6IInKtGt8yK92jDcgu7RrvA/LnoxY3hcMbK81dmc+7BUJHSP3Pi6mUX
         7NNn81/oTOU3w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 457E2E7399B;
        Mon, 11 Apr 2022 11:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dpaa_eth: Fix missing of_node_put in dpaa_get_ts_info()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164967541228.25321.11252715015759028756.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Apr 2022 11:10:12 +0000
References: <20220408094941.2494893-1-lv.ruyi@zte.com.cn>
In-Reply-To: <20220408094941.2494893-1-lv.ruyi@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lv.ruyi@zte.com.cn, zealci@zte.com.cn
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
by David S. Miller <davem@davemloft.net>:

On Fri,  8 Apr 2022 09:49:41 +0000 you wrote:
> From: Lv Ruyi <lv.ruyi@zte.com.cn>
> 
> Both of of_get_parent() and of_parse_phandle() return node pointer with
> refcount incremented, use of_node_put() on it to decrease refcount
> when done.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - dpaa_eth: Fix missing of_node_put in dpaa_get_ts_info()
    https://git.kernel.org/netdev/net/c/1a7eb80d170c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


