Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9834D38F3AB
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 21:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbhEXTbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 15:31:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233026AbhEXTbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 15:31:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A9E74613F7;
        Mon, 24 May 2021 19:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621884609;
        bh=xhRtJFhatXXsP6oM4d/pqsgRJzZZm4aa56al4rHMiRc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s3KrOBEIakzd54eWlW220s/mo2I0o5NNJOp4y+/XuEpg+KEvkxlVunOsBKy3zh3jz
         EeFBcNQZkFcHcBaxILxTkwOzc4kDfPp+vbecURSAf6iJIZTYmAAoqtudPolDftK5J7
         b+H6jy3ay+Y8TNiNVqmPEgBF11jIs7tI81VtC66rQVG25lHm1nUIVh74ZOu/S4v/r+
         Q/S+7xj1yX8xJr+NRTkVZSV+96WTJcsf/ThafIzWi/2+hmUeIDGs1/pAZqs5MYVMID
         96HrRUsP5yPIBcEZWm0dkZgJp7W6AS6XtziCJXvD1zDoJQ5wCM/keSh7TYtG03ojXm
         4FZn8N6led/Mg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A0F6E60BD8;
        Mon, 24 May 2021 19:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] libbpf: skip bpf_object__probe_loading for light
 skeleton
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162188460965.29581.17272808864471775553.git-patchwork-notify@kernel.org>
Date:   Mon, 24 May 2021 19:30:09 +0000
References: <20210521030653.2626513-1-sdf@google.com>
In-Reply-To: <20210521030653.2626513-1-sdf@google.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Thu, 20 May 2021 20:06:53 -0700 you wrote:
> I'm getting the following error when running 'gen skeleton -L' as
> regular user:
> 
> libbpf: Error in bpf_object__probe_loading():Operation not permitted(1).
> Couldn't load trivial BPF program. Make sure your kernel supports BPF
> (CONFIG_BPF_SYSCALL=y) and/or that RLIMIT_MEMLOCK is set to big enough
> value.
> 
> [...]

Here is the summary with links:
  - [bpf-next] libbpf: skip bpf_object__probe_loading for light skeleton
    https://git.kernel.org/bpf/bpf-next/c/f9bceaa59c5c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


