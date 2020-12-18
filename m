Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27892DE66F
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 16:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgLRPUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 10:20:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:58056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbgLRPUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 10:20:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608304807;
        bh=g6D5ZnRkhaQpRS+4nSgdXFSGEN+4woAT0V40kommTBI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oqR3tUcI3jlesACqpu+izO7NiuO2OobE3vzq1AxNIIR1h/fkgkzP7PPUxF9LV8LES
         hay31DlLfHNqyLt+Inm7AmYrrS9Vkd6ztbFUH6q1m2SQ06npSlu0PzRVdWfW/0Fbrh
         axck9hsFBFPkTGwZEgJeL4x/DgCN9ILC+ea7z2VU6uRAeO7txk+E77/GkHJvzqlfyX
         sh8Mn/GufFZtXMNjy8LV+cwtWgkLQAtCcIwKErPPtM+uIx1sTOdnP4Ou9rlUcSc6sX
         XI+ngIvye+gBHbCUsfHO1l/aLCb+oiR6k6rao7KEGTYNw0uAKpLSGyy/aB7C/Wsoqo
         efXNGyEUflhkA==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v2 0/2] xsk: fix two bugs in the SKB Tx path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160830480688.29956.160488544592910110.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Dec 2020 15:20:06 +0000
References: <20201218134525.13119-1-magnus.karlsson@gmail.com>
In-Reply-To: <20201218134525.13119-1-magnus.karlsson@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        A.Zema@falconvsystems.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf.git (refs/heads/master):

On Fri, 18 Dec 2020 14:45:23 +0100 you wrote:
> This patch set contains two bug fixes to the Tx SKB path. Details can
> be found in the individual commit messages. Special thanks to Xuan
> Zhuo for spotting both of them.
> 
> v1 -> v2:
> * Rebase
> 
> [...]

Here is the summary with links:
  - [bpf,v2,1/2] xsk: fix race in SKB mode transmit with shared cq
    https://git.kernel.org/bpf/bpf/c/f09ced4053bc
  - [bpf,v2,2/2] xsk: rollback reservation at NETDEV_TX_BUSY
    https://git.kernel.org/bpf/bpf/c/b1b95cb5c0a9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


