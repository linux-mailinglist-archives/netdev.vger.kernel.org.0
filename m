Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702222F5999
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbhANDut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 22:50:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:58942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbhANDus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 22:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3B6CC2389A;
        Thu, 14 Jan 2021 03:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610596208;
        bh=QUP+1CQnqq3kWeSwHRTS8aQbGzb/oyt9ChHyf3AtW3w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M/QFBTYAMehQXFR+yzE3cjNHcMnuWh3R3pukhYnZaHTYkFAxguVrd8ttUxauoX0Fd
         VE/q9rIeu5iPRu9Ml13u1A5wdgaZECXEi5N1Oi+SAcN/EcEH2rlksu5MrxWHFCs2qi
         r81udQDnKaKjn97wUrPnH9gIbcBS27ffZkImyIwcbPiYOq8aRkJ9puJx6OijUil15Q
         qR9dlBZd0Azho8yzeF1i350usGTqPdZlpIL0FFQgzMIB5VBh3VTjhVyKuacMSny1yl
         gzI09EYTvjTUWisrZ40vxL420ErweQluP7q3cGVorTaSdIvME64YUnpMNA1oH6FmLM
         HqUWkXuApAQdQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 2EEBA60593;
        Thu, 14 Jan 2021 03:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V3] cxgb4/chtls: Fix tid stuck due to wrong update of qid
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161059620818.12509.892822325079746339.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jan 2021 03:50:08 +0000
References: <20210112053600.24590-1-ayush.sawal@chelsio.com>
In-Reply-To: <20210112053600.24590-1-ayush.sawal@chelsio.com>
To:     Ayush Sawal <ayush.sawal@chelsio.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        secdev@chelsio.com, rohitm@chelsio.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 12 Jan 2021 11:06:00 +0530 you wrote:
> TID stuck is seen when there is a race in
> CPL_PASS_ACCEPT_RPL/CPL_ABORT_REQ and abort is arriving
> before the accept reply, which sets the queue number.
> In this case HW ends up sending CPL_ABORT_RPL_RSS to an
> incorrect ingress queue.
> 
> V1->V2:
> - Removed the unused variable len in chtls_set_quiesce_ctrl().
> 
> [...]

Here is the summary with links:
  - [net,V3] cxgb4/chtls: Fix tid stuck due to wrong update of qid
    https://git.kernel.org/netdev/net/c/8ad2a970d201

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


