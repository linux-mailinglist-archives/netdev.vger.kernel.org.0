Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE6741AED2
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240735AbhI1MVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:21:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240542AbhI1MVr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:21:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EDE7F61215;
        Tue, 28 Sep 2021 12:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632831608;
        bh=vG2qww7/fBaTcUIO9cayzJ306WRf/XafF7x+qnpkPEE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iRHFsZm87ReU34CkEjqv4pnOm4p5NmYzhmqLNHh3GB7CoQHFeNk+CU4YJoX2jbKst
         vwqWPNLBIkeNxKXUFp7LgFvjDUxH6ue0cSjmA7wYKGVT+vO+JAbWqGprYIJhc8gCf8
         CNNEyeig5tuUUwypFHxf+ByaBqSkJqukU2/1zZIUMCpryzcTQ4AsweDJSoT1QPq8SP
         /gA5RtCzGD+vzknvUITk8wP6K3YxJSXgOjPueqUm5dPD1cku9cjxok/tfKJ5DQwN5x
         5sQ/21+3B0xt0FpoTsuAL2wuTJougFk3egFPy6YaZtroWekcBDwEhrNhXN4wWCAs0+
         XrFvayPi20QxQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E695260A59;
        Tue, 28 Sep 2021 12:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] net: ipv6: squash $(ipv6-offload) in Makefile
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163283160793.2416.14163196262208999918.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Sep 2021 12:20:07 +0000
References: <20210927142840.13286-1-masahiroy@kernel.org>
In-Reply-To: <20210927142840.13286-1-masahiroy@kernel.org>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 27 Sep 2021 23:28:39 +0900 you wrote:
> Assign the objects directly to obj-$(CONFIG_INET).
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> ---
> 
>  net/ipv6/Makefile | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [1/2] net: ipv6: squash $(ipv6-offload) in Makefile
    https://git.kernel.org/netdev/net-next/c/9a1213849a94
  - [2/2] net: ipv6: use ipv6-y directly instead of ipv6-objs
    https://git.kernel.org/netdev/net-next/c/1817750bdc67

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


