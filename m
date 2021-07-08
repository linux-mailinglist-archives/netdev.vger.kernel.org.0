Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978683C19F8
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 21:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhGHTms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 15:42:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhGHTmq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 15:42:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EA16561624;
        Thu,  8 Jul 2021 19:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625773204;
        bh=E1pflG0YFVjmeEaja+6qqiW+R1kXF/e/2KaKrQcnyl4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q2Nrin+uva3HAzNbgIwiKXTrG9rhTGo2fZufTRcUrPcKcHWGxoLNKDLRG68/hvT0K
         duAZXxAaO68CQY0K32IV8Hd7ItJs2n3A6XN8nGVnlfRDnS+HoIiT3OhFXbHxf8ydvw
         r7fa7HX0pJbCn5+9xBXxqRyy06gszyJFWnMP7I9blUqBJ1n0ORJHR/36htkclhxeFp
         33w0nvHEDJQh7A5oiyXT4hhOaSuJG6qx36DwyHOCw6r32DFr0ajGYO6f6We2myzoiR
         S0UHwD5TtO9abyx5bG6JQv3te28r9afi9gY7Jrcv7W8rjTup2v7u1saUsrJkFtGziQ
         37Os4SBB2U7TA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DCCDA60A4D;
        Thu,  8 Jul 2021 19:40:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ptp: Relocate lookup cookie to correct block.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162577320389.12401.2909820508942054398.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Jul 2021 19:40:03 +0000
References: <20210708180408.3930614-1-jonathan.lemon@gmail.com>
In-Reply-To: <20210708180408.3930614-1-jonathan.lemon@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     davem@davemloft.net, dariobin@libero.it, richardcochran@gmail.com,
        kernel-team@fb.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 8 Jul 2021 11:04:08 -0700 you wrote:
> An earlier commit set the pps_lookup cookie, but the line
> was somehow added to the wrong code block.  Correct this.
> 
> Fixes: 8602e40fc813 ("ptp: Set lookup cookie when creating a PTP PPS source.")
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> Signed-off-by: Dario Binacchi <dariobin@libero.it>
> Acked-by: Richard Cochran <richardcochran@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] ptp: Relocate lookup cookie to correct block.
    https://git.kernel.org/netdev/net/c/debdd8e31895

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


