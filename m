Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2A2408A70
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 13:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239576AbhIMLlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 07:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234635AbhIMLlX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 07:41:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7283660EB4;
        Mon, 13 Sep 2021 11:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631533207;
        bh=nKWtpchNTemXpf7ymtCDEYkYLMxGeRccqtAmbdDCegQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Hp8OrOfvWDCm+fkOj6oNV/Cl3VLXJdBqtfDokKtHidgVwG9C6+NqNd+q7rnHzRRQg
         V762kqpmSnHpswMSz/q/ZGVRY62tMXp4Cj9qCHL3iWMwrPGgxofTfP725yhhnqTlqx
         Lpa9M2l3lC59Dk4W3bPyvDAHQscLY1MVcT2rDQIy6JWm8oF7PFrv4Gk8I7qdy1dkSX
         BnCmMDaXqPX2HEB0LY1lxEyOR3FMyqn96Hsnnv0wgHjQW5ibu12HxxHUhy0CvbhIEO
         Hgje9xP1HDrI4ds4CqIub9+uclygh5QFKBZ+74oZS+W67JOUnnBR/0jAexpkNAoTli
         P0AHW1ZE21UNg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 51C0060A47;
        Mon, 13 Sep 2021 11:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] bnxt_en: Bug fixes.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163153320733.25807.15907151450210347400.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Sep 2021 11:40:07 +0000
References: <1631464489-8046-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1631464489-8046-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edwin.peer@broadcom.com, gospo@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sun, 12 Sep 2021 12:34:46 -0400 you wrote:
> The first patch fixes an error recovery regression just introduced
> about a week ago.  The other two patches fix issues related to
> freeing rings in the bnxt_close() path under error conditions.
> 
> Edwin Peer (1):
>   bnxt_en: make bnxt_free_skbs() safe to call after bnxt_free_mem()
> 
> [...]

Here is the summary with links:
  - [net,1/3] bnxt_en: Fix error recovery regression
    https://git.kernel.org/netdev/net/c/eca4cf12acda
  - [net,2/3] bnxt_en: make bnxt_free_skbs() safe to call after bnxt_free_mem()
    https://git.kernel.org/netdev/net/c/1affc01fdc60
  - [net,3/3] bnxt_en: Clean up completion ring page arrays completely
    https://git.kernel.org/netdev/net/c/985941e1dd5e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


