Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE18E54C80A
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 14:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244617AbiFOMAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 08:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237953AbiFOMAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 08:00:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3F45400E;
        Wed, 15 Jun 2022 05:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9E11B81D6D;
        Wed, 15 Jun 2022 12:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7A162C341C0;
        Wed, 15 Jun 2022 12:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655294413;
        bh=3gCDG7Gl/RH/Ua80/Mre5ueekp+PMkzJsmoVDTmq3tw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ijCFy8Qbpetd2i9X7VMeJwxUwQuPZxW1+vP2HbLXHyvuEnqt7HEvQsNDAHJNQempt
         HygmeAvP3NTgmLuC3El/dBNVMTCYPDBLjjxZpxowW7BGGw/A2B74ZWCbPZGU43yBrl
         hIYtrI4kj9NawWVGnECq4lkMyp1UEzlyjHAx0HdZrn/65ikCB+GHgbMGZS7mKs07m7
         /cS8dbQU0sloypU1d7nHqky9kg/uQUB9fGdvrFy3hCCXaCac+t3h0T7xf1KhfIOsMB
         gjWtJgCKq2T2JbjnFMjSdBOdUyDeNBInchBu4jZlOoFGVETB3F2P4NDkX4pvYazi0y
         T9dP6CfHOqRRw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 599EAE6D466;
        Wed, 15 Jun 2022 12:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: don't check skb_count twice
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165529441336.9723.13573073281613758442.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Jun 2022 12:00:13 +0000
References: <20220615032426.17214-1-liew.s.piaw@gmail.com>
In-Reply-To: <20220615032426.17214-1-liew.s.piaw@gmail.com>
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 15 Jun 2022 11:24:26 +0800 you wrote:
> NAPI cache skb_count is being checked twice without condition. Change to
> checking the second time only if the first check is run.
> 
> Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
> ---
>  net/core/skbuff.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

Here is the summary with links:
  - net: don't check skb_count twice
    https://git.kernel.org/netdev/net-next/c/49ae83fc4fd0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


