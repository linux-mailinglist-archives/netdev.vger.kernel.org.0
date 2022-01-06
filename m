Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9B44865B3
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 15:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239874AbiAFOA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 09:00:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60986 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239827AbiAFOAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 09:00:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C683161671;
        Thu,  6 Jan 2022 14:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38262C36AE0;
        Thu,  6 Jan 2022 14:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641477610;
        bh=tXw20TSMnJAfLo2/ltFm5pQ5jx8+rY8SqxALuPVcfyI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZFdocrwWQ/OVKDg3MdJAI1zzvRc4RtymBAZz1qVjZXHNFChDSqlXBXmZ1rQDvMCbY
         nSMLGEMiAl0LDF9nfG5grt8mFYlsbHWTVxPDH0U3Y+3UafPsMSHwIj+6yZVUkUWPxj
         dDIkpnfD21lQr3V6R7BodGMJXmYJUsGaGECxJc2R7gJqpsuYSN5uV4VUGZesfaGLbt
         d4L5ima+HtsHMehrInweluvF0sbK/Y036EZIZ9oBQsKv+TGNn8ecjWvdHLRk5+UUYO
         TlM9KZHBQtAFLuL+IFdHXem/ROURzPVdA7TJGWxr0LAG5SzCiPqBsdAwT/4VGvpaAr
         BZCPqw3RQs1TQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 22534F79403;
        Thu,  6 Jan 2022 14:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v5] net/smc: Reset conn->lgr when link group registration
 fails
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164147761013.14327.180691218581013319.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Jan 2022 14:00:10 +0000
References: <1641472928-55944-1-git-send-email-guwen@linux.alibaba.com>
In-Reply-To: <1641472928-55944-1-git-send-email-guwen@linux.alibaba.com>
To:     Wen Gu <guwen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  6 Jan 2022 20:42:08 +0800 you wrote:
> SMC connections might fail to be registered in a link group due to
> unable to find a usable link during its creation. As a result,
> smc_conn_create() will return a failure and most resources related
> to the connection won't be applied or initialized, such as
> conn->abort_work or conn->lnk.
> 
> If smc_conn_free() is invoked later, it will try to access the
> uninitialized resources related to the connection, thus causing
> a warning or crash.
> 
> [...]

Here is the summary with links:
  - [net,v5] net/smc: Reset conn->lgr when link group registration fails
    https://git.kernel.org/netdev/net/c/36595d8ad46d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


