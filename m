Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2CB144625F
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 11:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbhKEKws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 06:52:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231642AbhKEKwr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 06:52:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F13A26124A;
        Fri,  5 Nov 2021 10:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636109408;
        bh=PEbAx5J23QwyAPFh+r1xwhp+zPTVbSStfq79iDXgTao=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KJpEQ91h9wDJQzsIU4auifDCO0ji2s9VYiYHn8Iaen8f+6tBlzijpSFE+FtQ3Hi2E
         0aJ35HcvIa6mRccEC0zca1kuBOZMUusHlOdMmhD73UY4D25ZAy1STWk298Ll6pW0aB
         4SVjU7Aw0/euQOaTOTZDm7XyL0jWmTO/MGHiTE9EYw66yFXVMtaFVu3Ovka8+pLe+Q
         B/oLb8/BtJa/gyJLqrbsjvYxpp8/bHESHKqbQdWb/uwcfyPyXrCbss1H+1pngLzcbl
         M0CuVQiaNivloiDFWiZKebDT/2Rar2QE/5dk4o976uVEJl5Lf6YCifr/k09zNv8k6T
         4HfvwZj/6FYJg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DF3DE60A0E;
        Fri,  5 Nov 2021 10:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: udp: correct the document for udp_mem
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163610940791.24664.10352541983010508425.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Nov 2021 10:50:07 +0000
References: <20211105073541.2981935-1-imagedong@tencent.com>
In-Reply-To: <20211105073541.2981935-1-imagedong@tencent.com>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, corbet@lwn.net,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, imagedong@tencent.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  5 Nov 2021 15:35:41 +0800 you wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> udp_mem is a vector of 3 INTEGERs, which is used to limit the number of
> pages allowed for queueing by all UDP sockets.
> 
> However, sk_has_memory_pressure() in __sk_mem_raise_allocated() always
> return false for udp, as memory pressure is not supported by udp, which
> means that __sk_mem_raise_allocated() will fail once pages allocated
> for udp socket exceeds udp_mem[0].
> 
> [...]

Here is the summary with links:
  - [net-next] net: udp: correct the document for udp_mem
    https://git.kernel.org/netdev/net/c/69dfccbc1186

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


