Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23838329351
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 22:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238560AbhCAVNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 16:13:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:37388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239065AbhCAVKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 16:10:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B1F67600CD;
        Mon,  1 Mar 2021 21:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614633006;
        bh=10f66vRrDYObGPqDTKUGYf/ghz73u8i/BH9WbY3ERq0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TAdxXkv5//SGIll546yMVvLtcxmA29ufr+h+VL103orZWse3heXqtLXzXEVF7Hbi/
         wQLiUZEqho5ozwEN9ZK/OOAXoOZPJlVq06cMRt2rW0E+3BBMNHiDYlSEcSjH/XisFf
         dnu/yyAuPfE5I3JZMLA68u8b+h+8TLYI0df0ighed0kKZLPalqi/7JWfDKi5xVd4A1
         h8C90laa+A7MMwdmLkHTlWCc9NrPKCBSb+KQ0SdaUQsL/Kb60yUN+T/Us9jRdbgLK/
         uARGl3bIU+Kv3EXPZ+1MjFl3gu2Dmw1O8wA3HtHb/p2cOH45ILIMLpTotoE9RBbx29
         rWsT06Di3zfqQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9A97660C1E;
        Mon,  1 Mar 2021 21:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] xen-netback: use local var in xenvif_tx_check_gop() instead
 of re-calculating
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161463300662.4342.7670414356889270416.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Mar 2021 21:10:06 +0000
References: <6604dec2-4460-3339-f797-e5f8a7df848f@suse.com>
In-Reply-To: <6604dec2-4460-3339-f797-e5f8a7df848f@suse.com>
To:     Jan Beulich <JBeulich@suse.com>
Cc:     wl@xen.org, paul@xen.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 25 Feb 2021 16:39:01 +0100 you wrote:
> shinfo already holds the result of skb_shinfo(skb) at this point - no
> need to re-invoke the construct even twice.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>

Here is the summary with links:
  - xen-netback: use local var in xenvif_tx_check_gop() instead of re-calculating
    https://git.kernel.org/netdev/net/c/826d82170b53

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


