Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E098F47B9C9
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 07:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbhLUGAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 01:00:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39910 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbhLUGAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 01:00:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 081D561416
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 06:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6169DC36AE7;
        Tue, 21 Dec 2021 06:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640066410;
        bh=kA3py8pwcLQE0fpZKEQHQ3mykUBSVTAFAL9U3rVWpkA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vM9oECU4z6xYn6Y8WmwdMmCycihm5SmPb4CP+p89azBS0+ya1Ug0lsi6GvOdiy7JN
         VTjKwlPwfXVhPMT9nMYpg3wSQ4Ec8bLf6k+GcvL62NIO3o3AOQMNh19ceQ4hSmPFLe
         7oBlGmf098rlGRsPxyd7+FG0zUmu/pdLRMQstNDrKHw44TjEpN4OWkQWtv8OqkQj1+
         tBaTDgVPKI7gZHoPtY+TUpFD2+G90si7cXbRkeSAhOQ4Mia+umIEbRtkhe8+diXH1o
         Jk9FBpFDI7bsAXHgrqHIQaPn3nAxutLl+e0nd7a12exPo22jP+yE69WtOfJQ/73/8u
         AIQ4kguqXkSXw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 462E160A27;
        Tue, 21 Dec 2021 06:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] mctp: emit RTM_NEWADDR and RTM_DELADDR
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164006641028.29004.14572048903554403851.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Dec 2021 06:00:10 +0000
References: <20211220023104.1965509-1-matt@codeconstruct.com.au>
In-Reply-To: <20211220023104.1965509-1-matt@codeconstruct.com.au>
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        jk@codeconstruct.com.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 20 Dec 2021 10:31:04 +0800 you wrote:
> Userspace can receive notification of MCTP address changes via
> RTNLGRP_MCTP_IFADDR rtnetlink multicast group.
> 
> Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
> ---
> v2: Simplify error return path, fix local variable ordering
> v3: Fix address size for nlmsg allocation, warn on undersized
> 
> [...]

Here is the summary with links:
  - [net-next,v3] mctp: emit RTM_NEWADDR and RTM_DELADDR
    https://git.kernel.org/netdev/net-next/c/dbcefdeb2a58

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


