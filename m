Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC57439ED0
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 21:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbhJYTCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 15:02:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232144AbhJYTCa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 15:02:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B1B5260230;
        Mon, 25 Oct 2021 19:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635188407;
        bh=xusDkpGJLr+iqTDfzPhIanQZvF579kt4yg7SzefsypA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DvapOU6HJ9xSSMmFaOOXlbtS4xrHGgGBcyVsQnXzBtwhU0Z+vjBcUtcoxk6JK0geh
         lGcNzOZHtOT+N9a4ts3uWYtGOTAsSGxwSHG8mZkLyzxANEOzZXRPAVQCuKvxhXhSXy
         KSDriCV9Ux4zCvNnkbtFBQV07g9mhpeMOhG34B5sYdV/cKf+GFmKPwQzTdzBkEQ0J1
         aElwSY1gHeztC4+CDuggw0JhWozEDrIH3Dwi5bYhU/axdKcBDXD/EStdnc/FfjUycQ
         bu/VGrm/Qkenj+0h1diZ3yhxX6mqJIAMZeryH4akZ2jw6mgXchtSZSOVCg5E7FsKk6
         L5t1VxT4crbnQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A46B660A47;
        Mon, 25 Oct 2021 19:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] bluetooth: don't write directly to
 netdev->dev_addr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163518840766.4840.11386138879668089724.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Oct 2021 19:00:07 +0000
References: <20211022231834.2710245-1-kuba@kernel.org>
In-Reply-To: <20211022231834.2710245-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 22 Oct 2021 16:18:32 -0700 you wrote:
> The usual conversions.
> 
> These are intended to be merged to net-next directly,
> because bluetooth tree is missing one of the pre-req
> changes at the moment.
> 
> v2: s/got/go/
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] bluetooth: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/08c181f052ed
  - [net-next,v2,2/2] bluetooth: use dev_addr_set()
    https://git.kernel.org/netdev/net-next/c/a1916d34462f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


