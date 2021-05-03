Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E7F3721BB
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 22:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhECUl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 16:41:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhECUlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 16:41:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5C87661244;
        Mon,  3 May 2021 20:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620074410;
        bh=SIGGcbZNnoVNPQobUG6p/oD03o9TdcRVfYOzyFG+Acc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rusvzxJvJp3Xak2yaUafUhih6+Dz444CP7pOtzxPkmN4pcS9BH/xQ9TX2Tut95MLG
         R8L4T9bntnK2/VyKPVzxICpEDp/GxNzkKQRLSwrAIYYWukldpg07dQQYEfbS/gLLtx
         kbKGLqWk04lfjsChMkk5Sh4enxOUpYEx7fUDLo8ae0iTGWPyDoazgQFn00ciqpcR31
         POASQi4eNRgD9nDPqN0GSkLnp5riJGWjSRiPxzCbk0W5Auschya9sMuVqyHiKUTA8U
         V0rqjOQEsuQ173bIeQS7ek3MX6RFRtjAjfgoFKv6EIsbBuah8Z9BpA9PdV2pXfUGT/
         1omL/IoUKWteA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4C47060ACA;
        Mon,  3 May 2021 20:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: fix a SCTP_MIB_CURRESTAB leak in
 sctp_sf_do_dupcook_b
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162007441030.32677.12037671567310177974.git-patchwork-notify@kernel.org>
Date:   Mon, 03 May 2021 20:40:10 +0000
References: <98b2f435ec48fba6c9bbb63908c887f15f67a98d.1619988080.git.lucien.xin@gmail.com>
In-Reply-To: <98b2f435ec48fba6c9bbb63908c887f15f67a98d.1619988080.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, marcelo.leitner@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  3 May 2021 04:41:20 +0800 you wrote:
> Normally SCTP_MIB_CURRESTAB is always incremented once asoc enter into
> ESTABLISHED from the state < ESTABLISHED and decremented when the asoc
> is being deleted.
> 
> However, in sctp_sf_do_dupcook_b(), the asoc's state can be changed to
> ESTABLISHED from the state >= ESTABLISHED where it shouldn't increment
> SCTP_MIB_CURRESTAB. Otherwise, one asoc may increment MIB_CURRESTAB
> multiple times but only decrement once at the end.
> 
> [...]

Here is the summary with links:
  - [net] sctp: fix a SCTP_MIB_CURRESTAB leak in sctp_sf_do_dupcook_b
    https://git.kernel.org/netdev/net/c/f282df039126

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


