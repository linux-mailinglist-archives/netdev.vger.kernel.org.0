Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4DE0562257
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 20:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235921AbiF3SuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 14:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbiF3SuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 14:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210592A97E
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 11:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B02F962268
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 18:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12986C341C8;
        Thu, 30 Jun 2022 18:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656615014;
        bh=6I8c53QgJxAUz+P9nQl5LVRKDQVqg7Q5ZCb/zlKuYfI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oz3Iotk1swnbrJuBrdTfvYcovgeIzxZ9OnlIVud1aafmZ6Ot7Sy2QNQ/HkNq9FI+C
         UKJfIwMymf598Nzc2lDWvd70/dlYyuQwb5LJ5hx/R7jzcJXuVOZO56xOK52Ut+Fx4+
         clrxTZ3OWoa5eOyokfI27pYSmseH/zQKciQyYkoe6rQSGp9gbUHDEBd/W+q917i/50
         LGdtN9QI0EufaBXHFZ+NZcFk2vg+VZ/XgImshhTNc4M1Qpbr/706vnvFdx40EAvjbF
         4ItfYGuJOQqlRHKdSpmhkxLDuSYh31U//01uvgZakJVdhXXHzMAvSAcaskmNMrKy0r
         bf9y2wJ2FXC2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EB48FE49BBF;
        Thu, 30 Jun 2022 18:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sparx5: mdb add/del handle non-sparx5 devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165661501395.16120.12605078841310251936.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Jun 2022 18:50:13 +0000
References: <20220630122226.316812-1-casper.casan@gmail.com>
In-Reply-To: <20220630122226.316812-1-casper.casan@gmail.com>
To:     Casper Andersson <casper.casan@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        steen.hegelund@microchip.com, edumazet@google.com,
        lars.povlsen@microchip.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 30 Jun 2022 14:22:26 +0200 you wrote:
> When adding/deleting mdb entries on other net_devices, eg., tap
> interfaces, it should not crash.
> 
> Fixes: 3bacfccdcb2d
> 
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: sparx5: mdb add/del handle non-sparx5 devices
    https://git.kernel.org/netdev/net/c/9c5de246c1db

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


