Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9F751790A
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 23:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387624AbiEBVXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 17:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387603AbiEBVXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 17:23:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E808A1AE;
        Mon,  2 May 2022 14:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2BF7B819F6;
        Mon,  2 May 2022 21:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57EB0C385A4;
        Mon,  2 May 2022 21:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651526411;
        bh=uLcybJcnNqI+j6jIrxeeIUMhxnhYzGU+2Dt86UpKrzM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sj6W1PWf9Gt4mLhi3rCR8bKAXR2IvFbcXIHi4Z/WRFxS29M5gfLrLQ2H8Gb9cZpSo
         vfbyETCmuzWQ9XOwl11yAG2LfkzSfRyZvXwl+wg2QwQcTQRMvXbqTjfo9LCeMYIzxf
         Nt1P8iQ8w6hmk9HPueO1fCQ3fB7clX8fH6CMkq73rglut7fI/iYx5RynoUXfhHacyp
         D/7vKqg1r+gk+TBnGXJBFCrlzXL3wFyapHNBMXI5zFUaVfkBNfMGDNCUo7BgWUzlaz
         eZBGmF4EmUiqXFALNgEBkar85bhxxgWYsAS7RDEKF6+z4rTHMWzHfHT+w0nFyIBrUS
         FbL5hbVAzN+Xw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3D4EAE6D402;
        Mon,  2 May 2022 21:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net-next 0/2] ocelot stats improvement
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165152641124.9389.11966311067254454723.git-patchwork-notify@kernel.org>
Date:   Mon, 02 May 2022 21:20:11 +0000
References: <20220430232327.4091825-1-colin.foster@in-advantage.com>
In-Reply-To: <20220430232327.4091825-1-colin.foster@in-advantage.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, UNGLinuxDriver@microchip.com,
        alexandre.belloni@bootlin.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 30 Apr 2022 16:23:25 -0700 you wrote:
> A couple of pick-ups after f187bfa6f35 ("net: ethernet: ocelot: remove
> the need for num_stats initializer") - one addresses a warning
> patchwork flagged about operator precedence when using macro arguments.
> The other is a reduction of unnecessary memory allocation.
> 
> Colin Foster (2):
>   net: mscc: ocelot: remove unnecessary variable
>   net: mscc: ocelot: add missed parentheses around macro argument
> 
> [...]

Here is the summary with links:
  - [v1,net-next,1/2] net: mscc: ocelot: remove unnecessary variable
    https://git.kernel.org/netdev/net-next/c/05e4ed1ce585
  - [v1,net-next,2/2] net: mscc: ocelot: add missed parentheses around macro argument
    https://git.kernel.org/netdev/net-next/c/8c5b07da9bc8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


