Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAEEF339AFB
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 03:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbhCMCA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 21:00:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:37666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhCMCAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 21:00:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1537964F8D;
        Sat, 13 Mar 2021 02:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615600808;
        bh=lS1/s3D+IvVXXJ9ooDOKWU2CSvNrGpUNS/19uInjkaM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UdRNMYNwfQ2wqkQWi8DWqbB06SpVZJwLvHUCgAXZ9KdhHG5wU1r/JruZq1IQTkKXm
         VxKQmrT5ggFnFYgdgXujK0liSWPRXOaXnLGAZOejc5jbzQuHY6RZt9HGT05sZjsSm1
         UAdUmb6moWFw1rUkZxERYGqucdIWcCfata5mTG/FhebVKbDNiUbmVqKfsrPx9c6Z55
         yFEms5QqEYCkX8o4BAsMAtpX/NG/VH4RhQWp+ItppkfRPuDP0WANovpv3/HFErQzP6
         nphvLrVgs0K7aqOHWNFbYybt2kCAJM4aADyhW7TwObXrG/ULtCHeHEZ8/uysJ1qjiK
         tKaOufO0l6JKw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0A79A60A57;
        Sat, 13 Mar 2021 02:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests: mptcp: Restore packet capture option in join
 tests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161560080803.26528.18408748749099031586.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Mar 2021 02:00:08 +0000
References: <20210313004352.209906-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210313004352.209906-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.01.org,
        geliangtang@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 12 Mar 2021 16:43:52 -0800 you wrote:
> The join self tests previously used the '-c' command line option to
> enable creation of pcap files for the tests that run, but the change to
> allow running a subset of the join tests made overlapping use of that
> option.
> 
> Restore the capture functionality with '-c' and move the syncookie test
> option to '-k'.
> 
> [...]

Here is the summary with links:
  - [net] selftests: mptcp: Restore packet capture option in join tests
    https://git.kernel.org/netdev/net/c/a673321aa74f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


