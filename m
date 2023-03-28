Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646AA6CB450
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 04:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbjC1CuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 22:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232524AbjC1CuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 22:50:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3021FC3;
        Mon, 27 Mar 2023 19:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 790936158D;
        Tue, 28 Mar 2023 02:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0196C433EF;
        Tue, 28 Mar 2023 02:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679971818;
        bh=Xr07b3ZwwpaCHxBO3Y3pvbKjO9fPVjgPOdfaZar9zwg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=frXSpqtkDead1DnD1371LLNt7nZvn17CMAoGlyzafeZVRKWCAZuLgVYcqCyvKt0/q
         r1sYQmKhWFfeR2FlB5hyWkFjE7XScVxlG3gXnH5boLZ0SZ/mMiJ53lJNMlZihMmS0Q
         ZmPb7nE7qkLxjpVoHybQ8B5N1r1F1x017muFHgEHZMK2Ygn92wwyXBwK0tAhxwm/jX
         mz1HrgqJ3YdOdaSA+X00rfh0AiRVxGLi9Y/VgI8iCoaB8lqdQObztPZsuOua6R7106
         Y0zsOZik7gVEy04qZPA97yF75aImMLG1lQ4aJqmhh61GY9TSffx+us7vaffkvXVKIW
         qpo4ijInFb0Bg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B1FE2E4D029;
        Tue, 28 Mar 2023 02:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] can: j1939: prevent deadlock by moving
 j1939_sk_errqueue()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167997181871.12698.12733102984157992409.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Mar 2023 02:50:18 +0000
References: <20230327124807.1157134-2-mkl@pengutronix.de>
In-Reply-To: <20230327124807.1157134-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        o.rempel@pengutronix.de,
        syzbot+ee1cd780f69483a8616b@syzkaller.appspotmail.com,
        hdanton@sina.com, stable@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Mon, 27 Mar 2023 14:48:06 +0200 you wrote:
> From: Oleksij Rempel <o.rempel@pengutronix.de>
> 
> This commit addresses a deadlock situation that can occur in certain
> scenarios, such as when running data TP/ETP transfer and subscribing to
> the error queue while receiving a net down event. The deadlock involves
> locks in the following order:
> 
> [...]

Here is the summary with links:
  - [net,1/2] can: j1939: prevent deadlock by moving j1939_sk_errqueue()
    https://git.kernel.org/netdev/net/c/d1366b283d94
  - [net,2/2] can: bcm: bcm_tx_setup(): fix KMSAN uninit-value in vfs_write
    https://git.kernel.org/netdev/net/c/2b4c99f7d9a5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


