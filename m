Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173532A1B16
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 23:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgJaWuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 18:50:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgJaWuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 18:50:05 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604184604;
        bh=ybUcSgC0FCeqUvBfkroFmJy3pBnAI0REyzrWPMlB5cw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=wA1aBw86ls/9y6tzrLL8pA2Dk02ToirV9rxgeCSnM8yMruKLREvdW3ZyQFhKRnv3g
         SPaacCEwnVDY+7icUw41ESXeg6jfTLNd3WnImCvvFLcKoOwQB/iLQf+YELRvUtpTBe
         fpzYwwjsWbVluWQOVMh/7pGpcBcPr/cE9vDbTg+A=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net/smc: improve return codes for SMC-Dv2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160418460471.3842.2355856936084967249.git-patchwork-notify@kernel.org>
Date:   Sat, 31 Oct 2020 22:50:04 +0000
References: <20201031181938.69903-1-kgraul@linux.ibm.com>
In-Reply-To: <20201031181938.69903-1-kgraul@linux.ibm.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 31 Oct 2020 19:19:38 +0100 you wrote:
> To allow better problem diagnosis the return codes for SMC-Dv2 are
> improved by this patch. A few more CLC DECLINE codes are defined and
> sent to the peer when an SMC connection cannot be established.
> There are now multiple SMC variations that are offered by the client and
> the server may encounter problems to initialize all of them.
> Because only one diagnosis code can be sent to the client the decision
> was made to send the first code that was encountered. Because the server
> tries the variations in the order of importance (SMC-Dv2, SMC-D, SMC-R)
> this makes sure that the diagnosis code of the most important variation
> is sent.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net/smc: improve return codes for SMC-Dv2
    https://git.kernel.org/netdev/net-next/c/3752404a68e8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


