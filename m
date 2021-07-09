Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDBFC3C290A
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 20:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhGIScz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 14:32:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229535AbhGISct (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 14:32:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0C308613DC;
        Fri,  9 Jul 2021 18:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625855405;
        bh=pI+sUYmx25U0SZSY5824E5PTW7jpIRRPAGsQ1WWsjhw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q5VFmxDLUrZbIpThSEc/sLgxdszS2XTWle2//Th4opfVB7To0mejs4oOVpFEj8rVp
         ZKc2G3mYZICJFzHbIrgkYSSt5FifmfjMetzJLcn2MKiOQsayY3WQCt1qxGB2Hyh7Of
         j7prNzGA81xtSErDupC486Qmq5zyShJNItegCMKMhiZi7ER4ypGPKJ9inekZXlYtKL
         nB2DQhC9aGXDR+aKjYaWD5vhcSB3YklV8yMEkmgo+WDNpapNb9MbKqiMDJV1VW9Jau
         jLspDWxhBpMolGjh3R97zoJsk0e29/BElCLFmLq+fKaQ41NbxIAGW5iSaiDtcZFMhR
         5yr05JXciY7/Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ED267609F6;
        Fri,  9 Jul 2021 18:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: do not reuse skbuff allocated from
 skbuff_fclone_cache in the skb cache
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162585540496.20680.4902965434925648962.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Jul 2021 18:30:04 +0000
References: <20210709161609.725717-1-atenart@kernel.org>
In-Reply-To: <20210709161609.725717-1-atenart@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, alobakin@pm.me
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  9 Jul 2021 18:16:09 +0200 you wrote:
> Some socket buffers allocated in the fclone cache (in __alloc_skb) can
> end-up in the following path[1]:
> 
> napi_skb_finish
>   __kfree_skb_defer
>     napi_skb_cache_put
> 
> [...]

Here is the summary with links:
  - [net] net: do not reuse skbuff allocated from skbuff_fclone_cache in the skb cache
    https://git.kernel.org/netdev/net/c/28b34f01a734

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


