Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45E4308397
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 03:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbhA2CLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 21:11:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:56836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231184AbhA2CKw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 21:10:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B693D64DFB;
        Fri, 29 Jan 2021 02:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611886211;
        bh=0PCQ6p6Nc9YCqzXiisxM1iDp4/tuMl6WDBxkrtxZ/6g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dHt6gv+ksiD3TWHu+W/tYPZ3PdbdMvm0jAmEkUFt/pyO1kBaba6uZ0dH14puLri8s
         UKrCnpVn5NmPD+ezdJxM6xv+svNvp348tU07EP+7xdqeRqah6sLT95jTmirrOxkgoz
         QXq/KDi7j48PkoSaDjsyxyTAzkGYWZK8lNsUzcDwCelZ4gcAqa8d0bsxvtrGyXHgBh
         KAPqvmyZSlAsT7b1u4NakzmRxlVsZM4XNwIB6Igwm+VymKfPBZVVb4RVPkGNZL9JK3
         fufG5w2ioi2wxgfH3PGNiLZemKvJnUlL11j6Z+Fwuj8Nd2F38z8FsbSEOYHm680tV2
         8rXxyYBnD0Zxw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A96DF6530E;
        Fri, 29 Jan 2021 02:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: qmi_wwan: Add pass through mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161188621168.7700.17885277914869380673.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jan 2021 02:10:11 +0000
References: <1611560015-20034-1-git-send-email-subashab@codeaurora.org>
In-Reply-To: <1611560015-20034-1-git-send-email-subashab@codeaurora.org>
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        stranche@codeaurora.org, aleksander@aleksander.es,
        dnlplm@gmail.com, bjorn@mork.no, stephan@gerhold.net,
        ejcaruso@google.com, andrewlassalle@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 25 Jan 2021 00:33:35 -0700 you wrote:
> Pass through mode is to allow packets in MAP format to be passed
> on to the stack. rmnet driver can be used to process and demultiplex
> these packets.
> 
> Pass through mode can be enabled when the device is in raw ip mode only.
> Conversely, raw ip mode cannot be disabled when pass through mode is
> enabled.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: qmi_wwan: Add pass through mode
    https://git.kernel.org/netdev/net-next/c/59e139cf0b32

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


