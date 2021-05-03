Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4CC372206
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 22:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhECUvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 16:51:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229570AbhECUvX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 16:51:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5F3A761208;
        Mon,  3 May 2021 20:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620075029;
        bh=fJ97GBiXBXgpuJbtorAG1rQaGMw+vD4SzlSfy/AmAUY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d/Gwt3OOOljL4y0WAwu13rbzuJVGF0xM2lX2DiH1I9if621/ot1OQ/D3U85/Zk+pL
         QhvABNRQLCaVEv4qvPR65xOmtX/KvtNHphiZ2tV3V6GAP5fcsBSPXi2xr620l484RD
         bCAIh7+pPCISzX3NYR7xZnUg1RB0mFN7xIinbjAgHysEXyvdsWK3QBY/0i4G6yOXAf
         Dnyz0f9BgsWVsktMtc4zPIZECNRdFHlGkKlwOZO7u8tgP/cKl4FOKcSF0x2f83N09u
         s07maT+vFyDAKt7sTBJQvNRdxY5Py8SmYkoeQulJ2lwkSbRzK4jMxkEhynROCqH7Wc
         7nLT5ViwRBbBw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 521A760987;
        Mon,  3 May 2021 20:50:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] Documentation: ABI: sysfs-class-net-qmi: document
 pass-through file
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162007502933.7131.16427348840952087519.git-patchwork-notify@kernel.org>
Date:   Mon, 03 May 2021 20:50:29 +0000
References: <20210503151050.2570-1-dnlplm@gmail.com>
In-Reply-To: <20210503151050.2570-1-dnlplm@gmail.com>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     bjorn@mork.no, subashab@codeaurora.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  3 May 2021 17:10:50 +0200 you wrote:
> Add documentation for /sys/class/net/<iface>/qmi/pass_through
> 
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
> ---
>  Documentation/ABI/testing/sysfs-class-net-qmi | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)

Here is the summary with links:
  - [1/1] Documentation: ABI: sysfs-class-net-qmi: document pass-through file
    https://git.kernel.org/netdev/net/c/bd1af6b5fffd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


