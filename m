Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468DC310410
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 05:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhBEEav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 23:30:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:43874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229729AbhBEEas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 23:30:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8FAA064FA9;
        Fri,  5 Feb 2021 04:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612499407;
        bh=4IKHutOzYQgASx10Kc+xUFhRAE8CY8rmiCLn40sZVuM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PofyqyRuLxW9BgnW9Mh4DruGdAWgiTYHuqxyKSczwlwGaHUFXvdQNXn6ageJlFH40
         DJt4zMwOEn7hqOrRIRxDDlSkw4CyR0bRsUqOu+hZJbBK9/tFFal1nw+fZXXb9ndRZV
         QlAWLqIKGZgcQqAECVeLt1tx0HoknjBYNRgKqAfItuJjsVzJ3kjNzcuuCJYSvqKAqf
         burDrRSUOYz1X6RfpzBJApin+Ui0Fkad94vaVbCUY4BtvnaVFaDBHCW8w038MhS42K
         LvXSUWlY+3F0BHLB7NOOjLKnxkHLnsu7MUBB3HLeWoF/qRoj19N9OETAwTQtQc5cwJ
         zj6+QHN2i6wtQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 78C3760978;
        Fri,  5 Feb 2021 04:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V3] drivers: net: ethernet: i825xx: Fix couple of spellings in
 the file ether1.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161249940748.23963.12160408162653739430.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Feb 2021 04:30:07 +0000
References: <20210204031648.27300-1-unixbhaskar@gmail.com>
In-Reply-To: <20210204031648.27300-1-unixbhaskar@gmail.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  4 Feb 2021 08:46:48 +0530 you wrote:
> s/initialsation/initialisation/
> s/specifiing/specifying/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
> Changes from V2:
>    Adjust and make changes which are obvious as per Randy's suggestions
> 
> [...]

Here is the summary with links:
  - [V3] drivers: net: ethernet: i825xx: Fix couple of spellings in the file ether1.c
    https://git.kernel.org/netdev/net-next/c/53b823b29aac

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


