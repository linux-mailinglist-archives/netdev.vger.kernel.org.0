Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16926BF80D
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 06:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbjCRFkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 01:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjCRFkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 01:40:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A44F132DB
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 22:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D48B860A72
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 05:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3AA2EC4339C;
        Sat, 18 Mar 2023 05:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679118019;
        bh=ZOabnSDds9uFyv5NTzBfcCdMLdNSMZRo/o3VpettWDE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e7Xg1YFKVdmnxsNPV3g+hXfSBVHABXuDUkVMS8BBonYURG3oo+m5C/piuvtLqwtPx
         4NYYyBQNsmHTt1ALxfzgt/wAIqSoFqipcICI3SHUbBjOcReXWeaTaiiwaLSFAUVTRN
         0tttEeTQfrHgoDdjVAbnfNtWwo9J224q83YQjb4i31E9QWfvtmeAcSRQnOqcb5Pno3
         M+gWCptnhmOSvqYmbuMxKT9N+EFcJE/+Na61giz8bAmNdzKV9N3Q73+s7TqywFVQoa
         3UOM57kb9FgBySdlmpmgeiq1klBg7dTz/trVxEO6zopqOx/IqTA4wXMuI25aS6MbBT
         xRcQEn6twNgew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 22922E2A03A;
        Sat, 18 Mar 2023 05:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: wangxun: Remove macro that is redefined
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167911801913.9150.7074682590612573768.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Mar 2023 05:40:19 +0000
References: <20230315091846.17314-1-mengyuanlou@net-swift.com>
In-Reply-To: <20230315091846.17314-1-mengyuanlou@net-swift.com>
To:     mengyuanlou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 15 Mar 2023 17:18:46 +0800 you wrote:
> Remove PCI_VENDOR_ID_WANGXUN which is redefined in
> drivers/pci/quirks.
> 
> Signed-off-by: mengyuanlou <mengyuanlou@net-swift.com>
> ---
>  drivers/net/ethernet/wangxun/libwx/wx_type.h | 5 -----
>  1 file changed, 5 deletions(-)

Here is the summary with links:
  - [net-next] net: wangxun: Remove macro that is redefined
    https://git.kernel.org/netdev/net-next/c/4dd2744fae6d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


