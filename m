Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E252B4BCA60
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 20:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242969AbiBSTAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 14:00:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242139AbiBSTAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 14:00:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953185A09D;
        Sat, 19 Feb 2022 11:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65AB3B80CB1;
        Sat, 19 Feb 2022 19:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D0D6C340F1;
        Sat, 19 Feb 2022 19:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645297210;
        bh=DRDDBCVkph1HPdANfG02zjftXRJS08B3iK2cQuXGaGE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qkGADES+asCTa/IQZsEP2SF6rj2eoWNaji6zz0fHQYeCfB8t9vSBk9SngWAXb7ZUB
         FPJTCrR6bOxkwP+aJ1JVFuq5/jETTy4xb5cz9foJN+TtZy5yRiwyWXk/wLdNxHUt5x
         OK5EECqtpjBknHiyOjKO9KBvCjwGKVZ7LBO9MUSc1iaB+fdXCqXmzjXlVwk6Y2zhw6
         dHAY7sy/4r9jp9vybbcuk0/jSGMDVqulnd6liDXP91fMI4tgFWfDORBfaB73LXtqpD
         yZ61kc2N0nPhGANDcNvVMw5XPTHIoicUGM+OZBwr8yWH9uHC9GjZoCdn9OEms4DWcb
         R+Ss/qTTJVOSA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 15439E7BB19;
        Sat, 19 Feb 2022 19:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: prestera: acl: fix 'client_map' buff overflow
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164529721008.31615.428174841093903848.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Feb 2022 19:00:10 +0000
References: <1645187351-8489-1-git-send-email-volodymyr.mytnyk@plvision.eu>
In-Reply-To: <1645187351-8489-1-git-send-email-volodymyr.mytnyk@plvision.eu>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     netdev@vger.kernel.org, taras.chornyi@plvision.eu,
        mickeyr@marvell.com, serhiy.pshyk@plvision.eu, vmytnyk@marvell.com,
        tchornyi@marvell.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri, 18 Feb 2022 14:29:11 +0200 you wrote:
> From: Volodymyr Mytnyk <vmytnyk@marvell.com>
> 
> smatch warnings:
> drivers/net/ethernet/marvell/prestera/prestera_acl.c:103
> prestera_acl_chain_to_client() error: buffer overflow
> 'client_map' 3 <= 3
> 
> [...]

Here is the summary with links:
  - [net-next] net: prestera: acl: fix 'client_map' buff overflow
    https://git.kernel.org/netdev/net-next/c/48c77bdf729a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


