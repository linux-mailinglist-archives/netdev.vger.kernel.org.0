Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26777545C39
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 08:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245692AbiFJGaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 02:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244171AbiFJGaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 02:30:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E59530F6C4;
        Thu,  9 Jun 2022 23:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 91240CE3257;
        Fri, 10 Jun 2022 06:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 95D03C3411B;
        Fri, 10 Jun 2022 06:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654842614;
        bh=2lr5wZFeksAx/GnYpYUQWva3ik4JO39BLodV/8etzrI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dmJHaC9b3tXr6kqNOvm74O1ikJbpqqLmkz4cmDLL6rdvWv7kPjeZS1UrGfVIQ0FJ7
         pXthwJQwFmLHtaBVYeALcx00HHn5Mfyd5kNXhOOJ9E///PcRCuHFGpGh36DH+ZCs7v
         YcmXL+B+GdIgn/CJHmNqsPM1gPnce8slAIpSbk9XqteP1Qi0Cq8hjZWhM5psGM+43X
         8LG5GBbFfIVeZ2zQU4OTbDhjudcRZiIYQyIuA2MbaPCV8fovDZLHiIBPv/5BrLUrlw
         W8Cz31FGD91jdFjtbtIl8CotKY7loMVFJ0Q4/3xqV5HKxI13XRWrkg5ybuIngZm0re
         mT3MEV7F/lLcQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7B11AE737EE;
        Fri, 10 Jun 2022 06:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: ieee802154-next 2022-06-09
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165484261349.4999.16719243463616104461.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Jun 2022 06:30:13 +0000
References: <20220609202956.1512156-1-stefan@datenfreihafen.org>
In-Reply-To: <20220609202956.1512156-1-stefan@datenfreihafen.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Jun 2022 22:29:56 +0200 you wrote:
> Hello Dave, Jakub.
> 
> An update from ieee802154 for your *net-next* tree.
> 
> This is a separate pull request for 6lowpan changes. We agreed with the
> bluetooth maintainers to switch the trees these changing are going into
> from bluetooth to ieee802154.
> 
> [...]

Here is the summary with links:
  - pull-request: ieee802154-next 2022-06-09
    https://git.kernel.org/netdev/net-next/c/6cbd05b2d07a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


