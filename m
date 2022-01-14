Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF9948E926
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 12:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240804AbiANLaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 06:30:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52978 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbiANLaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 06:30:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7606C61F15;
        Fri, 14 Jan 2022 11:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C6D44C36AF4;
        Fri, 14 Jan 2022 11:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642159810;
        bh=rULjxzkiXqPAXqFsnEPUzq2HriQyRVhf6KcpST4HMbg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W/fSQyTV2Eq0Bdv40FDq0AL8rqK60fghlU0k8YR5EQrbExiqu96DXHlEK03dcwPZ5
         q5Zbr4tSyuAdMB8OyWLy6XrDZ2Qgtnj2WYR4FrJUFtrb325SvaqwQcKfUPTtUb1TGA
         D+mWxHXFJMrWCw+6Py1L1/4vrb1nd4zeSMqH16Bpstgq+Ca7HP9Rs7KNwhqWMIGrS/
         llVitxPHbdoaODKn7jXdA4L9tsN5GAGW3fGax2tWufvjr/oEoWdsnqpWkw7H8O+Z3p
         zGrl1R850QXVb5Kig7sLSPD0Q7yrF6QmiDZO5sshDGxqCBsrTNEE871PYTQHiwTZN8
         CgCGrPPXSgM7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 84695F6079D;
        Fri, 14 Jan 2022 11:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] lib82596: Fix IRQ check in sni_82596_probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164215981053.30922.8077951298767216747.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Jan 2022 11:30:10 +0000
References: <20220114065727.22920-1-linmq006@gmail.com>
In-Reply-To: <20220114065727.22920-1-linmq006@gmail.com>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jeffrey.t.kirsher@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 14 Jan 2022 06:57:24 +0000 you wrote:
> platform_get_irq() returns negative error number instead 0 on failure.
> And the doc of platform_get_irq() provides a usage example:
> 
>     int irq = platform_get_irq(pdev, 0);
>     if (irq < 0)
>         return irq;
> 
> [...]

Here is the summary with links:
  - lib82596: Fix IRQ check in sni_82596_probe
    https://git.kernel.org/netdev/net/c/99218cbf81bf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


