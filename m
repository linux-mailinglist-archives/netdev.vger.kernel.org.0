Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515EA2CDB6E
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 17:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436526AbgLCQkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 11:40:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:51752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731194AbgLCQkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 11:40:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607013606;
        bh=iqEm+8B/op2ft2VRxSVqoIGs4zO2nKB7wtK1DPG8jaM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CB8WmQi3IUi65Qe6uiP/mxm/H9U5NPle4pcWGY9Ivp5yP3Jjc3DBWmvyXID98OaJK
         bGsqgRCxP6v1xSSCPRtiQvPvaGAhuBL9kdtPJYVjZsast2irrSW2C9W9y0VuyAAdI2
         rdWEu9RPeRI4A2oHaXXRhO9cAHTC0J5qTR/1+kr2EFEy0QOmKqtODYek0hpD2kv2vh
         KmqpxCF0qx5jXI5TNcf8ujs/4GC+PpxaOLruos9RRBQHilxSz5GSHyJNL/5sQM6+Lk
         K9lg+EzxN3Opah9CTjgYF9mOGPQZHff9bZDAwvCLfOgkj3CfDiL6mDaSQzanv4nN00
         BMNqgfIu4rnMg==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/5] Fix compiler warnings from GCC-10
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160701360644.5193.13492866178323803210.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Dec 2020 16:40:06 +0000
References: <20201130002135.6537-1-stephen@networkplumber.org>
In-Reply-To: <20201130002135.6537-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2.git (refs/heads/main):

On Sun, 29 Nov 2020 16:21:30 -0800 you wrote:
> Update to GCC-10 and it starts warning about some new things.
> 
> Stephen Hemminger (5):
>   devlink: fix uninitialized warning
>   bridge: fix string length warning
>   tc: fix compiler warnings in ip6 pedit
>   misc: fix compiler warning in ifstat and nstat
>   f_u32: fix compiler gcc-10 compiler warning
> 
> [...]

Here is the summary with links:
  - [1/5] devlink: fix uninitialized warning
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=f8176999390f
  - [2/5] bridge: fix string length warning
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=5bdc4e9151a1
  - [3/5] tc: fix compiler warnings in ip6 pedit
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=2319db905295
  - [4/5] misc: fix compiler warning in ifstat and nstat
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=c01498392138
  - [5/5] f_u32: fix compiler gcc-10 compiler warning
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=cae2e9291adf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


