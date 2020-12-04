Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79742CF4F5
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 20:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbgLDTk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 14:40:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:33008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgLDTk6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 14:40:58 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607110817;
        bh=rNDuMN1MmYiK1tAGoQ1k6iGiCCGFLolAECzOm9LjZhE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F1gkrMO0URllU+rs/1VuwRA3kVx7iUimHinDIYjJy08ftSbiMUgEM3gD+/UlyU1BT
         YjVCbT8MhowFefZSLnSbdIJxqVS7653EJZM9BfCW2H8G5+uMPCssf57pP0yiNNGm21
         xUN1buGZ1EraWvpVRJ6Q071vVjW2G0m2hr7D4ZGTO0MO1gUiziiCQZhRGfJkj3np6+
         OVFEgOll+kpbuTcSZMi8qubabvkpXYOrymKwxDjf+Hkg4pk6k8EE0sLQaz6886T7CF
         mBAuLjao2Ixi9nRr2SSggqC1NrrqGkYVD5zr/wrDJjyY6mNcI6IPLGMoChbCTFrF5K
         sxiQH7edbXhog==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] bpf: remove trailing semicolon in macro definition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160711081762.29539.3695576818249759103.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Dec 2020 19:40:17 +0000
References: <20201202212810.3774614-1-trix@redhat.com>
In-Reply-To: <20201202212810.3774614-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Wed,  2 Dec 2020 13:28:10 -0800 you wrote:
> From: Tom Rix <trix@redhat.com>
> 
> The macro use will already have a semicolon.
> Clean up escaped newlines
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> 
> [...]

Here is the summary with links:
  - [v2] bpf: remove trailing semicolon in macro definition
    https://git.kernel.org/bpf/bpf-next/c/2fa3515cc0d3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


