Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281662D4E89
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 00:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731399AbgLIXKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 18:10:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:49634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbgLIXKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 18:10:48 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607555407;
        bh=K/cHG6023+3WwK66mfoV4u9AkpQC7K0csJlln6G9vmI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=egd2fqRCzEZVoQBIdCi0mI0DgsYIG/F08t6glBL6PSduvMfPU/mnIqh/V0Z6SWMJ4
         gXmNhqoeSiVYhpP60eMBqIINtLhtU7+fFD4skEfWikJ+Upu0zTt7xSSkcgID77qToF
         B7VxGZnEG4PW7tbu6lrjo6FHhvKzwN7coaqY4fXBRh9DomdLG8MvYvwsfi5T47wNlI
         EahW7wShBk4A7+dcgEGWBpB7fnVtQYZo9jQVvpFPVD+AbpnbRpfdtMgU7KGndbkQKb
         1/+LBAYnQdye/UWTWPxaurAky7izXtD2WwrTUVOiZ3QIr/auzbDS1dvCvS+GFkqd1Z
         MYYA8G2iTbVWA==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/4] ptp: clockmatrix: reset device and check
 BOOT_STATUS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160755540785.17038.1749466093772501878.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Dec 2020 23:10:07 +0000
References: <1607442117-13661-1-git-send-email-min.li.xe@renesas.com>
In-Reply-To: <1607442117-13661-1-git-send-email-min.li.xe@renesas.com>
To:     <min.li.xe@renesas.com>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 8 Dec 2020 10:41:54 -0500 you wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> SM_RESET device only when loading full configuration and check
> for BOOT_STATUS. Also remove polling for write trigger done in
> _idtcm_settime().
> 
> Changes since v1:
> -Correct warnings from strict checkpatch
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] ptp: clockmatrix: reset device and check BOOT_STATUS
    https://git.kernel.org/netdev/net-next/c/251f4fe224d6
  - [net-next,2/4] ptp: clockmatrix: remove 5 second delay before entering write phase mode
    https://git.kernel.org/netdev/net-next/c/fa439059d828
  - [net-next,3/4] ptp: clockmatrix: Fix non-zero phase_adj is lost after snap
    https://git.kernel.org/netdev/net-next/c/7260d1c8fd86
  - [net-next,4/4] ptp: clockmatrix: deprecate firmware older than 4.8.7
    https://git.kernel.org/netdev/net-next/c/da9482332d58

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


