Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147CD2FAF48
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 05:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbhASEBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 23:01:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:60274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728722AbhASEA6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 23:00:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2F59A22ADF;
        Tue, 19 Jan 2021 04:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611028809;
        bh=dOQ6zhkwBv3m3dvXgJFPusi/j91ebRkRHmxwRp51YvM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i+tuV879nYnnRgu2q2QViJ5+7ko7Ziv5vwSjc4DUZ3q4jf/QOp9ay5t+qVPW0qEJK
         MHu5N/LCmovorUEPRUvsmfBeP/9u8e8EU/7dxk4rFx1iYLFPZGdd5CPkMyJ6twfDuS
         Ph24MoZV5VeEpsN7LCYJlqDLacBUMczA1RVaLdYWd2Qb19y3vIwo9zCHrQaNi3QEDo
         ex8UcR/6PI9jBWhwQHxWVtLkKhxYaOBo635HBhljmwVZrkDL7RX2fL5Assc+KUMkAV
         zDrkkOnNgBFvoXWn3JTlsrPnSPd+xPDh/tNhlSkUJJZ81fGoyeKWbI9ADcMmFIj9pJ
         LZrZgqPiX7wbg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 26B026036C;
        Tue, 19 Jan 2021 04:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] hv_netvsc: Add (more) validation for untrusted Hyper-V
 values
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161102880915.24762.9624432085976985112.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jan 2021 04:00:09 +0000
References: <20210114202628.119541-1-parri.andrea@gmail.com>
In-Reply-To: <20210114202628.119541-1-parri.andrea@gmail.com>
To:     Andrea Parri <parri.andrea@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        mikelley@microsoft.com, skarade@microsoft.com,
        juvazq@microsoft.com, linux-hyperv@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 14 Jan 2021 21:26:28 +0100 you wrote:
> For additional robustness in the face of Hyper-V errors or malicious
> behavior, validate all values that originate from packets that Hyper-V
> has sent to the guest.  Ensure that invalid values cannot cause indexing
> off the end of an array, or subvert an existing validation via integer
> overflow.  Ensure that outgoing packets do not have any leftover guest
> memory that has not been zeroed out.
> 
> [...]

Here is the summary with links:
  - [v2] hv_netvsc: Add (more) validation for untrusted Hyper-V values
    https://git.kernel.org/netdev/net-next/c/505e3f00c3f3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


