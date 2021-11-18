Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87941455AF0
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344249AbhKRLyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:54:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:36004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344348AbhKRLxJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 06:53:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 400E461108;
        Thu, 18 Nov 2021 11:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637236209;
        bh=NYXsHSj9PHtXZQN0iPC8T9b/KBiBOhIM6rsNnNDem/A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OQA00w95Q4u+LTDDSLzRrWV6ropQZHNXuEtSJyqm+ewlyZ3jaicwLtVTisg1lY7wt
         17UIGhLkquEc7ypq046k/z+Ti5OO3K7vZI/oj3Kt5t/EnFYvHgeGkOx1x+aKW9ktyp
         n7RwLKFFHc1X87oAH+ClZZ7hDmk5lyo0NLTfm3djh1Sh2Ixq8FFA79z5/jy0K/7jeU
         05OdE8Iom405s6G6HVTWK+JLvTviiIcsW0LiVQoqtOrd3uWQFV1ESMkC37Kct6dUnF
         EEwDpq0k9FRgFWPUQB2ntPzZ9+4neu7wCNX+cL08l3SF1FUuuO28mbLDNE/zFIvxok
         v5yu2iVcV3Q4A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 315CB60A94;
        Thu, 18 Nov 2021 11:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] ipv6: check return value of ipv6_skip_exthdr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163723620919.17258.7739860306001029002.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Nov 2021 11:50:09 +0000
References: <20211117190648.2732560-1-jordy@pwning.systems>
In-Reply-To: <20211117190648.2732560-1-jordy@pwning.systems>
To:     Jordy Zomer <jordy@pwning.systems>
Cc:     linux-kernel@vger.kernel.org, keescook@chromium.org,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 17 Nov 2021 20:06:48 +0100 you wrote:
> The offset value is used in pointer math on skb->data.
> Since ipv6_skip_exthdr may return -1 the pointer to uh and th
> may not point to the actual udp and tcp headers and potentially
> overwrite other stuff. This is why I think this should be checked.
> 
> EDIT:  added {}'s, thanks Kees
> 
> [...]

Here is the summary with links:
  - [v2] ipv6: check return value of ipv6_skip_exthdr
    https://git.kernel.org/netdev/net/c/5f9c55c8066b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


