Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677193BA64D
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 01:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhGBXcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 19:32:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229648AbhGBXcg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 19:32:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 53E8E61422;
        Fri,  2 Jul 2021 23:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625268603;
        bh=O+QwWPPbQm8HZaB7pCsIoDYi5c0h8/wcdUeiiILgVbg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K0OE++b+ARr5Eg4YAee4/56XNmz6UzoEhso7tyZSV1RfhXJasMC+HlhJyBSaTQuwO
         b4qpLlzSapNxgHlbgzWud54df54Qvqel+1aXFUF9eNEPBxyypoN174gpEUvHskTg2A
         Pd43kkIXadjwdn1x4G83ztuQuABaFdkOwb5HHVls66gKeVm6Auc4iSG6kkAC94KVMy
         +aiKjLZF5ab9V6WWFbhrkGgZHEqIjIDE7gH9VbXTWDxCOCYqgY2rN4JW00OeFJMDh+
         VWqRkzO+ZOVBKHirwncOm2cj8a+SrdrPZRJg+5IOLyLmrm2OKV4KExjgNE5GlnoeXq
         hWcxPI8AVEyMQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 47BCD60A4D;
        Fri,  2 Jul 2021 23:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] udp: properly flush normal packet at GRO time
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162526860328.25867.5929173667683563732.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Jul 2021 23:30:03 +0000
References: <dfd058a9a43317713bf075bbbc99b23e7f7d6fc6.1625264879.git.pabeni@redhat.com>
In-Reply-To: <dfd058a9a43317713bf075bbbc99b23e7f7d6fc6.1625264879.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org, willemb@google.com, mt@waldheinz.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat,  3 Jul 2021 00:38:43 +0200 you wrote:
> If an UDP packet enters the GRO engine but is not eligible
> for aggregation and is not targeting an UDP tunnel,
> udp_gro_receive() will not set the flush bit, and packet
> could delayed till the next napi flush.
> 
> Fix the issue ensuring non GROed packets traverse
> skb_gro_flush_final().
> 
> [...]

Here is the summary with links:
  - [net] udp: properly flush normal packet at GRO time
    https://git.kernel.org/netdev/net/c/b43c8909be52

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


