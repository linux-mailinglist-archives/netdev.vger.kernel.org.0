Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E7563B6E0
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 02:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234930AbiK2BKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 20:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234851AbiK2BKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 20:10:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A322AC58;
        Mon, 28 Nov 2022 17:10:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96AD96152D;
        Tue, 29 Nov 2022 01:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EFAA4C433B5;
        Tue, 29 Nov 2022 01:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669684215;
        bh=xdOIF4FtP3Kn7ii8PIDHrs0fsUcKrCPOZ/yWS5Hth0w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=caFFLviuooZ85na+RxkEa3DJpfm12J2Qh1i5W/3xQpl5o3dVrbcK5l4PASHxb3WrE
         frZoKLUwmEgv5d8SjfOV7S7gy0UL/ZjN4XE2p45yN3zQqHcMGUkpOBxchslbmJLSUs
         NbqpscBTljjoH7Jn9yRJCnzfByaDVnimx/J8QRawFhPooyfo7GMU13qkctyfi+Ffec
         EWG4aMeezB4UZ4xRvwiRuFtEb/lHXNdv1WL+VlpkXPjWfKikCvuPBWtXa+SkeJB4xc
         k2SwvB6hYcJJDaczFTvMDanhmqghhfKJGzCuFIak1jZ+dhGQn02XhNpW8pGVxiTx2b
         rvf/PUmbjfJ5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CBA3EE21EF7;
        Tue, 29 Nov 2022 01:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Revert "net: stmmac: use sysfs_streq() instead of
 strncmp()"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166968421482.15821.7452131414473151568.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 01:10:14 +0000
References: <20221125105304.3012153-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221125105304.3012153-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, claudiu.manoil@nxp.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        yang.yang29@zte.com, xu.panda@zte.com.cn,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 25 Nov 2022 12:53:04 +0200 you wrote:
> This reverts commit f72cd76b05ea1ce9258484e8127932d0ea928f22.
> This patch is so broken, it hurts. Apparently no one reviewed it and it
> passed the build testing (because the code was compiled out), but it was
> obviously never compile-tested, since it produces the following build
> error, due to an incomplete conversion where an extra argument was left,
> although the function being called was left:
> 
> [...]

Here is the summary with links:
  - [net-next] Revert "net: stmmac: use sysfs_streq() instead of strncmp()"
    https://git.kernel.org/netdev/net-next/c/469d258d9e11

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


