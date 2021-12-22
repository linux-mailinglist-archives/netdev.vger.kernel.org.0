Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64F447D988
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 00:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242424AbhLVXKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 18:10:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59416 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242340AbhLVXKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 18:10:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD1B6B81E93
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 23:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 74BBFC36AEA;
        Wed, 22 Dec 2021 23:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640214609;
        bh=h/gCg5LZQDhn8ROYqBBg1kMIf0biIjDKufSN3NteSmw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cPRwVIMOMxI7gh+LEztkfdVA2IE69iRfzEj0qX/dp9xEpnRT9w0okkfqE92W5T+6g
         5C0VSfpd/2OUBuE7l9h7jPYJdw5+ccucszp4oBvpv01IPV+SFWthZulTBtAuUrBfqq
         r+GR+2B6eaBInWCeovujoNtEumoRmZW+bSUrMzfoBzaRwkv+DIiD9sncV1ZZJfw4IP
         EvP+hAYfwEFH6mlmmKNIMQYYNLbzh5MxQgR3SJ7VnBhPysbIIh5BVg4JzVLy2Oifse
         Pn4uQZmvFyRQLChI7NxEWLyN3w1Upguej7SzRkeFInCPyS3SFhW+IO3LWCtpUslbyI
         UEU5UEWD2rLwg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 53F9DFE55A6;
        Wed, 22 Dec 2021 23:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1] ice: trivial: fix odd indenting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164021460933.4565.10777451233375589031.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Dec 2021 23:10:09 +0000
References: <20211221230538.2546315-1-jesse.brandeburg@intel.com>
In-Reply-To: <20211221230538.2546315-1-jesse.brandeburg@intel.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Dec 2021 15:05:38 -0800 you wrote:
> Fix an odd indent where some code was left indented, and causes smatch
> to warn:
> ice_log_pkg_init() warn: inconsistent indenting
> 
> While here, for consistency, add a break after the default case.
> 
> This commit has a Fixes: but we caught this while it was only in net-next.
> 
> [...]

Here is the summary with links:
  - [net-next,v1] ice: trivial: fix odd indenting
    https://git.kernel.org/netdev/net-next/c/0092db5fac22

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


