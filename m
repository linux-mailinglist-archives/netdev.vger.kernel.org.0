Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D07444076
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 12:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbhKCLWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 07:22:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231405AbhKCLWp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 07:22:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 150E2610FD;
        Wed,  3 Nov 2021 11:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635938409;
        bh=RD8qpeEQNqs1IHHBUt5tXBWknLg0tITMb7Ekd/jXwF4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PIK4Y7+M8VJq+RYSCNOoCdFXf/v9STgJP/8ieN/kcaGszhoTpw0Fo1KnRt38E+6zc
         QXii2cBiK0gM1znaS6qctsiUV3duuiNgVAmn47/Mo0P4akaJFz4UgnbQUU9QqoSVgV
         /Rref0LRPRR4Yq9KcgfB+S3anWdA/sIUwkmgGuEfo7tszLZie1A0z52L9ALQymBNRQ
         KRRhncJuQQ5qg5lnv9hRESN8parhwG+ARbn8iOqvoIyR9W/g3ov90sdpMghmwQX9ys
         anRbltOFUwcKksJmWm/ndDnehUrEtjktY3Z2nQKjVB96qtQ65iz/hgP1mB+SQwcCtt
         VzgIICS5MZ5/w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0816F609D9;
        Wed,  3 Nov 2021 11:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 net 0/4] security: fixups for the security hooks in sctp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163593840902.17756.9280314114933444317.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Nov 2021 11:20:09 +0000
References: <cover.1635854268.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1635854268.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, marcelo.leitner@gmail.com,
        jmorris@namei.org, paul@paul-moore.com,
        richard_c_haines@btinternet.com, omosnace@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  2 Nov 2021 08:02:46 -0400 you wrote:
> There are a couple of problems in the currect security hooks in sctp:
> 
> 1. The hooks incorrectly treat sctp_endpoint in SCTP as request_sock in
>    TCP, while it's in fact no more than an extension of the sock, and
>    represents the local host. It is created when sock is created, not
>    when a conn request comes. sctp_association is actually the correct
>    one to represent the connection, and created when a conn request
>    arrives.
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net,1/4] security: pass asoc to sctp_assoc_request and sctp_sk_clone
    https://git.kernel.org/netdev/net/c/c081d53f97a1
  - [PATCHv2,net,2/4] security: call security_sctp_assoc_request in sctp_sf_do_5_1D_ce
    https://git.kernel.org/netdev/net/c/e215dab1c490
  - [PATCHv2,net,3/4] security: add sctp_assoc_established hook
    https://git.kernel.org/netdev/net/c/7c2ef0240e6a
  - [PATCHv2,net,4/4] security: implement sctp_assoc_established hook in selinux
    https://git.kernel.org/netdev/net/c/e7310c94024c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


