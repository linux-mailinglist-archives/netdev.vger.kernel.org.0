Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADFD33B6B4E
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 01:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237038AbhF1XWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 19:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234600AbhF1XW3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 19:22:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3076F61CEF;
        Mon, 28 Jun 2021 23:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624922403;
        bh=Wu4jGFGnjl1kHgKvmAaQnp8dHjqb9QvVqHRMyqg/JUg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i7UJWgqxpDpRyocAWcdLuvPm7bBUR6tb+KqbmYVZT/36AGXlsTuJg7yax2jCYzVkx
         AG3B5lcgvM5qvsa/Up23ec+63SodGKFl0ZA7uVZtpx6KUWZWbCoRQCOpc2UY30CmrU
         Mk3EJm2o/60ZmTsdWvhtg++5FdjvRsHgp/uhRCH2TpnPqAO/BJT8K9OJwS5QcUQXwB
         71ZTQIpipmYXSUOe7o3GNryRqDOhFHeZKQ4u5HkTsltuxIHvnrXWD2z09014/KwzKd
         jrKaUL9ERwQjfeaL1MlyJhSAu/KU010dMzOFmehya/YF1vYlMk6zypUtT9/YG6GM6Z
         oKDqNetGFae3g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1F84460A56;
        Mon, 28 Jun 2021 23:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests: net: devlink_port_split: check devlink returned an
 element before dereferencing it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162492240312.3183.18165138324418989489.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Jun 2021 23:20:03 +0000
References: <20210628145424.69146-1-paolo.pisati@canonical.com>
In-Reply-To: <20210628145424.69146-1-paolo.pisati@canonical.com>
To:     Paolo Pisati <paolo.pisati@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 28 Jun 2021 16:54:24 +0200 you wrote:
> And thus avoid a Python stacktrace:
> 
> ~/linux/tools/testing/selftests/net$ ./devlink_port_split.py
> Traceback (most recent call last):
>   File "/home/linux/tools/testing/selftests/net/./devlink_port_split.py",
> line 277, in <module> main()
>   File "/home/linux/tools/testing/selftests/net/./devlink_port_split.py",
> line 242, in main
>     dev = list(devs.keys())[0]
> IndexError: list index out of range
> 
> [...]

Here is the summary with links:
  - selftests: net: devlink_port_split: check devlink returned an element before dereferencing it
    https://git.kernel.org/netdev/net/c/a118ff661889

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


