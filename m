Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129AF3B1541
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 10:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhFWICd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 04:02:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230052AbhFWICV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 04:02:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 045E661361;
        Wed, 23 Jun 2021 08:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624435204;
        bh=iHveAQ7hn8DmX+6PdFtc8zaPPT+BPX+b7UCxlM+J6kk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OH7vZ0XAzcDlrY5+iAwi+Jaqlk5d3g/ThJU0iE/SUFAJZnUY8k62W8/2O7PqiWQSg
         G3z/H8XQGmkytMFuXNu92fPQ9T0dtjM27XXI3/e2TW5Resl+CjdLyV4qLvT+rXbenW
         t71fuvz7mbzXiiTxt2a/Nn5yN7KH9/l1DtlR70/4Q+jP6ItpbvjmDRuHG0Y4aEMNMk
         Vv3E26AIN+Apg083urx2CCvyk8K2sGsXVIxBQlhoXCWnalt2Dk0CXFJXnSQZ9I4uUF
         NZLVsO1q2nrZnxaX93ix4Aw2JVmXzWkL1qcX5hLlhvSYxGvYWLk8PxLIhQzzCWYXFn
         ZYY8q8XZSoyUw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EA7F960A47;
        Wed, 23 Jun 2021 08:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] docs: af_xdp: consistent indentation in examples
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162443520395.27724.1615585938370222693.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Jun 2021 08:00:03 +0000
References: <20210622185647.3705104-1-i.maximets@ovn.org>
In-Reply-To: <20210622185647.3705104-1-i.maximets@ovn.org>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, davem@davemloft.net, kuba@kernel.org,
        corbet@lwn.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Tue, 22 Jun 2021 20:56:47 +0200 you wrote:
> Examples in this document use all kinds of indentation from 3 to 5
> spaces and even mixed with tabs.  Making them all even and equal to
> 4 spaces.
> 
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> ---
>  Documentation/networking/af_xdp.rst | 32 ++++++++++++++---------------
>  1 file changed, 16 insertions(+), 16 deletions(-)

Here is the summary with links:
  - docs: af_xdp: consistent indentation in examples
    https://git.kernel.org/bpf/bpf-next/c/4b9718b5a201

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


