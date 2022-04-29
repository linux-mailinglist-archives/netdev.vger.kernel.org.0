Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305D8514086
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 04:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354130AbiD2CNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 22:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiD2CNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 22:13:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205AE4BBB9
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 19:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5508D62229
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 02:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABF58C385AF;
        Fri, 29 Apr 2022 02:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651198212;
        bh=gcUrlbc4wI6d4pW3mqLOp4FexwNc6OplCTiSGm6NfUo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BZmW61hOrSorF9k4YtF6T11mErpsgFMY0M2Vh6lBs+pYKkMzekjCUhHet1uYbpQTg
         4qrTAQ5Q0yOhNdjwNdkia8+ZLO/6SjRa3wizOCq/xnniydedCpUoVMa0Gp5FMBkVSw
         ebfdm3vCA9gb2jw9ZiTqtn23nknFIA7H8yqhrOoJFIp0O4hzW/sWaG9c3wIwt7c4LJ
         YxmmGUByAzkzSkbyLNrgR1zzI6YIuGq276tHosA9HXFgJOjulJKF0PGKIgtTyN6+qm
         LkzRIBXdfvzvXlWZ+ocBWeYNXcxVnzXBw07umYy7tDScDm3G541U1OSSJCQsnsQpNd
         jfP1/bpzZpwWw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 909A4F03876;
        Fri, 29 Apr 2022 02:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: Deduplicate interrupt disablement on PHY
 attach
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165119821258.31798.4782488207078684684.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Apr 2022 02:10:12 +0000
References: <805ccdc606bd8898d59931bd4c7c68537ed6e550.1651040826.git.lukas@wunner.de>
In-Reply-To: <805ccdc606bd8898d59931bd4c7c68537ed6e550.1651040826.git.lukas@wunner.de>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        hkallweit1@gmail.com, andrew@lunn.ch, linux@armlinux.org.uk,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 27 Apr 2022 08:30:51 +0200 you wrote:
> phy_attach_direct() first calls phy_init_hw() (which restores interrupt
> settings through ->config_intr()), then calls phy_disable_interrupts().
> 
> So if phydev->interrupts was previously set to 1, interrupts are briefly
> enabled, then disabled, which seems nonsensical.
> 
> If it was previously set to 0, interrupts are disabled twice, which is
> equally nonsensical.
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: Deduplicate interrupt disablement on PHY attach
    https://git.kernel.org/netdev/net-next/c/07caad0bb1f8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


