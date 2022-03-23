Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 211154E5802
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 19:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343902AbiCWSBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 14:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235384AbiCWSBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 14:01:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585F837AB5;
        Wed, 23 Mar 2022 11:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1ACC8B82005;
        Wed, 23 Mar 2022 18:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA5C7C36AE2;
        Wed, 23 Mar 2022 18:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648058413;
        bh=I+InwoXQcf+sONGnxw2zxvs+HMUOtaWfmkHUkjj3LAo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SysejPG8+usZ2W5ix2yNbvGZXvMc0x9e/E1ZEr435V7kfXoAkm4SOSSuxJ/PW5n4H
         1byoVXJ5sIke6dXFR4du6AFbWq0rkYpHe7MCFw4d+uGd4pLkiY4PTFPYTI86KSdHYs
         26XCx4NjBXuCxSB52oaFgzJYmCieLccqijCdvQ4fc3ZwR0+oRM/grv6p869p6QQYr+
         sW6N88cdj1vq0X/STHwkBaFrThJrBEF0Wsi+z58LaV23r9+A0N/Ci67ScmR9/Q/jIn
         G0YWIGda+b/4R+nR2UfhjgB7fIsFV8UpjDg9EitI4tHy50rCfW2TdqIDZWvli5Fwvm
         yPfBp6KS+ootg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 94F5FE6D402;
        Wed, 23 Mar 2022 18:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] drivers: ethernet: cpsw: fix panic when intrrupt
 coaleceing is set via ethtool
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164805841360.28459.4057344335857009664.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Mar 2022 18:00:13 +0000
References: <20220323084725.65864-1-jan.sondhauss@wago.com>
In-Reply-To: <20220323084725.65864-1-jan.sondhauss@wago.com>
To:     =?utf-8?b?U29uZGhhdcOfLCBKYW4gPGphbi5zb25kaGF1c3NAd2Fnby5jb20+?=@ci.codeaurora.org
Cc:     grygorii.strashko@ti.com, vigneshr@ti.com, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, Jan.Sondhauss@wago.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 23 Mar 2022 08:47:33 +0000 you wrote:
> cpsw_ethtool_begin directly returns the result of pm_runtime_get_sync
> when successful.
> pm_runtime_get_sync returns -error code on failure and 0 on successful
> resume but also 1 when the device is already active. So the common case
> for cpsw_ethtool_begin is to return 1. That leads to inconsistent calls
> to pm_runtime_put in the call-chain so that pm_runtime_put is called
> one too many times and as result leaving the cpsw dev behind suspended.
> 
> [...]

Here is the summary with links:
  - [v2] drivers: ethernet: cpsw: fix panic when intrrupt coaleceing is set via ethtool
    https://git.kernel.org/netdev/net-next/c/2844e2434385

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


