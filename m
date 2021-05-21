Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBC638CF9E
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 23:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbhEUVLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 17:11:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhEUVLd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 17:11:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D4913613EE;
        Fri, 21 May 2021 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621631409;
        bh=7qtJ9r508lTluU2juVl/URvRzMpU9FriaYCqZ+3bPIw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mr3o5DiFDmBxUAigklIOWpKiof2tkVo3UyCqK00RMMpE8HkDQJQNLhGQiSRWNkZ6i
         RLU5PO4O92Vlks+bAqDfcuJ5q/wJn2GWqrxi/CKl10IVMLXBg4DIzME1T6rIdQvlhA
         YauPv/ZTnN+JBUx1iDCgpBINJ9fbOQwzshSGuGgDc5qpJiSCoffu58r+I+NQmZXqga
         PsNeaZD29qJiLYqARUbdjZ2BJJpnljEQvlJCWVvP1Va0xXqhNGcakXHNGFodHW7toc
         +wLd2uqXqmuGFzKF+Lc9t8wYNpJI+cYnphEIm+wpR2Hw7TzAdGWa6339LKE0+iWqtA
         cw4JPbaqZAUOQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C8B6C60A56;
        Fri, 21 May 2021 21:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: s390/net: add netdev list
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162163140981.28899.15556106989177880068.git-patchwork-notify@kernel.org>
Date:   Fri, 21 May 2021 21:10:09 +0000
References: <20210521132856.1573533-1-jwi@linux.ibm.com>
In-Reply-To: <20210521132856.1573533-1-jwi@linux.ibm.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, kgraul@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 21 May 2021 15:28:56 +0200 you wrote:
> Discussions for network-related code should include the netdev list.
> 
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - [net] MAINTAINERS: s390/net: add netdev list
    https://git.kernel.org/netdev/net/c/e5bfaed7508f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


