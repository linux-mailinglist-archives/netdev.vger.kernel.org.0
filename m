Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E6C2FADA1
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 00:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732484AbhARXAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 18:00:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:43714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732481AbhARXAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 18:00:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 04C6122EBF;
        Mon, 18 Jan 2021 23:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611010808;
        bh=7/i6FKOJv0Va3+UWXcyDz09yHfTddkLrm7z9LdFTWDM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ee2FhJV4iK0PVba647lYnKG0SJCX+04Ip+zEakrBnAXjOtRjeGOjbxF4RyaGuPaDa
         17S25O1RtUzA1hUPuRnSRe4D7oxWymmnuZ6Q1DJ4okk1LquaRaSy2ii/zwhKWSUcFc
         9OvoiFJhKAfz33joGBj3PZlhPQmmozq7YzzBQ12r2jxeYVKdj7TgewG0W98CUpQgIS
         J/T7nv1BmiXIKYLz4+KUfJ7Kc1NrzrJ25cMG+2ql+HIN1Ht6wGCldnvoLplW6T76+r
         uGQXJ9C1R0bXpI+WOX+R5HO11N/BdACdpoFu6ZzWi6LOZ2oLw/IVdQgVifj4OlAB+i
         eNhjcHWCkPhew==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id E9DDC602DA;
        Mon, 18 Jan 2021 23:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] samples/bpf: add BPF_ATOMIC_OP macro for BPF samples
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161101080795.7559.2010212326831673657.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Jan 2021 23:00:07 +0000
References: <20210118091753.107572-1-bjorn.topel@gmail.com>
In-Reply-To: <20210118091753.107572-1-bjorn.topel@gmail.com>
To:     =?utf-8?b?QmrDtnJuIFTDtnBlbCA8Ympvcm4udG9wZWxAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, jackmanb@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Mon, 18 Jan 2021 10:17:53 +0100 you wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> Brendan Jackman added extend atomic operations to the BPF instruction
> set in commit 7064a7341a0d ("Merge branch 'Atomics for eBPF'"), which
> introduces the BPF_ATOMIC_OP macro. However, that macro was missing
> for the BPF samples. Fix that by adding it into bpf_insn.h.
> 
> [...]

Here is the summary with links:
  - [bpf-next] samples/bpf: add BPF_ATOMIC_OP macro for BPF samples
    https://git.kernel.org/bpf/bpf-next/c/af6953b633b3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


