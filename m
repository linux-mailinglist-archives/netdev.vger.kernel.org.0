Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5CC3F7276
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239762AbhHYKBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:01:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237077AbhHYKA7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 06:00:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 92CDE61212;
        Wed, 25 Aug 2021 10:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629885613;
        bh=/ntJ2mMXX4PtgpsnFtVxq4/rtW5hlIIX8CFtQHf8yp4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K5uPDU86ilRD5Sw8HRmQUUgvv4E27sRI8uEX2H+52Fo854TNfOAHfvY9WYiWg34BQ
         fPn/XVM77C8lXrXq+9LRuXOydbYq/mkw6vJntgvJJLeqkOxbqUGnWLrs6qn7zYdWpQ
         bS3ZE2kLpIB3OzYYV57gdWfo/lkan4vuTsnXqiviR4MDvpO/TNs0xr5U7Tg8fMTsdm
         CKIk4EAEsoQPvIFvC0EtGOsa1MOF/ksLMoYBizUk6W9QezOuzE9qbNVZtOJ2coZYkE
         gwdbefT9G/CxrJqgX7z6d4oC38g7jP1p7eTSgbYsENWDWEJOeRuuED0AYMVOz59qSS
         SP9K7qQFmIRPQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 889B360A12;
        Wed, 25 Aug 2021 10:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] qed: Enable automatic recovery on error condition.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162988561355.31154.13741354935010932574.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Aug 2021 10:00:13 +0000
References: <20210824040246.21689-1-palok@marvell.com>
In-Reply-To: <20210824040246.21689-1-palok@marvell.com>
To:     Alok Prasad <palok@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        GR-everest-linux-l2@marvell.com, smalin@marvell.com,
        aelior@marvell.com, irusskikh@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 24 Aug 2021 04:02:46 +0000 you wrote:
> This patch enables automatic recovery by default in case of various
> error condition like fw assert , hardware error etc.
> This also ensure driver can handle multiple iteration of assertion
> conditions.
> 
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Alok Prasad <palok@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net-next] qed: Enable automatic recovery on error condition.
    https://git.kernel.org/netdev/net-next/c/755f90534080

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


