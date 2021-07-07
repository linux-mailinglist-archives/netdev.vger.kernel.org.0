Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706BA3BF140
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 23:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbhGGVMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 17:12:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230185AbhGGVMq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 17:12:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 70579611C2;
        Wed,  7 Jul 2021 21:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625692205;
        bh=SzI71yZPqaePqttVrnck73zSiV4WrI16hV7zAukBggg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tNN5zihkwjRm10jHivzWD63+iQmVNQfRIhZEs864gyyO/p79+OLiRnaoJA3LP+jFL
         dZBkuHYsuWYqLntTk2FvfHFfaeRIRjlLAxyWyjUqyYWmxLNKc+3LpUv4+cFJlQZhYT
         PB9gcooNv4rmyDCEz8dTqgAdQRZg8HIHLeTen8QeLgU+1ZhH3pD3pe1ZGE43FFonQ1
         GGTbMbbSu6+K+M7NFSIQovk1XUfjkAJCYJ/pRElbKbvUjLONS6pJGs3jHZxUjJp9cy
         OGSEL+KpC5SSOPDlf4lanMVjfiv8QSHmXcAwJ8qXFwa29Ul3aZuKqTldLWIhC/l5zD
         360NchCNHPHSQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6A701609B4;
        Wed,  7 Jul 2021 21:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/11] selftest: netfilter: add test case for unreplied
 tcp connections
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162569220543.14612.3843026233526868452.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Jul 2021 21:10:05 +0000
References: <20210707161844.20827-2-pablo@netfilter.org>
In-Reply-To: <20210707161844.20827-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed,  7 Jul 2021 18:18:34 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> TCP connections in UNREPLIED state (only SYN seen) can be kept alive
> indefinitely, as each SYN re-sets the timeout.
> 
> This means that even if a peer has closed its socket the entry
> never times out.
> 
> [...]

Here is the summary with links:
  - [net,01/11] selftest: netfilter: add test case for unreplied tcp connections
    https://git.kernel.org/netdev/net/c/37d220b58d52
  - [net,02/11] netfilter: conntrack: do not renew entry stuck in tcp SYN_SENT state
    https://git.kernel.org/netdev/net/c/e15d4cdf27cb
  - [net,03/11] netfilter: nf_tables: Fix dereference of null pointer flow
    https://git.kernel.org/netdev/net/c/4ca041f919f1
  - [net,04/11] netfilter: conntrack: nf_ct_gre_keymap_flush() removal
    https://git.kernel.org/netdev/net/c/a23f89a99906
  - [net,05/11] netfilter: ctnetlink: suspicious RCU usage in ctnetlink_dump_helpinfo
    https://git.kernel.org/netdev/net/c/c23a9fd209bc
  - [net,06/11] netfilter: conntrack: improve RST handling when tuple is re-used
    https://git.kernel.org/netdev/net/c/c4edc3ccbc63
  - [net,07/11] netfilter: conntrack: add new sysctl to disable RST check
    https://git.kernel.org/netdev/net/c/1da4cd82dd18
  - [net,08/11] netfilter: conntrack: Mark access for KCSAN
    https://git.kernel.org/netdev/net/c/cf4466ea47db
  - [net,09/11] netfilter: nft_last: honor NFTA_LAST_SET on restoration
    https://git.kernel.org/netdev/net/c/6ac4bac4ce48
  - [net,10/11] netfilter: nft_last: incorrect arithmetics when restoring last used
    https://git.kernel.org/netdev/net/c/d1b5b80da705
  - [net,11/11] netfilter: uapi: refer to nfnetlink_conntrack.h, not nf_conntrack_netlink.h
    https://git.kernel.org/netdev/net/c/d322957ebfb9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


