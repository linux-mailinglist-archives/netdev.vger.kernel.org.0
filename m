Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328CB355F76
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344430AbhDFXaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:30:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244126AbhDFXaT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 19:30:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 742AB613D3;
        Tue,  6 Apr 2021 23:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617751810;
        bh=qRv2FvvjbIrhksOio+RjarU/NxEdye2iHRth7pVWquo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FcK9RD+6qOcCNuXMnMT9sqGeCulpPOxk762j0WofdM2Qgs1AZDnSTMwDi7x+k6HMW
         mHOj9zfFtyctnTWhgt8Q55FKY+Y4P2niqHepwblUU9qpNt0XPubRciIva3RUt2uhIK
         2QiM3FfXbJdL/8X1x+Dld+1YC7tcUbQwlFS1qByLnc+yQOrVA001/Q3uW43Y6oEus5
         NoT2IUNUNQ/tCXZT0TbkQ5K/+YLhty9e78xL61+DwoZ87uZ2+FZAloJdg/xCBmBFum
         d6/966D3/YII5CrRImfHLndhnJB3uokxdQjej4X6zE798GzE5TQislab3NMkRisPhp
         /uBH4UcqXMFew==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6B7AD60A2A;
        Tue,  6 Apr 2021 23:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] nfc: s3fwrn5: remove unnecessary label
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161775181043.15996.13707777847563590852.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Apr 2021 23:30:10 +0000
References: <20210406015954.10988-1-samirweng1979@163.com>
In-Reply-To: <20210406015954.10988-1-samirweng1979@163.com>
To:     samirweng1979 <samirweng1979@163.com>
Cc:     krzysztof.kozlowski@canonical.com, k.opasiak@samsung.com,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wengjianfeng@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  6 Apr 2021 09:59:54 +0800 you wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> In function s3fwrn5_nci_post_setup, the variable ret is assigned then
> goto out label, which just return ret, so we use return to replace it.
> Other goto sentences are similar, we use return sentences to replace
> goto sentences and delete out label.
> 
> [...]

Here is the summary with links:
  - [v2] nfc: s3fwrn5: remove unnecessary label
    https://git.kernel.org/netdev/net-next/c/b58c4649d94e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


