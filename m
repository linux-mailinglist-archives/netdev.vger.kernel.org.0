Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783C967C892
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 11:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235934AbjAZKaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 05:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjAZKaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 05:30:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9B0126D7;
        Thu, 26 Jan 2023 02:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C35E617A6;
        Thu, 26 Jan 2023 10:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F578C4339B;
        Thu, 26 Jan 2023 10:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674729017;
        bh=0m4xSwUSHrDtAFwl9N7mny3ncb3ZM5wC3GzVlLAydcY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=epPMlwZrkvma+/rONLAZU1G3PJ3gfKHMhPXWkpZGXGU829XdKk9m/lQtRyXZ/0i7S
         4U8tWdAp6djD+fkH+0JQYMmA2+U8WpuLiqqJ2VjgLwuNDOBWnxo3iP256wn/HYvVSp
         okQ5jCmuNDq4jwFCQRzDivQGeKm8bedr62m+UtnXmmFYfWf0zUM5gWsCMgrZR+q9Ju
         Gl7F0VKKqxfLuIEbmmVtkA1kRSEMB7TRmJt3/GNe1syqQV5SSxlrcfUseJs2wEnnGu
         ws9lilmZTlO2TcQ26iOfNjhG7MK2SEZ21ybz4f3IDZHh7Q+V0brRJxOFbDPNxJm6Se
         VD7Td642YBKlg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 768EAF83ED4;
        Thu, 26 Jan 2023 10:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND] icmp: Add counters for rate limits
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167472901748.7426.11311443685943262882.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Jan 2023 10:30:17 +0000
References: <273b32241e6b7fdc5c609e6f5ebc68caf3994342.1674605770.git.jamie.bainbridge@gmail.com>
In-Reply-To: <273b32241e6b7fdc5c609e6f5ebc68caf3994342.1674605770.git.jamie.bainbridge@gmail.com>
To:     Jamie Bainbridge <jamie.bainbridge@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        rawal.abhishek92@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 25 Jan 2023 11:16:52 +1100 you wrote:
> There are multiple ICMP rate limiting mechanisms:
> 
> * Global limits: net.ipv4.icmp_msgs_burst/icmp_msgs_per_sec
> * v4 per-host limits: net.ipv4.icmp_ratelimit/ratemask
> * v6 per-host limits: net.ipv6.icmp_ratelimit/ratemask
> 
> However, when ICMP output is limited, there is no way to tell
> which limit has been hit or even if the limits are responsible
> for the lack of ICMP output.
> 
> [...]

Here is the summary with links:
  - [RESEND] icmp: Add counters for rate limits
    https://git.kernel.org/netdev/net-next/c/d0941130c935

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


