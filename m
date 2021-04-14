Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539C535FC78
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 22:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348355AbhDNUUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 16:20:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348332AbhDNUUb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 16:20:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0C621611AD;
        Wed, 14 Apr 2021 20:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618431610;
        bh=ziW3vgmeSl5nblZ+qGSbFNfQVB8zMCCvqQvsFgFJ1y4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TEl8qo5o/yF4D3gpOk5hmU7zbz5DbYL9JNKKC5R9BBhmQyFMKBMNG3OyyVLEq4VXZ
         nq1QLRZZu21eW5zpl6xwUz46WC45VlkTodPD4Xg9qqGDuyzDHCf0w7zS2XXW0Pd6AI
         sCYWTYuj1IMe2t51fJmlLqbQl6qwFQ+vuYsrUd5vnYnA9JRn6CjuJIl0ldRIMqJNlE
         /n6jh875gMQLVJTig3pM3S2M/upu5OlMqJoyIONv7BpxoH3yLxi153IjdLExma6qgn
         vDoVbqFN40BWCdXVHwYoASTnE0zvz6uNtbJ7RJ24Es45/Z4AFQsnn/BmsZBtE/vDLV
         f+Ws9vLNzrsMA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EFA1660CD5;
        Wed, 14 Apr 2021 20:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] doc: move seg6_flowlabel to seg6-sysctl.rst
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161843160997.15230.7001721122026016292.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Apr 2021 20:20:09 +0000
References: <20210414100027.14313-1-nicolas.dichtel@6wind.com>
In-Reply-To: <20210414100027.14313-1-nicolas.dichtel@6wind.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 14 Apr 2021 12:00:27 +0200 you wrote:
> Let's have all seg6 sysctl at the same place.
> 
> Fixes: a6dc6670cd7e ("ipv6: sr: Add documentation for seg_flowlabel sysctl")
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>  Documentation/networking/ip-sysctl.rst   | 15 ---------------
>  Documentation/networking/seg6-sysctl.rst | 13 +++++++++++++
>  2 files changed, 13 insertions(+), 15 deletions(-)

Here is the summary with links:
  - [net] doc: move seg6_flowlabel to seg6-sysctl.rst
    https://git.kernel.org/netdev/net/c/292ecd9f5a94

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


