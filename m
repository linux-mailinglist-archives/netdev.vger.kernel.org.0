Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B916C482BE7
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 17:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbiABQUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 11:20:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49604 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233341AbiABQUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 11:20:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33226B80DB7;
        Sun,  2 Jan 2022 16:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E35BBC36AF4;
        Sun,  2 Jan 2022 16:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641140409;
        bh=LFPdMZ/ubkBr7uyX7kzJTw9/g6V5SxfeW4zWOrPcKtQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WhCpS7G4XljrfoNL661wOzFC6fBsG/coHBx5jx9bb/gTWY51/TdVMqFTrrKOP8Iwp
         Hl9unTquyszscFUcTwgJZySQBI02aBpsY9qC0UKCMTLM+NAtd/jxKQfPnevzkDVypY
         fCJkOoUEQ9XDPrRBg6hF9IFrXydAdooxO+J33QtCUszPU/uKF6Sl6ktJrlNJIc6jDN
         msEqv4tW5XpVe/vMwqZPR+5Es5qMD1YfLKfF+o6VUzAxKCMnuGQdkOLTrdp1WDkH50
         ILyjzj5oC5OP8gW3z06ZKAdp7kZtsSSkIqE9YBa9QsYVYJqvrfqLxO+apte97LBKB8
         /Nq2tiYTxulBA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C8526C395EB;
        Sun,  2 Jan 2022 16:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: add comments for smc_link_{usable|sendable}
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164114040981.20715.13036176120282476805.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Jan 2022 16:20:09 +0000
References: <20211231060853.8106-1-dust.li@linux.alibaba.com>
In-Reply-To: <20211231060853.8106-1-dust.li@linux.alibaba.com>
To:     Dust Li <dust.li@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        guwen@linux.alibaba.com, tonylu@linux.alibaba.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 31 Dec 2021 14:08:53 +0800 you wrote:
> Add comments for both smc_link_sendable() and smc_link_usable()
> to help better distinguish and use them.
> 
> No function changes.
> 
> Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - [net] net/smc: add comments for smc_link_{usable|sendable}
    https://git.kernel.org/netdev/net-next/c/1f52a9380ff1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


