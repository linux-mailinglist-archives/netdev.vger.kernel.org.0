Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B973E4C3373
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 18:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbiBXRU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 12:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbiBXRUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 12:20:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D4A29F41C
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 09:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E93CAB827AF
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 17:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 75E23C340E9;
        Thu, 24 Feb 2022 17:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645723210;
        bh=EDqSAzZWK3EFtWEiplLDXcqXuLVWY407tMNAoysHms0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jfdVooFqMEkcXEyqlAzeRyyf73L4DG1z+SsIo6geogXO7j7EnNP+EPmeHJcx/cTgN
         OcJhu3kLQ+YGR6hjYcZVz/58MmtNVMYhmw/WBfVVM7UeBEYxijYYUVZmaWY7CW7RGW
         Cj5eN1lHfJeP399C0K161WWTrGVJbGbVRKRbgsrQuKdH5XNbYh7ZqWhbrV9jwbvFJR
         52mxpbtPF0+FPcgxws0svAnOyPrV0LauQheuGixwgtDKUs1ylyRNhuTRespGMdOy18
         Su/hu+Br2sJ52c4df44ZF5x+Ue7GmLv+8Uo45TVUaUwayl57r5XV/F22PfaD+5qOQW
         SZaUsUJrJvQog==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5CA1AEAC09B;
        Thu, 24 Feb 2022 17:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bnx2x: fix driver load from initrd
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164572321037.7006.5821188682790574637.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Feb 2022 17:20:10 +0000
References: <20220223085720.12021-1-manishc@marvell.com>
In-Reply-To: <20220223085720.12021-1-manishc@marvell.com>
To:     Manish Chopra <manishc@marvell.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, aelior@marvell.com,
        palok@marvell.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 23 Feb 2022 00:57:20 -0800 you wrote:
> Commit b7a49f73059f ("bnx2x: Utilize firmware 7.13.21.0") added
> new firmware support in the driver with maintaining older firmware
> compatibility. However, older firmware was not added in MODULE_FIRMWARE()
> which caused missing firmware files in initrd image leading to driver load
> failure from initrd. This patch adds MODULE_FIRMWARE() for older firmware
> version to have firmware files included in initrd.
> 
> [...]

Here is the summary with links:
  - [net] bnx2x: fix driver load from initrd
    https://git.kernel.org/netdev/net/c/e13ad1443684

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


