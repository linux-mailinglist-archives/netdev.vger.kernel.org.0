Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3203A6F09
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 21:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234765AbhFNTcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 15:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233816AbhFNTcH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 15:32:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 273B961246;
        Mon, 14 Jun 2021 19:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623699004;
        bh=Q5kNMaSIxEzQflywy/cF9pMyMcOQL2sfarVYEPNDDbU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XoD86XPo8DB7ZahxPHkgkJyFmOGXHFsY0qTT36y69hIEdcnueZ/nHySvFxfq/ozBg
         /08wVSwJ5MwRLDoNyDKSBpI8JvvSqeYUZlTxHdBEZ/gxbW6Wl7QHGXZ4sSVEgnEbA3
         scOcB5WUtnbczWz4Elatb2PHfRC56XRzwMp/Qof5jFvVmjn0+BGoRcPQONXvoXHIvi
         XqopShXN2DatdJlivqADbrHf6gupGLz8hw33tYl3KqiVhp42RIqSdcu4A5Zv7sjuOk
         HUsi0jdKsxac4m5dSg32mZwbyVY6AeOgpCswWg7fjS6Cyk7HeXA+sQ+DCK+l+HQKsf
         RH3jb+p5GmJpQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 16D9C60A71;
        Mon, 14 Jun 2021 19:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] cxgb4: fix wrong ethtool n-tuple rule lookup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162369900408.32080.12551738459900287841.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 19:30:04 +0000
References: <1623505844-11391-1-git-send-email-rahul.lakkireddy@chelsio.com>
In-Reply-To: <1623505844-11391-1-git-send-email-rahul.lakkireddy@chelsio.com>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rajur@chelsio.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 12 Jun 2021 19:20:44 +0530 you wrote:
> The TID returned during successful filter creation is relative to
> the region in which the filter is created. Using it directly always
> returns Hi Prio/Normal filter region's entry for the first couple of
> entries, even though the rule is actually inserted in Hash region.
> Fix by analyzing in which region the filter has been inserted and
> save the absolute TID to be used for lookup later.
> 
> [...]

Here is the summary with links:
  - [net] cxgb4: fix wrong ethtool n-tuple rule lookup
    https://git.kernel.org/netdev/net/c/09427c1915f7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


