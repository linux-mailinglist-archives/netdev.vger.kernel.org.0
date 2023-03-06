Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415766AD078
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbjCFVbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbjCFVbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:31:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB31D86DF7
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 13:30:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 437E2B80FE3
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 21:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DEEBAC4339C;
        Mon,  6 Mar 2023 21:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678138218;
        bh=mNicOD0uJNMdo21iVNVJRTGXcKkgKZSAbT6gB+p7684=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hTcTs2sY/6lRb+v9WMCi57XbbP/ddTW3CD+8Mya1uQHiUpXPf4FtzEhp/B6Hsb5fk
         1MMN7iS3WzaouULT3mPw1oUr3eZ5ikBD8HgBj7yuGSO38kD2rOB41Brb3QV0Zyv7HQ
         2ysYaQqt1z23ZQ2HINwqA4VNoAtQ10yKcyOXBlqvR3KYS6M1vGn9/yin6OkyPh5RoB
         3Vlgp9JgcAT3OMWANbUWGivMd0eMeVLPewEezaLwKUga2u9DymZ0PxdYYOx6AVupDV
         OluvzIqajwaEupxx2NYMcnZyV5WQUygXv3mHlxGp97G+4D4VCNYTHacBwjKTJ63Kz2
         qd1oUGnptSeuA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B745DE55B15;
        Mon,  6 Mar 2023 21:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: stmmac: add to set device wake up flag when
 stmmac init phy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167813821874.7576.8952772223077508630.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Mar 2023 21:30:18 +0000
References: <20230302062143.181285-1-clementwei90@163.com>
In-Reply-To: <20230302062143.181285-1-clementwei90@163.com>
To:     Rongguang Wei <clementwei90@163.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        xiaolinkui@kylinos.cn, netdev@vger.kernel.org,
        weirongguang@kylinos.cn
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu,  2 Mar 2023 14:21:43 +0800 you wrote:
> From: Rongguang Wei <weirongguang@kylinos.cn>
> 
> When MAC is not support PMT, driver will check PHY's WoL capability
> and set device wakeup capability in stmmac_init_phy(). We can enable
> the WoL through ethtool, the driver would enable the device wake up
> flag. Now the device_may_wakeup() return true.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: stmmac: add to set device wake up flag when stmmac init phy
    https://git.kernel.org/netdev/net/c/a9334b702a03

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


