Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F089549EDBF
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 22:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236317AbiA0VuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 16:50:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50444 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233574AbiA0VuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 16:50:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE25D61B76;
        Thu, 27 Jan 2022 21:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39242C340E9;
        Thu, 27 Jan 2022 21:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643320209;
        bh=bc9FdBvKKjDxU5M79mkzd3zWQh71IJmJMwOkJM4zQYQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZIWlsoIQ49vWNoza0qnHu1K2F2Bhm1bbA3YVvOyvpeEDo92KiYjWBjTkeMS1Sy3sK
         cfcskWIkdWm35Tm4nVY6QIbGHg3p2aQOAFVcxAmDTMohyPwLdnoBeNTGGrqN2DRVtl
         rQtdWE+6OWWm7vTGnVjYGQpmOtMGM9EiQ4YBu/GEWwdgAUxlaVWz2oQPnpWQC/6ZST
         m8Jpua7Wrk6qMEz7MaiQTEFXyxxbM8vZ7lIXrjNusscuze4KX4OxDSpXff3WMGI12N
         PY6YQ0XuvVIVrehDPZsqpOwctf2lFAyaGnwH9f/cTnRxKHqHexen2opgZ6H5AdD8/v
         4sVKh3zm9cKuA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 215EBE5D084;
        Thu, 27 Jan 2022 21:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf,
 x86: remove unnecessary handling of BPF_SUB atomic op
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164332020913.6471.16764153839958663792.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 21:50:09 +0000
References: <20220127083240.1425481-1-houtao1@huawei.com>
In-Reply-To: <20220127083240.1425481-1-houtao1@huawei.com>
To:     Hou Tao <houtao1@huawei.com>
Cc:     ast@kernel.org, john.fastabend@gmail.com, kafai@fb.com, yhs@fb.com,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, jackmanb@google.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu, 27 Jan 2022 16:32:40 +0800 you wrote:
> According to the LLVM commit (https://reviews.llvm.org/D72184),
> sync_fetch_and_sub() is implemented as a negation followed by
> sync_fetch_and_add(), so there will be no BPF_SUB op and just
> remove it.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf, x86: remove unnecessary handling of BPF_SUB atomic op
    https://git.kernel.org/bpf/bpf-next/c/b6ec79518ef0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


