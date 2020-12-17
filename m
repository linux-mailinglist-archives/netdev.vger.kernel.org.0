Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18BB12DD85E
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 19:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731379AbgLQSas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 13:30:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:37690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729161AbgLQSas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 13:30:48 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608229807;
        bh=MhOvszaj8//BcjryXniguzshmSdlpKt9CaU5E3SkDB8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AaEBHkKrrd6YxN1g6O233ws9UH0su04vw8XuEoti5kHwizRVEg8Z+F1qaaGHtEJj3
         i+7O0o3n2FcrTUU0CAstjUj9INj8yp7pg6wQ9HHqih0C1Kt+raSdTfmMJ1dna0Lhog
         H7AZV5OW2RtprRWwXAEOMQY2hHNeXAF54flQ4NwtVJGNUoPlulbznTk/ROZ71NX2VR
         oGW9QDbPzYVVmCrqmY2e1Gdh/Ngo2f+iODckRjVCcugsQIhL0ZmbFBQC2TwhrUwgPG
         bsIrAw7GQIxbhirP0ylQCs8zCp2uZD4c65KlVX2e5PKmrrsy0ihUowjobiEKazjJEs
         MdL6cYhgiEWdw==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] mptcp: a bunch of assorted fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160822980777.23072.11158682843744324037.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Dec 2020 18:30:07 +0000
References: <cover.1608114076.git.pabeni@redhat.com>
In-Reply-To: <cover.1608114076.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mptcp@lists.01.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 16 Dec 2020 12:48:31 +0100 you wrote:
> This series pulls a few fixes for the MPTCP datapath.
> Most issues addressed here has been recently introduced
> with the recent reworks, with the notable exception of
> the first patch, which addresses an issue present since
> the early days
> 
> Paolo Abeni (4):
>   mptcp: fix security context on server socket
>   mptcp: properly annotate nested lock
>   mptcp: push pending frames when subflow has free space
>   mptcp: fix pending data accounting
> 
> [...]

Here is the summary with links:
  - [net,1/4] mptcp: fix security context on server socket
    https://git.kernel.org/netdev/net/c/0c14846032f2
  - [net,2/4] mptcp: properly annotate nested lock
    https://git.kernel.org/netdev/net/c/3f8b2667f257
  - [net,3/4] mptcp: push pending frames when subflow has free space
    https://git.kernel.org/netdev/net/c/219d04992b68
  - [net,4/4] mptcp: fix pending data accounting
    https://git.kernel.org/netdev/net/c/13e1603739e5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


