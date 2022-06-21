Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34CE7553A8B
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 21:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353270AbiFUTaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 15:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbiFUTaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 15:30:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE05DF3B;
        Tue, 21 Jun 2022 12:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64BEBB81B08;
        Tue, 21 Jun 2022 19:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D905CC341C5;
        Tue, 21 Jun 2022 19:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655839813;
        bh=dLn289f+YOXcvwDhqg5jQUIVxdtdzapNYJ1bpSYsrvw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i0UmHWIWoWn+rrLxaRdcsixcTs4ERbYmTc/x3uTUjHCrfdSkkS/6Mxvage8RJmbOf
         vEmOS+2uaXj/UnOPwjLA94GtcrxSB4xHw2g+dO/1urr0JarLvywSctFYBfErvKkV6E
         aI2ij7aSP7SAcxbtZVGsC3rO9n953nHD+6ePOpRlYulGdl3VSAohWFHWGs1eQscwks
         CrwtHH7YXtn/izZNjJlos5lffaMlpcwSpIxRAWGaiCf1lP8PCzMY2pzjQJO1AMBsvT
         TRbMogk2pVLsrMH5RyA3Q/NLhuijL2uADso+Ht+AG4n8NicaLYGwK+izJjqPhgGnyv
         j+3kDR1j4UWdw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B91FAE73875;
        Tue, 21 Jun 2022 19:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel PATCH v1 0/1] Fix refresh cached connection info
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <165583981375.29669.2524383777560438152.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Jun 2022 19:30:13 +0000
References: <20220613214327.15866-1-jiangzp@google.com>
In-Reply-To: <20220613214327.15866-1-jiangzp@google.com>
To:     Zhengping Jiang <jiangzp@google.com>
Cc:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        chromeos-bluetooth-upstreaming@chromium.org, brian.gix@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Mon, 13 Jun 2022 14:43:26 -0700 you wrote:
> Get connection info will return error when using synchronous hci_sync
> call to refresh the cached information when the data times out. This is
> because the cmd->user_data was not set before the call, so it will fail
> checking connection is still connected.
> 
> Changes in v1:
> - Set connection data before calling hci_cmd_sync_queue
> 
> [...]

Here is the summary with links:
  - [kernel,v1,1/1] Bluetooth: mgmt: Fix refresh cached connection info
    https://git.kernel.org/bluetooth/bluetooth-next/c/d9cc9d78ca85

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


