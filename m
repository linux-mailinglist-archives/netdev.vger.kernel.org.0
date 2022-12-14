Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4039564C2F6
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 05:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237321AbiLNEA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 23:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237303AbiLNEAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 23:00:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2C9183B2
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 20:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F15B617DC
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 04:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A224AC433F1;
        Wed, 14 Dec 2022 04:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670990418;
        bh=MN9702pZk1qolnEC/tnRezgtF322g5zNuHpS6DNyWoo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D1ZQ5nqrbGprqPisF588GsE3T879rpW+mf7NA/CORVdeEis0dRTpcAmz2aPafSYLL
         QXJ85ltdtMOPizq136Rwn8qtyhBiVHxnjFVfyJkhQw76QYZiZX9kAgWZPKoZOZp6nu
         qYmiPHBCoOYdthlsGAwsbxhHYZTTqnhOyRJGmNODryLBmtXiADsImGzCIAbHB4DVtj
         qEuIL+U5QakuZ2pQBNPJXhpXtqoMUUTU4dq7XSsznJ3Gv68JJPNi1zVzW3tcj6cofY
         iol3J3KuSGUkSfUjCsrMJ+JCeWYj2xDDQuvTQkD21DH1TpHzHi+h7RycmeY8ZGehK0
         u34yhA8lYcYRA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7AC4CE50D78;
        Wed, 14 Dec 2022 04:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] igb: Initialize mailbox message for VF reset
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167099041849.9337.1143674230455461708.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Dec 2022 04:00:18 +0000
References: <20221212190031.3983342-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20221212190031.3983342-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, agraf@suse.de,
        akihiko.odaki@daynix.com, yan@daynix.com,
        gregkh@linuxfoundation.org, security@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 12 Dec 2022 11:00:31 -0800 you wrote:
> When a MAC address is not assigned to the VF, that portion of the message
> sent to the VF is not set. The memory, however, is allocated from the
> stack meaning that information may be leaked to the VM. Initialize the
> message buffer to 0 so that no information is passed to the VM in this
> case.
> 
> Fixes: 6ddbc4cf1f4d ("igb: Indicate failure on vf reset for empty mac address")
> Reported-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Reviewed-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> 
> [...]

Here is the summary with links:
  - [net,1/1] igb: Initialize mailbox message for VF reset
    https://git.kernel.org/netdev/net/c/de5dc44370fb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


