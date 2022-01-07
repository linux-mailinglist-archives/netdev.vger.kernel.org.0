Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75843487EB9
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 23:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbiAGWAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 17:00:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45900 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbiAGWAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 17:00:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 425E8B8278C;
        Fri,  7 Jan 2022 22:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E08C5C36AF3;
        Fri,  7 Jan 2022 22:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641592810;
        bh=bTlSZejXDuY45ouciVP68pq4GFckfoeRTq9mjoNq4sc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IzSF/OPjPQWKeZkqDyarWy/NUZi+p62Jk2ppHt+TirAwYIiFEeJ0W46K9UiYRD1B6
         gwoQb4/J7an9rsH66gWhEM1+KVybVBYYvKWfnZuQCv4HMo8IjKAA3C3vdIFoLK6gvD
         /SKIKlrYVzy6OFVI6/SKR5uHqdbsiuttacbgI0RgtDarBqaFWjQPcFXPq2PJMMeF4W
         Q1jzrDlpaPCP1d3Vp62rmHTT50btQ2+d27gXW4LPL01r9HCkchgv38tI44kyzNbSNc
         fH8mHzwegII67Kbs80T9kABbHvJN6DSDaCUaqQCmQq9Whi45M4rvw/nnFMp0J/gCXq
         /NK0IYgnxsSGg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF444F79401;
        Fri,  7 Jan 2022 22:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 1/2] libbpf: Use IS_ERR_OR_NULL() in hashmap__free()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164159281077.23296.8769148718825057618.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Jan 2022 22:00:10 +0000
References: <20220107152620.192327-1-mauricio@kinvolk.io>
In-Reply-To: <20220107152620.192327-1-mauricio@kinvolk.io>
To:     =?utf-8?q?Mauricio_V=C3=A1squez_=3Cmauricio=40kinvolk=2Eio=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, quentin@isovalent.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Fri,  7 Jan 2022 10:26:19 -0500 you wrote:
> hashmap__new() uses ERR_PTR() to return an error so it's better to
> use IS_ERR_OR_NULL() in order to check the pointer before calling
> free(). This will prevent freeing an invalid pointer if somebody calls
> hashmap__free() with the result of a failed hashmap__new() call.
> 
> Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/2] libbpf: Use IS_ERR_OR_NULL() in hashmap__free()
    https://git.kernel.org/bpf/bpf-next/c/d793c2eb5dbc
  - [bpf-next,2/2] bpftool: Fix error check when calling hashmap__new()
    https://git.kernel.org/bpf/bpf-next/c/2318517920d1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


