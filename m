Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44D4850FB03
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 12:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349310AbiDZKkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 06:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350270AbiDZKkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 06:40:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EA926DC;
        Tue, 26 Apr 2022 03:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 354D0B81D53;
        Tue, 26 Apr 2022 10:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE7D1C385BD;
        Tue, 26 Apr 2022 10:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650969012;
        bh=l6n5SuqN/qPa31I2vHmvChTwK5PnnNOmZRtqZAhfKD0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hI1YVZprZsEvzU3QtVMbeMXpy81SrjwvfFgT8EgaGocogSJNqziOFnjAbYTa+FkR2
         E5lGm1zuN5+e8VsGYAKWVINVwre8YkB5XMIqqPLJECPZuXSjKTQ9gwAVope5gthEGU
         I2UcdomeHTVvLq1t2bvCk88qA47fBsMGSNq4Ke2JxJDYnp2W5PLcf0v1rteOLALWIK
         9TgsX4OFZs5gFIVWQxAmGLoDnKeez0WUWzBc/4WdoDYRxOzxaHNbUbenOb9veJ3SgM
         TWDHmaHux2/wCWY7Zz5mLPNfI+1hS3/zleMAafDqFi5In66bVpHkmXoxyPM+DLYzh2
         lsGGcVr/1tGZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CCCB2E6D402;
        Tue, 26 Apr 2022 10:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: dsa: mv88e6xxx: Fix port_hidden_wait to account for
 port_base_addr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165096901183.6856.17060900849638968052.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Apr 2022 10:30:11 +0000
References: <20220425070454.348584-1-nathan@nathanrossi.com>
In-Reply-To: <20220425070454.348584-1-nathan@nathanrossi.com>
To:     Nathan Rossi <nathan@nathanrossi.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, kabel@kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 25 Apr 2022 07:04:54 +0000 you wrote:
> The other port_hidden functions rely on the port_read/port_write
> functions to access the hidden control port. These functions apply the
> offset for port_base_addr where applicable. Update port_hidden_wait to
> use the port_wait_bit so that port_base_addr offsets are accounted for
> when waiting for the busy bit to change.
> 
> Without the offset the port_hidden_wait function would timeout on
> devices that have a non-zero port_base_addr (e.g. MV88E6141), however
> devices that have a zero port_base_addr would operate correctly (e.g.
> MV88E6390).
> 
> [...]

Here is the summary with links:
  - [v3] net: dsa: mv88e6xxx: Fix port_hidden_wait to account for port_base_addr
    https://git.kernel.org/netdev/net/c/24cbdb910bb6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


