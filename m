Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A88364DAD
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 00:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhDSWax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 18:30:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229652AbhDSWaq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 18:30:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 76B35613B4;
        Mon, 19 Apr 2021 22:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618871416;
        bh=vXNRLnvkhcCJ/GZMMOpnokBh5X5WFoe4zwOROidHXVE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c8Wj8LjvZrzdodWaSMYtadf/bTwR3NdNZG9KiUDsXHGVmKONY/6yDLFnCXIhdXDJI
         P9xg8QDeDiyEK7X9aYwyOlMGn5avXnVsbhXTTYr8IXsNp0H+6di5FdBgrXc9acvLxS
         nyY9Z2Gi10MDh3kRezxhUDYgPeNy/rUUCBEK6qvu128LG8itaVKcYCw1pmBlEywYQU
         SG5TGOE+/6laddfVrt5xEG0uiOYT/djY5L2aHl7KxvsKvJGhfgsRrY7qV3iKrNGnoI
         VK8b9tp9WYLjkndhPT7+wbocwdAUa4BWODi8dd3ZzdhsfyAGGswhSmGtgP3dX3Leah
         U+2N5OKYAU3WA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6A4C660A39;
        Mon, 19 Apr 2021 22:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-next-2021-04-18
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161887141643.15331.4135144000327887554.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Apr 2021 22:30:16 +0000
References: <20210418082614.7DC5DC433F1@smtp.codeaurora.org>
In-Reply-To: <20210418082614.7DC5DC433F1@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Sun, 18 Apr 2021 08:26:14 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-next-2021-04-18
    https://git.kernel.org/netdev/net-next/c/56aa7b21a5a7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


