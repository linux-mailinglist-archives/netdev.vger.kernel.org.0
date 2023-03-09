Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D42B6B21B9
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 11:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjCIKmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 05:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbjCIKlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 05:41:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C995AE8CFA;
        Thu,  9 Mar 2023 02:40:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A918B81DBB;
        Thu,  9 Mar 2023 10:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A73F6C4339B;
        Thu,  9 Mar 2023 10:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678358418;
        bh=NjW+SCdBHVHl5OPHQTIfeNxrTkiTDwl6hAlCJn1rDyU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=auaAg2gXTNY0/P5bwZ/Qr+mQZvvgqPz8oCT/bsyO5xaY7+s4WWCfSE7RkOB6jm6TU
         P0mLGy0HhPWtHxbCBE93QX3+Sh6iVv6hwOBPm3ttpj/3T+bMxsbrvoppvqXieAWjrx
         8XMkbsjIeujhvADXIkxAVaSwdul827peQSHeNRgCzEzYPEsMUc/70ygTUJNhxnH0C4
         QJc/VZpwhAZmPGwiaCKjoXfEzasWfQSE+Pn4A4phELiaWDd3bKv50ysfFOWX+ki2I5
         hqE8vJCiYAQq9Kg/T11nMDa+mos/gXY+OIifjnJU8Joo3bpTrgWgTjud13cGD18Z+2
         AkMl1wwdEwfTw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8393BE49F63;
        Thu,  9 Mar 2023 10:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] sctp: add another two stream schedulers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167835841852.16610.7402267659998000194.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Mar 2023 10:40:18 +0000
References: <cover.1678224012.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1678224012.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, marcelo.leitner@gmail.com, nhorman@tuxdriver.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue,  7 Mar 2023 16:23:25 -0500 you wrote:
> All SCTP stream schedulers are defined in rfc8260#section-3,
> First-Come First-Served, Round-Robin and Priority-Based
> Schedulers are already added in kernel.
> 
> This patchset adds another two schedulers: Fair Capacity
> Scheduler and Weighted Fair Queueing Scheduler.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] sctp: add fair capacity stream scheduler
    https://git.kernel.org/netdev/net-next/c/4821a076eb60
  - [net-next,2/2] sctp: add weighted fair queueing stream scheduler
    https://git.kernel.org/netdev/net-next/c/42d452e7709f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


