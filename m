Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C835C33C7BC
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 21:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbhCOUaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 16:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229994AbhCOUaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 16:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9E5EB64F37;
        Mon, 15 Mar 2021 20:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615840208;
        bh=HtZL/GvAs+Cqa/HTWWD8yuAJ2pzl6fj5lKYgz1uOhEY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eQe0kPU2BjwU90Z97KBU5yI3cXg3aRmpN1Y9efHXRXDL9Rg1+qjHT1GgLDFKLnO0q
         wRbz08cuC7xNBC40FOtn/vHE5MHn3pbPdskumf3ehTnYq9JaaSmBrZ5lrCCKPNnAcG
         vdYyCQYL8at4SPd4gQJl52nV3U8+DXLKPWNsvtcZFPSg2dbbQ5zjHUMR9JFLHQWsc6
         R2rhwAnuy2u6ieKVCbwf1y3GuuNGKrlcj7C5iuL+isPQ+ks7bikza8hPaKIF0MAhBX
         5QlVhJLJZdEGkQTOPnJ518JzL8UHal3pNTrSQkhO9h6zoWCozuw7KmZsKWPmoG5hZ/
         Od40Ovz8gHq9g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8ABFF60A1A;
        Mon, 15 Mar 2021 20:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tipc: better validate user input in
 tipc_nl_retrieve_key()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161584020856.11795.2171913758819530741.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Mar 2021 20:30:08 +0000
References: <20210315100658.1587352-1-eric.dumazet@gmail.com>
In-Reply-To: <20210315100658.1587352-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, tuong.t.lien@dektech.com.au,
        jmaloy@redhat.com, ying.xue@windriver.com,
        syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 15 Mar 2021 03:06:58 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Before calling tipc_aead_key_size(ptr), we need to ensure
> we have enough data to dereference ptr->keylen.
> 
> We probably also want to make sure tipc_aead_key_size()
> wont overflow with malicious ptr->keylen values.
> 
> [...]

Here is the summary with links:
  - [net] tipc: better validate user input in tipc_nl_retrieve_key()
    https://git.kernel.org/netdev/net/c/0217ed2848e8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


