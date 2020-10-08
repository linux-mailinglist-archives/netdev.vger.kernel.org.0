Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E981C287CBD
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 22:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbgJHUA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 16:00:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729432AbgJHUAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 16:00:05 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602187205;
        bh=nXUrNRBpVCg9rQTK16D1Yz1BLRydEY/9kJh9Qa+V3Ik=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ptdWHoocbrDBRk8MDIEVHLBulfn1u5Eemq0k59bI6fHeSwaEhHTJRHWeTbEDsgyOn
         R07bibP+9VqprcSTbXYqwKf+fQS6+Xsrs9zKvwgc3Ero2++8Oog2UsYRMubA0AhTYG
         SWxRv7U1freQL/1EHJhTkTtlv7gxIcDO80EBjiFk=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: fix sctp_auth_init_hmacs() error path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160218720508.8125.9469723637272631712.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Oct 2020 20:00:05 +0000
References: <20201008083831.521769-1-eric.dumazet@gmail.com>
In-Reply-To: <20201008083831.521769-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  8 Oct 2020 01:38:31 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> After freeing ep->auth_hmacs we have to clear the pointer
> or risk use-after-free as reported by syzbot:
> 
> BUG: KASAN: use-after-free in sctp_auth_destroy_hmacs net/sctp/auth.c:509 [inline]
> BUG: KASAN: use-after-free in sctp_auth_destroy_hmacs net/sctp/auth.c:501 [inline]
> BUG: KASAN: use-after-free in sctp_auth_free+0x17e/0x1d0 net/sctp/auth.c:1070
> Read of size 8 at addr ffff8880a8ff52c0 by task syz-executor941/6874
> 
> [...]

Here is the summary with links:
  - [net] sctp: fix sctp_auth_init_hmacs() error path
    https://git.kernel.org/netdev/net/c/d42ee76ecb6c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


