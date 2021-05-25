Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8723F3903C7
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 16:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbhEYOVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 10:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233401AbhEYOVj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 10:21:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 02CEB6142B;
        Tue, 25 May 2021 14:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621952410;
        bh=uMnHa6ZOLtNxDi9gA1MQfUF6Bopn37EoixFRmu3Za54=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ktzuFqAwit63Hm/7sTyJr0S3+1+dkgjhVYBAawgMbJuoIfy8DpQX/+MaTZ3KmLfTP
         Bg6iPsbLy7rzBgjA5tcEzonkwhQ/664Z8BByJNPYL++vcPPtE1HWyvoONdCkFaZUGZ
         ZM/G6Ew13gBHGJkMmR3ZLbtgoLKIgO6K3SmNxsCv9jo8hVzwI6WcdW1exoZ3U6o5Dp
         m8xP04EEC/h/i8P5kw6uj1thp2lZt9MNBHYtjLKNsHqnP0yXov/VnJTWF/ZQ9NCnzf
         /bxIyveqSCnaOeJBJ/fLJriYi5VMv2LNWNUNeI0vwATLYxMVwxccwbUBcqSRnkKW59
         m0JDQAZzmLHPg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E9B5260CD8;
        Tue, 25 May 2021 14:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] bpftool: Add sock_release help info for cgroup attach/prog
 load command
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162195240995.24888.15893741035233070045.git-patchwork-notify@kernel.org>
Date:   Tue, 25 May 2021 14:20:09 +0000
References: <20210525014139.323859-1-liujian56@huawei.com>
In-Reply-To: <20210525014139.323859-1-liujian56@huawei.com>
To:     Liu Jian <liujian56@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        quentin@isovalent.com, sdf@google.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Tue, 25 May 2021 09:41:39 +0800 you wrote:
> The help information is not added when the function is added.
> Here add the missing information to its cli, documentation and bash completion.
> 
> Fixes: db94cc0b4805 ("bpftool: Add support for BPF_CGROUP_INET_SOCK_RELEASE")
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---
> v1 -> v2:
>      Add changelog text.
> v2 -> v3:
>      Also change prog cli help info, documentation and bash completion mentioned by Quentin.
>      So the subject was also changed.
> 
> [...]

Here is the summary with links:
  - [v3] bpftool: Add sock_release help info for cgroup attach/prog load command
    https://git.kernel.org/bpf/bpf/c/a8deba8547e3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


