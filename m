Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119BC3AD28D
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 21:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbhFRTMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 15:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234711AbhFRTMN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 15:12:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D3E1C61264;
        Fri, 18 Jun 2021 19:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624043403;
        bh=SgZUkPiXwqdXTFfbo0ipEASettsiAdzw/azMpSAJ/tY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HDmP0bqDryf/VHA/rDaqclZXXST3k4pIcmC4b3Ar6uhIlGi7te0CeJ7mDC88EFwz4
         yBGbaOdawOzOS1eHnyL53EvCcdiRDFJP6y4UpaY9y3mfPFC04YkFUjECJtwy+ke070
         RxqiluPUmsbHrtO0NJnrw680DlmekuEsVTXWBiJs/cteNY8/FADmi7ACvals5J9IxM
         5ezOVB3TkrRMg8eT7jhmlnj8tdk06xJ4Pj7kZLEGpeaFARXs+SXP5OO4evfTGs+H5T
         UB2WSiKG5QqAOw9xUb/sbnWeEIP5LgMhldLV8sIsNJFq7bl2bFkCgIot++XIyV/CHB
         Gdr0xbtJoL6ng==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C257460C29;
        Fri, 18 Jun 2021 19:10:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] bnxt_en: Bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404340379.6189.8018755889955505608.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 19:10:03 +0000
References: <1623996447-28958-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1623996447-28958-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 18 Jun 2021 02:07:24 -0400 you wrote:
> This patchset includes 3 small bug fixes to reinitialize PHY capabilities
> after firmware reset, setup the chip's internal TQM fastpath ring
> backing memory properly for RoCE traffic, and to free ethtool related
> memory if driver probe fails.
> 
> Michael Chan (1):
>   bnxt_en: Rediscover PHY capabilities after firmware reset
> 
> [...]

Here is the summary with links:
  - [net,1/3] bnxt_en: Rediscover PHY capabilities after firmware reset
    https://git.kernel.org/netdev/net/c/0afd6a4e8028
  - [net,2/3] bnxt_en: Fix TQM fastpath ring backing store computation
    https://git.kernel.org/netdev/net/c/c12e1643d273
  - [net,3/3] bnxt_en: Call bnxt_ethtool_free() in bnxt_init_one() error path
    https://git.kernel.org/netdev/net/c/03400aaa69f9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


