Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E64306B84
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 04:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbhA1DUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 22:20:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:51284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229831AbhA1DUx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 22:20:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 810BA64DD8;
        Thu, 28 Jan 2021 03:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611804012;
        bh=O6tUNpIcgF4x9X6sgd3rpc6974VmXxPMWsMT4uncE54=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DOLUptACjMX/Noui5srpX2o2GysdjXnQFxf2YqmSwMJ9pE8AE2VCmpHdUWp3clLWj
         7BWTKfh7H43LgFzpepa1y8OWgMvccJzL9voR2yWITBx1XTHbG4eNeKYloDp1wN2cgZ
         1sqenq3q3fsbD93FKWUgPdCyJi49SB8t8u933yKCGJLj/eJ7+kKEt+UwTj4FvAFkhW
         BL8+5CJ6diD4yxrWpeDNarKTD7SE8c/1GF5yiDZ39l473yrzav2bRY8VRRj4AOtiBa
         ag624rLhjF1eotPGuf8mIR++pWzBzC9ddXNUuZ8W61Gqc30RP97fLQ+d8eBDB1C+gG
         64Txkl6/n+23Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7C58365307;
        Thu, 28 Jan 2021 03:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211-next 2021-01-27
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161180401250.7081.14497810946310131416.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 03:20:12 +0000
References: <20210127210915.135550-1-johannes@sipsolutions.net>
In-Reply-To: <20210127210915.135550-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Wed, 27 Jan 2021 22:09:14 +0100 you wrote:
> Hi Jakub,
> 
> Alright ... let's try again, with two more fixes on top, one
> for the virt_wifi deadlock and one for a minstrel regression
> in the earlier patches.
> 
> Please pull and let me know if there's any problem.
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211-next 2021-01-27
    https://git.kernel.org/netdev/net-next/c/5998dd0217df

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


