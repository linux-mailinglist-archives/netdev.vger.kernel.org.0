Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7AE331B405
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 02:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhBOBk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 20:40:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229642AbhBOBku (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Feb 2021 20:40:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DF3B664E2C;
        Mon, 15 Feb 2021 01:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613353209;
        bh=ve+NQqn6Mi39Sd04Al3f7gT3XBa4tVzFkaI+WucCvlA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O+E+k6XM3L/hJYJx6cO9lLNI/arAqvjKdqRgX9SY8L8YwK3XZvbbfqPGRbPyeIk5C
         rHJZEmOb9CKLlyZNdGt7mmZ0CWZp+FPAknlXVmPAz21EvQOsJWhrROmDM5dC+xL+Eq
         QGcy/S18aC+7PeY03tDFhC4ukbUMgggakyAbuDom5TAx+CEFymhRinyRxzViDJJj19
         Xx9fG2P5HgTNopXxbOfO6eaTM8bhOUspWCQZOt0S8I9393IFntSvxk5pE9BnByMuC9
         B3DKbMSoLLFeLOfDCVF5U1Gsg3bEQ/DL7augREZAB9X2T9nf+kh/Mqk/0/bgEov3t7
         LOoLb+GDMmHTw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CC15E60A4A;
        Mon, 15 Feb 2021 01:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] bnxt_en: Error recovery optimizations.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161335320983.7007.839275812277589242.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 01:40:09 +0000
References: <1613343901-6629-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1613343901-6629-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 14 Feb 2021 18:04:54 -0500 you wrote:
> This series implements some optimizations to error recovery.  One
> patch adds an echo/reply mechanism with firmware to enhance error
> detection.  The other patches speed up the recovery process by
> polling config space earlier and to selectively initialize
> context memory during re-initialization.
> 
> Edwin Peer (1):
>   bnxt_en: selectively allocate context memories
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] bnxt_en: Update firmware interface spec to 1.10.2.16.
    https://git.kernel.org/netdev/net-next/c/31f67c2ee055
  - [net-next,2/7] bnxt_en: selectively allocate context memories
    https://git.kernel.org/netdev/net-next/c/be6d755f3d0c
  - [net-next,3/7] bnxt_en: Implement faster recovery for firmware fatal error.
    https://git.kernel.org/netdev/net-next/c/dab62e7c2de7
  - [net-next,4/7] bnxt_en: Add context memory initialization infrastructure.
    https://git.kernel.org/netdev/net-next/c/e9696ff33c79
  - [net-next,5/7] bnxt_en: Initialize "context kind" field for context memory blocks.
    https://git.kernel.org/netdev/net-next/c/41435c394000
  - [net-next,6/7] bnxt_en: Reply to firmware's echo request async message.
    https://git.kernel.org/netdev/net-next/c/df97b34d3ace
  - [net-next,7/7] bnxt_en: Improve logging of error recovery settings information.
    https://git.kernel.org/netdev/net-next/c/f4d95c3c194d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


