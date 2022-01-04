Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E634841BA
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 13:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbiADMkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 07:40:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38046 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbiADMkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 07:40:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 441F16138B;
        Tue,  4 Jan 2022 12:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4F60C36AEF;
        Tue,  4 Jan 2022 12:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641300010;
        bh=E1qmSjqC/aHssBJwzDrvVpd10JpyZ01jMBr+08BO3Sc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HbvAfqFJERRXpyJN1K+xs9iXFkWM0Ob+nCmCNFmc/3apPzPcyHCfEC+ooTUtjOji3
         /OVp6GQmVH/niyzfUfUAM+hitBwvgLGOh+lprX5H2Nz0oRbFlAGmiz+ouKhgVerwta
         BTGSj0k+gCNYKtzFdSHWZ1X5uuvgP3P6lmDnQQg8vbaXq4kgeTz3yWDrmVtle3CRpA
         f9AjujCbjG/Td8X9UZ6KZYOGpgXXlo0LP9utVYONMenpktZv6G6+4CTB3//j+aege8
         vIAxlaNhbd9nTNx+z9incKWiQYuQ0VCGDaapu1mW8S33u49K+2vPn5PtF16fLXIFmu
         eNbt3w8wYCWsw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8E808F79400;
        Tue,  4 Jan 2022 12:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] netrom: fix copying in user data in nr_setsockopt
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164130001057.24992.16411426784038058921.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Jan 2022 12:40:10 +0000
References: <20220104092126.172508-1-hch@lst.de>
In-Reply-To: <20220104092126.172508-1-hch@lst.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        dan.carpenter@oracle.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  4 Jan 2022 10:21:26 +0100 you wrote:
> This code used to copy in an unsigned long worth of data before
> the sockptr_t conversion, so restore that.
> 
> Fixes: a7b75c5a8c41 ("net: pass a sockptr_t into ->setsockopt")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> [...]

Here is the summary with links:
  - netrom: fix copying in user data in nr_setsockopt
    https://git.kernel.org/netdev/net/c/3087a6f36ee0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


