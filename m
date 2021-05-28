Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557CB394847
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 23:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbhE1VVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 17:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229494AbhE1VVk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 17:21:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 46786613D1;
        Fri, 28 May 2021 21:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622236805;
        bh=xbHxDkwdqZf5bFkeAe/ykjvC5GnuJG3J4UW/o6L6xB4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E4m6kOyGaw3YiWVxECQPukmm8Fj8tPg3aymanAlVyYE+OTqJcagbC1eoUtj71RT4N
         m/LkRdHDCzND4p0nGnRnCmlNEc60ujN6wI6ohIo3kHNKB0yBpFiJrmlgoLNEnZweaW
         X10BMuur+a98dOC/D1eaNamBxXh4h2TV6ECcSXrWkzTNz952HyWKBKzb1AZ2/Io6Nb
         sf0pKCQNwxxvRP22wwbdn8Widw7VawxHcwCs8pvsjj3dLtbJM7XhqUbxlmzhjAl2rx
         Nd3VzQaGXEY8Ru9qPGJgXfbBRemp2prlLGqxcPtAwt7Ajk3Ysy3NgynbnSuviilNa+
         uEK9I24npehIg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 34A816098E;
        Fri, 28 May 2021 21:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next 00/10] net: hdlc_fr: clean up some code style
 issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162223680521.28751.9762561920313563826.git-patchwork-notify@kernel.org>
Date:   Fri, 28 May 2021 21:20:05 +0000
References: <1622160769-6678-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1622160769-6678-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xie.he.0141@gmail.com,
        ms@dev.tdt.de, willemb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        tanhuazhong@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 28 May 2021 08:12:39 +0800 you wrote:
> From: Peng Li <lipeng321@huawei.com>
> 
> This patchset clean up some code style issues.
> 
> ---
> Change log:
> V1 -> V2:
> 1, Use appropriate commit prefix suggested by Jakub Kicinski,
> replace commit prefix "net: wan" by "net: hdlc_fr".
> 
> [...]

Here is the summary with links:
  - [V2,net-next,01/10] net: hdlc_fr: remove redundant blank lines
    https://git.kernel.org/netdev/net-next/c/b11faec36870
  - [V2,net-next,02/10] net: hdlc_fr: add blank line after declarations
    https://git.kernel.org/netdev/net-next/c/4a9ab454ae9b
  - [V2,net-next,03/10] net: hdlc_fr: fix an code style issue about "foo* bar"
    https://git.kernel.org/netdev/net-next/c/7aad06425991
  - [V2,net-next,04/10] net: hdlc_fr: add some required spaces
    https://git.kernel.org/netdev/net-next/c/30e7720d379a
  - [V2,net-next,05/10] net: hdlc_fr: move out assignment in if condition
    https://git.kernel.org/netdev/net-next/c/168a196ffcff
  - [V2,net-next,06/10] net: hdlc_fr: code indent use tabs where possible
    https://git.kernel.org/netdev/net-next/c/683b54bb468f
  - [V2,net-next,07/10] net: hdlc_fr: remove space after '!'
    https://git.kernel.org/netdev/net-next/c/8f032c6535fe
  - [V2,net-next,08/10] net: hdlc_fr: add braces {} to all arms of the statement
    https://git.kernel.org/netdev/net-next/c/5d650a6c7b9c
  - [V2,net-next,09/10] net: hdlc_fr: remove redundant braces {}
    https://git.kernel.org/netdev/net-next/c/c9a2ca5d7e58
  - [V2,net-next,10/10] net: hdlc_fr: remove unnecessary out of memory message
    https://git.kernel.org/netdev/net-next/c/2744fa2dfdcd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


