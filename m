Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84BCA68EAAD
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 10:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbjBHJLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 04:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjBHJLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 04:11:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD2946D76
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 01:10:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60567B81AB4
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 09:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 05B6BC433A1;
        Wed,  8 Feb 2023 09:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675847418;
        bh=2wH6GTJjvq+zugJZDvuxkWcDMsPD71XNS2MQJmyg7W4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RUPIG1tFEw9R1mxWiOP3YUqFI2AES6+VEZMdnG0RXqQ7A29CGvCo66BgPT8xRDGKB
         2ApjxsaZBQv2Gk3eVhBprHH/8XAAGzc/NXzDc+2aAzaC/xtHlqwBpKoV7XGHLHAmna
         e7vC/beTGrUN44enLAv0ncI8bm5gadmdfRGuLHGjHBm4C6pcu8d6yhXvNxZvD6zO3P
         Pa2Ywz8Otcmgbnf/MYCuPznFTSeQs/Qr5rXXIgCh49UNw4WzdibUp09j54r3bK8HsQ
         93NobMAPnUbct3SlpD87u+7tQngb5m0Jddco3pbswR5wsDyYrGnboYJXrwrHfiTlme
         +ln+YTqFJqgAA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E21CCE524EA;
        Wed,  8 Feb 2023 09:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] nfp: ethtool: fix the bug of setting unsupported port
 speed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167584741791.9727.14237218868500187267.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Feb 2023 09:10:17 +0000
References: <20230207101650.2827218-1-simon.horman@corigine.com>
In-Reply-To: <20230207101650.2827218-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        yu.xiao@corigine.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  7 Feb 2023 11:16:50 +0100 you wrote:
> From: Yu Xiao <yu.xiao@corigine.com>
> 
> Unsupported port speed can be set and cause error. Now fixing it
> and return an error if setting unsupported speed.
> 
> This fix depends on the following, which was included in v6.2-rc1:
> commit a61474c41e8c ("nfp: ethtool: support reporting link modes").
> 
> [...]

Here is the summary with links:
  - [net] nfp: ethtool: fix the bug of setting unsupported port speed
    https://git.kernel.org/netdev/net/c/821de68c1f9c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


