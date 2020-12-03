Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9742CDB6F
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 17:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387547AbgLCQkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 11:40:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:51758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731295AbgLCQkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 11:40:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607013606;
        bh=83a77g4IiIBa0MHwwIzUwdamuvcy7LL+jVYNUoNAJnc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=utwXQxTCE6+RUwSp0iwamBuz3qf+MUScILeRUtURnWaCJJVHPGDbhQlQmPz43NKUF
         580HvsuN6L+WPivZ4UKHhlbwqCWV+D/8H9N6pcrIsOJJ0jLEqL0NNtaOhegmw0yiJj
         TfpleBACfe5Dgcf4JeW8PrfkbcJLJ9vjQiuovsbkL8hdXX4CRY98pL+Adz+HixPlCG
         p86cM2ImohiHNvAA4O5x2k70zJY7AwzwoENTX51no9dCMgWVV6mBUej5PXRvEo+ofT
         V5d7PcCtAZvYuhKFWrvPv8z4b8CxfXx5Xz9yi3cmsk1GSz2d49Iqoq/zISrpQeBJ4U
         6QnhgVTefMpAA==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] tc/mqprio: json-ify output
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160701360648.5193.7072312580742548786.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Dec 2020 16:40:06 +0000
References: <20201202170845.248008-1-luca.boccassi@gmail.com>
In-Reply-To: <20201202170845.248008-1-luca.boccassi@gmail.com>
To:     Luca Boccassi <luca.boccassi@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (refs/heads/main):

On Wed,  2 Dec 2020 17:08:45 +0000 you wrote:
> From: Luca Boccassi <bluca@debian.org>
> 
> As reported by a Debian user, mqprio output in json mode is
> invalid:
> 
> {
>      "kind": "mqprio",
>      "handle": "8021:",
>      "dev": "enp1s0f0",
>      "root": true,
>      "options": { tc 2 map 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0
>           queues:(0:3) (4:7)
>           mode:channel
>           shaper:dcb}
> }
> 
> [...]

Here is the summary with links:
  - [v3] tc/mqprio: json-ify output
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=755b1c584eee

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


