Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EDC39EB00
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 02:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhFHAv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 20:51:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230266AbhFHAvz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 20:51:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6C0BB6124B;
        Tue,  8 Jun 2021 00:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623113403;
        bh=5lQhCmnd0rMcXv2s8T06Jtf+pffwF6DFgGQ48nbOz7o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GMvtnp3B5aYSaed/iIZim6/KUYk89tosbX23HWGXTCvSZKDE2x1xCHPySad1T3xYp
         9GBldXvbpz2OxjfO0a4KOhZ5ryW0XBpWIz5ziUwjjtrjmN3XmXgIyNDbFwK1iMMzCF
         KTHnxRhg0kzMj8C0EwxYyj4w61fwnlFKHhpdlQcq1WO70ZOFnVjN0z6Yy7REK0/hUq
         q98Q1HUvW6ZXy/LltwMJ0i7FNeMnjUh3YWorfaEGY6punOQ1BMkmAkz3YzFBiYrXmN
         lVXKJ885G8bgEExQisWPl6bpyqjZDUSvkh1PjAjUiIrOAAj2ufQCVZA5LZ4yOqzkES
         TkhqgY9N4tkGw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5B71E60A1B;
        Tue,  8 Jun 2021 00:50:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] libbpf: Fixes incorrect rx_ring_setup_done
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162311340336.30910.107622073412741714.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 00:50:03 +0000
References: <YL4aU4f3Aaik7CN0@linux-dev>
In-Reply-To: <YL4aU4f3Aaik7CN0@linux-dev>
To:     Kev Jackson <foamdino@gmail.com>
Cc:     bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Mon, 7 Jun 2021 14:08:35 +0100 you wrote:
> When calling xsk_socket__create_shared(), the logic at line 1097 marks a
> boolean flag true within the xsk_umem structure to track setup progress
> in order to support multiple calls to the function.  However, instead of
> marking umem->tx_ring_setup_done, the code incorrectly sets
> umem->rx_ring_setup_done.  This leads to improper behaviour when
> creating and destroying xsk and umem structures.
> 
> [...]

Here is the summary with links:
  - libbpf: Fixes incorrect rx_ring_setup_done
    https://git.kernel.org/bpf/bpf/c/11fc79fc9f2e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


