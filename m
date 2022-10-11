Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD6A5FA9E4
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 03:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiJKBU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 21:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiJKBUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 21:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD8B40E0E;
        Mon, 10 Oct 2022 18:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEF80B81100;
        Tue, 11 Oct 2022 01:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9389DC433D6;
        Tue, 11 Oct 2022 01:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665451215;
        bh=cfVQzOtvpVQuPs2yzafVx/Gecgi+P/DxQOOasuViRsM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VW/uqde0YQhYWYdWewUO1sywYeq57fQHuQTi+r6uDGmBEHxJu274ZVSgDBdklX53A
         F4V6Eioq/ZwOdwssRU5nzgvHcoW4tWPHMRSj2qLB6vRUS0ikwTPma7NtnslOT72YjZ
         QJ/cv43Gcz/IbtOSyJqMGIKqbm3QEuKNQj+sfp3pghCazCow8vY846r9pjN8SlXM7S
         1Yw5gbKT5OnXhPxkJ3qnnNFVdaQZQ3ojUClXACiQPYdoEhWgWOzGr+EY+g5Tmr7Phw
         jB8DrqmAUsyaKWRnX7CXJDNgAaWMeU6cXMBr+orJR8HHKd+MeH17+CQg0W36PR9zKv
         VQ6pYVPJgn//A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 70832E4D00E;
        Tue, 11 Oct 2022 01:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: systemport: Enable all RX descriptors for SYSTEMPORT
 Lite
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166545121545.22576.6517732665062130017.git-patchwork-notify@kernel.org>
Date:   Tue, 11 Oct 2022 01:20:15 +0000
References: <20221007034201.4126054-1-f.fainelli@gmail.com>
In-Reply-To: <20221007034201.4126054-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org
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

On Thu,  6 Oct 2022 20:42:01 -0700 you wrote:
> The original commit that added support for the SYSTEMPORT Lite variant
> halved the number of RX descriptors due to a confusion between the
> number of descriptors and the number of descriptor words. There are 512
> descriptor *words* which means 256 descriptors total.
> 
> Fixes: 44a4524c54af ("net: systemport: Add support for SYSTEMPORT Lite")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: systemport: Enable all RX descriptors for SYSTEMPORT Lite
    https://git.kernel.org/netdev/net/c/a390e03401e9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


