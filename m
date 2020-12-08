Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5842D2F55
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 17:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730227AbgLHQUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 11:20:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:58904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728679AbgLHQUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 11:20:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607444406;
        bh=scIWirR59KFZIsD9V4p0CTy8sSmcAyyTZU450t0uR3s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EMfJRHu7CyE7oSq//HWDU6YmnbjnZZfMlugOZSFoX5XZgfsA4tdTLg6hR2V3bK1qs
         4au65OIPo0Ru3wP+DTCOaJULaB7PnAqqVOYgaAcZ49Hf+4RSu6YBhh9kuRYPWpbHeQ
         gcZ4MV9dA9QzHLdgTN69KkXW/G83GkqfPoyITSZm1cCurq+UrRbQAQiXTEyLp9fAcL
         NTV7CByw0w88fN9If20PY39aDrxLgrrDy85RSRnnQRobQK04bxXzh2xTGgs76cQb1A
         Mz3bxf+fKMCQ6aQC6FbNvZvqqcjo6nnHYdyrWAN7kuqWJ6C3wzDVosqltEN5/ytIcc
         dh8pgF5zDBGvA==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next] bpf: return -ENOTSUPP when attaching to
 non-kernel BTF
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160744440636.9463.7172637715152108009.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Dec 2020 16:20:06 +0000
References: <20201208064326.667389-1-andrii@kernel.org>
In-Reply-To: <20201208064326.667389-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com, ast@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Mon, 7 Dec 2020 22:43:26 -0800 you wrote:
> Return -ENOTSUPP if tracing BPF program is attempted to be attached with
> specified attach_btf_obj_fd pointing to non-kernel (neither vmlinux nor
> module) BTF object. This scenario might be supported in the future and isn't
> outright invalid, so -EINVAL isn't the most appropriate error code.
> 
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next] bpf: return -ENOTSUPP when attaching to non-kernel BTF
    https://git.kernel.org/bpf/bpf-next/c/8bdd8e275ede

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


