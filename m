Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E81C2DC968
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 00:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgLPXKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 18:10:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:56300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727512AbgLPXKr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 18:10:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608160206;
        bh=7r7diXa5I5C1+OxN8TDmWdHKUXQmpfSoh3vC6kWKw1k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eLzpaPN27i7So8m5vTQ2V0BmsVnT+SlCACWtSPRNPoqKE+cRInPwKRAFRENAlBeWM
         SYQVGiUWJKgqvwL1nr1+MtnSkDNmrV7KbN2oL7zCuBf1TfMTOn6uyk59LaTIkPm1TL
         AtQLgn5d+AyXhKgZro4DT5hirBBpWT0u53+qRBujU5lZM0e9+snuRzTFFXwG3DrweT
         js2VTvSeI9dsROmVBoEKf9Om0Iw7vBCQvuTaxK6+7BFst7O6p14KFeCgAeYsUOL0SQ
         kd2B4+q5shTGARXWywUoNpH5reiGTC+ATFe/sUDPHTmia2hq2R9Pz1wffay6NUSPoB
         39w1nnIhmmX9A==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/1] net/smc: fix access to parent of an ib device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160816020680.24098.3479905096894723694.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Dec 2020 23:10:06 +0000
References: <20201215091058.49354-1-kgraul@linux.ibm.com>
In-Reply-To: <20201215091058.49354-1-kgraul@linux.ibm.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hca@linux.ibm.com,
        raspl@linux.ibm.com, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 15 Dec 2020 10:10:57 +0100 you wrote:
> Please apply the following patch for smc to netdev's net-next tree.
> 
> The patch fixes an access to the parent of an ib device which might be NULL.
> 
> I am sending this fix to net-next because the fixed code is still in this
> tree only.
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] net/smc: fix access to parent of an ib device
    https://git.kernel.org/netdev/net/c/995433b795ce

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


