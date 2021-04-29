Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757A236F2AC
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 00:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbhD2Wk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 18:40:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229831AbhD2Wk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 18:40:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4BD1861463;
        Thu, 29 Apr 2021 22:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619736010;
        bh=QbQXkPq6BJHPS6TviYjoOBcJ2uncFFyJSToJW3amIvw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CR3IL5wioMIOJRfbi/vsvy5yZu9P/wb7xnCxrToU9RozbCSgtUQ5O5nxeYrQnCDIB
         jXgL6WX6L8mpkGGdwv6v+yJgxxQfNKwIlta3RdThTuTkhal6XnXVBT6Q8HXRrXVVnt
         RME+i7tCAnsQnyqcBe1AfVEfMbbNZLV9WHCHxvUEWLnMjcwShY6G93TVOVR378Fbpt
         CVJ/OSrsEyUJkgYiSSpd2eLdTItnruUiQoIxycQ4C6+Rfz/7QXMWLTjxE0lvpdVpJb
         A4Z8TzNPe3861lIZ8ls7y9yTeKvD+BfXUD0qschhk4AP/kBZNFMdcvAv2oZWFZy2ug
         NMH8KUGraQTMw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3EB8C60A23;
        Thu, 29 Apr 2021 22:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] seg6: add counters support for SRv6 Behaviors
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161973601025.15907.4856994010690207332.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Apr 2021 22:40:10 +0000
References: <20210427154404.20546-1-andrea.mayer@uniroma2.it>
In-Reply-To: <20210427154404.20546-1-andrea.mayer@uniroma2.it>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, stefano.salsano@uniroma2.it,
        paolo.lungaroni@uniroma2.it, ahabdels.dev@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 27 Apr 2021 17:44:04 +0200 you wrote:
> This patch provides counters for SRv6 Behaviors as defined in [1],
> section 6. For each SRv6 Behavior instance, counters defined in [1] are:
> 
>  - the total number of packets that have been correctly processed;
>  - the total amount of traffic in bytes of all packets that have been
>    correctly processed;
> 
> [...]

Here is the summary with links:
  - [net-next] seg6: add counters support for SRv6 Behaviors
    https://git.kernel.org/netdev/net/c/94604548aa71

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


