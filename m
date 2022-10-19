Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C20566047B6
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbiJSNoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233339AbiJSNoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:44:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D872EF22;
        Wed, 19 Oct 2022 06:30:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 214F6618C1;
        Wed, 19 Oct 2022 13:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 77907C43140;
        Wed, 19 Oct 2022 13:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666186216;
        bh=7W+MMJb+mdEg7giA6Vsig1IokMXA7l0hDQSXJrxDq50=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=em+dDn++1diJixL0kyQZh6KsfVdNtU0EJf28SsYVxRRlN2EfMlptaT3MnK0WrtdBk
         K5KN82e/0whNG3HSLm2YaKbeO+BXT1XnaPdJv8ahF2kxCIFyWrZkXpt8OrklSJPdgX
         73adkEv8zUIRLJbI18cjXZVfmxUWxoMJOLY6laWYmSeVCxasRtlhUS/PV8cw4c+alP
         7XdDGMTm4FahEi+68b94aGCY1ERuoir2pfjIkMHSZ7KUOd/30NvdMtJ4/OAywpFFvd
         o2Kv/DSuJ6nk0gka1b8C4fA+wVtzgf+mLV46nlY6sC7HQHp/VdqTrZudaxXr+fe/4e
         NXQBmDPdbUEiA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 58E6DE4D007;
        Wed, 19 Oct 2022 13:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] net: ethernet: adi: adin1110: Fix SPI transfers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166618621636.2082.14752525949133267319.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Oct 2022 13:30:16 +0000
References: <20221017163703.190018-1-alexandru.tachici@analog.com>
In-Reply-To: <20221017163703.190018-1-alexandru.tachici@analog.com>
To:     Alexandru Tachici <alexandru.tachici@analog.com>
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 17 Oct 2022 19:37:03 +0300 you wrote:
> No need to use more than one SPI transfer for reads.
> Use only one from now as ADIN1110/2111 does not tolerate
> CS changes during reads.
> 
> The BCM2711/2708 SPI controllers worked fine, but the NXP
> IMX8MM could not keep CS lowered during SPI bursts.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: adi: adin1110: Fix SPI transfers
    https://git.kernel.org/netdev/net-next/c/a526a3cc9c8d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


