Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C784AF14D
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbiBIMUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbiBIMUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:20:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CA7E03A43C;
        Wed,  9 Feb 2022 04:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61E62B8207D;
        Wed,  9 Feb 2022 12:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24A47C340EB;
        Wed,  9 Feb 2022 12:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644408609;
        bh=OmFyowaarOAXDYzcFG0p3/lKYpAZz6ILFbXsPwcShv8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tA9yIWuBh6U+H9Ynq/jXBNLKIgsqux2NlFXDM3agTpyylvh493Zr3T2PxHLsFcB3F
         4bWS8bkoCvpAS7kWF/51nK5c8FNrQe27PshP1CmTp55NbWLMqMLAokISWJhmKEU+5m
         8Gl8MTq1HjxudQXm/jMta97hZHL1Y9MJUNnkQGxeI34uDlTcUiO2C5uD3KRIDwZVaY
         8Dsuh30mCnV5lhrEbefCEDh+08ST6C+LAcd+SC1iKlV73CYBQXJ713klbETQlP8VhJ
         KtC1xN8t/ODhDXipfBnrkuWyeKvgYMzMvBhSOjSL7+xKr6taCtcn4NKYZzUKv0oL/6
         P9OrMtI9YcUxg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0885EE5D07D;
        Wed,  9 Feb 2022 12:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] can: isotp: fix potential CAN frame reception race in
 isotp_rcv()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164440860903.17005.14991566915194907951.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 12:10:09 +0000
References: <20220209080154.315214-2-mkl@pengutronix.de>
In-Reply-To: <20220209080154.315214-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        socketcan@hartkopp.net, stable@vger.kernel.org,
        syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com,
        william.xuanziyang@huawei.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Wed,  9 Feb 2022 09:01:53 +0100 you wrote:
> From: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> When receiving a CAN frame the current code logic does not consider
> concurrently receiving processes which do not show up in real world
> usage.
> 
> Ziyang Xuan writes:
> 
> [...]

Here is the summary with links:
  - [net,1/2] can: isotp: fix potential CAN frame reception race in isotp_rcv()
    https://git.kernel.org/netdev/net/c/7c759040c1dd
  - [net,2/2] can: isotp: fix error path in isotp_sendmsg() to unlock wait queue
    https://git.kernel.org/netdev/net/c/8375dfac4f68

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


