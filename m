Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB0E350C4EC
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiDVXnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 19:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbiDVXnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 19:43:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D53DE;
        Fri, 22 Apr 2022 16:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4DE4B83340;
        Fri, 22 Apr 2022 23:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5D035C385AA;
        Fri, 22 Apr 2022 23:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650670811;
        bh=x3Fm3UTmQrTrnibWxOAq1FxmE2/iaVqUmOEfG4Pw/UI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uheDa7NHIlKYgh85x5F2nnTvRZ12OX/d0KkaJInzqkIlQ+ymCEWEHPmOc7lN5tKdZ
         uzmTA7KcKBZMeVJNr4aXoVHg43kcGoLzIwfQ7+/zGKfz3R6WxobxccnCA1UkrA82e/
         oOZGmSttbrJ/upzWHJ1ymX3jv65Ro++z0rOW8OWp3UdWszmGpCMobilVKFTXEK1BAP
         XKNlOoiu6WM65eGMsNayVEV8hAt78BRBDdqgQ1tU+OXu2z5bcveQJpOd/DyKgPARBz
         PTmphJu73o3m4aJ7DXrZP6zbJFa4lsQMp4XsxkFOM3Bc8DMgUHGcS/Or12grK002oa
         qeGLhE18SaRkw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4533CE8DBDA;
        Fri, 22 Apr 2022 23:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: stmmac: fix write to sgmii_adapter_base
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165067081128.10261.6868308583766884518.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Apr 2022 23:40:11 +0000
References: <20220420152345.27415-1-dinguyen@kernel.org>
In-Reply-To: <20220420152345.27415-1-dinguyen@kernel.org>
To:     Dinh Nguyen <dinguyen@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 20 Apr 2022 10:23:45 -0500 you wrote:
> I made a mistake with the commit a6aaa0032424 ("net: ethernet: stmmac:
> fix altr_tse_pcs function when using a fixed-link"). I should have
> tested against both scenario of having a SGMII interface and one
> without.
> 
> Without the SGMII PCS TSE adpater, the sgmii_adapter_base address is
> NULL, thus a write to this address will fail.
> 
> [...]

Here is the summary with links:
  - net: ethernet: stmmac: fix write to sgmii_adapter_base
    https://git.kernel.org/netdev/net/c/5fd1fe4807f9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


