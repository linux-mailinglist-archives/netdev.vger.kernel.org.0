Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEA040AEEA
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 15:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233237AbhINNbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 09:31:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232411AbhINNbY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 09:31:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 692DD610A6;
        Tue, 14 Sep 2021 13:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631626207;
        bh=QZ6PZcqZo5v6hDeq9EAgO0uqBYCgIk7IxHYHz3gMTt0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XE6ySgr2caHuqQLCJmn9b0iFAUwFT2oVH6txvSP98wvrzpY3/hRnEgTJiyZQ8z/Qq
         +9bKZMpqxv4jT8umrS7v3H0uA0jRyJm+k3EZ5XDZGoJefnIDqaiqotj3a500/52cB4
         0N9MjS3iF29qlqA2N2BcDMH1kDOdc/jI/RAGvRytSwgH3c0vvLmcA2fqp/i9zLQ+hF
         BSHqsP5anMOriEghVanf8HQcSuTAUyS58hTgKb95noHEPyEuzOMbQ9KpQCwId/WsUf
         YCsGrnweZKvcwe2E//1dl2UGCFrj83dpVrwLXa6DNOnEcqRyLaCGDZXPYlngqw/Y53
         3IPlvYCVMaZCg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5C04B60A7D;
        Tue, 14 Sep 2021 13:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "Revert "ipv4: fix memory leaks in ip_cmsg_send()
 callers""
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163162620737.30283.9519094171883283410.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Sep 2021 13:30:07 +0000
References: <20210914051851.1056723-1-eric.dumazet@gmail.com>
In-Reply-To: <20210914051851.1056723-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 13 Sep 2021 22:18:51 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This reverts commit d7807a9adf4856171f8441f13078c33941df48ab.
> 
> As mentioned in https://lkml.org/lkml/2021/9/13/1819
> 5 years old commit 919483096bfe ("ipv4: fix memory leaks in ip_cmsg_send() callers")
> was a correct fix.
> 
> [...]

Here is the summary with links:
  - [net] Revert "Revert "ipv4: fix memory leaks in ip_cmsg_send() callers""
    https://git.kernel.org/netdev/net/c/d198b2776264

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


