Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6063364145C
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 06:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiLCFu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 00:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiLCFu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 00:50:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42F2B0A1C;
        Fri,  2 Dec 2022 21:50:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58D7360301;
        Sat,  3 Dec 2022 05:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A5BB0C433C1;
        Sat,  3 Dec 2022 05:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670046624;
        bh=7uUA233utYGrgu+O6CmC82RM5goqcSrPaI5g+St9LIE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o+cSYCYRs/88CdOEtFyFqfP7NrgSAClnGck55asNzWle5S+ommauVLUF+F7658/Pj
         MOcTV9nMzNzqpLim4IrI8/f/PRYVnsYxOs74cZ/f4qI5r4h93vLE3hQijYT2rRBw3B
         WuAlPNFvHM+fpdTzyXL6jLNBJOdtAggHF8JRjkBCEzFN5liASAogORVDaRYDBDhY52
         zv923z3NiFeFSEWJVQeRxMsMmJuAB0sy+nT+6mMIuO+TFyJZbpwKTgc2DAuWAX2TvG
         3PR5ltDU0K/cQTBNP7KmHOYuVz9j9IpEguKvJIBzptuQDiiLedZxKiXWdhWVQjM75J
         U0+FTE84qgyjA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 79377E29F3E;
        Sat,  3 Dec 2022 05:50:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-next-2022-12-02
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167004662449.29967.10480563352739628700.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Dec 2022 05:50:24 +0000
References: <20221202214254.D0D3DC433C1@smtp.kernel.org>
In-Reply-To: <20221202214254.D0D3DC433C1@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  2 Dec 2022 21:42:54 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-next-2022-12-02
    https://git.kernel.org/netdev/net-next/c/edd4e25a230d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


