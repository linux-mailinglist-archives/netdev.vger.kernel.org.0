Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8F12FF43A
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 20:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbhAUTVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 14:21:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:40546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727175AbhAUTUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 14:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C110E23A03;
        Thu, 21 Jan 2021 19:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611256808;
        bh=MHQgDUKYsvD4GX+RjJgZPjIPUBa14VO+UjlThDS3Nec=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bbWyVBri/VP3gKGPVr9Tu7uTd0YPvzpyONGAQoc6bisxJXTdnhl7ob+kEy6SHeXZW
         iyb8NNk2KkITzrTfU6cW43zTlqYUc2EKA7NKW5qy+4y8jpRE3Xehw6liYBixZuWSKe
         YheIoBrZokU+g9Dq6DgDQlfPqvj7ktii+SKwipbHkflKo7dWuGRa1V633MQMKmVq7m
         vNKpN8zmLWB5gYLsiuU69CgogFz5ftmZ2BnA6Hmx1dqDbWHYqeXfAld9eUCSPL1WB2
         DZhybR9EaJ3TrArs9Se1pkf5QTdmRgfh5RwuMkbo6aKLSahVS0PdnBx1sMn0bxFAUF
         sIg3nOV4THiEQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id B5CBA600E0;
        Thu, 21 Jan 2021 19:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request (net): ipsec 2021-01-21
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161125680873.18349.14598876426542165762.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Jan 2021 19:20:08 +0000
References: <20210121121558.621339-1-steffen.klassert@secunet.com>
In-Reply-To: <20210121121558.621339-1-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Thu, 21 Jan 2021 13:15:53 +0100 you wrote:
> 1) Fix a rare panic on SMP systems when packet reordering
>    happens between anti replay check and update.
>    From Shmulik Ladkani.
> 
> 2) Fix disable_xfrm sysctl when used on xfrm interfaces.
>    From Eyal Birger.
> 
> [...]

Here is the summary with links:
  - pull request (net): ipsec 2021-01-21
    https://git.kernel.org/netdev/net/c/35c715c30b95

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


