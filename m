Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E3C617525
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 04:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiKCDkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 23:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiKCDkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 23:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E4215823
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 20:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64E736121D
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 03:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C6A6EC43141;
        Thu,  3 Nov 2022 03:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667446815;
        bh=j6OFkvt565NsHZ0uBCgW4H4/4HnLbZ+kL5lmj4qM7Rc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F7t1G32t+t1FxoqxtsSfN1V3UJKx126LhrWvKT8YE0SvYH5nKTG0dJeHeuC85QGIh
         vrPltZP+XyxxcZOGVM81r4aCm81JvXp34TxLNbUAX09DOgwtD4Sfqs47gpH4/SKfqm
         0TATBKSHOl32T+RzJhHPX3R9dB4y6hCOjbXvJEEa4ZX+m4GfQ5nOZRPVpC9hjymiPH
         3PciPxxYzbE6JoT7Gv46UJOp2dg5kIpSGTVdgrGyBAAFUpQytM/LIH4UCHuBBeSEGu
         vdqPH51KNyKIZ0h/37bLyIbYEedq3GppDFv1r5NENkB0HNfGBJjhdboOvqcWJuIB/E
         ocZUR1QxZvxAA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A95DDE29F4D;
        Thu,  3 Nov 2022 03:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ibmvnic: Free rwi on reset success
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166744681568.6035.1517483549300918172.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Nov 2022 03:40:15 +0000
References: <20221031150642.13356-1-nnac123@linux.ibm.com>
In-Reply-To: <20221031150642.13356-1-nnac123@linux.ibm.com>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org, haren@linux.ibm.com,
        ricklind@linux.ibm.com, danymadden@us.ibm.com,
        tlfalcon@linux.ibm.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 31 Oct 2022 10:06:42 -0500 you wrote:
> Free the rwi structure in the event that the last rwi in the list
> processed successfully. The logic in commit 4f408e1fa6e1 ("ibmvnic:
> retry reset if there are no other resets") introduces an issue that
> results in a 32 byte memory leak whenever the last rwi in the list
> gets processed.
> 
> Fixes: 4f408e1fa6e1 ("ibmvnic: retry reset if there are no other resets")
> Signed-off-by: Nick Child <nnac123@linux.ibm.com>
> 
> [...]

Here is the summary with links:
  - [net] ibmvnic: Free rwi on reset success
    https://git.kernel.org/netdev/net/c/d6dd2fe71153

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


