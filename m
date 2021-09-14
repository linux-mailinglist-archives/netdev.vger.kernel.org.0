Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292ED40AEEB
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 15:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbhINNbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 09:31:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232420AbhINNbY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 09:31:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8591761130;
        Tue, 14 Sep 2021 13:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631626207;
        bh=ym2SvkKT/tL4iFuJ1RIroZFwy1unrvgPm+35gZ5NdmI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cxpk8MWBReHHelY+greYp/GIJeve/+DNfOjclmYGaAmHC4uybcdu5T2AgbllpbSy/
         S3wUCyCQcgrlHL5ipMaS6b7H145pdUgIUHZR3dcc+Qo+nngAb0jRxvZpHzfckq9Kdm
         llzoV6sAGgX3BSolsJAk+2/zgdYTDx4unkwdOAdGaeeCAdzojCHCX0HxBmQy0DYYKe
         vsOBwhemXHI5jIVaxWcu0YbG2enEKkE42pXwLSSuYDkHewwyLyUmlRidhARQx86Vgo
         /FktS6mn2eAqTFYm3ucAOre3hG1KZ9ojBQPU+RaYDWMgE9zYyNmNhZtchtzeY5GUVT
         b4GGr/1pWk/5Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 787B860A6F;
        Tue, 14 Sep 2021 13:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] tcp: fix tp->undo_retrans accounting in tcp_sacktag_one()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163162620748.30283.15575445260661832151.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Sep 2021 13:30:07 +0000
References: <1631584275-3075-1-git-send-email-zhenggy@chinatelecom.cn>
In-Reply-To: <1631584275-3075-1-git-send-email-zhenggy@chinatelecom.cn>
To:     zhenggy <zhenggy@chinatelecom.cn>
Cc:     ncardwell@google.com, netdev@vger.kernel.org, edumazet@google.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, ycheng@google.com, qitiepeng@chinatelecom.cn,
        wujianguo@chinatelecom.cn, liyonglong@chinatelecom.cn,
        luchang1@chinatelecom.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 14 Sep 2021 09:51:15 +0800 you wrote:
> Commit 10d3be569243 ("tcp-tso: do not split TSO packets at retransmit
> time") may directly retrans a multiple segments TSO/GSO packet without
> split, Since this commit, we can no longer assume that a retransmitted
> packet is a single segment.
> 
> This patch fixes the tp->undo_retrans accounting in tcp_sacktag_one()
> that use the actual segments(pcount) of the retransmitted packet.
> 
> [...]

Here is the summary with links:
  - [v4] tcp: fix tp->undo_retrans accounting in tcp_sacktag_one()
    https://git.kernel.org/netdev/net/c/4f884f396276

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


