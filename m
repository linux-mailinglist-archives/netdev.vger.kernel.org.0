Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB8E50DDDE
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 12:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241459AbiDYKdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 06:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238159AbiDYKdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 06:33:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F66222A;
        Mon, 25 Apr 2022 03:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D49E60EC4;
        Mon, 25 Apr 2022 10:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82C39C385A4;
        Mon, 25 Apr 2022 10:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650882611;
        bh=9IBThzZfRfFGRygmt26kLGYK/fRYWzh59kZXPTNxgKk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fo/9rGhOEWYIvNijrtoxZhCbcgrD6wPis+Bpa2oLK2Hi+i6wyuKRC3PZP3lesHpKE
         SPyAopHgTk4r+RSaHcSAWRq911G43ySk+IVOXHVDgVSkqAcXN2teaq20KAatbZEa8J
         gq3ytHUJiwN6UH/TQA9sDG/JWAjUlCgK5WaqRDueBJzON0h/QK30iQSyopKhjt1yQC
         heawSSFqEEy/1KmC7vqTCs4yqttk2EzsF9B2qO6S8CL2w/ox0aZKu1y+/DRPst18o5
         SRZZiZ7EhaYALt59cpAHdaBsKfrqHCrxKYw8ccraXiZuT5fK/3sZvbm52l9ELOSteP
         MMm4XyiVastLg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 66946E85D90;
        Mon, 25 Apr 2022 10:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: lan966x: fix a couple off by one bugs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165088261141.604.6325494108887689082.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Apr 2022 10:30:11 +0000
References: <YmF8RTClhMXPVPgh@kili>
In-Reply-To: <YmF8RTClhMXPVPgh@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 21 Apr 2022 18:46:13 +0300 you wrote:
> The lan966x->ports[] array has lan966x->num_phys_ports elements.  These
> are assigned in lan966x_probe().  That means the > comparison should be
> changed to >=.
> 
> The first off by one check is harmless but the second one could lead to
> an out of bounds access and a crash.
> 
> [...]

Here is the summary with links:
  - [net] net: lan966x: fix a couple off by one bugs
    https://git.kernel.org/netdev/net/c/9810c58c7051

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


