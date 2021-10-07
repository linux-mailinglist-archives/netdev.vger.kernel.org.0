Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141CC425573
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 16:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242040AbhJGOcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 10:32:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233381AbhJGOcC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 10:32:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3EC24610C8;
        Thu,  7 Oct 2021 14:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633617008;
        bh=81gRRp4C0pO5K1S9uRdPBKwpyXAs/mBcAIdUyeluXPQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rpNCAt9jq30lez4MEifXxV+QpN2KYxfg044TFdIPDOqT4ycxsrXzApp9erXCrl9nU
         3nZfhDKOMVQLYTYhLTUoBD1w2MbxG0bE/lOVkhnGZKozYBxrK1pdjTc4K9zaSfXwno
         azLG5PNdxrQ7SlSujEeS7s5MR5Eg7Z6ST7ShEpaxd9cKmVcAcg1PVXTYnB44qk9dzj
         m6D61Q0yyYJO5SdgnNyh89/3oGd7Kgu6qc/W04XkvNFPOWYwjKFIwASrI3wzUj2HCF
         DulLx+ZCxzwsxbT23cfNAPZpj+Vwf9CeswWe/SMHQo2cb9ZeUWVaUJs2eTiVNpvVMm
         /S+yB3T6wt8bw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 31B1A60A44;
        Thu,  7 Oct 2021 14:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2021-10-07
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163361700819.11150.17273275679214156746.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Oct 2021 14:30:08 +0000
References: <20211007135010.21143-1-daniel@iogearbox.net>
In-Reply-To: <20211007135010.21143-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  7 Oct 2021 15:50:10 +0200 you wrote:
> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 7 non-merge commits during the last 8 day(s) which contain
> a total of 8 files changed, 38 insertions(+), 21 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2021-10-07
    https://git.kernel.org/netdev/net/c/7671b026bb38

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


