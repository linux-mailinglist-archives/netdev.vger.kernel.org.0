Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC7065252F
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 18:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbiLTRKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 12:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233794AbiLTRKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 12:10:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8731170
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 09:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42FDC61525
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 17:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 850A0C433F0;
        Tue, 20 Dec 2022 17:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671556216;
        bh=dd1mrqoeoLB+NDNveoixSCoTRkdlJtHWbQAOjBvQSTg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IxXBzmv2nhg3/VcSAzFqfeqcP/cUA+J/ksdhPLbb7ik+yHyDhFbmXLsBjMz2xqC6t
         NAxBbwpeECQ3vbU2CfXJdwHMTJVOfSWYiE/OnAeASDNnRXopcIsKlGXfa2rOYj+SQs
         aXaRor2XDyYwAZbJ6fqLKo9zKuCAKj40JPi7UDLVZip1FaiuEk9BWnV6MxEHXmp0xF
         owb158YCE8gcu/8Fqs6oV7aFrGy9fzbRVDIJ/VESrbToljqoZsklFNgCDMf4y6y5jR
         UfU0IMBIdtVARVQRio01VT4GVFgu20J2a3dP/OmR8DyG1zxByiVT+e+54VZHKrC865
         drCu5bxvDskyg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 69171C43159;
        Tue, 20 Dec 2022 17:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool-next v3 v3] JSON output support for Netlink
 implementation of --show-coalesce option
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167155621642.25913.4763773818649351883.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Dec 2022 17:10:16 +0000
References: <20221215051347.70022-1-glipus@gmail.com>
In-Reply-To: <20221215051347.70022-1-glipus@gmail.com>
To:     Maxim Georgiev <glipus@gmail.com>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org, kuba@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to ethtool/ethtool.git (master)
by Michal Kubecek <mkubecek@suse.cz>:

On Wed, 14 Dec 2022 22:13:47 -0700 you wrote:
> Add --json support for Netlink implementation of --show-coalesce option
> No changes for non-JSON output for this feature.
> 
> Example output without --json:
> [ethtool-git]$ sudo ./ethtool --show-coalesce enp9s0u2u1u2
> Coalesce parameters for enp9s0u2u1u2:
> Adaptive RX: n/a  TX: n/a
> stats-block-usecs:	n/a
> sample-interval:	n/a
> pkt-rate-low:		n/a
> pkt-rate-high:		n/a
> 
> [...]

Here is the summary with links:
  - [ethtool-next,v3,v3] JSON output support for Netlink implementation of --show-coalesce option
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=8cee2091ae2a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


