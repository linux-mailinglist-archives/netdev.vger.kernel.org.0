Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0A5646820
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 05:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiLHEKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 23:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiLHEKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 23:10:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73109077B;
        Wed,  7 Dec 2022 20:10:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D1E2B8227D;
        Thu,  8 Dec 2022 04:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B5703C4347C;
        Thu,  8 Dec 2022 04:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670472619;
        bh=Lkaew454KJwOgP02M/+A17KF6JdgIiQd4LIt0fsP5fg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aOut5V7JIhA4H6xkdb7/yj0kP+2pzt2rvnYgXRE2emKLReffiaZH8CRnBLzT3UzAJ
         6evv8GuyLCT8xV1/vnhmURPkOc1g6f2GSqppBbjftp8j2ghDARRfZpkssBcnfxOpBm
         hIIrwjzsO+GuU4TFA8YeIR65X7F/mwTXZOKe3WU4TU0550/ue1PIywHa2kCC+I3TA4
         63FD7/MqRAotz1fAmFgHoCzQPaCAhDdSq2We+qvijQzaa18PneXK0uU3o4Fx0EZUjs
         DQV5kUBzRJBfjM2b619UMk+poq5HmXbhbnrGT+zN3tY8zqrXSvoc+rusSr+4uFdmiQ
         ImWAWSwfpojzA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 93837E50D9B;
        Thu,  8 Dec 2022 04:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: =?utf-8?q?=5BPATCH_net-next=5D_net=3A_ethernet=3A_use_sysfs=5Femit?=
        =?utf-8?q?=28=29_to_instead_of_scnprintf=28=29?=
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167047261959.18861.7142548286993253802.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Dec 2022 04:10:19 +0000
References: <202212051918564721658@zte.com.cn>
In-Reply-To: <202212051918564721658@zte.com.cn>
To:     <ye.xingchen@zte.com.cn>
Cc:     edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, richardbgobert@gmail.com, iwienand@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Mon, 5 Dec 2022 19:18:56 +0800 (CST) you wrote:
> From: ye xingchen <ye.xingchen@zte.com.cn>
> 
> Follow the advice of the Documentation/filesystems/sysfs.rst and show()
> should only use sysfs_emit() or sysfs_emit_at() when formatting the
> value to be returned to user space.
> 
> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: use sysfs_emit() to instead of scnprintf()
    https://git.kernel.org/netdev/net-next/c/16dc16d9f058

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


