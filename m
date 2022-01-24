Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AD3497FB7
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239539AbiAXMkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:40:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48676 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239489AbiAXMkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:40:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39B02B80F9B
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 12:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1557C340E4;
        Mon, 24 Jan 2022 12:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643028010;
        bh=owkJhEuds4SNplVqvQOfRIvkn3yPQr83IUU7Ltaup28=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JTG5h7/J+sUWj1Pz+jbQPsX3pu55KKWYTAw3k8EPLZMzQlk19xFATryto3P7pGhHR
         Yff2zn3exjtosE0UIc5NJ8+oJDPTleFk6E5FRRHA3qLqdHTZagmuTRRef2f4WJzcEk
         uRIcOIYbA5TuFP09zUFBE650WfQEj9XqWWOSFoF3xbJ538IcLctgk9+MJTlH8QYpmz
         P9mGtTRSQC2DOO7uGceeLv8YEVfbM//t7sLNLaBTNXmaQtHLwKUSgBIYm8e5wwhk7w
         OojYLx0iLF7vAjqqHhXn4j6Gtmwh7hp69SjAVqQG6JmjSgfTDGhgNzAOTpEDUo1MIk
         keHbdrfKqMEjA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D8695F6079F;
        Mon, 24 Jan 2022 12:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ping: fix the sk_bound_dev_if match in ping_lookup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164302800988.4335.2895946725154792835.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Jan 2022 12:40:09 +0000
References: <9a0135a36d3f5b14af375a23459325d7bc97bb9c.1642851656.git.lucien.xin@gmail.com>
In-Reply-To: <9a0135a36d3f5b14af375a23459325d7bc97bb9c.1642851656.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        segoon@openwall.com, liuhangbin@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 22 Jan 2022 06:40:56 -0500 you wrote:
> When 'ping' changes to use PING socket instead of RAW socket by:
> 
>    # sysctl -w net.ipv4.ping_group_range="0 100"
> 
> the selftests 'router_broadcast.sh' will fail, as such command
> 
>   # ip vrf exec vrf-h1 ping -I veth0 198.51.100.255 -b
> 
> [...]

Here is the summary with links:
  - [net] ping: fix the sk_bound_dev_if match in ping_lookup
    https://git.kernel.org/netdev/net/c/2afc3b5a31f9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


