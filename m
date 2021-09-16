Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1621740DA82
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 15:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239792AbhIPNB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 09:01:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239741AbhIPNB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 09:01:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CC5F860EE9;
        Thu, 16 Sep 2021 13:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631797207;
        bh=b2pU57FhVLp5+sAxVdLdiB8G3NtaTNgb27tj1GNVBSU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gfcfXUtFYwc/wLuaB+FiiOL32FOzDeL63kkn1u/vSuBHebXZRlYQSRvPeAqu1Gw8k
         8epXIMgEbA87h4Fb1bntHb9XTlDxAv2QebBEPAWFDtA7uH6Orj0+GhOLHpVe2nPttR
         NRp4gxc0M8O8Tf8uKCQbOfr9DMECMLbMPktX8un5eYK4EPDbIZ7btwu1HLJjcMasjS
         8jFGgY0Q/1y2US2ZNLwGX/enwCqkfoXFCXppPfBf074iXGRw8Z8MvFA7fYOhmNEt5j
         AMk206vIZzX9isSHM0BxMrrt/mDDxVzzGtd033cv7xj7mVOOznvvtaAfi3P30sS8Hq
         U/iBe2LTwVb5A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B77E960A9E;
        Thu, 16 Sep 2021 13:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] selftests: nci: replace unsigned int with int
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163179720774.29332.2952119753951803388.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Sep 2021 13:00:07 +0000
References: <20210916122442.14732-1-wangxiang@cdjrlc.com>
In-Reply-To: <20210916122442.14732-1-wangxiang@cdjrlc.com>
To:     Xiang wangx <wangxiang@cdjrlc.com>
Cc:     bongsu.jeon@samsung.com, shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 16 Sep 2021 20:24:42 +0800 you wrote:
> Should not use comparison of unsigned expressions < 0.
> 
> Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
> ---
> 
> Changes since v1
> * Change commit log
> 
> [...]

Here is the summary with links:
  - [v3] selftests: nci: replace unsigned int with int
    https://git.kernel.org/netdev/net/c/98dc68f8b0c2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


