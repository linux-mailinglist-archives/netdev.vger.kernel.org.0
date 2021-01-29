Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06CB9308393
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 03:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhA2CKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 21:10:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:56824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229828AbhA2CKw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 21:10:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 94F7764D99;
        Fri, 29 Jan 2021 02:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611886211;
        bh=RdENYdY4gj6wWwcaWo8+tbsc4H/ztPUCWEomHGAfofI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U4E7warIHq20ogYmAVgcA9mlREq746dtOcG179n4jJ1jA83uE6sZNpSUZgKpG+b+x
         715RqmhkToUVTTfE4nl3b0ScGdBujsLErRa5rThKhZ3oUvygoPeh4j4P17Dz5PXXr+
         hzbT+Bo53I/bxYThgpO8P4ey4Q6dFijwBBBiXntFLadwS8up+nj6PIWO71QOZJNXyk
         RdzcVCVZP2ebNuMXLUE8aK+zBYTLMs3wMmM0uXdQWwTFTPATHBZm2TwZy7A4QQeVty
         C6bepaHJYCYGu8aHWp/jbzC1Aier/v4/0y5ZncxOYopsjil2KIy53ieAAZbDWnztRB
         4bTgjhGLwLDEA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8438B65324;
        Fri, 29 Jan 2021 02:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipvlan: remove h from printk format specifier
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161188621153.7700.11671679352103424363.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jan 2021 02:10:11 +0000
References: <20210124190804.1964580-1-trix@redhat.com>
In-Reply-To: <20210124190804.1964580-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, maheshb@google.com,
        edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 24 Jan 2021 11:08:04 -0800 you wrote:
> From: Tom Rix <trix@redhat.com>
> 
> This change fixes the checkpatch warning described in this commit
> commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use of
>   unnecessary %h[xudi] and %hh[xudi]")
> 
> Standard integer promotion is already done and %hx and %hhx is useless
> so do not encourage the use of %hh[xudi] or %h[xudi].
> 
> [...]

Here is the summary with links:
  - ipvlan: remove h from printk format specifier
    https://git.kernel.org/netdev/net-next/c/d7a177ea8fe6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


