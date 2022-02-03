Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466A74A8A48
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352941AbiBCRkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:40:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49026 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239435AbiBCRkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:40:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2960C60B72;
        Thu,  3 Feb 2022 17:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88136C340ED;
        Thu,  3 Feb 2022 17:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643910009;
        bh=SAdLkjNr2RrsDyFMfuy2KN43kJtChi9IrkQ9pgfD/P0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n7in4HcX96wOqxtz3BVsjMjFf1m0bRM4W1Uk+R+Pf6dPPyKm9SJnup871Z47UA//L
         nz0kUntVSlXDMmFOcW7kpJJHQ2e29Li505Ag6JHd2fzKebpGN7BdUkDHDp0qB8yDsO
         10kRvUEnCkZFQfcFDKmF6Y3/z4o8X8ecbdaPOVBtkyjTgf7rjW7f3rB9NvSk3yCNgb
         UrxdfZDxMrX6uLuIvMOGvl2m6xm2rI8Hyfcd3qLY/z7gEJM4xZDzN0YeEOhxu5BLNn
         8vMSXE1CcHu5Vh4FtN44JI+AzSefIrt++289tYFQ39QqNC0NxlRf+nk7llWIFy/dzV
         6AJI/gTwF3Nng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6D7B9E5D08C;
        Thu,  3 Feb 2022 17:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/5] bpf, docs: Document the byte swapping instructions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164391000944.27300.17075086641401753236.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Feb 2022 17:40:09 +0000
References: <20220131183638.3934982-2-hch@lst.de>
In-Reply-To: <20220131183638.3934982-2-hch@lst.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     corbet@lwn.net, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Mon, 31 Jan 2022 19:36:34 +0100 you wrote:
> Add a section to document the byte swapping instructions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/bpf/instruction-set.rst | 44 ++++++++++++++++++++++++---
>  1 file changed, 40 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [1/5] bpf, docs: Document the byte swapping instructions
    https://git.kernel.org/bpf/bpf-next/c/dd33fb571f5c
  - [2/5] bpf, docs: Better document the regular load and store instructions
    https://git.kernel.org/bpf/bpf-next/c/63d8c242b9a5
  - [3/5] bpf, docs: Better document the legacy packet access instruction
    https://git.kernel.org/bpf/bpf-next/c/15175336270a
  - [4/5] bpf, docs: Better document the extended instruction format
    https://git.kernel.org/bpf/bpf-next/c/5ca15b8a939f
  - [5/5] bpf, docs: Better document the atomic instructions
    https://git.kernel.org/bpf/bpf-next/c/594d32348556

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


