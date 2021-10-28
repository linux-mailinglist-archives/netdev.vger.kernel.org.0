Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4AD43E29E
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhJ1Nww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:52:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230258AbhJ1Nwf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 09:52:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 867F561154;
        Thu, 28 Oct 2021 13:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635429008;
        bh=faPta3OUJ5SNPw/PLJr2sBQDxSDb64bbG/7xv2gqM30=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IbJQfy8fJiIWh+7cytipJwgnjdhpwPrPDa4eKJcu/52l2S+lP7Jl2i0oQMGZLehSX
         i33w/GSI3eRVRWJRsly22ExWrDuZ2KGWUu8SyLEFIetTIaQk2q6y59/quaYeDFp3Vb
         Sxk7A5e9W7I3pY4xHqLWFbFRI981eFh6BL7IlTVpHncKMyMNgR/rCcdIbDa6QFhpYp
         dRzP/CadkCIIKB/m9Yzn6K24hFY7nrsgwZvtRyk0Myo/L41O9V/QriOQnBLeldXTz+
         fEFjNzzt06RU+6huhjycnktbk/SIJIAscGMmo24JfHrqd8EyC5ajTyFUJNcv5CurFz
         aASjSArrcLXZg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 80C5A60A5A;
        Thu, 28 Oct 2021 13:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ptp: fix code indentation issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163542900852.8409.2836302978583592473.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 13:50:08 +0000
References: <20211027231802.2844313-1-cmllamas@google.com>
In-Reply-To: <20211027231802.2844313-1-cmllamas@google.com>
To:     Carlos Llamas <cmllamas@google.com>
Cc:     richardcochran@gmail.com, davem@davemloft.net,
        yangyingliang@huawei.com, netdev@vger.kernel.org,
        kernel-team@android.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 27 Oct 2021 23:18:02 +0000 you wrote:
> This fixes the following checkpatch.pl errors:
> 
> ERROR: code indent should use tabs where possible
> +^I        if (ptp->pps_source)$
> 
> ERROR: code indent should use tabs where possible
> +^I                pps_unregister_source(ptp->pps_source);$
> 
> [...]

Here is the summary with links:
  - [net] ptp: fix code indentation issues
    https://git.kernel.org/netdev/net-next/c/11195bf5a355

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


