Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE27738B969
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 00:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbhETWVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 18:21:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229750AbhETWVc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 18:21:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DF3566135C;
        Thu, 20 May 2021 22:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621549210;
        bh=glrPf7khmGAvBbB4imbnnS6aY6FgU7QslbD9PSC/1Gg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RuWWpsh2lXVQmcqp5TEWBbuvO2ooGKlXQpHmmWlo0nwaxDnwnLbDmxr1HRunUZf0z
         selAs3Uqibmz0auk6v7s9U/NUZplgMV/MWg+y9ec4JDu/ENkLSRqdo3tfF4T8jBOr2
         vOXb3XBdcdrNwzAecqjBKojGTHDpFJ2EHN90u4+KWbyiVa/YpspcjiD347q38hWGo5
         80Dow9QdsvJ4QMrCG3zyaujEuJsYeO2FSka6/rEgZzIDq7yXBumqcnNPF7PLKhmkQr
         PW6bSAFXBmsbpHKhGx4e2Ke1AtPFcfWbvZ3SWWwQGoNSgjO8l/iUkqwtzNv65nMGS+
         SRcktX5fPa8KQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CF95760982;
        Thu, 20 May 2021 22:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] net: remove leading spaces before tabs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162154921084.13631.15799228433249563284.git-patchwork-notify@kernel.org>
Date:   Thu, 20 May 2021 22:20:10 +0000
References: <1621482474-26903-1-git-send-email-tanghui20@huawei.com>
In-Reply-To: <1621482474-26903-1-git-send-email-tanghui20@huawei.com>
To:     Hui Tang <tanghui20@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 20 May 2021 11:47:45 +0800 you wrote:
> There are a few leading spaces before tabs and remove it by running the
> following commard:
> 
>         $ find . -name '*.[ch]' | xargs sed -r -i 's/^[ ]+\t/\t/'
> 
> Hui Tang (9):
>   net: wan: remove leading spaces before tabs
>   net: usb: remove leading spaces before tabs
>   net: slip: remove leading spaces before tabs
>   net: ppp: remove leading spaces before tabs
>   net: hamradio: remove leading spaces before tabs
>   net: fddi: skfp: remove leading spaces before tabs
>   net: appletalk: remove leading spaces before tabs
>   ifb: remove leading spaces before tabs
>   mii: remove leading spaces before tabs
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] net: wan: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/c169a93c8176
  - [net-next,2/9] net: usb: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/094fefd663ad
  - [net-next,3/9] net: slip: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/1d314fc1a157
  - [net-next,4/9] net: ppp: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/63b63138f656
  - [net-next,5/9] net: hamradio: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/d1542f85dfc2
  - [net-next,6/9] net: fddi: skfp: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/a597111a3ce3
  - [net-next,7/9] net: appletalk: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/20a4fc3bc284
  - [net-next,8/9] ifb: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/cf9207d77aef
  - [net-next,9/9] mii: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/9e5914cc9571

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


