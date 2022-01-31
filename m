Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC78F4A5097
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 21:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379217AbiAaUxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 15:53:47 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:47374 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240122AbiAaUxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 15:53:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 76C13CE169F;
        Mon, 31 Jan 2022 20:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B87F6C340F0;
        Mon, 31 Jan 2022 20:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643662422;
        bh=ZmsmhNqvIl6GsqenI7gJdKN+zOLEOvin7Kd5KbEWOiY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fREXsiad8dP4MDUR7USpMPSzu0zepniUJ7V/Gejegrqt5MyAilhORM2B/h9u0V0h9
         0qe8vndD0txFH0bK2KTdJ9a/LVdq8lwp8AMc9i18pgOkMHKyBg7OSnTvU8fjUIuHsW
         qvuMAl6dhWb2+WXWITpMtj9RdDTEKp8UZWAxZTynIz7E8hDpqAzXOBQ5aSuN7mKyFh
         RTKU2514+w5elb98iZeMoWnXxJU/yJNe5CIdxbv8sKri8pYM7a4OsdVjS+fGKkESaK
         XAw1xuHJ+xgeCTuwmtYM+MDZtT7IT+9YobJLvwdj6Tjz5+YHbYP35xxBPv2b5zn1hc
         8lil7p6PpLbtA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A198AE6BAC6;
        Mon, 31 Jan 2022 20:53:42 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 0/2] Split bpf_sock dst_port field
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164366242265.17453.14979978699179482148.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Jan 2022 20:53:42 +0000
References: <20220130115518.213259-1-jakub@cloudflare.com>
In-Reply-To: <20220130115518.213259-1-jakub@cloudflare.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        kafai@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Sun, 30 Jan 2022 12:55:16 +0100 you wrote:
> This is a follow-up to discussion around the idea of making dst_port in struct
> bpf_sock a 16-bit field that happened in [1].
> 
> v2:
> - use an anonymous field for zero padding (Alexei)
> 
> v1:
> - keep dst_field offset unchanged to prevent existing BPF program breakage
>   (Martin)
> - allow 8-bit loads from dst_port[0] and [1]
> - add test coverage for the verifier and the context access converter
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,1/2] bpf: Make dst_port field in struct bpf_sock 16-bit wide
    https://git.kernel.org/bpf/bpf-next/c/4421a582718a
  - [bpf-next,v2,2/2] selftests/bpf: Extend verifier and bpf_sock tests for dst_port loads
    https://git.kernel.org/bpf/bpf-next/c/8f50f16ff39d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


