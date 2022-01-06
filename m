Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23698486586
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 14:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239722AbiAFNuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 08:50:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56170 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239275AbiAFNuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 08:50:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A44661C14;
        Thu,  6 Jan 2022 13:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 930B6C36AED;
        Thu,  6 Jan 2022 13:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641477009;
        bh=Fwbo2yecLmp9uAeJ+cM83JzgCwQAI2o2P3vL8OnRblA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TlWqevPeTn86bi2sNLMOmtX6HvAfBe0Bg2sMa2+KddatFzdFDitTGQKipbQkO6pEz
         uLwt1OT4ARJICMEA2Ez9+x21nE5eagdGOUB1+b71EnTL8u4FvXLU5ZJq8M6lL5YetN
         RqRsBEXt68lIoRz15zIFd94SyF1d5auKmn1tUFk0LjabIFiVML+xCvHnUGLdOan+/3
         RFZQoUPz6SYov2hnUnciSkxOdSHQ7mIWY0EDJELR+DXKzve6UAPj+Q+mU21EZdzWDY
         iiqCFpefbaua1i0NyMz+ArGFHkS/eGf+iI5hgvkJPpTNrUVitzpQv9nqXIkeRP+H+5
         JT8wEnJQjeg9g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 77BADF7940B;
        Thu,  6 Jan 2022 13:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rocker: fix a sleeping in atomic bug
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164147700948.9137.13562727639638310210.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Jan 2022 13:50:09 +0000
References: <20220106115754.GB28590@kili>
In-Reply-To: <20220106115754.GB28590@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     jiri@resnulli.us, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 6 Jan 2022 14:57:54 +0300 you wrote:
> This code is holding the &ofdpa->flow_tbl_lock spinlock so it is not
> allowed to sleep.  That means we have to pass the OFDPA_OP_FLAG_NOWAIT
> flag to ofdpa_flow_tbl_del().
> 
> Fixes: 936bd486564a ("rocker: use FIB notifications instead of switchdev calls")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> [...]

Here is the summary with links:
  - [net] rocker: fix a sleeping in atomic bug
    https://git.kernel.org/netdev/net/c/43d012123122

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


