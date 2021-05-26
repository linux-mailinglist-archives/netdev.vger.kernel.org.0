Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9F6392161
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 22:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbhEZUVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 16:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234595AbhEZUVm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 16:21:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3F1BE613CA;
        Wed, 26 May 2021 20:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622060410;
        bh=/eklCphJroDHrrXV/QLhufITmFwkH8AlXCkrHPI+ac8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q23rcQ0mVFVz9KPowT4mb1Umm5St0kmsYwqb+1DzKYeaW1rAavqFQOJN5K8H3SgjK
         lbY36sHiBdYGQJ21JaSHCLpzvzclsFjHsMyqX3OD7IcOF7Uyr7WLOu0nSbnV5yDram
         L7FTq1htPhHoDNfgUuxW5JB1WT5zEFtDgQMs1iJFQWq7MwNghjLcXz80VbIchDw/z2
         fQw6nXBMg8LwfkCpy6C3e2FqeRwCAv5Fnsh2BtM0rxCCumyvcdyNdiYp+yTFKub/hi
         o3ghaJbtq/TkMp36AR1EeTsP/OiUUEKpraxEW747d8lQsGV9L4MQCyFyPgiDplmVI+
         Rty0D+9ee8fsQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2E667609F2;
        Wed, 26 May 2021 20:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] nfc: st95hf: remove unnecessary assignment and label
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162206041018.2669.11111719801395575530.git-patchwork-notify@kernel.org>
Date:   Wed, 26 May 2021 20:20:10 +0000
References: <20210526005651.12652-1-samirweng1979@163.com>
In-Reply-To: <20210526005651.12652-1-samirweng1979@163.com>
To:     samirweng1979 <samirweng1979@163.com>
Cc:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        dinghao.liu@zju.edu.cn, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 26 May 2021 08:56:51 +0800 you wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> In function st95hf_in_send_cmd, the variable rc is assigned then goto
> error label, which just returns rc, so we use return to replace it.
> Since error label only used once in the function, so we remove error label.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> 
> [...]

Here is the summary with links:
  - [v2] nfc: st95hf: remove unnecessary assignment and label
    https://git.kernel.org/netdev/net-next/c/568e7142a15f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


