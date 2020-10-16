Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23399290D4C
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 23:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410477AbgJPVaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 17:30:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406032AbgJPVaE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 17:30:04 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602883803;
        bh=Iha3UzVe2jDJommM1IBHUO4EWT+4P+YFWBi7x9ObpEI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ep2LJrcorhJja64koPOFWzFEnS+RZn5mUeE8yY3WmqbKn4CFNIMcDKBPWXlNugLW6
         xZEtndrPMfrB/utRvyupsUi08dIuJb6US61GmaI4LrFMG/ciWW7pUDT6ZrSV8GOYyk
         Xcl6L8ophqpXiMhxEb4avRos1o43d+pEvRiSs06I=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 1/2] tipc: re-configure queue limit for broadcast link
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160288380340.31566.9245323917252134913.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Oct 2020 21:30:03 +0000
References: <20201016023119.5833-1-hoang.h.le@dektech.com.au>
In-Reply-To: <20201016023119.5833-1-hoang.h.le@dektech.com.au>
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 16 Oct 2020 09:31:18 +0700 you wrote:
> The queue limit of the broadcast link is being calculated base on initial
> MTU. However, when MTU value changed (e.g manual changing MTU on NIC
> device, MTU negotiation etc.,) we do not re-calculate queue limit.
> This gives throughput does not reflect with the change.
> 
> So fix it by calling the function to re-calculate queue limit of the
> broadcast link.
> 
> [...]

Here is the summary with links:
  - [net,1/2] tipc: re-configure queue limit for broadcast link
    https://git.kernel.org/netdev/net/c/75cee397ae6f
  - [net,2/2] tipc: fix incorrect setting window for bcast link
    https://git.kernel.org/netdev/net/c/ec78e31852c9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


