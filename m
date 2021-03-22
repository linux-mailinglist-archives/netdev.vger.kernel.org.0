Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E413450CB
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbhCVUaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:30:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231535AbhCVUaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 146A66199E;
        Mon, 22 Mar 2021 20:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616445009;
        bh=g9vF2bkJOQVJ9MRrosp/D5dIG395s0ox1NyIP1QCK6s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dlyTI+Au8tAIDTfzzrzZtOtv/P4NzTabBgW1KQ4qZC9uFvWM6FcTjrPp0swX51AAV
         mxSgCpPmS3CgUyCbbfQJPqt+ngitqt3Z+fUfOlcRREQ79WfnqhG+VXh8xH+sXMIK8G
         DeEB/wWGkg1dYz+KcBeyXDUnNrD4syZ2zzNSqouMiamjfyLP9vsUrokdJ/gcqw3RI9
         sihM6Zau7twpZR9i9aH/kHL+7Fb1kyvEyIBbuRE15oBAJXXMxBjG0gArAgbXgOGGOH
         Nghi7KpMr+vDTmHqJYGnrHRSU3UQkQEHXc+Jg4BMlOFmyuIWIQN3hW41d7cwHM7OZY
         gcipcCto5em5Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 044E260A49;
        Mon, 22 Mar 2021 20:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: make xps_needed and xps_rxqs_needed static
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161644500901.31591.14148107011427206952.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Mar 2021 20:30:09 +0000
References: <20210322113019.3788474-1-olteanv@gmail.com>
In-Reply-To: <20210322113019.3788474-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, amritha.nambiar@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 22 Mar 2021 13:30:19 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Since their introduction in commit 04157469b7b8 ("net: Use static_key
> for XPS maps"), xps_needed and xps_rxqs_needed were never used outside
> net/core/dev.c, so I don't really understand why they were exported as
> symbols in the first place.
> 
> [...]

Here is the summary with links:
  - [net-next] net: make xps_needed and xps_rxqs_needed static
    https://git.kernel.org/netdev/net-next/c/5da9ace3405f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


