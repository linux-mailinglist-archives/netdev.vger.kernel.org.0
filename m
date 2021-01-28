Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882B7306968
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbhA1BFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:05:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:34732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231178AbhA1BAx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 20:00:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id AF6E064DCE;
        Thu, 28 Jan 2021 01:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611795611;
        bh=8Pun2wqZuGuxEClKKXqNNaSqVndKhSRIWq7bA9R2nC8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XjFuRm4p4kuQtWq8QV3t4qRrmNNPQnmd0bXmSrJg2ipiqBB4vfc/dysCeJg4aXdsB
         WC9gNmEjoAEr+zmYVbRQr3dAdarH7LyUJm7FqbJKQ8WLp1kuLXxBkHsY7IaA0XfP7Q
         hlTHZO+dda75M5aDIRYbjKSsroibDEpZK1lC6a7VgZKMSy+DJdAxhWJ6D7VQTq8YSe
         urPaMNhUIG79f8hEgiLvV3PRc7W/ya7Eplxm2kXwaOqb1lPgKvhD6R26jScR2FiQA0
         IdgJlecI8nNr3rlQ6dShk+MwgUB2Xv3o7YFIVXv7wNSEqr71VDIl7Z5oM00bRBHoKm
         1DtCJDiceUc6A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9637065307;
        Thu, 28 Jan 2021 01:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] MPTCP: IPv4-mapped IPv6 addressing for subflows
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161179561160.17796.7241015093858370942.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 01:00:11 +0000
References: <20210125185904.6997-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210125185904.6997-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mptcp@lists.01.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 25 Jan 2021 10:58:59 -0800 you wrote:
> This patch series from the MPTCP tree adds support for IPv4-mapped IPv6
> addressing that was missing when multiple subflows were first
> implemented.
> 
> Patches 1 and 2 handle the conversion and comparison of the mapped
> addresses.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] mptcp: support MPJoin with IPv4 mapped in v6 sk
    https://git.kernel.org/netdev/net-next/c/50a13bc3945c
  - [net-next,2/5] mptcp: pm nl: support IPv4 mapped in v6 addresses
    https://git.kernel.org/netdev/net-next/c/7b9b0f7e1230
  - [net-next,3/5] mptcp: pm nl: reduce variable scope
    https://git.kernel.org/netdev/net-next/c/1f2f1931b2a8
  - [net-next,4/5] selftests: mptcp: add IPv4-mapped IPv6 testcases
    https://git.kernel.org/netdev/net-next/c/a6094788031d
  - [net-next,5/5] selftests: increase timeout to 10 min
    https://git.kernel.org/netdev/net-next/c/9c2cadefde48

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


