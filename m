Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11693CC01C
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 02:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhGQAdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 20:33:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231588AbhGQAdB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 20:33:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EBF21613F3;
        Sat, 17 Jul 2021 00:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626481806;
        bh=coH/5I0XOC6QEqrNv+snKkc3OfItvztthnGBJdEh4bU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LAXNiitbBzbXL0jlRgP/CaePmyIYnjsBr6lfRdO+xU44J5f/KpogbtzMusWLld6Yk
         36DSVbo26UCaTZRrFl1cQWEr6n5Tq3DtKdav1doKpaAXgn8xcKyoG0dR1TdxTfJ1s/
         h6XKbBgF+4cC7xgdDA5xlnKkGkCtTfXqXHWlJo4WtrveI4PGuVUMO8khglanL7clef
         CfK7lKrHILWY9Op1NeKRqhfITXBXzQU97WvCTMHmCV2UV2ClhsKQaoaec0nVJWm1Bi
         2BNixSsTpwnYS3EXjhqO81kl+8+Bgg73M2z5fepQeyklqBEAuCQRdfacRxKH02Zjsj
         XkdEWRjoon4pQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E09B360ACA;
        Sat, 17 Jul 2021 00:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tipc: keep the skb in rcv queue until the whole data
 is read
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162648180591.17758.8670370662568415469.git-patchwork-notify@kernel.org>
Date:   Sat, 17 Jul 2021 00:30:05 +0000
References: <57cb295272cdeedec04ac2f920a1fd37446163c6.1626471847.git.lucien.xin@gmail.com>
In-Reply-To: <57cb295272cdeedec04ac2f920a1fd37446163c6.1626471847.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jmaloy@redhat.com, tipc-discussion@lists.sourceforge.net,
        erin.shepherd@e43.eu
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 16 Jul 2021 17:44:07 -0400 you wrote:
> Currently, when userspace reads a datagram with a buffer that is
> smaller than this datagram, the data will be truncated and only
> part of it can be received by users. It doesn't seem right that
> users don't know the datagram size and have to use a huge buffer
> to read it to avoid the truncation.
> 
> This patch to fix it by keeping the skb in rcv queue until the
> whole data is read by users. Only the last msg of the datagram
> will be marked with MSG_EOR, just as TCP/SCTP does.
> 
> [...]

Here is the summary with links:
  - [net-next] tipc: keep the skb in rcv queue until the whole data is read
    https://git.kernel.org/netdev/net-next/c/f4919ff59c28

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


