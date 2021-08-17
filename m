Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62DE3EF5AC
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 00:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235731AbhHQWUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 18:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229729AbhHQWUj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 18:20:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 36FAE60EE0;
        Tue, 17 Aug 2021 22:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629238806;
        bh=88PEeN3QPvy2n7i+U59YDW1+amHB33i+8WSgBy2glF8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ur7e6pkBy5DlpJXANsQp2WzwIDe3Y0KD1cAoTbnIg1iwnZaIxeCaPBycq8MP5MGLj
         Pi+oTGwQrGkxnexkhlnPrlFReizL0ZLnGHCf4wQkit/LQwd6xcwW9mQue80UVjkSZ1
         wbqNHGbujNxQHveVKV0IEddPuM10rQLh0cgc0TRr8OXZ5976bUI+2ss+xshXv2IN1l
         uwEFDGfAx60YBfyfsTzKxG0YWmwajcO0lJpDUHX9heZ1vnVrWkWrgVA194doNYok8q
         aaXwAyGgepPq1jeLLJX7gmPwwNqWUo81jGf/ll8nmxxuKg2xbiPxmmqH/mbyI3GacO
         bJ558qvJ93rPQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2A0DA60A25;
        Tue, 17 Aug 2021 22:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-2021-08-17
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162923880616.4403.10581636012968627104.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Aug 2021 22:20:06 +0000
References: <20210817171027.EC1E6C43460@smtp.codeaurora.org>
In-Reply-To: <20210817171027.EC1E6C43460@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Tue, 17 Aug 2021 17:10:27 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-2021-08-17
    https://git.kernel.org/netdev/net/c/e5e487a2ec8a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


