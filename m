Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300282CCCDA
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 03:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgLCCuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 21:50:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:57734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgLCCuz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 21:50:55 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606963814;
        bh=fcc2vMF7JXpGEwhIXJlwVsC7GeZ8+GUJEPNkGILoQVM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KLQZoRJ8JhMIa0OJN5QLbLHx0VEGBpAAI3EVevwhowf6xUPqPVOwSlFxsipRefkwc
         MeoM38HYGxotWdY7oirNd0dXoDWGvVzzb8Q2M0Q6we9g157VW1ZuV38SSS8OKBBkBo
         UbzHXBqaHBSFNK7beDXSSHlkdFemU+HHAb3SgTI7pGgdvH4k4R/PV5PSFZNiVgmgk2
         ZU35vprMCpTVxxm1d+G4jAt3NF0IQyzYXHDrxASgKTPy+5YM38akgdzTcyzLyBO6nZ
         kgG0Kh7aFJU3ujVYzF1Az9q7tztqTWERlvSyzZOIA55Wbiw58napPH0uj32aSIjSbz
         +bHX1265WQuMw==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v9 00/34] bpf: switch to memcg-based memory
 accounting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160696381396.20026.12605091950733901404.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Dec 2020 02:50:13 +0000
References: <20201201215900.3569844-1-guro@fb.com>
In-Reply-To: <20201201215900.3569844-1-guro@fb.com>
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, andrii@kernel.org,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Tue, 1 Dec 2020 13:58:26 -0800 you wrote:
> Currently bpf is using the memlock rlimit for the memory accounting.
> This approach has its downsides and over time has created a significant
> amount of problems:
> 
> 1) The limit is per-user, but because most bpf operations are performed
>    as root, the limit has a little value.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v9,01/34] mm: memcontrol: use helpers to read page's memcg data
    https://git.kernel.org/bpf/bpf-next/c/bcfe06bf2622
  - [bpf-next,v9,02/34] mm: memcontrol/slab: use helpers to access slab page's memcg_data
    https://git.kernel.org/bpf/bpf-next/c/270c6a71460e
  - [bpf-next,v9,03/34] mm: introduce page memcg flags
    https://git.kernel.org/bpf/bpf-next/c/87944e2992bd
  - [bpf-next,v9,04/34] mm: convert page kmemcg type to a page memcg flag
    https://git.kernel.org/bpf/bpf-next/c/18b2db3b0385
  - [bpf-next,v9,05/34] bpf: memcg-based memory accounting for bpf progs
    https://git.kernel.org/bpf/bpf-next/c/ddf8503c7c43
  - [bpf-next,v9,06/34] bpf: prepare for memcg-based memory accounting for bpf maps
    https://git.kernel.org/bpf/bpf-next/c/48edc1f78aab
  - [bpf-next,v9,07/34] bpf: memcg-based memory accounting for bpf maps
    https://git.kernel.org/bpf/bpf-next/c/d5299b67dd59
  - [bpf-next,v9,08/34] bpf: refine memcg-based memory accounting for arraymap maps
    https://git.kernel.org/bpf/bpf-next/c/6d192c7938b7
  - [bpf-next,v9,09/34] bpf: refine memcg-based memory accounting for cpumap maps
    https://git.kernel.org/bpf/bpf-next/c/e88cc05b61f3
  - [bpf-next,v9,10/34] bpf: memcg-based memory accounting for cgroup storage maps
    https://git.kernel.org/bpf/bpf-next/c/3a61c7c58b30
  - [bpf-next,v9,11/34] bpf: refine memcg-based memory accounting for devmap maps
    https://git.kernel.org/bpf/bpf-next/c/1440290adf7b
  - [bpf-next,v9,12/34] bpf: refine memcg-based memory accounting for hashtab maps
    https://git.kernel.org/bpf/bpf-next/c/881456811a33
  - [bpf-next,v9,13/34] bpf: memcg-based memory accounting for lpm_trie maps
    https://git.kernel.org/bpf/bpf-next/c/353e7af4bf5e
  - [bpf-next,v9,14/34] bpf: memcg-based memory accounting for bpf ringbuffer
    https://git.kernel.org/bpf/bpf-next/c/be4035c734d1
  - [bpf-next,v9,15/34] bpf: memcg-based memory accounting for bpf local storage maps
    https://git.kernel.org/bpf/bpf-next/c/e9aae8beba82
  - [bpf-next,v9,16/34] bpf: refine memcg-based memory accounting for sockmap and sockhash maps
    https://git.kernel.org/bpf/bpf-next/c/7846dd9f835e
  - [bpf-next,v9,17/34] bpf: refine memcg-based memory accounting for xskmap maps
    https://git.kernel.org/bpf/bpf-next/c/28e1dcdef0cb
  - [bpf-next,v9,18/34] bpf: eliminate rlimit-based memory accounting for arraymap maps
    https://git.kernel.org/bpf/bpf-next/c/1bc5975613ed
  - [bpf-next,v9,19/34] bpf: eliminate rlimit-based memory accounting for bpf_struct_ops maps
    https://git.kernel.org/bpf/bpf-next/c/f043733f31e5
  - [bpf-next,v9,20/34] bpf: eliminate rlimit-based memory accounting for cpumap maps
    https://git.kernel.org/bpf/bpf-next/c/711cabaf1432
  - [bpf-next,v9,21/34] bpf: eliminate rlimit-based memory accounting for cgroup storage maps
    https://git.kernel.org/bpf/bpf-next/c/087b0d39fe22
  - [bpf-next,v9,22/34] bpf: eliminate rlimit-based memory accounting for devmap maps
    https://git.kernel.org/bpf/bpf-next/c/844f157f6c0a
  - [bpf-next,v9,23/34] bpf: eliminate rlimit-based memory accounting for hashtab maps
    https://git.kernel.org/bpf/bpf-next/c/755e5d55367a
  - [bpf-next,v9,24/34] bpf: eliminate rlimit-based memory accounting for lpm_trie maps
    https://git.kernel.org/bpf/bpf-next/c/cbddcb574d41
  - [bpf-next,v9,25/34] bpf: eliminate rlimit-based memory accounting for queue_stack_maps maps
    https://git.kernel.org/bpf/bpf-next/c/a37fb7ef24a4
  - [bpf-next,v9,26/34] bpf: eliminate rlimit-based memory accounting for reuseport_array maps
    https://git.kernel.org/bpf/bpf-next/c/db54330d3e13
  - [bpf-next,v9,27/34] bpf: eliminate rlimit-based memory accounting for bpf ringbuffer
    https://git.kernel.org/bpf/bpf-next/c/abbdd0813f34
  - [bpf-next,v9,28/34] bpf: eliminate rlimit-based memory accounting for sockmap and sockhash maps
    https://git.kernel.org/bpf/bpf-next/c/0d2c4f964050
  - [bpf-next,v9,29/34] bpf: eliminate rlimit-based memory accounting for stackmap maps
    https://git.kernel.org/bpf/bpf-next/c/370868107bf6
  - [bpf-next,v9,30/34] bpf: eliminate rlimit-based memory accounting for xskmap maps
    https://git.kernel.org/bpf/bpf-next/c/819a4f323579
  - [bpf-next,v9,31/34] bpf: eliminate rlimit-based memory accounting for bpf local storage maps
    https://git.kernel.org/bpf/bpf-next/c/ab31be378a63
  - [bpf-next,v9,32/34] bpf: eliminate rlimit-based memory accounting infra for bpf maps
    https://git.kernel.org/bpf/bpf-next/c/80ee81e0403c
  - [bpf-next,v9,33/34] bpf: eliminate rlimit-based memory accounting for bpf progs
    https://git.kernel.org/bpf/bpf-next/c/3ac1f01b43b6
  - [bpf-next,v9,34/34] bpf: samples: do not touch RLIMIT_MEMLOCK
    https://git.kernel.org/bpf/bpf-next/c/5b0764b2d345

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


