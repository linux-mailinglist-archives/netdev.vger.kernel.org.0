Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B15302FDD
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732697AbhAYXMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:12:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:34050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732516AbhAYXKz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 18:10:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B6E74229C4;
        Mon, 25 Jan 2021 23:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611616211;
        bh=bzxH52m6mEeu7PK5hxWtLULWiou9rXvMKEBFxfxWch8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I98T+10ZlfBp3149/mw35omP8QRKr5YHOhus7qd4AIXwMQHbKZ4OpblmocNn9k5c7
         Ix3GSVkT/ezeJK1Fh3P6RC68cNMjM4uizWEk1aaigQBDvHKQWfZW1l9a2ra4euRFnw
         teB5fwzdCSmJ0PbT3s+pK1Ox2OQPHBJlRkGMmmnZOX92gjj9qGEP9jlLVkXF6nL+L8
         /t/s4aDPGqoGBtc6QhCZGiPKstAgoFgV+bwBK46OQIX5fGhKFRVl2DyVk2rDDvCffn
         COceBVk+opkH52N5EIbRo5uso5K8h9nlCwRGurobF/Jnqv2MTZTp/KD04acdgd97F4
         ch9hSKp+vE4Vg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A859061F2E;
        Mon, 25 Jan 2021 23:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 00/12] Various cleanups/fixes for AF_XDP selftests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161161621168.7118.186206208680598620.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Jan 2021 23:10:11 +0000
References: <20210122154725.22140-1-bjorn.topel@gmail.com>
In-Reply-To: <20210122154725.22140-1-bjorn.topel@gmail.com>
To:     =?utf-8?b?QmrDtnJuIFTDtnBlbCA8Ympvcm4udG9wZWxAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Fri, 22 Jan 2021 16:47:13 +0100 you wrote:
> This series is a number of fixes/cleanups, mainly to improve the
> readability of the xdpxceiver selftest application.
> 
> Details in each commit!
> 
> 
> Cheers,
> Björn
> 
> [...]

Here is the summary with links:
  - [bpf-next,01/12] selftests/bpf: remove a lot of ifobject casting
    https://git.kernel.org/bpf/bpf-next/c/7140ef14007e
  - [bpf-next,02/12] selftests/bpf: remove unused enums
    https://git.kernel.org/bpf/bpf-next/c/449f0874fd4e
  - [bpf-next,03/12] selftests/bpf: fix style warnings
    https://git.kernel.org/bpf/bpf-next/c/a86072838b67
  - [bpf-next,04/12] selftests/bpf: remove memory leak
    https://git.kernel.org/bpf/bpf-next/c/4896d7e37ea5
  - [bpf-next,05/12] selftests/bpf: improve readability of xdpxceiver/worker_pkt_validate()
    https://git.kernel.org/bpf/bpf-next/c/8a9cba7ea858
  - [bpf-next,06/12] selftests/bpf: remove casting by introduce local variable
    https://git.kernel.org/bpf/bpf-next/c/0b50bd48cfe7
  - [bpf-next,07/12] selftests/bpf: change type from void * to struct ifaceconfigobj *
    https://git.kernel.org/bpf/bpf-next/c/124000e48b7e
  - [bpf-next,08/12] selftests/bpf: change type from void * to struct generic_data *
    https://git.kernel.org/bpf/bpf-next/c/59a4a87e4b26
  - [bpf-next,09/12] selftests/bpf: define local variables at the beginning of a block
    https://git.kernel.org/bpf/bpf-next/c/829725ec7bf5
  - [bpf-next,10/12] selftests/bpf: avoid heap allocation
    https://git.kernel.org/bpf/bpf-next/c/93dd4a06c0e3
  - [bpf-next,11/12] selftests/bpf: consistent malloc/calloc usage
    https://git.kernel.org/bpf/bpf-next/c/d08a17d6de20
  - [bpf-next,12/12] selftests/bpf: avoid useless void *-casts
    https://git.kernel.org/bpf/bpf-next/c/095af986525a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


