Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977D7301897
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 22:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbhAWVlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 16:41:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:56884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbhAWVku (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 16:40:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DBAC5225A9;
        Sat, 23 Jan 2021 21:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611438009;
        bh=SNlJdZcc6Aud/IzxpHGsU9+qqBlCX3OrB/t9yNERZdk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bC7qx1FYz943EKhQIunds/WHCSznIYeuIZ7DUED/+Rk1KwgF6v6Q2MkojtJMY3qGa
         iZMo7Qn+GhRdAFgPkuVj/cVhdgk8DL2zhJAgUtIsPeL0q3aaRMHnZQMEb897hf9WLM
         ojeIVyGaiBLy7nXWX8Y+g5ICLNCAZjXD6WjQGjkghgkcc3rAidtFmCBokSAh3gwQ30
         nPerlAiYku5toyp7SDEN7iJScEV4QrVSfsyKjdDikGWGCX64Hy8JSBNkydnkeBk8vq
         5RGLpApyJzNezn18LAStHD8zZ5KmdGxzm9CyjOXTqmcVy1VJKo8ICDpeawE2Dcka7u
         ML02MUmfmVIWw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CC23F652E1;
        Sat, 23 Jan 2021 21:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] doc: networking: ip-sysctl: Document conf/all/disable_ipv6
 and conf/default/disable_ipv6
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161143800982.9404.6249176590747440979.git-patchwork-notify@kernel.org>
Date:   Sat, 23 Jan 2021 21:40:09 +0000
References: <20210121150244.20483-1-pali@kernel.org>
In-Reply-To: <20210121150244.20483-1-pali@kernel.org>
To:     =?utf-8?b?UGFsaSBSb2jDoXIgPHBhbGlAa2VybmVsLm9yZz4=?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 21 Jan 2021 16:02:44 +0100 you wrote:
> This patch adds documentation for sysctl conf/all/disable_ipv6 and
> conf/default/disable_ipv6 settings which is currently missing.
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> ---
>  Documentation/networking/ip-sysctl.rst | 12 ++++++++++++
>  1 file changed, 12 insertions(+)

Here is the summary with links:
  - doc: networking: ip-sysctl: Document conf/all/disable_ipv6 and conf/default/disable_ipv6
    https://git.kernel.org/netdev/net/c/fc024c5c07aa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


