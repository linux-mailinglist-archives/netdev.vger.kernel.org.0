Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8C1642617
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbiLEJuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiLEJuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:50:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A77F59F;
        Mon,  5 Dec 2022 01:50:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64BB460FF0;
        Mon,  5 Dec 2022 09:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3CD5C433C1;
        Mon,  5 Dec 2022 09:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670233815;
        bh=ubvaaB4pk7dW3yKhtx+/4OXxdTTndIk3pSKSzPTdX7E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Pi2IVjSk0ssn8feM6q2TaEgwOjEhUM4myvuI1w29g7oYy7p9Nlj6jqI5htmAh0/pv
         86/MT3OZ3HJj55nQMaap+J1vATgwBtO0HK0J2b2c1ImLvv3aNu1ehTmFR5WzGFaquK
         iKA38WMy+cTFWM6iGkLTs2w/e4onqIs6oydXJ434mA0BxG8an+Qqbta2B95GHQeE/x
         kKbaErJRq3PPFXrtd2kIRqdfzhfo4LYmCZ0ru/QbfDUEtb2Alsmed9C9CZeQugKzG+
         1XKPGuDoc+bodxbMTMDwEvsFEgWvS9qhVS3A5q/Nqv0rpmBRnDoG6YsWI6AeYjgzyU
         /YXyaLqMVYNtA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A2760C395EA;
        Mon,  5 Dec 2022 09:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] net: encx24j600: Add parentheses to fix precedence
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167023381566.8030.441453693172726774.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Dec 2022 09:50:15 +0000
References: <20221201173408.26954-1-goncharenko.vp@ispras.ru>
In-Reply-To: <20221201173408.26954-1-goncharenko.vp@ispras.ru>
To:     Valentina Goncharenko <goncharenko.vp@ispras.ru>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jringle@gridpoint.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
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

On Thu,  1 Dec 2022 20:34:07 +0300 you wrote:
> In functions regmap_encx24j600_phy_reg_read() and
> regmap_encx24j600_phy_reg_write() in the conditions of the waiting
> cycles for filling the variable 'ret' it is necessary to add parentheses
> to prevent wrong assignment due to logical operations precedence.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> [...]

Here is the summary with links:
  - [1/2] net: encx24j600: Add parentheses to fix precedence
    https://git.kernel.org/netdev/net/c/167b3f2dcc62
  - [2/2] net: encx24j600: Fix invalid logic in reading of MISTAT register
    https://git.kernel.org/netdev/net/c/25f427ac7b8d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


