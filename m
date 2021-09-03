Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9007D3FFEB5
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 13:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348976AbhICLLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 07:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348672AbhICLLG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 07:11:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ADDEE610E5;
        Fri,  3 Sep 2021 11:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630667406;
        bh=ldQm8zVTHmrAm3Pi4juEvFQko80QHQ20RcWra5CgX+s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SPPXVVQ3ftWkqTMdSQRTc09epXM3jd9dE2n+YvwSW66zIQGAc0FnElBiXbQRlw3h5
         m7u+N3kdPawP1flfjF87nqZ2o09aBw1LQw6//+Cfkp67nZt71ERa+4hhLJNgWjaM7Q
         wchGFNmTkVx9S2d6JDyi2f79/uE1uZhb90cAcn1DURwpfOPdI6n5g/5Qs9Mu6+p1J7
         YaBXHotDgCh2fliKTZW09F77PJC1NeaT/TIarSX4NL0cLHpRmJ32C1LIWs0vI19LY6
         jVHg54GM1eIcd210ztYMQZN/xY3FV0AZAeHVpPe3003HNkh4u0Lt9jigyrK8pn9pO5
         MtSpDi2onE97A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A593260A2F;
        Fri,  3 Sep 2021 11:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] skbuff: clean up inconsistent indenting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163066740667.18620.16941532048366358544.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Sep 2021 11:10:06 +0000
References: <20210902225623.58209-1-colin.king@canonical.com>
In-Reply-To: <20210902225623.58209-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  2 Sep 2021 23:56:23 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a statement that is indented one character too deeply,
> clean this up.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - skbuff: clean up inconsistent indenting
    https://git.kernel.org/netdev/net/c/c645fe9bf6ae

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


