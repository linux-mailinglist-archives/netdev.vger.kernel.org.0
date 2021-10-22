Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975084380C1
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 01:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhJVXwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 19:52:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231293AbhJVXwZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 19:52:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 18E8861078;
        Fri, 22 Oct 2021 23:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634946607;
        bh=52MhHSRNdDSztc0sngTAhd9847cchjH0bEDnZCu0LIA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Lkk0V+LczlTf9O2NZUA0hvsLjjvgrDRH3eGbAiflLlRLWwX82gWYozbvrsPpXY73y
         ZVf+u2dk4/UuPbYJky7nBUP0PPzPayXclBAYYYMTb/3fkGqaw1COjLhrkmfENRpECo
         zxnhXsxB0n27W2fHI6wKKsLqzp485YQqAAOcmaXDGYPCvHyZifQpLqYOaJIL4a12JJ
         4KPuPIDsI0jjFC8xwYrT3DbWd2EtlOdGQ4RIdJU+mlPFZoG++G2FaPER3aCXNTwNZN
         6mHMPuUZn5rmrhjf04JUKXpp/ZnI3QT59exskOYuOdePotcr7AVdhUZiKVvjCcADBR
         LlQE+st3kLJQQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0314B60A47;
        Fri, 22 Oct 2021 23:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpftool: avoid leaking the JSON writer prepared for
 program metadata
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163494660700.5438.6280491410693757212.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Oct 2021 23:50:07 +0000
References: <20211022094743.11052-1-quentin@isovalent.com>
In-Reply-To: <20211022094743.11052-1-quentin@isovalent.com>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zhuyifei@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Fri, 22 Oct 2021 10:47:43 +0100 you wrote:
> Bpftool creates a new JSON object for writing program metadata in plain
> text mode, regardless of metadata being present or not. Then this writer
> is freed if any metadata has been found and printed, but it leaks
> otherwise. We cannot destroy the object unconditionally, because the
> destructor prints an undesirable line break. Instead, make sure the
> writer is created only after we have found program metadata to print.
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpftool: avoid leaking the JSON writer prepared for program metadata
    https://git.kernel.org/bpf/bpf-next/c/e89ef634f81c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


