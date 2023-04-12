Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBA26DF106
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 11:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjDLJua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 05:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjDLJuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 05:50:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFC07EE3;
        Wed, 12 Apr 2023 02:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7E7863266;
        Wed, 12 Apr 2023 09:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32D90C4339C;
        Wed, 12 Apr 2023 09:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681293018;
        bh=JKpqY99dVH3rpl5Sq6TldQsWgp6tczXZgXe/sHAL36o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TQEPiQC7RGuGuNhyQyEnEvajjBPGwg+C2q7VNigz5rMU/7gdFzcFGPEru9HhkcaK9
         qnGHgo+uANmRyOX7Gt7dCAvSr9VLJrVz0nvx24td/j0bfOHIP8bOhQAQw2Ov79Wl7R
         twBYr96ozLSxXsFLu/ZDXcgJY1FSyMp46qaAerSPKFXiL2qUwztTICdlV4OSFseISZ
         FsB5K0w17f4nCjuqUUQuZY7NooBeFmIWCfBatREbyud859k9yF+L81AMHkpC7O+q8P
         A/ZXeZsa9DKVm0Zmy9yaC+bVWdVI3N9GXQE8YvdQ7JmLmE+ykaJ3+cQ8SvZcSgqCYP
         cUSuBr4ju44UQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1917CE5244C;
        Wed, 12 Apr 2023 09:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V2] net: wwan: iosm: Fix error handling path in
 ipc_pcie_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168129301809.23085.4084807905542802523.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Apr 2023 09:50:18 +0000
References: <20230408194321.1647805-1-harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20230408194321.1647805-1-harshit.m.mogalapalli@oracle.com>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     m.chetan.kumar@intel.com, linuxwwan@intel.com,
        loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, simon.horman@corigine.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, error27@gmail.com,
        kernel-janitors@vger.kernel.org, vegard.nossum@oracle.com
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

On Sat,  8 Apr 2023 12:43:21 -0700 you wrote:
> Smatch reports:
> 	drivers/net/wwan/iosm/iosm_ipc_pcie.c:298 ipc_pcie_probe()
> 	warn: missing unwind goto?
> 
> When dma_set_mask fails it directly returns without disabling pci
> device and freeing ipc_pcie. Fix this my calling a correct goto label
> 
> [...]

Here is the summary with links:
  - [net,V2] net: wwan: iosm: Fix error handling path in ipc_pcie_probe()
    https://git.kernel.org/netdev/net/c/a56ef25619e0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


