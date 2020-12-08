Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E062D217B
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 04:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbgLHDat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 22:30:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:55332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727009AbgLHDas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 22:30:48 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607398208;
        bh=hyUm5uFJ6AbiEowizqolRXZ0TPsaCCZJKu7XnntXj8w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gZ9D0IyozS+VOsgoF0YMOPeiq8SMUteACigPSdZe8HCKoCrc68LeSbEtRP7QES/UT
         TGyzNeJRn/mwTpNmFFQpDV/2A7IHQ/PLKUsDmwIaCyexdmNmE3XQEHv+OJVjxwnqh0
         ghz7JdILC3bmy/N1y3ZwM7Vbt59u0go+7cS62qrcv26A0cqNVhHdMqNq2wp29WxoUn
         wnVefnKZ7/i9lxEifgwP/l+LTLSWe58h4niiiFXhG8NLbpL4CGSOu69CS7ed9mkyXB
         ebT7v7jOS9yKBLOcUc17k37nyHsPeqOGVHMSRZkn3Bhbu/1JByY92uDVIAzEhfWR0Q
         KrgmiX0PObQ+g==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [pull request][for-next V2] mlx5-next auxbus support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160739820797.1788.11470217528048681800.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Dec 2020 03:30:07 +0000
References: <20201207053349.402772-1-saeed@kernel.org>
In-Reply-To: <20201207053349.402772-1-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     kuba@kernel.org, jgg@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, davem@davemloft.net, leonro@nvidia.com,
        david.m.ertman@intel.com, dan.j.williams@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Sun,  6 Dec 2020 21:33:49 -0800 you wrote:
> Hi Jakub, Jason
> 
> v1->v2: Fix compilation warning when compiling with W=1 in the mlx5
> patches.
> 
> This pull request is targeting net-next and rdma-next branches.
> 
> [...]

Here is the summary with links:
  - [pull,request,for-next,V2] mlx5-next auxbus support
    https://git.kernel.org/netdev/net-next/c/8e98387b16b8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


