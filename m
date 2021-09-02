Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557233FEC47
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 12:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245324AbhIBKlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 06:41:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244285AbhIBKlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 06:41:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BE033610CF;
        Thu,  2 Sep 2021 10:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630579206;
        bh=nIjdRScGSWuvC1Sigc0EAEUkSB/5w2uQcuG227e7hiw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mc9yCsmAIegCag1DBNr5OcDgeg3JM7ATd1P26DlFa6TajKg3zdRr0k7IXDUnXY+Nn
         FSGCGrD+TIxZXsUX7H7LEVzJ3u27+zRDHYS8pscw3WtlNN2rQyMM+jn5r0yqHBDugJ
         4dBjmbjNk1PuTbdoTWaNLxW0e9ma/rjCPq1hKgne2ej3scYdaB/FOrccZBCT76GEEz
         qV7PuY5+alZfPvZhMFFJirnPs2NfvJASz3Yhhd1+656iEsddRyl7oEKZKMTr6dgG7O
         1QaTZd8Oa4MReKUWprf63knZ9IwuAqjfmEqBoj/a5Q7AwKmVifE+40Rn5OjjvX6bm2
         Lm5bTqFGY7Ukw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ACFEC60982;
        Thu,  2 Sep 2021 10:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: qrtr: revert check in qrtr_endpoint_post()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163057920670.13463.6345421030550581694.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Sep 2021 10:40:06 +0000
References: <20210902100851.GD2151@kadam>
In-Reply-To: <20210902100851.GD2151@kadam>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     john.stultz@linaro.org, kuba@kernel.org,
        torvalds@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, bjorn.andersson@linaro.org,
        srinivas.kandagatla@linaro.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 2 Sep 2021 13:08:51 +0300 you wrote:
> I tried to make this check stricter as a hardenning measure but it broke
> audo and wifi on these devices so revert it.
> 
> Fixes: aaa8e4922c88 ("net: qrtr: make checks in qrtr_endpoint_post() stricter")
> Reported-by: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Tested-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> 
> [...]

Here is the summary with links:
  - [net] net: qrtr: revert check in qrtr_endpoint_post()
    https://git.kernel.org/netdev/net/c/d2cabd2dc8da

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


