Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDBD83FAA84
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 11:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235029AbhH2JvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 05:51:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234917AbhH2Ju6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Aug 2021 05:50:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EEB8860C51;
        Sun, 29 Aug 2021 09:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630230607;
        bh=EMXztJnJVgluRBNgCufVLdCcbPYPNXID2oweou75bRY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mOlFzOJHhreFvpLkeJTbrYiZKmf3Jl+v/j3bCQ1XXcynNLdwS9Uv+Asvr9UaAUBHD
         KY4HLMp9APHJMw51CD1yIsbjwdXiip7WF+dHGn7Ey/XWD//umSzerI6Tedd4uZXluc
         YMKFG71woyho0NtZSjZ17/bvBcC/0VLnrA0/neceCchmk7wEf9iXZ3OoPdXQOpoIjw
         sqPLcDZ+rmL5kdhlMucJoKpvDxz3yEJRCvbalmQYgcmPVK9cK1PnP5bnomj0YNXd+1
         ZiVUooxPLRX5TeMZMlhd/k4k85fd0pBtVV+vHgCI9XLZh6aiWrCNNRu+ITiAy28S3/
         /Tr2ll99Mmtsg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E837E60A37;
        Sun, 29 Aug 2021 09:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v2 PATCH] octeontx2-pf: Add vlan-etype to ntuple filters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163023060694.19070.15929631829728472564.git-patchwork-notify@kernel.org>
Date:   Sun, 29 Aug 2021 09:50:06 +0000
References: <1630071055-6672-1-git-send-email-sbhatta@marvell.com>
In-Reply-To: <1630071055-6672-1-git-send-email-sbhatta@marvell.com>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sgoutham@marvell.com, hkelam@marvell.com, gakula@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 27 Aug 2021 19:00:55 +0530 you wrote:
> NPC extraction profile marks layer types
> NPC_LT_LB_CTAG for CTAG and NPC_LT_LB_STAG_QINQ for
> STAG after parsing input packet. Those layer types
> can be used to install ntuple filters using
> vlan-etype option. Below are the commands and
> corresponding behavior with this patch in place.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] octeontx2-pf: Add vlan-etype to ntuple filters
    https://git.kernel.org/netdev/net-next/c/dce677da57c0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


