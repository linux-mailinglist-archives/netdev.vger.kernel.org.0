Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBBC3721B8
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 22:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhECUlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 16:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229928AbhECUlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 16:41:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6B853613C3;
        Mon,  3 May 2021 20:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620074410;
        bh=gq4Sk4xGeDQacCjcHMfgI4xdKJiAF3rvZgt0PNCGEsg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VE0BKSxylv3TsTCSSN8l8+7wjKDKHJOqvtN+isev0a0UOLQrtMor2npEs+7ncB5CT
         w+9Lx1fjTB7RlGKFJlhVwB+b0a4hwRb64ZdNF1shK2/X4QSXnMaZ/QOO9D+eY1CDh6
         zPDdGGNV636PhetimJ2lZ7NPYqshNrLnaTXk7JX6LrQpGR6Ne9la1B1h7CJSJREb0n
         fJAwEkKhzeJVXFFGXedNpgByQ5GkUySOkjVUCZITziikQTUWH8ifCQTgHSHeyR4eH7
         jH9m7viXBx9n4WaE0u/fFqxFlBmjGQ52cT8v+bSTvD7vWZyM+2sEq1YuCvEPlNrij/
         cmoVxP3XMZU7g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5FDC1609D9;
        Mon,  3 May 2021 20:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: hsr: check skb can contain struct hsr_ethhdr in
 fill_frame_info
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162007441038.32677.12112313977751851037.git-patchwork-notify@kernel.org>
Date:   Mon, 03 May 2021 20:40:10 +0000
References: <20210502213442.2139-1-phil@philpotter.co.uk>
In-Reply-To: <20210502213442.2139-1-phil@philpotter.co.uk>
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     davem@davemloft.net, kuba@kernel.org, m-karicheri2@ti.com,
        olteanv@gmail.com, george.mccollister@gmail.com,
        ap420073@gmail.com, wanghai38@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun,  2 May 2021 22:34:42 +0100 you wrote:
> Check at start of fill_frame_info that the MAC header in the supplied
> skb is large enough to fit a struct hsr_ethhdr, as otherwise this is
> not a valid HSR frame. If it is too small, return an error which will
> then cause the callers to clean up the skb. Fixes a KMSAN-found
> uninit-value bug reported by syzbot at:
> https://syzkaller.appspot.com/bug?id=f7e9b601f1414f814f7602a82b6619a8d80bce3f
> 
> [...]

Here is the summary with links:
  - net: hsr: check skb can contain struct hsr_ethhdr in fill_frame_info
    https://git.kernel.org/netdev/net/c/2e9f60932a2c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


