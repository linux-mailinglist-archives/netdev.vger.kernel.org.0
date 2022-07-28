Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6125837BB
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 05:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbiG1DuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 23:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbiG1DuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 23:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264112664;
        Wed, 27 Jul 2022 20:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B444961A0D;
        Thu, 28 Jul 2022 03:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15A6DC43143;
        Thu, 28 Jul 2022 03:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658980214;
        bh=QC6FqwqcL8Puqg1h6k/L4W0cjGIrLJZFEZr7ULfWD3U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HTh8zhoukHvvzx4nS5q1kMZhDng8vT2aQS6QZpS7xoImq4+RFyJ3YnDQxgU1r6Is5
         5MCcPJUvwEt5mClqMvwTkmsf3qz5ssO3/r16me6gFYgEV6MC44UIK4yJv3ronNSvpA
         ssskZq/qAapLzwl2N2joSYGZTCEv2ij5B96oV9eyVuxflp68CiyfR/gvdU6cSVJcLP
         qZfftUhw79UkirTvrgnN6uMXkNTcIjhao/TmaI4nqPI+fiBeJKyRTU9sDKn+/mP55o
         9CU4HgKanTcuMMoolz/nnC2yRC2ZEFy7lo4H0cp+aM/4zaJ4QX8OkM/T/kEd2RsKq9
         QHIvt4aUnl0jg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ED3A3C43144;
        Thu, 28 Jul 2022 03:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next: PATCH v2] net: dsa: mv88e6xxx: fix speed setting for
 CPU/DSA ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165898021396.7628.6404582771725126143.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jul 2022 03:50:13 +0000
References: <20220726230918.2772378-1-mw@semihalf.com>
In-Reply-To: <20220726230918.2772378-1-mw@semihalf.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        jaz@semihalf.com, tn@semihalf.com, upstream@semihalf.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 27 Jul 2022 01:09:18 +0200 you wrote:
> Commit 3c783b83bd0f ("net: dsa: mv88e6xxx: get rid of SPEED_MAX setting")
> stopped relying on SPEED_MAX constant and hardcoded speed settings
> for the switch ports and rely on phylink configuration.
> 
> It turned out, however, that when the relevant code is called,
> the mac_capabilites of CPU/DSA port remain unset.
> mv88e6xxx_setup_port() is called via mv88e6xxx_setup() in
> dsa_tree_setup_switches(), which precedes setting the caps in
> phylink_get_caps down in the chain of dsa_tree_setup_ports().
> 
> [...]

Here is the summary with links:
  - [net-next:,v2] net: dsa: mv88e6xxx: fix speed setting for CPU/DSA ports
    https://git.kernel.org/netdev/net-next/c/cc1049ccee20

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


